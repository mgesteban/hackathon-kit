# App Starter — workflow detail

This is the long form of the five phases. `SKILL.md` is the summary; come here when a phase isn't obvious or when starting a new project for the first time in a while.

## Phase 0 — Discovery (10 min, before any code)

Output: `BRIEF.md` at the project root with these five sections filled in.

**The five questions**, asked in one batched round so the user only context-switches once:

1. **What is this app, in one sentence?** Force a clear north star. If the user can't answer in one sentence, the scope is unclear and Phase 1 will produce the wrong scaffold.

2. **Who is the primary user?** Grace? CCSF staff? Hackathon judges? Public? Each of these implies different defaults — auth model, hosting, polish level, accessibility.

3. **What's the demo / success moment?** The thing she'll show off when it works. Every Phase 3 slice gets prioritized by how close it gets to this moment.

4. **Hard constraints?** Deadline. Required stack. Deployment target. Judges' rubric for hackathons. Privacy / compliance constraints for CCSF work.

5. **What stays the same, what's new?** Compared to her usual Python + Supabase stack. If she's trying a new framework, that's a signal to budget extra time for skeleton (Phase 2) since the wiring is unfamiliar.

If she's eager to start coding, write `BRIEF.md` with your best inference and ask her to confirm or correct it in one round. Do not silently proceed to Phase 1 with unanswered questions.

### Anti-patterns

- Asking the five questions one at a time across multiple turns. Batch them.
- Treating discovery as a separate "planning document" exercise — `BRIEF.md` is a live, terse file (use the template).
- Skipping discovery because "it's a quick prototype." Quick prototypes that drift cost more than 10 minutes of upfront thinking.

## Phase 1 — Scaffold (15 min, the boring automatable layer)

Output: a repo with templates dropped in, first commit made, dev environment ready.

Run `scripts/new_app.sh <app-name>` or copy templates manually. Edit `CLAUDE.md` to reflect the actual stack and run commands.

Set up the dev environment **fully** before any feature code:

- Python: `uv venv && uv sync` (preferred) or `python -m venv .venv && pip install -e .`
- Node: `npm install` or `pnpm install`
- Supabase: `supabase init` if local dev; create the project in the dashboard if cloud-only.
- Env vars: copy `.env.example` to `.env`, fill in real values, verify `.env` is gitignored.

**First commit before any feature code.** Pure scaffold commit so the diff for the first feature is clean and reviewable.

### Anti-patterns

- Mixing scaffold with feature code in the first commit.
- Skipping the dev env setup ("I'll do it when I need it") — you'll need it in Phase 2 and the friction will break flow.
- Forgetting to verify `.gitignore` covers `.env` before the first commit.

## Phase 2 — Skeleton (1–2 hr, smallest end-to-end happy path)

Output: the thinnest possible slice that touches every layer the final app will touch.

For a typical web app this means:
- 1 page or 1 endpoint
- 1 DB read or write
- 1 external API call (or stub)
- A `make run` / `npm run dev` / `python -m foo` that produces a visible result

**The goal is to prove the wiring works**, not to deliver value. If the app will eventually have auth, the skeleton has *hardcoded fake auth* — not no auth. If it will eventually deploy to Vercel, deploy the skeleton to Vercel — not just `localhost`. Push every layer end-to-end at minimum complexity.

For UI-heavy apps: start the dev server, open the browser, and confirm the page renders. The skeleton is not done until you have *seen* it work.

For voice / SMS / Twilio apps: get one round-trip working with a real phone number and real Twilio account before adding any logic. The 401s and webhook config eats hours — surface that pain in Phase 2, not Phase 3.

### Anti-patterns

- "Vertical slice" that's actually horizontal — building all of the DB layer, then all of the API layer, then all of the UI layer. Don't.
- Stubbing out a layer "for now" that you don't actually know how to wire when the time comes. If you stub it, write a one-line note in `BRIEF.md` of what's stubbed and what real-wiring will require.
- Skipping the deploy / hosting wiring because "we'll deploy at the end." You won't have time at the end. Deploy the skeleton.

## Phase 3 — Iterate (vertical slices, bulk of the build)

Output: features added one vertical slice at a time, each one shippable before the next starts.

Each slice:
1. Add a row to the "Done / Next" list in `BRIEF.md` — one line, what user value it delivers.
2. Implement the slice across all layers (data → API → UI).
3. Run it end-to-end yourself. For UI: open the browser. For backend: hit the endpoint.
4. Commit with a one-line message focused on the *why* ("add Brown Act preflight check to packet upload"), not the *what* ("add function checkBrownAct").

**Repetition rule** (the talk's core skill-engineering reflex): if you write the same script or block twice across two slices, promote it. Either:
- A reusable script in `scripts/` with one line of usage comment.
- A helper module in the codebase.
- An update to this skill if it's a *cross-project* pattern.

This is how Day 30 ends up better than Day 1 — each project leaves the toolkit slightly sharper.

### Anti-patterns

- Widening surface area before depth works. Don't add a second feature when the first isn't end-to-end yet.
- Long-running uncommitted state. If you go more than ~1 hour without a commit, you're losing the ability to bisect or revert.
- "We'll write tests at the end." Either write the test alongside the slice or explicitly decide not to test that slice — never defer.

## Phase 4 — Ship (last 20%)

For demos / hackathons: run `checklists/pre-demo.md` end to end. Don't skim — every item exists because something failed once.

For deploys / production:
- Production env vars set on the host (Vercel, Render, Railway, whatever) — `.env` is dev-only.
- A health check endpoint or smoke test you can hit after deploy.
- `README.md` has a "how to run this" section that works on a fresh clone.
- One-line rollback plan: "previous commit was X, redeploy by running Y." Don't deploy without it.

### Capture lessons (the compounding step)

Before closing out the project, ask: **what did we learn that the next app would benefit from?**

Three buckets:
- **Personal preference / behavior pattern** → write a feedback memory at `~/.claude/projects/-home-grace/memory/`.
- **Procedural lesson, generic to all apps** → update this skill (SKILL.md rules, a checklist, a template).
- **Whole new domain** (voice agents, civic tech, security ops) → spin up a sibling skill at `~/.claude/skills/<domain>/`. Don't bloat this one.

This step is easy to skip and is exactly the step that makes the difference between "I used an AI to build apps" and "my AI partner gets sharper with every app."

## Composition with other skills and MCP

The talk's architecture: agent loop + MCP for outside-world data + Skills for procedural expertise.

When this skill points to or depends on others, link them with `[[skill-name]]` so future versions can resolve them automatically. Current siblings to be aware of:

- (None yet — write the first one when you need it.)

MCP servers that pair well with app builds:
- Supabase MCP — for DB schema introspection and migrations.
- Playwright MCP — for end-to-end UI testing of Phase 2/3 work.
- GitHub MCP — for PR creation and CI status.

Don't load these unless the project actually uses them — context budget matters.
