---
name: app-starter
description: Bootstrap and run a new app build from zero to shipped — five-phase workflow (Discovery → Scaffold → Skeleton → Iterate → Ship), project templates (CLAUDE.md, BRIEF.md, .env.example, .gitignore), and standing gotchas baked in (secrets hygiene, Supabase RLS, Linux inotify, hackathon mode, ElevenLabs scoped keys, plus example org-specific rules to customize for your own stack). Use whenever the user starts a fresh project, a prototype, a hackathon entry, or any "let's build X from scratch" work.
---

# App Starter — workflow + rules for shipping new apps

This skill encodes an opinionated workflow for going from zero to shipped app. **Follow the phases in order. Do not skip Discovery to jump to code** — that's the single biggest failure mode and is why this skill exists.

The detailed phase-by-phase playbook lives in `workflow.md`. Read it the first time you use this skill in a new project, or when a phase isn't obvious. This file is the always-loaded summary.

## The five phases (at a glance)

| # | Phase | Output | Time-box |
|---|-------|--------|----------|
| 0 | Discovery | `BRIEF.md` answering 5 questions | 10 min |
| 1 | Scaffold | Repo + templates + first commit | 15 min |
| 2 | Skeleton | Thinnest end-to-end happy path | 1–2 hr |
| 3 | Iterate | Vertical feature slices | bulk of build |
| 4 | Ship | Demo or deploy, then capture lessons | last 20% |

## Standing rules (apply at every phase — non-negotiable)

These are the things I would have to re-tell you every time if they weren't written down. Hold them in working memory before each phase.

1. **Secrets**: `.env.example` is the authoritative shape of every secret the app reads. Add a placeholder there before committing any code that references a new env var. The real `.env` is gitignored and never committed. Before every commit, diff `.env.example` against the actual usage. See `checklists/secrets.md`.

2. **Discovery is not optional**. If the user wants to start coding before `BRIEF.md` is filled, write `BRIEF.md` first with whatever you can infer and ask them to confirm or correct in one batched round. 10 minutes here saves hours of rework.

3. **Hackathon mode**. When the user flags this as a hackathon, do not downgrade ambition. Default to the strongest models, escalate to better tools where reasoning matters, use multi-agent setups where they help. Speed over polish on internals, but the demo path must be rock-solid.

4. **CCSF projects = Microsoft 365**. Outlook / Excel / OneDrive / Power Automate. Never default to Google Apps Script, Gmail, or Drive integrations for CCSF work, even if they're technically easier.

5. **Linux dev servers with file watchers** (Next.js, Vite, nodemon, Vercel CLI, Astro, etc.): pre-bump inotify limits **before** running the dev server, not after the first crash:
   ```
   sudo sysctl fs.inotify.max_user_watches=524288
   sudo sysctl fs.inotify.max_user_instances=512
   ```

6. **Supabase**: enable RLS on every public-facing table in the first migration. Anon key in client only. Service-role key never in client code or any file the client bundle can reach.

7. **ElevenLabs**: scoped API keys default to zero permissions. Explicitly enable `text_to_speech` and `voices_read` (and any others needed) at key creation, or every call 401s.

8. **UI / frontend**: code that compiles is not code that works. Start the dev server, open the browser, and click through the change yourself before declaring a UI task done. If you can't, say so explicitly — never claim success on UI you didn't see render.

9. **Don't half-finish**. No TODO stubs, no commented-out code, no "we'll come back to this" features merged. Either land it complete or revert the slice.

## Decision tree — which template / stack?

If the user hasn't picked a stack:

- **Python + Supabase**: API or backend-heavy. Voice/SMS agents. Civic tech / records work.
- **Next.js + Supabase**: when there's a real UI and you want fast styled components.
- **Power Automate / Excel / Outlook macros**: any Microsoft-shop internal automation (example of org-specific routing — replace with yours).
- **Plain Python script + `uv`**: one-off tools, scrapers, internal utilities.

Ask if unclear — but only once, batched with Discovery.

## Bootstrap

For a new app folder, run:
```
bash ~/.claude/skills/app-starter/scripts/new_app.sh <app-name>
```
That creates the folder, copies templates, runs `git init`, and makes the scaffold commit. If you're already in a folder, copy the templates manually with:
```
cp ~/.claude/skills/app-starter/templates/* .
cp ~/.claude/skills/app-starter/templates/.* . 2>/dev/null
```
Then edit `BRIEF.md` and `CLAUDE.md` to match the project.

## Files in this skill

- `workflow.md` — phase-by-phase detail with examples (read on first use)
- `templates/CLAUDE.md` — project-root CLAUDE.md, copied into every new app
- `templates/BRIEF.md` — Discovery brief skeleton (Phase 0 output)
- `templates/.env.example` — secret-shape header
- `templates/.gitignore` — Python + Node combined
- `checklists/secrets.md` — secret-handling checklist
- `checklists/pre-demo.md` — demo / hackathon readiness
- `scripts/new_app.sh` — bootstrap script

## When to update this skill

After every project ships, ask: "what did we learn that the next app would benefit from?"

- A standing rule that was missing → add to the Standing Rules section above.
- A new check that catches a specific bug class → add to a checklist.
- A new stack pattern you've adopted → add to the decision tree.
- A whole new domain (voice, civic tech, security ops) → spin up a sibling skill, don't bloat this one.

The point of this skill is to compound — Day 30 should be better than Day 1.
