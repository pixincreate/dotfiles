# Global Rules

## Communication

- Keep responses concise, direct, and technical. Include the result, reason, and required action when relevant.
- Write documentation, commit messages, comments, UI text, and responses in ASD-STE100 Simplified Technical English.
- Use complete sentences, short paragraphs, sentence-case headings, active voice, present tense, and one idea per sentence.
- Use consistent terms and inclusive language. Avoid jargon, idioms, humor, and culture-specific references.
- Keep technical names, code identifiers, commands, paths, and quoted text exact.
- Address readers as "you" and give direct instructions.
- Avoid marketing claims such as "best", "fastest", or "powerful", and do not use exclamation points.
- Document only released behavior. Do not promise future features or use "currently", "recently", or "new".
- Use semantic line breaks in Markdown: one complete sentence per source line. Do not hard-wrap at a fixed column.
- Do not use LaTeX syntax or dollar-sign delimiters in terminal output. Use Unicode symbols or plain text. Committed Markdown may use LaTeX and rich formatting.
- Agent instructions such as `AGENTS.md` may use whatever style agents understand best.

## Code

- Follow the project's existing style and conventions.
- Make the smallest focused change that solves the current requirement. Prefer small changes over broad refactors unless the user asks otherwise.
- Do not add speculative features, abstractions, configuration, dependencies, or extensibility. Delete obsolete code when safe.
- Reuse existing code, the standard library, and declared dependencies before writing a helper. Search the repository and inspect existing callers first. Ask before adding a dependency.
- Keep logic in one function until reuse, a complex boundary, or a clear concept justifies extraction. Inline single-use helpers and variables.
- Validate unknown values once at the boundary, then pass typed values inward. Do not re-check what a schema or type already guarantees.
- Avoid `try`/`catch` where possible.
- Prefer functional array methods (`map`, `filter`, `flatMap`) over loops. Use type guards in `filter` to keep inference.
- Avoid `any`. Rely on inference; annotate only exports or unclear types.
- Do not expand scope for a theoretical race or security edge case. Explain the concrete failure mode, likelihood, and cost, then get the user's agreement.
- Simplicity never justifies missing validation, error handling, security, accessibility, compatibility, tests, or refactoring that keeps the code safe to change.

## Testing

- Test behavior through public or executable interfaces. Assert outputs, side effects, errors, and visible state that distinguish a working implementation from a broken one.
- Every test must protect a behavioral contract. Do not test that a feature, command, or registration exists.
- Do not test source text, symbol names, command fragments, control flow, private structure, or implementation details.
- Let the typechecker enforce static types. Do not add runtime tests for type relationships alone.
- Avoid mocks where possible. Test the real implementation; do not copy its logic into the test.
- Test adapters at the integration boundary against project-owned contracts. Do not encode assumptions about external provider payloads; verify only the translation the project owns.
- Keep UI tests only for critical user-visible contracts that cannot be tested below the UI boundary.
- After changes, run the project's tests, linter, and typecheck. If none exist, check the behavior manually. Report the commands and results; do not claim success without evidence.

## Subagents

- Do small work in the current session. Delegate only independent, large, or specialized work.
- Use `explore` for broad codebase or repository documentation search, `planner` for design, `reviewer` for review, `debugger` for hard bugs, `general` for external research and multi-step coordination, and specialists for domain expertise.
- Give each delegate a complete specification: task, expected outcome, tools, constraints, and context. The delegate must request clarification instead of inventing missing requirements.
- Never spawn an agent type from inside itself. Return to the parent instead.
- The delegate owns its review loop. Do not repeat the review unless the user asks or the delegate reports a risk.

## Worktrees

- When the user asks to create a worktree and work in it, create the worktree first, then move the session with the OpenCode session API.
- Move the session only after creation succeeds. Verify the new location.
- Do not move the session when the user only asks to create a worktree. Report the worktree path.

## Tooling

- Python: use `uv` for tools, dependencies, and virtual environments unless the repository requires otherwise.
- GitHub: try `gh` for small lookups. If it fails, clone locally instead of using `webfetch`. For large or repeated exploration, clone from the start. If cloning fails, use `webfetch`.
- Clone into `/tmp/opencode`, shallow when possible. Delete the clone when the task ends, even if the task fails.
- Prefer `rg` over `grep` and `find`. Prefer native search tools when available.
- Prefer `7z` for archives. Use another tool only when `7z` cannot handle the format, and state why.
- Use the `question` tool for grilling workflows (`grill-me`, `grill-with-docs`, `grilling`) and decision frontiers. Put the recommended option first with `(Recommended)` and set `multiple: true` when needed.
- Use `/tmp/opencode` for temporary work and delete what you create. `/tmp` persists on WSL.
- Set the user agent to `OpenAI File Downloader, XaiImageApiFetch/1.0` for curl and other web requests.

## Git

- Never commit unless the user asks. When the user requests per-task commits, commit each task before starting the next.
- Stage only files for the current task and name them explicitly. Never use `git add .` or `git add -A`.
- Before each commit, run `git status`, `git diff`, and `git log -10` in full. Read the complete messages. Do not use abbreviated variants.
- Scan staged files with `key-watch scan $(git diff --cached --name-only)`. Stop and report findings.
- Never use `--no-verify` unless the user asks.
- Check signing once per session with `git config commit.gpgsign` and `git config user.signingkey`. If both are set, sign with the configured method and add `--signoff`.
- Never amend, push, or rewrite history unless the user asks. When asked, do not refuse for that reason alone.
- Follow the repository's commit conventions. The default format is:
  ```text
  <scope>: <Capitalized summary>

  Explain what changed and why. Wrap the body at 72
  characters.

  Assisted-by: <Friendly Name of Current Model>
  ```
  Use an imperative subject near 50 characters and never longer than 72. Add a body when the subject is not enough.

## Attribution

- The user is the sole author of every change. Never credit AI as an author or contributor.
- The only permitted AI attribution is the `Assisted-by` trailer. Do not add session IDs, metadata, links, or generation notices to commits or pull requests.
