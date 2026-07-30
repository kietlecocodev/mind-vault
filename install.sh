#!/usr/bin/env bash
# Symlink mind-vault skills into ~/.claude/skills/ so Claude Code picks them up.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$SKILLS_DIR"

for skill in "$REPO_DIR"/skills/*/; do
  name="$(basename "$skill")"
  target="$SKILLS_DIR/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "SKIP $name: $target exists and is not a symlink — remove it manually first."
    continue
  fi
  ln -sfn "${skill%/}" "$target"
  echo "OK   $name -> $target"
done

echo "Done. Restart your Claude Code session to load the skills."
