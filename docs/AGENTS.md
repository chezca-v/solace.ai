# Solace.ai Agent Guidelines

These instructions apply to work in this repository. Follow the existing Flutter/Dart patterns and keep implementation status consistent with the product documentation.

## 🎯 Primary Directive

* Build Solace as a journal-first, local-first reflection companion.
* Prioritize user control: writing is primary, AI is optional, and personal memories require user approval.
* Do not claim planned product behavior is implemented unless it has been verified.
* Avoid breaking changes, unrelated edits, and new dependencies without a clear need.

## 🛠️ Code Standards & Best Practices

* **Language / Framework:** Use idiomatic Dart and Flutter. Follow the structure and naming conventions already present in `lib/`.
* **Architecture:** Keep UI, persistence, and AI orchestration responsibilities clear. Prefer local operation for journal and personal-context features.
* **Data handling:** Validate external/model output and handle failures explicitly. Do not silently present invalid output as success.
* **Privacy:** Never log raw journal text, prompts containing personal content, or private model responses. Do not add cloud transmission or telemetry for journal content.
* **AI behavior:** Use only context the user permits. Distinguish model output from deterministic fallback behavior; never claim a model ran if it did not.
* **Safety boundaries:** Do not diagnose, label, or claim to predict a mental-health condition or crisis. Treat interpretations as uncertain and allow correction or dismissal.
* **Secrets:** Never commit credentials or API keys. The current Flutter prototype has no required `.env` configuration; if a future feature needs secrets, do not embed them in the mobile app.
* **Comments:** Explain non-obvious business rules or algorithms; avoid redundant comments.

## 🧪 Testing Protocol

* Add or update relevant tests under `test/` when changing behavior.
* Run `flutter analyze` and the smallest relevant test command; run `flutter test` for broader changes.
* For changes to persistence, privacy, or inference, verify behavior on a target device where practical. Do not claim offline behavior without testing it.
* Report checks that were not run.

## 🔒 Security & Safety Constraints

* Local storage is not automatically secure. Consider deletion, backups, database protection, and device compromise when changing data handling.
* Ask before persisting inferred themes as long-term memories; provide review and deletion controls.
* For any offline safety content, use reviewed and dated sources. Do not imply bundled content provides live alerts.
* Solace is a journaling and reflection companion, not a clinician, diagnostic product, or emergency service.

## 📚 Documentation

* Keep `README.md`, `docs/PRODUCT.md`, `docs/ARCHITECTURE.md`, and `docs/AI.md` aligned with verified implementation.
* Update directly related documentation when behavior, privacy claims, dependencies, or setup steps change.
