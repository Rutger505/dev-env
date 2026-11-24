User-wide, every project and session.

**Comments**
- Default none; self-explanatory code instead (clear names, small functions)
- Only a non-obvious why: workaround, edge case, deliberate odd choice
- Never restate the code; remove useless comments in code I touch

**Tooling**
- `rg`, `fd`, `eza`, not `grep`, `find`, `ls`
- Node: verify with the project's `typecheck` script (`npm run typecheck`), not ad hoc `tsc`

**Commands** (simple, readable, auto-grantable)
- No needless `cd`: absolute paths or the tool's working dir
- No `2>/dev/null`, no decorative `echo`
- Separate commands over chains
- Commands for Rutger to run: never prefix `!` (in his zsh it inverts the exit status)

**Projects**
- In `~/Source/`; not there: `gh repo list`, `gh repo clone`
- Repo lacks context, or task refers to another project ("like in fastify"): rocky's knowledge in `~/Source/zeroclaw-config` (`agents/rocky/workspace/AGENTS.md` all projects, `agents/rocky/workspace/skills/` per project). How: someclaw skill, "rocky's skills"
