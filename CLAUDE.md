# Solace.ai Project Guide

## 🛠️ Build & Development

* **Prerequisites:** Flutter SDK 3.10 or newer, Dart, and Git. Android development also requires Android Studio and the Android SDK.
* **Install dependencies:** `flutter pub get`
* **Check toolchain:** `flutter doctor`
* **List available targets:** `flutter devices`
* **Run the app:** `flutter run` (or `flutter run -d <device-id>`)
* **Analyze code:** `flutter analyze`

The current `lib/main.dart` still launches the Flutter starter counter screen. Do not describe the complete Solace journaling experience as implemented yet.

## 🧪 Testing

* **Run all Flutter tests:** `flutter test`
* **Run a specific test file:** `flutter test test/path_to_test.dart`
* **Validate Dart changes:** `flutter analyze`

For offline, persistence, or on-device inference changes, validate on the intended Android device where practical and report what was not tested.

## 📁 Codebase Structure

* `lib/ai/` — AI orchestration, prompts, local engines, and fallback behavior
* `lib/services/` — Shared application services
* `lib/ui/screens/` — Flutter screens
* `test/` — Flutter tests
* `docs/PRODUCT.md` — Product concept, priorities, and intended user experience
* `docs/ARCHITECTURE.md` — Proposed application architecture
* `docs/AI.md` — AI, model, fallback, and offline requirements
* `docs/AGENTS.md` — Repository-specific agent instructions

## 💡 Product & Privacy Principles

* **Capture first. Understand second. Assist third.** Journaling is primary; AI is optional and user-requested.
* Keep journal and personal context local by default. Do not log raw journal content or send it to cloud services.
* Use only context the user has allowed; ask before saving inferred themes as memories.
* Clearly identify model output versus deterministic fallback. The Gemma inference implementation is currently a stub.
* Do not diagnose, label, or claim to predict mental-health conditions or crises.
* Keep documentation accurate: distinguish intended features from working, verified behavior.
