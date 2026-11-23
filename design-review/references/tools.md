# Инструменты по средам

SKILL.md называет действия по смыслу. Здесь — чем их выполнить в конкретной среде. Определи среду по доступным тебе инструментам.

## Figma (одинаково везде, где подключён Figma MCP)

| Действие | Инструмент |
|---|---|
| дерево нод | `get_metadata` |
| свойства и референсный код | `get_design_context` |
| токены | `get_variable_defs` |
| скриншот фрейма | `get_screenshot` |
| запись шаблона ревью | `use_figma` (сначала скилл `figma-use`) |

В Claude Code имена с префиксом: `mcp__figma__get_metadata` и т.д. В Codex — `figma.get_metadata` или похожее; ориентируйся на суффикс.

## Браузер

| Действие | Claude in Chrome | Playwright MCP (Codex, Claude Code) | Chrome DevTools MCP |
|---|---|---|---|
| открыть страницу | `navigate` | `browser_navigate` | `navigate_page` |
| вьюпорт | `resize_window` | `browser_resize` | `resize_page` / `emulate` |
| скриншот | `computer` (screenshot) | `browser_take_screenshot` | `take_screenshot` |
| дерево доступности | `read_page` | `browser_snapshot` | `take_snapshot` |
| выполнить JS | `javascript_tool` | `browser_evaluate` | `evaluate_script` |
| клики / ввод (состояния) | `computer`, `form_input` | `browser_click`, `browser_type`, `browser_hover` | `click`, `fill`, `hover` |

Если браузера нет, но есть shell (Codex, Claude Code) — допустимо одноразово запустить headless Playwright скриптом (`npx playwright` / `python -m playwright`) и снять те же данные. Скрипт клади во временную папку, не в репозиторий пользователя.

## Репозиторий и локальный запуск (эталон из репо, сборка из ветки)

| Действие | Claude Code / Codex | Claude Desktop / claude.ai | ChatGPT |
|---|---|---|---|
| прочитать спеку, токены, README | чтение файлов | загруженные файлы / коннектор (GitHub и т.п.) | загруженные файлы / коннектор |
| склонировать репо | shell: `git clone` во временную папку | нет — попроси запустить локально и дать `localhost` | нет |
| запустить прототип / сборку | shell: `python3 -m http.server <порт>` или команда из README, в фоне | нет — пользователь запускает сам | нет |
| снять DOM прототипа | браузер (см. выше) на `http://localhost:<порт>/?…` | браузер на `localhost` пользователя | нет — только скрины прототипа |

`localhost` доступен только браузеру на той же машине, где запущен сервер. В облачных средах (Codex cloud, claude.ai без Chrome) локальный стенд не откроется — проси превью-стенд или скрины.

## ChatGPT

- Скилл загружается как файл; Figma — через коннектор/приложение Figma, если он подключён в рабочем пространстве.
- Выполнения JS на стенде обычно нет → работай по **варианту Б** (скрины/видео), помечай отступы и типографику `confidence: low`.
- Шаблон в Figma, как правило, недоступен → результат **документом** (Markdown), сводка для Slack — текстом.
