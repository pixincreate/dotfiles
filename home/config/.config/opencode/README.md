# OpenCode v2 configuration

This directory is the Stow source for `~/.config/opencodev2`.
The `config` package is managed by your rig.
The v1 configuration remains in `~/.config/opencode`.

## Select this configuration

After you install v2, start a private server with these overrides:

```sh
OPENCODE_CONFIG_DIR="$HOME/.config/opencodev2" \
OPENCODE_CONFIG="$HOME/.config/opencodev2/local.jsonc" \
opencode --standalone
```

Both overrides are required.
Your shell sets `OPENCODE_CONFIG` to the v1 `local.jsonc`.
Changing only the directory still loads that additional file.
Restart OpenCode after changing server configuration or agent files.

For initial testing, also set `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME` to separate temporary directories.
Do not use your v1 database for that test.
No credentials or session data are stored in this directory.
Connect your existing OpenCode Go account when you test authenticated requests.
Use an inference-only API key for normal model requests.

## Plugins

`cli.json` loads the local Mouth and Sesh PR builds from their `dist` directories.
Rebuild those projects before testing changes.
Keep both PRs open until you verify the dashboard and session picker in your v2 installation.

The server configuration enables DCP.
The v1 `opencode-anthropic-auth` plugin is not enabled because its v1 implementation does not establish v2 compatibility.
Its existing v1 entry remains unchanged.
The ADHD plugin and its skill copies are removed, not migrated.

## Preserved settings and limitations

- Shell deny/ask rules and agent permission overrides retain their order and effects.
- Provider restrictions retain the legacy allowlist and explicit deny policies.
- The title agent uses your former `small_model` value.
- Grafana stays in `local.jsonc`; the other MCP servers stay in `opencode.jsonc`.
- All 47 remaining skill directories include their support files.
  The Magisk skill is an independent copy, not a link to the Magisk checkout.
- `lsp` and `share` settings remain recorded, but v2 does not provide the corresponding v1 behavior.
  Legacy `doom_loop` and `lsp` permission actions have no v2 Core equivalent and are omitted.
- Your custom provider ID remains `llama`, while the existing allowlist names `llama.cpp`.
  That mismatch is preserved; the custom provider remains denied by the allowlist.
- `AGENTS.md` still names `coder-low`, `coder-high`, and `reasoner`, but those agents have no definitions here.
  This migration does not rewrite your routing policy.

The server config retains the documented schema URL.
That public URL still describes v1 fields.
Validate native v2 fields with the v2 runtime rather than relying on that editor schema alone.
