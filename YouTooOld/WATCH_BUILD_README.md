# watchOS 8.8.1 / Apple Watch Series 3 — сборка на Xcode 26

## Проблема

На **Xcode 26** (macOS 26) компилятор storyboard (ibtool) **не поддерживает** WatchKit:  
`Unknown element name "interfaceController"`.  
Для **watchOS 8 и Series 3** нужен именно **WatchKit + Storyboard**, поэтому без обхода ты не соберёшь приложение на своём Mac.

## Решение: готовый storyboardc через GitHub Actions

Идея: storyboard **один раз компилируется в CI** на **macOS 13** (там стоит Xcode 15, он ещё умеет WatchKit). В репозиторий коммитится уже **скомпилированный** `Interface.storyboardc`. У себя на Mac (Xcode 26) ты **не компилируешь** storyboard — в бандл просто копируется этот готовый `Interface.storyboardc`. Так ты получаешь **одну и ту же сборку** под watchOS 8 / Series 3, но без старого Xcode у себя.

## Что нужно сделать один раз

1. **Создать репозиторий на GitHub** и запушить проект (если ещё не сделано).
2. **Первый запуск workflow**
   - Открой репозиторий → вкладка **Actions**.
   - Слева выбери workflow **"Build WatchKit storyboard for watchOS 8"**.
   - Нажми **Run workflow** → **Run workflow**.
3. **Дождаться зелёного завершения** (2–5 минут).
4. **Обновить проект у себя**: `git pull`.
5. **Собрать в Xcode 26** схему **YouTooOld** как обычно — в бандл попадёт готовый `Interface.storyboardc`, ibtool по storyboard вызываться не будет.

После этого ты на **своём Mac (M2, Xcode 26)** собираешь приложение для **watchOS 8.8.1 / Series 3** без виртуалок и второго Xcode.

## Когда перезапускать workflow

Запускай workflow снова, если:

- менял **Interface.storyboard** (экраны, кнопки, контроллеры);
- менял структуру **WatchKit App** (добавлял/удалял таргеты, сильно трогал project).

Workflow можно запускать вручную (**Actions** → **Build WatchKit storyboard for watchOS 8** → **Run workflow**) или он сам запустится при **push в main/master**, если изменились:

- `YouTooOld/YouTooOld WatchKit App/Interface.storyboard`
- `.github/workflows/build-watchkit-storyboard.yml`

## Что лежит в репозитории

- **Interface.storyboard** — исходник (для CI и на будущее); в твоей сборке на Xcode 26 он **не компилируется**.
- **Interface.storyboardc** — скомпилированный вариант (папка с .nib); его коммитит workflow, его копирует Xcode 26 в приложение.
- В **project.pbxproj** в таргете WatchKit App в Resources участвует **Interface.storyboardc**, а не компиляция storyboard.

## Таргеты

| Таргет                    | Назначение              | Встраивается в iOS |
|---------------------------|--------------------------|----------------------|
| YouTooOld WatchKit App    | watchOS 8 / Series 3    | ✅ Да                |
| YouTooOld Watch App (SwiftUI) | watchOS 9+ (опционально) | Нет              |

Итог: цель **watchOS 8.8.1 и Apple Watch Series 3** достигается за счёт CI и одного `git pull` после первого (и при необходимости последующих) прогонов workflow.
