<div align="center">
  <h1>Solace.ai</h1>
  <p><strong>A private journal that helps you understand yourself and think clearly—even offline.</strong></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Early%20Prototype-blueviolet.svg" alt="Project Status: Early Prototype">
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

**Tagline:** Private by design. Personal by learning. Useful offline.

**Project description:** Solace.ai is a journal-first reflection companion. People can write freely, choose when they want help, and decide which preferences or memories Solace may use. The product is designed around local-first privacy, contextual decision support, and graceful offline use—not an always-on chatbot.

[Product Blueprint](docs/PRODUCT.md) · [Architecture](docs/ARCHITECTURE.md) · [AI & Offline Behavior](docs/AI.md) · [MIT License](LICENSE)

## 📌 Product Overview

### What users can do

- **Write privately:** Create, edit, find, and delete journal entries stored locally.
- **Ask for support when wanted:** Request a reflection or compare choices using priorities they selected.
- **Control personal context:** Review, edit, exclude, or delete approved memories and preferences.

### Why it matters

Journaling can feel directionless, personal context is easy to lose, and generic cloud AI may not reflect a person's priorities. Solace aims to help people make sense of their own writing while keeping control of sensitive context in their hands.

**Product principle:** Capture first. Understand second. Assist third. AI is optional; writing freely is the primary experience.

### Current project status

This repository is an early Flutter prototype, not yet the complete journaling app. [lib/main.dart](lib/main.dart) still launches Flutter's starter counter screen. The Gemma inference call is a stub, so a model file alone does not provide working on-device inference. See [docs/PRODUCT.md](docs/PRODUCT.md) for intended behavior and [docs/AI.md](docs/AI.md) for implementation limitations.

---

## 🚀 Live App

