# YouTooOld

YouTube client for Apple Watch Series 3 (watchOS 8.x). Uses WatchKit + Invidious API.

## Requirements

- Xcode (watchOS 8.0+ SDK)
- Apple Watch Series 3 or compatible (watchOS 8.0+)
- iPhone with the YouTooOld container app for installation

## Важно: сборка в Xcode 26

**В Xcode 26 компиляция WatchKit-сторибордов сломана** (ошибка «Failed to unarchive element named "interfaceController"»). Обойти это в самой Xcode 26 нельзя.

**Что делать:** собирать проект в **Xcode 15 или Xcode 16**.

1. Скачай [Xcode 15 или 16](https://developer.apple.com/download/all/) (например, Xcode 15.4 или 16.2).
2. Установи в `/Applications/Xcode 15.app` (или оставь рядом с Xcode 26).
3. Открой проект **в этом старом Xcode** и собери (Cmd+B).
4. Запуск на устройстве/симуляторе делай из этого же Xcode.

Редактировать код можно в любой версии Xcode или в Cursor; для **сборки** используй Xcode 15/16.

## Build (в Xcode 15/16)

1. Open `YouTooOld/YouTooOld.xcodeproj` in Xcode (15 or 16).
2. Select the **YouTooOld WatchKit App** scheme (or the **YouTooOld** container scheme to run on the watch).
3. Choose a watchOS destination and build (Cmd+B).

If CodeSign fails with "resource fork, Finder information, or similar detritus not allowed", run:

```bash
xattr -cr YouTooOld
```

from the project root, then build again.

## Run on device

1. Connect your iPhone and pair your Apple Watch.
2. Select the **YouTooOld** scheme and your iPhone as the run destination.
3. Run (Cmd+R). The watch app will be installed on the paired watch.

## Testing on Series 3

- Use **Instruments → Allocations** while using the app to keep memory under ~80 MB.
- Test with Wi‑Fi only (no iPhone nearby) to match the standalone use case.
- Try API fallback by using an invalid or slow first instance; the app should switch to the next.
- Test video playback with 144p/240p/360p in Settings and audio-only mode.

## Editing the storyboard

Recent Xcode versions **cannot open WatchKit storyboards in the visual editor** (“Failed to unarchive element named 'interfaceController'”). The app still **builds** correctly.

To change the UI:

1. In the Project Navigator, **right‑click** `YouTooOld WatchKit App/Interface.storyboard`.
2. Choose **Open As** → **Source Code**.
3. Edit the XML (labels, button titles, controller IDs, etc.).
4. Save. Do **not** switch back to Interface Builder for this file or it will show the error again.

## Structure

- **YouTooOld WatchKit App**: Storyboard, assets, Info.plist.
- **YouTooOld WatchKit Extension**: All Swift code (controllers, models, services, helpers).

Invidious instances (see `.cursorrules`): vid.puffyan.us, invidious.snopyta.org, yewtu.be, invidious.kavin.rocks.
