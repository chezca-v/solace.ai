# On-Device AI Architecture (Solace.ai)

Solace.ai is intended to provide private, local-first journaling support. AI assistance should be optional and use only context the user permits. Journaling and local search should not depend on model or network availability.

> **Implementation status:** The current Gemma integration is incomplete. The documented model is a candidate, not a verified runtime capability. [lib/ai/gemma_ai.dart](../lib/ai/gemma_ai.dart) checks for a model file, but its inference method is a stub.

---

## 1. Model Used

- **Model Name:** Gemma 3 1B IT int4 (`gemma3-1b-it-int4.task`)
- **Architecture:** Small Language Model (SLM) optimized for on-device natural language reflection and structured decision analysis.
- **Source:** [litert-community/Gemma3-1B-IT](https://huggingface.co/litert-community/Gemma3-1B-IT) on Hugging Face.
- **Direct Download URL:** `https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task`
- **Quantization & Format:** 4-bit integer quantization (int4) packed in MediaPipe `.task` format for mobile acceleration.
- **License:** Gemma Terms of Use and Open License.

---

## 2. In-App Model Downloader & Onboarding Flow

The intended product may offer an optional model setup flow after the user has made privacy choices. Model availability must not block journaling.

1. **Local storage:** Store an installed model in application-private storage, using a platform-supported path.
2. **User choice:** Explain model size, purpose, and local processing before download or installation.
3. **Progress and errors:** Show real download progress and clear retry/cancel options if a download flow is implemented.
4. **Existing model:** Check whether a compatible model is installed before offering setup again.
5. **Current status:** A complete, verified onboarding downloader is not yet implemented. Do not claim this flow is available.

The current code references `${getApplicationDocumentsDirectory().path}/gemma3-1b-it-int4.task` as a candidate location, not a guarantee of a working model install.

---

## 3. Dependencies

The current `pubspec.yaml` declares the following relevant dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Networking & File Management
  dio: ^5.7.0
  path_provider: ^2.1.5
  path: ^1.9.1

  # On-Device AI Candidate
  flutter_gemma: ^1.11.2
  flutter_gemma_mediapipe: ^1.0.6

  # Local Database & Storage
  sqflite: ^2.4.1
```

Declared packages do not by themselves mean that model download, inference, or persistent journaling is fully implemented.

---

## 4. What Runs On-Device vs What is Rule-Based

| Capability                      | Intended Engine                               | Current Status                                                                        |
| :------------------------------ | :-------------------------------------------- | :------------------------------------------------------------------------------------ |
| **Journal storage and search**  | Local database                                | Product requirement; verify the complete flow before describing it as available.      |
| **Reflection**                  | Verified local model or disclosed local rules | Gemma inference is not implemented; do not claim model-generated reflection.          |
| **Structured decision support** | Verified local model or disclosed local rules | Intended feature; verify output and context behavior on the target phone.             |
| **Personal context retrieval**  | Local database and retrieval                  | Must use only permitted context and expose its source to the user.                    |
| **Memory management**           | User-approved local memory                    | Ask before saving inferred themes; provide review, edit, exclusion, and deletion.     |
| **Safety references**           | Reviewed, bundled content                     | If implemented, identify source and review date; offline content is not a live alert. |
| **Voice transcription**         | Future on-device speech-to-text               | Not part of the verified current implementation.                                      |

Solace should not claim accurate emotion detection, diagnosis, crisis prediction, or complete understanding of a user.

---

## 5. Fallback Behavior

The intended local AI flow is:

1. **Model availability:** Attempt inference only when the selected local model is installed and initialized.
2. **Output validation:** Validate generated text or structured output before displaying it.
3. **Recoverable errors:** For missing models, timeouts, or invalid output, use a suitable deterministic local fallback when one exists.
4. **Honest status:** Identify whether a response came from the model, rules, or no available engine.
5. **No success-shaped failure:** If no safe fallback exists, report that assistance is unavailable while preserving access to the journal.

The current `AiService` has a model-first/rule-based-fallback structure, but the Gemma inference method is a stub. Its existence does not demonstrate working model inference or a completed safety protocol.

---

## 6. Offline Test Steps (Airplane Mode)

After journal persistence and on-device inference are implemented, validate them on the actual target phone:

1. Install the app and any required model while online; confirm the model status in the app.
2. Enable **Airplane Mode** and verify that Wi-Fi and mobile data remain disabled.
3. Create, edit, reopen, search, and delete a journal entry.
4. Request a supported reflection or decision comparison using only permitted local context.
5. Confirm the UI reports the actual engine used and handles model failure transparently.
6. Reopen the app offline and verify saved data remains available.
7. Inspect runtime network behavior; a successful airplane-mode test alone is not proof that the app never makes network requests.

The offline demo must not depend on a first-run model download or remote API. Do not report these steps as passing until tested.

---

## 7. Disclosures

- **Model:** Gemma 3 1B IT int4 is a candidate, not a verified integrated model.
- **Frameworks:** Flutter and Dart; MediaPipe is a candidate Android inference runtime.
- **Cloud Services:** No cloud service is required by the intended offline core. Verify actual runtime network behavior before making an absolute zero-network claim.
- **Privacy:** Local storage alone does not guarantee secure storage; assess device backups and database protection before production.
- **Product Boundary:** Solace is a journaling and reflection companion, not a clinician, diagnostic product, or emergency service.
