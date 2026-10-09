# On-Device AI Architecture (Solace.ai)

Solace.ai provides private, local-first AI journaling companionship running completely on-device without cloud dependencies, external API calls, or remote telemetry.

---

## 1. Model Used
* **Model Name:** Gemma 3 1B IT int4 (`gemma3-1b-it-int4.task`)
* **Architecture:** Small Language Model (SLM) optimized for on-device natural language reflection and structured decision analysis.
* **Source:** [litert-community/Gemma3-1B-IT](https://huggingface.co/litert-community/Gemma3-1B-IT) on Hugging Face.
* **Quantization & Format:** 4-bit integer quantization (int4) packed in MediaPipe `.task` format for mobile acceleration.
* **License:** Gemma Terms of Use and Open License.

---

## 2. How to Sideload the Model
During local development and testing, sideload the `.task` model file to the Android device Download directory:

1. Download `gemma3-1b-it-int4.task` from Hugging Face.
2. Connect your Android device via USB with USB debugging enabled.
3. Push the file using ADB:
   ```bash
   adb push gemma3-1b-it-int4.task /storage/emulated/0/Download/gemma3-1b-it-int4.task
   ```
4. Alternatively, transfer the file directly to the phone's internal storage `Download/` folder using the Android File Transfer or Files app.

---

## 3. Dependencies to Add
Add the following dependencies to `pubspec.yaml` when integrating the AI engine and local persistence:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # On-Device AI
  flutter_gemma: ^1.11.2
  flutter_gemma_mediapipe: ^1.0.6

  # Local Database & Storage
  sqflite: ^2.4.1
  path: ^1.9.1
  path_provider: ^2.1.5
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

1. Put the Android phone into **Airplane Mode** (disable Wi-Fi, Mobile Data, and Bluetooth).
2. Launch the Solace app.
3. Open a new journal entry and write a reflection or decision prompt (e.g., "Choosing between studying tonight or resting early").
4. Submit the entry and observe the reflection and option breakdown generated on-device.
5. Verify in the Settings screen that the engine status displays active on-device execution with zero network roundtrips.

---

## 7. Disclosures
* **Models:** Google Gemma 3 1B IT (int4 quantized).
* **Frameworks:** Flutter, Google MediaPipe on Android.
* **Cloud Services:** None. Zero cloud APIs, telemetry, or remote servers.
* **AI Development Tools:** Claude, Antigravity.
