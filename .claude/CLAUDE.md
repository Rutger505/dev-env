# User-wide instructions

These apply to every project and session.

## Response style
Be brief. Lead with the answer or what was done.
- Still explain the mechanism — why something breaks, how a fix works — just say it in fewer words.
- Cut restated evidence and caveats that don't change what I should do next.
- Don't pre-empt follow-up questions — offer the detail instead of including it.

## Code comments
Default: don't write comments. Make the code self-explanatory instead — clear names, small functions, obvious structure.
- Never write a comment that restates what the code already says.
- Only comment a non-obvious *why*: a workaround, an edge case, or a deliberate counterintuitive choice.
- Remove existing useless comments in code you're already touching.

## Shell tooling
- Always use `rg` (ripgrep), `fd`, and `eza` instead of `grep`, `find`, and `ls`.

## Node projects
- Always run the project's `typecheck` script (e.g. `npm run typecheck`) to verify changes rather than an ad-hoc `tsc` invocation.

## Command style
Keep shell commands as simple as possible so they are readable and Claude Code can auto-grant permission:
- Avoid unnecessary `cd` — use absolute paths or the tool's working directory.
- Don't append `2>/dev/null` to suppress errors.
- Don't add decorative `echo` statements.
- When multiple steps are needed, prefer running separate commands over chaining them, to keep each one parseable.
