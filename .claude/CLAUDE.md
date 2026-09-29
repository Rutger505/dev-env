# User wide instructions

These apply to every project and session.

## Code comments

Default: don't write comments. Make the code self explanatory instead — clear names, small functions, obvious structure.

- Never write a comment that restates what the code already says.
- Only comment a non obvious _why_: a workaround, an edge case, or a deliberate counter intuitive choice.
- Remove existing useless comments in code you're already touching.

## Shell tooling

- Always use `rg` (ripgrep), `fd`, and `eza` instead of `grep`, `find`, and `ls`.

## Node projects

- Always run the project's `typecheck` script (e.g. `npm run typecheck`) to verify changes rather than an ad hoc `tsc` invocation.

## Command style

Keep shell commands as simple as possible so they are readable and Claude Code can auto grant permission:

- Avoid unnecessary `cd` — use absolute paths or the tool's working directory.
- Don't append `2>/dev/null` to suppress errors.
- Don't add decorative `echo` statements.
- When multiple steps are needed, prefer running separate commands over chaining them, to keep each one parse able.
- Never prefix a command with `!` when writing it out for me to run. I copy commands into my own zsh, where a leading `!` is the logical NOT operator and inverts the exit status, so a successful command reports failure. Print the bare command.

## Machine folder structure

All projects are stored in `~/Source/`.
When talking about a project, try finding it in the source folder first, if you cant find it use `gh repo list` and `gh repo clone` to get it.
