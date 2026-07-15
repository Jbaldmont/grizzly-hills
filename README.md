# Grizzly Hills

Personal finance app for Android, built with Flutter. It tracks monthly budgets by spending groups, day-to-day expenses and fixed monthly payments — designed around a real envelope-style budgeting workflow instead of a generic expense tracker.

> UI is in Spanish; code and structure are in English.

## Features

- **Monthly budget** — register your salary, apply a reusable template of spending groups and track spent vs. budget per group from the home screen
- **Quick expense capture** — bottom sheet from the FAB: amount, group, note and date in seconds
- **Fixed expenses checklist** — recurring monthly payments with remembered amounts from previous months
- **Unexpected expenses** — one-off costs that draw from the overall available balance
- **Visual alerts** — per-group progress bars that change color at 75% and 90% spent
- **Theming** — light/dark/system mode with a curated set of FlexColorScheme themes, persisted across sessions

## Roadmap

Savings locations and transfers · loan tracking with interest · local notifications · month close with history · biometric lock · expense tags with charts · local JSON backup

## Tech stack

- Flutter with Material 3
- [drift](https://drift.simonbinder.eu/) (SQLite) for local persistence, with schema migrations
- shared_preferences for settings
- FlexColorScheme for theming
- Widget and unit tests with `flutter_test`

Amounts are stored as integer cents to avoid floating-point rounding issues.

## Getting started

```bash
flutter pub get
flutter run
```

Requires the Flutter SDK and an Android device or emulator.