[https://your-live-app-url.com/](https://your-live-app-url.com/)
There is no published live app yet. The project is being developed as a local Flutter application, with Android as the initial target.

---

## 📸 Screenshots

_(Optional: Describe where your detailed screenshot folders are located or showcase a walkthrough GIF below)_

![Walkthrough GIF](docs/screenshots/walkthrough.gif)

### Portal / View A Screenshots

<table width="100%">
  <tr>
    <td align="center" valign="top">
      <strong>Dashboard View</strong><br><br>
      <img src="docs/screenshots/dashboard.png" alt="Dashboard" width="400"/>
    </td>
    <td align="center" valign="top">
      <strong>Calendar View</strong><br><br>
      <img src="docs/screenshots/calendar.png" alt="Calendar" width="400"/>
    </td>
  </tr>
</table>
---

## 🛠️ Tech Stack

| #   | Tool / Technology                          | Category               | Description                                                                     |
| --- | ------------------------------------------ | ---------------------- | ------------------------------------------------------------------------------- |
| 1   | Flutter / Dart                             | Mobile application     | Cross-platform UI framework; Android-first for the initial prototype.           |
| 2   | SQLite / `sqflite`                         | Local persistence      | Intended local storage for journal entries, preferences, and approved memories. |
| 3   | `dio`, `path_provider`, `path`             | File management        | Declared packages for model download and application file paths.                |
| 4   | `flutter_gemma`, `flutter_gemma_mediapipe` | On-device AI candidate | Declared dependencies; runtime integration and inference are not yet working.   |
| 5   | Plus Jakarta Sans                         | Typography             | Bundled and applied through Flutter's shared theme across supported targets.    |

---

## 🏗️ System Architecture

The intended application keeps journaling, search, user-approved context, and supported AI processing on the device. The model runtime is optional and must be verified on the target phone. No cloud backend is required for the offline core.

```text
[Flutter UI] ---> [Local App Workflows] ---> [SQLite on device]
                         |
                         +---> [Permission-aware local retrieval]
                         |
                         +---> [Verified on-device model OR disclosed rule-based fallback]
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for component responsibilities and data flows.

---

## 🔒 Security & Data Privacy

These are product requirements and should not be read as claims that every control is already implemented.

- **Local-first:** Journal content should stay on the device by default; do not send it to cloud AI or analytics.
- **User control:** Use only context the user permits, and ask before saving inferred themes as long-term memories.
- **No sensitive logs:** Never log raw journal text or prompts containing private content.
- **Honest AI status:** Distinguish model output from deterministic fallback behavior.
- **Safe boundaries:** Solace is a journaling and reflection companion, not a clinician, diagnostic product, or crisis service.
- **Storage security:** Offline storage alone is not a complete security guarantee. Assess database protection, backups, device compromise, and deletion behavior before production.

---

## ⚙️ Getting Started & Local Setup

### Prerequisites

- Flutter SDK 3.10 or newer and Dart
- Git
- For Android: Android Studio and Android SDK, plus an emulator or USB-debugging-enabled Android device

### Installation

1. Clone the repository:

```powershell
git clone https://github.com/chezca-v/solace.ai.git
cd solace.ai
```

2. Check your Flutter setup and install Dart dependencies:

```powershell
flutter doctor
flutter pub get
```

3. Start an Android emulator or connect a device, then run:

```powershell
flutter devices
flutter run
```

If more than one device is available, specify one with `flutter run -d <device-id>`. The current app still opens the starter counter screen.

No `.env` file or backend service is required to run the current Flutter prototype. The root `.env.example` documents that no environment variables are currently needed.

---

## 🧪 Testing

Run the Flutter analyzer and tests:

```powershell
flutter analyze
flutter test
```

On-device inference and offline behavior must additionally be verified on the actual target phone; see [docs/AI.md](docs/AI.md).

---

## 🗂️ Repository Structure

```text
solace.ai/
├── android/              # Android application
├── assets/               # Shared bundled fonts, brand art, images, and animations
├── docs/                 # Product, architecture, and AI documentation
├── ios/                  # iOS application
├── lib/
│   ├── ai/               # AI orchestration, prompts, and local engines
│   ├── services/         # Shared services
│   ├── ui/screens/        # Flutter screens
│   └── main.dart          # Current app entry point
├── test/                 # Flutter tests
├── pubspec.yaml           # Flutter dependencies and project settings
└── README.md              # Project overview and setup
```

---

## 🤝 Contributing

Contributions are welcome. Please focus on the local-first product principles and clearly distinguish planned behavior from verified functionality.

1. Fork the project.
2. Create a feature branch.
3. Make and test your changes with `flutter analyze` and `flutter test`.
4. Open a pull request describing the change and its validation.

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.

## 🤔‍💻 Meet the Team

<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td align="center" width="25%">
      <img src="docs/team/Banayad.jpg" alt="Franchezca" style="border-radius: 50%; width: 120px; height: 120px;"><br>
      <strong>Franchezca Natividad Z. Banayad</strong><br>
      <sub>Product Lead</sub><br><br>
      <a href="https://www.linkedin.com/in/franchezca-banayad/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
      </a>
    </td>
    <td align="center" width="25%">
      <img src="docs/team/Listangco.jpg" alt="John Benedict" style="border-radius: 50%; width: 120px; height: 120px;"><br>
      <strong> John Benedict S. Listangco</strong><br>
      <sub>DevOps & Infrastructure Lead</sub><br><br>
      <a href="https://www.linkedin.com/in/john-benedict-listangco/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
      </a>
    </td>
    <td align="center" width="25%">
      <img src="docs/team/Sanchez.jpg" alt="Princess Mae" style="border-radius: 50%; width: 120px; height: 120px;"><br>
      <strong>Princess Mae V. Sanchez</strong><br>
      <sub>AI Engineer</sub><br><br>
      <a href="https://www.linkedin.com/in/cessamaeeee/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
      </a>
    </td>
        <td align="center" width="25%">
      <img src="docs/team/Frigillana.jpg" alt="Ysa" style="border-radius: 50%; width: 120px; height: 120px;"><br>
      <strong>Niña Ysabelle C. Frigillana</strong><br>
      <sub>Frontend Develope</sub><br><br>
      <a href="https://www.linkedin.com/in/frigillanaysabelle/">
        <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
      </a>
    </td>
  </tr>
</table>
