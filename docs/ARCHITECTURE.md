# System Architecture

> A high-level technical overview of Solace.ai's proposed design, components, and local data flows. This describes the intended product architecture; the current repository is an early Flutter prototype.

---

## 📐 1. System Overview

Solace.ai is designed as a journal-first mobile application. Writing, local search, approved personal context, and supported AI assistance should remain available offline. A cloud backend is not required for the offline core.

* **Architecture Style:** Local-first mobile application with optional on-device inference.
* **Core Purpose:** Protect private writing, support user-controlled personalization, and remain useful without a network.

```text
[Flutter UI] ---> [Application Workflows] ---> [SQLite on device]
                          |
                          +---> [Permission-aware local retrieval]
                          |
                          +---> [Verified local model OR disclosed rule-based fallback]
```

---

## 🛠️ 2. Technology Stack & Components

| Tier | Technology | Purpose / Rationale |
| --- | --- | --- |
| **Mobile UI** | Flutter / Dart | Onboarding, journaling, settings, and AI response screens; Android-first for the prototype. |
| **Local persistence** | SQLite / `sqflite` | Store journal entries, profile preferences, approved memories, and settings on the device. |
| **AI orchestration** | Dart | Build prompts from permitted context, validate output, and report which engine responded. |
| **Inference** | One device-verified runtime and model | Candidate on-device inference; select only after testing on the target phone. |
| **Fallback** | Deterministic local rules | Limited behavior when inference is unavailable; disclose that rules were used. |
| **Offline references** | Bundled, reviewed content | Provide dated reference material for supported safety scenarios; not live alerts. |

The repository currently declares Flutter Gemma and MediaPipe packages, but the inference integration is incomplete. See [AI.md](AI.md) for the current status.

---

## 🗂️ 3. Directory & Module Structure

The current repository is organized as a Flutter application:

```text
root/
├── android/                  # Android application
├── docs/                     # Product, architecture, and AI documentation
├── ios/                      # iOS application
├── lib/
│   ├── ai/                   # AI orchestration, prompts, and local engines
│   ├── services/             # Shared application services
│   ├── ui/screens/           # Flutter screens
│   └── main.dart             # Current application entry point
├── test/                     # Flutter tests
└── pubspec.yaml              # Dependencies and Flutter configuration
```

The directory layout does not imply that all planned product flows have been implemented.

---

## 🔄 4. Data Flow & Request Lifecycle

### Saving a journal entry

1. **User input:** The user writes in the journal editor; AI analysis is not automatic.
2. **Local validation:** The application validates basic fields.
3. **Local persistence:** The entry is stored in SQLite and remains available after restart.
4. **Confirmation:** The UI reports save status. Journal content is not sent to a remote service or written to logs.

### Requesting a reflection or decision comparison

1. **Explicit request:** The user asks for help from a particular entry.
2. **Context selection:** The app loads that entry and only profile or memory context permitted by the user.
3. **Local retrieval:** Relevant prior entries may be retrieved locally; show their source and allow correction.
4. **Inference:** The orchestrator calls a verified local model or suitable deterministic fallback.
5. **Validation:** The output is validated and displayed separately from the user's original writing.
6. **User control:** The user can dismiss or correct the response. Ask before saving inferred themes as long-term memory.

### Local search

1. Search runs against the local journal database.
2. Results open in their original form.
3. Use a result as AI context only when permitted, and make its source visible.

---

## 🔒 5. Security & Authentication

Solace does not require user accounts or a remote authentication service for the offline core.

* **Authentication:** No account system is required by the current local-first product direction.
* **Authorization:** The user controls whether AI is enabled and which context it may use.
* **Data Protection:** Do not transmit journal text or include it in telemetry or logs. Provide understandable controls to delete entries, memories, and local data.
* **Device Storage:** Offline storage is not automatically secure. Assess database protection, Android backups, app-lock options, rooted/debuggable devices, and user-controlled export before production.
* **Safety:** Do not present generated text as diagnosis or professional advice. Bundled emergency references must be reviewed, sourced, and dated; they cannot represent live conditions.

---

## 🚀 6. Deployment & Infrastructure

The initial release target is an Android app demonstrated and tested on the actual target phone.

* **Development:** Run locally with Flutter and an Android emulator or connected device.
* **Device validation:** Verify persistence, deletion, offline behavior, model status, and fallback behavior on the demo device.
* **Distribution:** No production deployment or live app is configured yet.
* **Future platforms:** iOS may be considered after the Android core and local inference path are stable.

Do not add cloud infrastructure for the offline core. Any future online feature requires explicit opt-in and a documented data-flow review.
