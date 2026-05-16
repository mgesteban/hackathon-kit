# Hackathon-kit

A reusable [Claude Code Skill](https://docs.claude.com/en/docs/claude-code/skills) for going from zero to a shipped app the way a senior engineer would. It encodes a five-phase workflow, project templates, secret-hygiene checks, and demo-readiness checklists into a single folder Claude can auto-discover and use in every project.

It is one opinionated workflow — mine, built from real shipping pain across hackathon entries, civic-tech projects, and CCSF (community college) work. **Fork it and replace the parts that don't match your context.** The talk that inspired this ([Anthropic Skills, late 2025](https://www.anthropic.com/news/skills)) puts it well: skills are domain-specific procedural knowledge, not generic advice.

## What's inside

```
app-starter/
├── SKILL.md              # always-loaded summary: 5-phase workflow + 9 standing rules
├── workflow.md           # phase-by-phase deep dive (loaded on demand)
├── templates/            # copied into every new app
│   ├── CLAUDE.md         # per-project context for Claude
│   ├── BRIEF.md          # the Phase 0 discovery brief (5 questions)
│   ├── .env.example      # secret-shape header with common providers
│   └── .gitignore        # Python + Node + Supabase + editor junk
├── checklists/
│   ├── secrets.md        # run before any commit touching env
│   └── pre-demo.md       # hackathon / demo readiness, day-before
└── scripts/
    └── new_app.sh        # bootstraps a fresh app: folder, templates, git init, scaffold commit
```

## The workflow at a glance

| # | Phase | Output | Time-box |
|---|-------|--------|----------|
| 0 | Discovery | `BRIEF.md` answering 5 questions | 10 min |
| 1 | Scaffold | Repo + templates + first commit | 15 min |
| 2 | Skeleton | Thinnest end-to-end happy path | 1–2 hr |
| 3 | Iterate | Vertical feature slices | bulk of build |
| 4 | Ship | Demo or deploy, then capture lessons | last 20% |

The standing rules — secrets hygiene, "Discovery is not optional," hackathon mode, Linux inotify pre-bumps, Supabase RLS, ElevenLabs scoped-key gotcha, UI-not-done-until-you-clicked-it, no half-finished slices — live in `app-starter/SKILL.md`.

## Install

Clone the repo and make Claude Code aware of the skill by symlinking it into your user-level skills directory:

```bash
git clone https://github.com/mgesteban/hackathon-kit.git ~/Hackathon-kit
ln -s ~/Hackathon-kit/app-starter ~/.claude/skills/app-starter
```

That's it. Open any project in Claude Code and the skill is auto-discovered from its `SKILL.md` description.

Prefer a copy over a symlink? Use `cp -a ~/Hackathon-kit/app-starter ~/.claude/skills/app-starter` instead — but you'll have to re-sync when the repo updates.

## Start a new app

```bash
bash ~/.claude/skills/app-starter/scripts/new_app.sh <app-name> ~/Hackathon-kit
cd ~/Hackathon-kit/<app-name>
```

You'll land in a folder with `BRIEF.md`, `CLAUDE.md`, `.env.example`, `.gitignore`, git initialized, and the scaffold commit made. **Fill in `BRIEF.md` (the Phase 0 discovery brief) before writing any code** — the workflow only works if Discovery isn't skipped.

You can also just open an empty folder and tell Claude something like *"Let's start a new app from the app-starter skill."* The skill takes over from there.

## Customizing for your context

The standing rules in `app-starter/SKILL.md` are *my* rules — some are universal (secrets hygiene, never half-finish), some are specific to my stack (Supabase, ElevenLabs) or my org (CCSF = Microsoft 365). When you fork:

- **Keep** the rules that match your stack.
- **Replace** the org-specific routing rule ("CCSF projects = Microsoft 365") with your own — every org has one of these.
- **Add** rules as you ship and learn. The last phase of every project is "what did we learn?" Update the skill so Day 30 is sharper than Day 1.

## Why a Skill, not a template repo

Templates rot. They sit in `~/templates/` until someone remembers to copy them, and they don't compose with the agent doing the work. A Skill is procedural knowledge the agent loads on demand — it travels with you across projects, gets sharper over time as you update it, and explicitly trades off context budget by being progressively disclosed (only the description loads upfront; the full workflow loads when needed).

See the [Anthropic Skills announcement](https://www.anthropic.com/news/skills) for the broader pattern.

## License

MIT. Use freely, fork freely, share freely.
