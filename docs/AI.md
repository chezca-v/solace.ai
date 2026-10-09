# On-Device AI Architecture (Solace.ai)

Solace.ai provides private, local-first AI journaling companionship running completely on-device without cloud dependencies, external API calls, or remote telemetry.

---

## 1. Model Used
* **Model Name:** Gemma 3 1B IT int4 (`gemma3-1b-it-int4.task`)
* **Architecture:** Small Language Model (SLM) optimized for on-device natural language reflection and structured decision analysis.
* **Source:** [litert-community/Gemma3-1B-IT](https://huggingface.co/litert-community/Gemma3-1B-IT) on Hugging Face.
* **Direct Download URL:** `https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task`
* **Quantization & Format:** 4-bit integer quantization (int4) packed in MediaPipe `.task` format for mobile acceleration.
* **License:** Gemma Terms of Use and Open License.

---

## 2. In-App Model Downloader & Onboarding Flow
Solace downloads the Gemma SLM directly into the application's internal documents directory during the initial onboarding experience:

1. **Internal Storage Location:**
   `${getApplicationDocumentsDirectory().path}/gemma3-1b-it-int4.task`
2. **Onboarding Screen (Step 5+):**
   Immediately after profile configuration (Step 5), the app presents `ModelDownloadScreen` with the text *"Setting up your private offline brain..."* and a live progress indicator driven by `dio`.
3. **Demo Bypass:**
   Before displaying the download screen or starting the animation, the app checks if `File(filePath).exists()`. If the model is already present, the screen is skipped instantly, routing directly to the Sanctuary Dashboard.

---

## 3. Dependencies
Add or verify the following dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Networking & File Management
  dio: ^5.7.0
  path_provider: ^2.1.5
  path: ^1.9.1

  # On-Device AI
  flutter_gemma: ^1.11.2
  flutter_gemma_mediapipe: ^1.0.6

  # Local Database & Storage
  sqflite: ^2.4.1
```

---

## 4. What Runs On-Device vs What is Rule-Based

| Capability | Engine Used | Details |
| :--- | :--- | :--- |
| **SLM Reflection** | Gemma 3 1B IT (MediaPipe) | Generates nuanced 2-sentence reflections mirroring user emotions in English, Filipino, or Taglish. |
| **Structured Decision Analysis** | Gemma 3 1B IT (MediaPipe) | Analyzes dilemmas and returns structured JSON with balanced pros and cons. |
| **Deterministic Fallback Reflection** | Rule-Based Mode | Keyword intent detection (venting, decision, planning, stress) in English and Taglish. |
| **Side-by-Side Option Splitting** | Rule-Based Mode | Heuristic regex parser splitting entries across keywords (`or`, `o`, `between`, `vs`, `kaysa`). |
| **Crisis & Safety Interception** | Rule-Based Safety Protocol | Always intercepts self-harm and crisis keywords immediately with vetted helpline information. Never diagnoses. |

---

## 5. Fallback Behavior
1. **Model Availability:** `AiService` first attempts to initialize `GemmaAi`. If the model file is not present or initialization fails, `AiService` automatically boots `RuleBasedAi`.
2. **Inference Guardrails:** Each model request runs under a strict 30-second timeout.
3. **Invalid Output Recovery:** If `GemmaAi` returns unparsable JSON, it retries once with explicit JSON instructions. If it still fails or times out, execution seamlessly falls back to `RuleBasedAi`.
4. **Honest Status Tracking:** The engine name and `usingModel` flag always reflect true runtime execution. The system never claims the SLM ran when fallback was used.

---

## 6. Offline Test Steps (Airplane Mode)
To verify that Solace operates 100% locally:

1. Complete initial model download or verify the `.task` file exists in the app documents directory.
2. Put the Android phone into **Airplane Mode** (disable Wi-Fi, Mobile Data, and Bluetooth).
3. Launch the Solace app (notice the instant demo bypass straight to the Sanctuary Dashboard).
4. Open a new journal entry and write a reflection or decision prompt (e.g., "Choosing between studying tonight or resting early").
5. Submit the entry and observe the reflection and option breakdown generated on-device.
6. Verify in Settings that the engine status displays active on-device execution with zero network roundtrips.

---

## 7. Disclosures
* **Models:** Google Gemma 3 1B IT (int4 quantized).
* **Frameworks:** Flutter, Google MediaPipe on Android.
* **Cloud Services:** None. Zero cloud APIs, telemetry, or remote servers.
* **AI Development Tools:** Claude, Antigravity.
