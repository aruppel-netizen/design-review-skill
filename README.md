# design-review — скилл дизайн-ревью для Claude, Codex и ChatGPT

Сверяет сборку с макетом в Figma и прототипом из репозитория, находит расхождения в отступах, шрифтах, радиусах, токенах и состояниях, проверяет, собран ли экран из компонентов и токенов дизайн-системы, раскладывает расхождения по критичности (🔴 Критичные · 🟠 Значимые · ⚪ Незначительные · ❓ Уточнить) и собирает отчёт. Подходит дизайнеру для приёмки сборки и разработчику для самопроверки до ревью.

Полный гайд: [GUIDE.md](GUIDE.md).

## Установка

Выберите **один** способ, иначе у вас окажутся две копии скилла.

| Где работаете | Как поставить |
|---|---|
| **Claude** (claude.ai, Desktop, Code) | включить по ссылке: https://claude.ai/customize/skills/id/plugin_016MnGNGLaaPKk1xgNM4eTF1. Обновления приходят сами |
| Claude, если ссылка не открывается | Settings → Capabilities → Skills → Upload skill → [`design-review.skill`](design-review.skill) |
| **Codex** | `git clone` этого репо → `./install.sh codex` |
| **Claude Code / Codex, для всей команды проекта** | `./install.sh repo /путь/к/проекту` → закоммитить `.claude/skills` и `.agents/skills` в проект |
| **ChatGPT** | Skills → Create → Upload from your computer → [`design-review.zip`](design-review.zip) |

Ещё нужны:
- **Figma** — коннектор в Claude или MCP; для Codex см. [`codex/config.toml.example`](codex/config.toml.example);
- **браузер**, чтобы проверять живой стенд: Claude in Chrome, Playwright MCP или Chrome DevTools MCP. Без браузера скилл работает по скринам и выдаёт менее точный результат.

```bash
git clone https://ci-gitea.cian.tech/a.ruppel/design-review-skill.git
# или копия на GitHub: git clone https://github.com/aruppel-netizen/design-review-skill.git
cd design-review-skill
./install.sh codex        # или: ./install.sh repo ~/path/to/project
```

Обновиться: `git pull` и снова `./install.sh …`.

## Как запустить

> Сделай дизайн-ревью. Макет: <ссылка на **фрейм** Figma с node-id>. Стенд: <ссылка или localhost>. Код сборки: <ветка/PR, для чекапа компонентов ДС>. Не вошло: <что осознанно не делали>. Вьюпорты 1440, 1920. Результат — документом.

## Что в репозитории

```
design-review/            сам скилл (SKILL.md + references/tools.md)
design-review.skill       архив для Claude
design-review.zip         тот же архив для ChatGPT
GUIDE.md                  полный гайд
DESCRIPTION.md            короткий текст для Slack
install.sh                установка для Claude Code / Codex
publish.sh                публикация новой версии (для владельца)
codex/config.toml.example Figma и браузер для Codex
```

## Предложить правку

Напишите автору или сделайте PR в `design-review/SKILL.md`. Архивы и копии в проектах пересобирает `publish.sh`, руками их не трогайте.
