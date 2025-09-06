# Repository Guidelines

## Project Structure & Module Organization
- `lib/` — Dart sources. Group by feature:
  - `lib/screens/` (UI screens), `lib/widgets/` (reusable widgets), `lib/widgets/text_form_fields/` (form fields), `main.dart`, `firebase_options.dart`.
- `test/` — Dart tests (`*_test.dart`).
- `android/`, `ios/` — platform projects and configs.
- `readme_files/` — images for documentation.
- Root configs: `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`.

## Build, Test, and Development Commands
- `flutter pub get` — install dependencies.
- `flutter run -d <device>` — run the app locally (emulator or device).
- `flutter test` — run unit/widget tests.
- `dart analyze` — static analysis per `analysis_options.yaml`.
- `dart format .` — format Dart code (CI-safe).
- Release builds: `flutter build apk` (Android), `flutter build ios` (iOS, requires Xcode setup).

## Coding Style & Naming Conventions
- Dart/Flutter style; 2-space indentation; keep files under ~300 lines when practical.
- Files: `snake_case.dart` (e.g., `sleep_list.dart`).
- Types/Widgets: `UpperCamelCase`; variables/methods: `lowerCamelCase`.
- Organize by feature: screens → widgets → sub-widgets; prefer composition over inheritance.
- Run `dart analyze` and `dart format .` before pushing.

## Testing Guidelines
- Framework: `flutter_test`. Place tests in `test/` as `*_test.dart`.
- Add widget tests for new screens/components (e.g., `test/sleep_list_test.dart`).
- Keep tests deterministic; avoid real network/IO. Use fakes/mocks where needed.
- Run locally: `flutter test` (optionally `--coverage`).

## Commit & Pull Request Guidelines
- Use Conventional Commits where possible: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`. Short subject (≤72 chars), details in body.
- Reference issues/PRs: `#123`. Include screenshots/GIFs for UI changes.
- PRs: clear description (what/why), steps to test, linked issues, before/after screenshots, and a checklist (tests pass, analyzed, formatted).

## Security & Configuration Tips
- Do not commit secrets or tokens. Firebase platform files are expected; avoid adding additional secret configs.
- Local setup requires `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` from Firebase; manage any extra secrets via environment/CI.

## Agent-Specific Notes
- Apply minimal, targeted changes; follow structure and style above. Ask before destructive actions (e.g., file moves, mass renames).

## 重要な指示
- ユーザーには日本語で回答してください。