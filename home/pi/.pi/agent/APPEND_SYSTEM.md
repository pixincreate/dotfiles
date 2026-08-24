# Global instructions

Ponytail/lazy-mode rules apply to backend, system, tooling, and infra code only. Exempt UI/UX/frontend/web-design work — those get full creative treatment (no minimalism bias).

## Git Safety

- Never create commits, amend, or push unless the user explicitly asks for them in the current task.
- Never stage with `git add .` or `git add -A`. Name the files explicitly instead.
- Before committing, scan the staged files for secrets with key-watch:
  `key-watch scan $(git diff --cached --name-only)`
  If it reports findings, stop and report them to the user instead of committing.
- Never bypass git hooks with `--no-verify`.
