# Secrets checklist

Run before every commit that touches env vars, config, or any file that reads from `os.environ` / `process.env`.

## Before any commit

- [ ] `.env` is in `.gitignore` and `git status` does not show `.env`.
- [ ] Every new env var the code reads has a placeholder entry in `.env.example` with the same name.
- [ ] `.env.example` has placeholder values only — no real secrets.
- [ ] `git diff --staged` reviewed line by line. No real keys, tokens, or passwords in the diff.

## Quick audit commands

Find every env var the code reads:
```
grep -rEh 'os\.environ\[|os\.getenv|process\.env\.' \
  --include='*.py' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' \
  | sort -u
```

Confirm each one appears in `.env.example`:
```
diff <(grep -rEho 'os\.environ\["[^"]+"\]|process\.env\.[A-Z_]+' --include='*.py' --include='*.ts' --include='*.tsx' . | sed -E 's/.*\.([A-Z_]+).*/\1/; s/.*\["([^"]+)"\].*/\1/' | sort -u) \
     <(grep -Eo '^[A-Z_]+=' .env.example | tr -d '=' | sort -u)
```

Scan the repo for accidentally committed real-looking secrets:
```
grep -rE '(sk-[a-zA-Z0-9_-]{20,}|eyJ[A-Za-z0-9_-]{40,}|AIza[A-Za-z0-9_-]{20,}|whsec_[A-Za-z0-9]{20,})' \
  --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.venv .
```

## If a real secret slipped into a commit

1. **Rotate the key immediately** at the provider — git history is forever, even if you force-push.
2. Update `.env` locally with the new key.
3. Then (and only then) clean the git history (`git filter-repo` or BFG) and force-push if the repo is private. Public repo: assume the old key is permanently compromised regardless of cleanup.

## Provider-specific gotchas

- **Supabase**: anon key is client-safe; service-role key is **server only**. Never put the service-role key in a Next.js client component, public env (`NEXT_PUBLIC_*`), or any file the client bundle can reach.
- **Stripe**: `sk_test_*` and `sk_live_*` look almost identical. Verify which one is in `.env` before any payment flow.
- **ElevenLabs**: scoped keys default to no permissions — explicitly enable `text_to_speech` and `voices_read` at key creation.
- **Twilio**: auth token is rotateable; account SID is not secret but treat it as one anyway.
- **OpenAI / Anthropic**: project-scoped keys with usage limits are safer than account-wide keys for prototypes.
