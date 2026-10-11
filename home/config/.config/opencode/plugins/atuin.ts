/**
 * Atuin plugin for opencode (v2).
 *
 * Tracks shell commands executed by opencode in Atuin history with author
 * `opencode`.
 *
 * This is the v2 plugin form, loaded through the `@opencode/plugin` API. The
 * `atuin hook install opencode` command writes the older v1 form of this file,
 * which opencode v2 does not run. If you run that command, replace the file it
 * writes with this one, then restart opencode.
 */

import { Plugin } from "@opencode/plugin";
import { spawn } from "node:child_process";

const ATUIN_AUTHOR = "opencode";
const ATUIN_TIMEOUT_MS = 10_000;

// opencode names its built-in shell tool `shell` in v2.
const SHELL_TOOL = "shell";

// A command that did not exit on its own reports a null exit code, so
// substitute the conventional code for each of the two ways that happens.
const EXIT_ABORTED = 130;
const EXIT_TIMED_OUT = 124;

// A denied command reaches neither the shell hook nor `execute.after`, so its
// proposal is never claimed and would sit in the map for the life of the
// session. Bound the map to cap that. Evicting the oldest can in principle drop
// a command still waiting at its permission prompt, which just goes unrecorded,
// but only a handful of calls are ever genuinely in flight at once.
const MAX_PROPOSED = 128;

interface Proposal {
	command: string;
	intent?: string;
}

interface Entry {
	historyId: string;
	cwd: string;
}

interface AtuinResult {
	code: number | null;
	stdout: string;
}

// The `execute.before` event carries the tool call id and its mutable input.
interface ToolStartEvent {
	tool: string;
	id: string;
	input: unknown;
}

// The `execute.after` event carries the id and a discriminated result.
interface ToolFinishEvent {
	tool: string;
	id: string;
	status: "completed" | "error";
	result?: { output?: string; metadata?: unknown };
	error?: unknown;
}

// The `create.before` shell event carries the command and its resolved cwd. It
// has no tool call id, so a shell is matched to its proposal by command text.
interface ShellCreateEvent {
	command: string;
	cwd: string;
}

/**
 * Run Atuin, resolving rather than rejecting on every failure.
 *
 * Spawned without a shell: a recorded command is arbitrary text that has to
 * reach Atuin as a single argv entry unmangled, which rules out running it
 * through a shell.
 */
function atuin(args: string[], cwd: string): Promise<AtuinResult> {
	return new Promise((resolve) => {
		let child: ReturnType<typeof spawn>;
		try {
			child = spawn("atuin", args, { cwd, stdio: ["ignore", "pipe", "ignore"] });
		} catch {
			resolve({ code: null, stdout: "" });
			return;
		}

		let stdout = "";
		let settled = false;
		const timer = setTimeout(() => child.kill("SIGKILL"), ATUIN_TIMEOUT_MS);

		const settle = (result: AtuinResult) => {
			if (settled) return;
			settled = true;
			clearTimeout(timer);
			resolve(result);
		};

		child.stdout?.setEncoding("utf8");
		child.stdout?.on("data", (chunk: string) => {
			stdout += chunk;
		});
		child.on("error", () => settle({ code: null, stdout: "" }));
		child.on("close", (code) => settle({ code, stdout }));
	});
}

async function startHistory(
	cwd: string,
	proposal: Proposal,
): Promise<string | undefined> {
	const args = [
		"history",
		"start",
		"--author",
		ATUIN_AUTHOR,
		"--author-kind",
		"agent",
	];
	if (proposal.intent) args.push("--intent", proposal.intent);
	args.push("--", proposal.command);

	const result = await atuin(args, cwd);
	if (result.code !== 0) return undefined;

	const historyId = result.stdout.trim();
	return historyId.length > 0 ? historyId : undefined;
}

function errorText(error: unknown): string {
	if (error instanceof Error) return error.message;
	if (typeof error === "string") return error;
	if (error && typeof error === "object" && "message" in error) {
		return String((error as { message: unknown }).message);
	}
	return "";
}

