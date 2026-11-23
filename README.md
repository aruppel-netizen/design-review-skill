# design-review — скилл дизайн-ревью для Claude, Codex и ChatGPT

Сверяет сборку с макетом в Figma и прототипом из репозитория, находит расхождения в отступах, шрифтах, радиусах, токенах и состояниях, проверяет, собран ли экран из компонентов и токенов дизайн-системы, раскладывает расхождения по критичности (🔴 Критичные · 🟠 Значимые · ⚪ Незначительные · ❓ Уточнить) и собирает отчёт. Подходит дизайнеру для приёмки сборки и разработчику для самопроверки до ревью.

Полный гайд: [GUIDE.md](GUIDE.md).

## Установка

Выберите **один** способ, иначе у вас окажутся две копии скилла.

| Где работаете | Как поставить |
|---|---|
| **Claude** (claude.ai, Desktop, Code) | включить по ссылке: https://claude.ai/customize/plugins/plugin_01FDUzPqqPJgE1hGiBgsDXaN. Плагин опубликован в библиотеке организации, обновления приходят сами. В Claude Code: `/plugin install design-review@claudeai-organization-library` |
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

### Если вы в другой организации Claude (например, ОН 2 Team)

Плагин из ссылки выше живёт в библиотеке **одной** организации claude.ai. Из другой организации его не видно. Варианты:

**Claude Code: маркетплейс из этого репозитория** (рекомендуем, обновления через `/plugin`):
```
/plugin marketplace add https://ci-gitea.cian.tech/a.ruppel/design-review-skill.git
/plugin install design-review@design-review-skill
```
Нужен доступ к gitea (git должен клонировать репозиторий). Обновиться: `/plugin marketplace update design-review-skill`.

**Claude Desktop / claude.ai: загрузить файл:** скачайте [`design-review.skill`](design-review.skill) → Settings → Capabilities → Skills → Upload skill. Это личная копия, и обновления сами не придут: при новой версии загрузите файл заново.

**Для всей вашей организации:** склонируйте репозиторий и попросите Claude Code «опубликуй плагин из папки `plugin/` в организацию». Плагин появится в библиотеке вашей организации (возможно, после проверки админом). Новые версии публикует тот, кто опубликовал первую.

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

Правки приветствуются. Схема такая:

1. **Сделайте форк** (кнопка Fork в gitea) или ветку, если у вас есть права на запись.
2. **Правьте только `design-review/`**: это `SKILL.md` и `references/`. Архивы `.skill`/`.zip`, папку `plugin/` и копии скилла в проектах не трогайте, их пересобирает `publish.sh`, и ручные правки там перезапишутся.
3. **Откройте Pull Request** в `main` и коротко опишите, что и зачем поменяли. Хорошо, если приложите пример: на каком ревью скилл ошибся или что пропустил.
4. После мержа владелец публикует новую версию (`./publish.sh --push` + обновление плагина в claude.ai), и у всех в Claude скилл обновится сам.

Описание скилла (`description` в начале SKILL.md) должно быть не длиннее 1024 символов, иначе скилл не загрузится.
