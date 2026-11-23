#!/usr/bin/env bash
# Установка скилла design-review для Claude Code и OpenAI Codex.
# Использование:
#   ./install.sh            — личная установка (Claude Code + Codex)
#   ./install.sh claude     — только Claude Code
#   ./install.sh codex      — только Codex
#   ./install.sh repo PATH  — в репозиторий PATH (для всей команды, обе среды)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/design-review"

copy_to() {
  mkdir -p "$1"
  rm -rf "$1/design-review"
  cp -R "$SRC" "$1/"
  echo "✓ $1/design-review"
}

case "${1:-all}" in
  claude) copy_to "$HOME/.claude/skills" ;;
  codex)  copy_to "$HOME/.agents/skills" ;;
  all)    copy_to "$HOME/.claude/skills"; copy_to "$HOME/.agents/skills" ;;
  repo)
    [ -n "${2:-}" ] || { echo "Укажите путь к репозиторию"; exit 1; }
    copy_to "$2/.claude/skills"; copy_to "$2/.agents/skills" ;;
  *) echo "Неизвестный режим: $1"; exit 1 ;;
esac

echo "Для ChatGPT загрузите $HERE/design-review.zip (Skills → Create → Upload from your computer)."