// The tool records an abort or a timeout in its output text rather than as an
// exit code, so string matching is the only way to tell the two apart.
function exitCodeFrom(event: ToolFinishEvent): number {
	const result = event.status === "completed" ? event.result : undefined;
	const exit = (result?.metadata as { exit?: unknown } | undefined)?.exit;
	if (typeof exit === "number") return exit;

	const text =
		typeof result?.output === "string"
			? result.output
			: event.status === "error"
				? errorText(event.error)
				: "";
	if (/aborted/i.test(text)) return EXIT_ABORTED;
	if (/exceeded timeout \d+ ms/.test(text)) return EXIT_TIMED_OUT;
	return 1;
}

// A rejected hook aborts opencode's tool call and discards the command's
// output. A missing history entry is always the better failure.
async function swallowFailures(work: () => void | Promise<void>): Promise<void> {
	try {
		await work();
	} catch {
		// Deliberately ignored.
	}
}

export default Plugin.define({
	id: "atuin",
	async setup(ctx) {
		const directory = ctx.location.directory;

		// Commands opencode has proposed but is not yet cleared to run, keyed by
		// tool call id.
		const proposed = new Map<string, Proposal>();
		// Atuin history IDs for commands that did start, keyed by tool call id.
		const running = new Map<string, Entry>();

		function propose(callID: string, input: unknown) {
			const { command, description } = (input ?? {}) as {
				command?: unknown;
				description?: unknown;
			};
			if (typeof command !== "string" || command.length === 0) return;

			if (proposed.size >= MAX_PROPOSED) {
				const oldest = proposed.keys().next().value;
				if (oldest !== undefined) proposed.delete(oldest);
			}

			proposed.set(callID, {
				command,
				intent:
					typeof description === "string" && description.length > 0
						? description
						: undefined,
			});
		}

		// The shell hook has no tool call id, so find the proposal whose command
		// text matches. The map is insertion ordered, so the first match is the
		// oldest still-pending proposal for that command.
		async function start(command: string, cwd: string) {
			let callID: string | undefined;
			let proposal: Proposal | undefined;
			for (const [id, candidate] of proposed) {
				if (candidate.command === command) {
					callID = id;
					proposal = candidate;
					break;
				}
			}
			if (callID === undefined || proposal === undefined) return;
			proposed.delete(callID);

			const historyId = await startHistory(cwd, proposal);
			if (historyId) running.set(callID, { historyId, cwd });
		}

		async function finish(callID: string, event: ToolFinishEvent) {
			proposed.delete(callID);

			const entry = running.get(callID);
			if (!entry) return;
			running.delete(callID);

			await atuin(
				[
					"history",
					"end",
					entry.historyId,
					"--exit",
					String(exitCodeFrom(event)),
				],
				entry.cwd,
			);
		}

		// Fires before the permission prompt, so only remember the command here.
		// Starting an entry would record commands the user went on to deny.
		await ctx.tool.hook("execute.before", (event) =>
			swallowFailures(() => {
				const ev = event as ToolStartEvent;
				if (ev.tool !== SHELL_TOOL) return;
				propose(ev.id, ev.input);
			}),
		);

		// The only hook that runs after the permission prompt but before the
		// command does, and the only one given the resolved working directory.
		// It also fires for user-run shells and for PTY sessions, which opencode
		// did not run; those are skipped because they have no proposal to claim.
		await ctx.shell.hook("create.before", (event) =>
			swallowFailures(() => {
				const ev = event as ShellCreateEvent;
				return start(ev.command, ev.cwd || directory);
			}),
		);

		// Also fires when the user aborts a command, unlike the error paths,
		// which skip this hook and leave the entry open.
		await ctx.tool.hook("execute.after", (event) =>
			swallowFailures(() => {
				const ev = event as ToolFinishEvent;
				if (ev.tool !== SHELL_TOOL) return;
				return finish(ev.id, ev);
			}),
		);
	},
});
