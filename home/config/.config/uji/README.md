# Uji configuration

Use this configuration with the Uji fork in `~/dev/forge/tools/uji`.
Keep project features and tests in the Uji repository, not in these dotfiles.

## Build and run

The local `main` branch tracks upstream.

```sh
git -C "$HOME/dev/forge/tools/uji" switch main
git -C "$HOME/dev/forge/tools/uji" pull --ff-only
rustup run stable cargo build --manifest-path "$HOME/dev/forge/tools/uji/Cargo.toml" -p uji
```

The first build fetches the `ito` dependency, so it needs network access.

`uji` is aliased to `~/dev/forge/tools/uji/target/debug/uji` in `~/.zsh/local.zsh`.
Open a new shell or run `source ~/.zsh/local.zsh` to use it.
The Homebrew build is older and does not support this configuration.
Check the executable path rather than the version.

Run the fork explicitly from your project directory:

```sh
"$HOME/dev/forge/tools/uji/target/debug/uji" \
  --config-dir "$HOME/.dotfiles/home/config/.config/uji"
```

Add `--db /tmp/uji-pr-test.db` to keep test conversations separate.

Deploy the configuration links:

```sh
stow --no-folding --restow \
  --dir="$HOME/dev/.dotfiles/home/config/.config" \
  --target="$HOME/.config/uji" uji
```

## What this configuration loads

`init.lua`:

- Builds the default theme with a yellow accent and a screen that centers the composer on an empty conversation.
- Pins the official plugin pack.
- Enables `skills`, `planmode`, `readonly` under `~/.agents/skills`, `subagent`, `telescope`, `websearch`, and five MCP servers: `deepwiki`, `grep`, `kite`, `context7`, and `firecrawl`.

`plugin/`:

- `startup-ui.lua` draws the yellow UJI logo while the conversation is empty and a footer bar with directory, model, effort, and context, built from `statusline` segments. The pack's default bar is not installed.
- `sessions.lua` adds `/sessions` (list and resume, or delete with `<C-d>` and `y`) and `/new`, using the public session APIs.
- `modes.lua` adds permission modes: `<S-Tab>` cycles ask, auto, and plan, and `/mode <name>` sets one. Auto allows `write_file`, `edit_file`, and `run_command` before the `planmode` and `readonly` hooks; plan denies them.

## Notes

- An empty conversation centers the composer in a column up to 80 columns wide; after the first message the composer spans the full width.
- `/effort` changes reasoning effort; `/thinking` changes reasoning visibility.
- Providers load their models from each service's `/models` endpoint and models.dev. There is no bundled fallback; `/reload` retries.
- OpenCode Zen can restrict free models to the OpenCode client. A 403 does not always mean your key is invalid.
- Keep credentials in Uji's data directory, not these dotfiles.
- `init.lua` and plugins are executable Lua with full runtime access. Model tool approvals do not sandbox plugin code.
