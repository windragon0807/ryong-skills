#!/usr/bin/env bash
set -euo pipefail

# Link a skill from this repo into an agent's skills directory.
# Usage:
#   scripts/link-skill.sh <skill-name> <agent-skills-dir>
#   scripts/link-skill.sh <skill-name>   # interactive agent detection
# Example:
#   scripts/link-skill.sh ryong-youtube-summary "$CODEX_HOME/skills"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <skill-name> [agent-skills-dir]"
  exit 1
fi

SKILL_NAME="$1"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/skills/$SKILL_NAME"

if [[ ! -d "$SRC" ]]; then
  echo "Skill not found: $SRC"
  exit 1
fi

pick_agent_dir_interactive() {
  local codex_path="${CODEX_HOME:-$HOME/.codex}/skills"
  local claude_path="$HOME/.claude/skills"
  local cursor_path="$HOME/.cursor/skills"
  local -a labels=()
  local -a paths=()

  labels+=("Codex")
  paths+=("$codex_path")
  labels+=("Claude")
  paths+=("$claude_path")
  labels+=("Cursor")
  paths+=("$cursor_path")

  echo "Detected agent targets:"
  local i
  for i in "${!labels[@]}"; do
    printf "  %d) %s -> %s\n" "$((i+1))" "${labels[$i]}" "${paths[$i]}"
  done
  printf "  %d) Custom path\n" "$(( ${#labels[@]} + 1 ))"
  printf "Choose target number: "
  read -r choice

  if [[ "$choice" =~ ^[0-9]+$ ]]; then
    if (( choice >= 1 && choice <= ${#labels[@]} )); then
      AGENT_SKILLS_DIR="${paths[$((choice-1))]}"
      return 0
    fi
    if (( choice == ${#labels[@]} + 1 )); then
      printf "Enter custom skills directory path: "
      read -r AGENT_SKILLS_DIR
      return 0
    fi
  fi

  echo "Invalid selection."
  exit 1
}

if [[ $# -ge 2 ]]; then
  AGENT_SKILLS_DIR="$2"
else
  if [[ ! -t 0 ]]; then
    echo "No interactive terminal. Provide agent-skills-dir explicitly."
    exit 1
  fi
  pick_agent_dir_interactive
fi

DST="$AGENT_SKILLS_DIR/$SKILL_NAME"
mkdir -p "$AGENT_SKILLS_DIR"

if [[ -L "$DST" ]]; then
  rm "$DST"
elif [[ -e "$DST" ]]; then
  echo "Target exists and is not a symlink: $DST"
  echo "Move or remove it manually, then retry."
  exit 1
fi

ln -s "$SRC" "$DST"
echo "Linked: $DST -> $SRC"
