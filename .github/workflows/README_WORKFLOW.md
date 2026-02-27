# Workflow: Build WatchKit storyboard

## Проверено

- **Пути:** репозиторий имеет структуру `YouTooOld/YouTooOld.xcodeproj` и `YouTooOld/YouTooOld WatchKit App/` — в workflow используются верные пути.
- **pbxproj:** ID `A1B101062F50D35600093105` (storyboard) и `A1B101382F50D35600093105` (BuildFile) есть в проекте — скрипты совпадают с файлом.
- **Права:** у job задано `permissions: contents: write` — push из workflow разрешён.

## Внесённые исправления

1. **git push** — явный ref: `git push origin HEAD:refs/heads/${{ github.ref_name }}`, чтобы push шёл в нужную ветку даже при нестандартном состоянии HEAD.
2. **switch-to-storyboardc.py** — проверка: если после замен ничего не изменилось или ref storyboardc не появился, скрипт завершается с ошибкой (exit 1).
3. **revert-to-storyboard.py** — проверка: если замены не изменили файл, скрипт завершается с ошибкой (exit 1).

## Возможные причины сбоев

| Проблема | Что проверить |
|----------|----------------|
| **Xcode 15 не найден** на macos-14 | В репозитории [actions/runner-images](https://github.com/actions/runner-images) посмотреть, какие версии Xcode есть на образе; при необходимости в workflow указать точную версию, например `'15.2'`. |
| **Build failed** (Scheme/Project) | В логе шага «Build WatchKit App» смотреть точную ошибку xcodebuild (подпись, путь к storyboard, таргет). |
| **YouTooOld WatchKit App.app not found** | В шаге «Find and extract» вывести `find ./derived_data -type d` и проверить фактический путь к `.app` и к `Interface.storyboardc` внутри него. |
| **push: permission denied / 128** | В настройках репо: Settings → Actions → General → Workflow permissions = «Read and write». |
| **Branch protection** | Если на `main` включены правила (required reviews, status checks), push от `GITHUB_TOKEN` может блокироваться — временно ослабить правила или пушить в отдельную ветку и мержить вручную. |

## Запуск

- Вручную: Actions → «Build WatchKit storyboard for watchOS 8» → Run workflow.
- Автоматически: при push в `main`/`master` с изменениями в `YouTooOld/YouTooOld WatchKit App/Interface.storyboard` или в этом workflow-файле.
