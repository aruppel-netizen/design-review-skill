#!/usr/bin/env bash
# Публикация новой версии скилла design-review.
# Источник правды — папка design-review/ рядом с этим скриптом. Правьте только её.
#
# Использование:
#   ./publish.sh                     — пересобрать архивы, обновить репо(и), закоммитить
#   ./publish.sh "что поменяли"      — то же, со своим текстом коммита
#   ./publish.sh --push "что поменяли" — и запушить в origin
#
# Какие репозитории обновлять — список REPOS ниже (или переменная окружения REPOS через пробел).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/design-review"
SKILL_URL="https://claude.ai/customize/skills/id/plugin_016MnGNGLaaPKk1xgNM4eTF1"
REPOS="${REPOS:-$HOME/ai-prototypes/search-bar-web}"

PUSH=0
if [ "${1:-}" = "--push" ]; then PUSH=1; shift; fi
MSG="${1:-Обновление скилла design-review}"

[ -f "$SRC/SKILL.md" ] || { echo "Нет $SRC/SKILL.md"; exit 1; }

# Проверка описания: стандарт Agent Skills ограничивает его 1024 символами
DESC_LEN=$(sed -n 's/^description: //p' "$SRC/SKILL.md" | head -1 | python3 -I -c "import sys; print(len(sys.stdin.read().strip()))")
if [ "$DESC_LEN" -gt 1024 ]; then
  echo "✗ description в SKILL.md — $DESC_LEN символов, максимум 1024. Сократите."; exit 1
fi

# 1. Архивы
cd "$HERE"
rm -f design-review.zip design-review.skill
zip -rq design-review.zip design-review -x '*.DS_Store'
cp design-review.zip design-review.skill
echo "✓ Архивы пересобраны: design-review.skill (Claude), design-review.zip (ChatGPT)"

# 1б. Сам репозиторий скилла
if [ -d "$HERE/.git" ]; then
  git add -A
  if git diff --cached --quiet; then
    echo "• репо скилла — без изменений"
  else
    git commit -q -m "$MSG" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
    echo "✓ репо скилла — закоммичено: $(git log --oneline -1)"
  fi
  # Пушим во все remotes скилла (gitea = origin, github = копия); ошибка одного не останавливает остальное
  if [ "$PUSH" = 1 ]; then
    for R in $(git remote); do
      git push -q "$R" HEAD && echo "✓ репо скилла — запушено в $R" \
        || echo "✗ репо скилла — push в $R не прошёл (репозиторий создан?), продолжаю"
    done
  fi
fi

# 2. Репозитории
for REPO in $REPOS; do
  [ -d "$REPO/.git" ] || { echo "✗ $REPO — не git-репозиторий, пропускаю"; continue; }
  for DST in "$REPO/.claude/skills" "$REPO/.agents/skills"; do
    mkdir -p "$DST"
    rm -rf "$DST/design-review"
    cp -R "$SRC" "$DST/"
    cp "$HERE/GUIDE.md" "$DST/design-review/GUIDE.md"
    find "$DST/design-review" -name .DS_Store -delete
  done

  cd "$REPO"
  git add -f .claude/skills/design-review .agents/skills/design-review
  if git diff --cached --quiet -- .claude/skills/design-review .agents/skills/design-review; then
    echo "• $REPO — без изменений"
  else
    git commit -q -m "$MSG" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" \
      -- .claude/skills/design-review .agents/skills/design-review
    echo "✓ $REPO — закоммичено: $(git log --oneline -1)"
    if [ "$PUSH" = 1 ]; then
      git push -q origin HEAD && echo "✓ $REPO — запушено в origin"
    else
      echo "  (не запушено — запустите с --push или сделайте git push сами)"
    fi
  fi
  cd "$HERE"
done

# 3. claude.ai — вручную
cat <<EOF

Осталось вручную: перезалить скилл в claude.ai
  1. Откроется страница скилла (или откройте: $SKILL_URL)
  2. Загрузите: $HERE/design-review.skill
После этого у всех в Claude (claude.ai, Desktop, Code) скилл обновится сам.
EOF
[ -z "${NO_OPEN:-}" ] && command -v open >/dev/null && open "$SKILL_URL" || true
