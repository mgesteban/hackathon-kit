#!/usr/bin/env bash
# new_app.sh — bootstrap a fresh app folder from the app-starter templates.
#
# Usage:
#   bash ~/.claude/skills/app-starter/scripts/new_app.sh <app-name> [parent-dir]
#
# Creates <parent-dir>/<app-name>/ (default parent: current working directory),
# copies templates in, runs git init, makes the scaffold commit. It will not
# overwrite an existing non-empty folder — bail and let the human decide.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES="$SKILL_DIR/templates"

if [[ $# -lt 1 ]]; then
  echo "usage: new_app.sh <app-name> [parent-dir]" >&2
  exit 64
fi

APP_NAME="$1"
PARENT_DIR="${2:-$PWD}"
APP_DIR="$PARENT_DIR/$APP_NAME"

if [[ -d "$APP_DIR" && -n "$(ls -A "$APP_DIR" 2>/dev/null)" ]]; then
  echo "error: $APP_DIR already exists and is not empty — aborting" >&2
  exit 1
fi

mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Copy regular + dotfile templates. Using cp -a preserves anything we add
# later (binaries, subdirs).
cp -a "$TEMPLATES"/. .

# Personalize the obvious placeholders so the first commit isn't a wall of
# <PROJECT NAME>. The user will still edit further.
for f in CLAUDE.md BRIEF.md; do
  if [[ -f "$f" ]]; then
    sed -i "s/<PROJECT NAME>/$APP_NAME/g" "$f"
  fi
done

git init -q
git add -A
git commit -q -m "scaffold: bootstrap $APP_NAME from app-starter skill"

echo ""
echo "✓ $APP_NAME scaffolded at $APP_DIR"
echo ""
echo "next steps:"
echo "  cd $APP_DIR"
echo "  \$EDITOR BRIEF.md      # fill in the 5 discovery questions"
echo "  \$EDITOR CLAUDE.md     # set stack, run commands, deploy target"
echo "  \$EDITOR .env.example  # uncomment + name every secret this app reads"
echo ""
