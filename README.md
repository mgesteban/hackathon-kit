# Hackathon-kit

Working directory for new app builds. The actual workflow + templates live in the **app-starter** skill at `~/.claude/skills/app-starter/`, where Claude auto-discovers them from any project.

## To start a new app

```
bash ~/.claude/skills/app-starter/scripts/new_app.sh <app-name> ~/Hackathon-kit
cd ~/Hackathon-kit/<app-name>
```

That gives you a folder with `BRIEF.md`, `CLAUDE.md`, `.env.example`, `.gitignore`, git initialized, and the scaffold commit made. Fill in `BRIEF.md` (Phase 0 — Discovery) before writing any code.

## To inspect or update the workflow

- Entry point: `~/.claude/skills/app-starter/SKILL.md` — phases + standing rules
- Long form: `~/.claude/skills/app-starter/workflow.md` — phase-by-phase detail
- Templates: `~/.claude/skills/app-starter/templates/`
- Checklists: `~/.claude/skills/app-starter/checklists/`

When you learn something new across a build, update the skill — Day 30 should be better than Day 1.
