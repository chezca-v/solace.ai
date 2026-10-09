# Physical Device Testing Guide: On-Device Gemma 3 1B with MediaPipe / LiteRT

This guide provides step-by-step instructions for installing, configuring, and testing on-device Small Language Model (SLM) inference using **Google Gemma 3 1B IT (int4)** via **MediaPipe / LiteRT** in **Solace.ai**.

---

## 1. Hardware & System Requirements

Running Large/Small Language Models locally on mobile hardware requires sufficient memory and GPU acceleration.

### Android Requirements
- **OS Version:** Android 8.0 (API Level 26) or higher.
- **Physical RAM:** 
  - **Minimum:** 4 GB RAM.
  - **Recommended:** 6 GB – 8 GB RAM or higher (avoids OS memory pressure when loading weights into GPU memory).
- **Free Storage:** At least **2.5 GB** free internal storage (the quantized model is ~500 MB – 1.5 GB depending on bundle precision + working buffer).
- **Processor / GPU:** 
  - Qualcomm Snapdragon 7-series / 8-series (Adreno 640+).
  - Google Tensor (Pixel 6, 7, 8, 9, 10 series).
  - MediaTek Dimensity 8000/9000 series (Mali-G77+).
  - *Must support OpenCL or Vulkan GPU acceleration.*

### iOS Requirements
- **OS Version:** iOS 16.0 or higher.
- **Device Generation:** iPhone 12 or newer (A14 Bionic chip or newer with Apple Neural Engine & Metal support).
- **Physical RAM:** 4 GB RAM or higher.
- **Free Storage:** At least **3.0 GB** free storage.

---

## 2. Model Specifications & Source

- **Model Identifier:** `gemma3-1b-it-int4.task`
- **Architecture:** Gemma 3 1B Instruction-Tuned (SLM).
- **Quantization:** 4-bit integer (`int4`) weights with group-wise quantization.
- **Runtime Format:** MediaPipe GenAI Task Bundle (`.task`).
- **Official Hugging Face Repository:** [litert-community/Gemma3-1B-IT](https://huggingface.co/litert-community/Gemma3-1B-IT)
- **Direct Download URL:**
  ```text
  https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task
  ```

---

## 3. Preparation & Build Steps

### Step 1: Prepare Your Device
1. On Android:
   - Go to **Settings > About Phone** and tap **Build Number** 7 times to enable Developer Options.
   - Go to **Settings > Developer Options** and enable **USB Debugging**.
   - Connect the phone to your computer via USB and allow USB debugging when prompted.
2. Confirm Flutter detects your device:
   ```powershell
   flutter devices
   ```

### Step 2: Android Build Configuration Verification
Verify that `android/app/build.gradle.kts` specifies `minSdk = 26`:
```kotlin
defaultConfig {
    applicationId = "com.example.solace_ai"
    minSdk = 26
    targetSdk = flutter.targetSdkVersion
    ...
}
```

---

## 4. Model Loading Options

### Option A: In-App Download (Standard User Flow)
1. Launch the app on your physical device:
   ```powershell
   flutter run -d <your-device-id>
   ```
2. Navigate to the **Model Download Screen**.
3. Tap **Download Model (Gemma 3 1B)**.
4. The built-in `ModelDownloadService` uses `dio` with chunked streaming to write the `.task` file directly to `getApplicationDocumentsDirectory()/gemma3-1b-it-int4.task`.

### Option B: Sideload via ADB (Fast Developer Flow)
To test immediately without waiting for in-app download:
1. Download `gemma3-1b-it-int4.task` on your PC:
   ```powershell
   curl -L -o gemma3-1b-it-int4.task "https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task"
   ```
2. Push the model directly to the app's internal documents folder:
   ```powershell
   adb push gemma3-1b-it-int4.task /data/user/0/com.example.solace_ai/app_flutter/gemma3-1b-it-int4.task
   ```

---

## 5. Step-by-Step Test Procedure

### Test 1: Verification of Rule-Based Fallback (Before Model Download)
1. Open Solace on a fresh install without the model file.
2. Create a journal entry: *"I'm feeling very overwhelmed with exams."*
3. Request reflection.
4. **Expected Result:**
   - App responds promptly with an empathetic reflection.
   - The engine indicator displays **"Rule-based mode"**.
   - No crashes or freeze occurs.

### Test 2: On-Device Model Initialization & Warm-up
1. Ensure `gemma3-1b-it-int4.task` is in place.
2. Open the app (or trigger model initialization).
3. Check `flutter logs` or `adb logcat | grep -i mediapipe`:
   - MediaPipe initializes the GPU delegate (OpenCL / Vulkan / Metal).
   - `GemmaAi.init()` returns `true`.
   - The engine indicator updates to **"Gemma 3 1B (on-device)"**.

### Test 3: Live Natural Reflection Generation
1. Write a reflective journal entry:
   > *"I had a conversation with my manager today about shifting roles. Part of me is excited for the challenge, but I'm nervous about leaving my current team."*
2. Tap **Reflect**.
3. **Expected Result:**
   - MediaPipe executes local token generation.
   - Text streams or generates without contacting any external API.
   - Generates non-judgmental, warm reflection tailored to the user's entry.

### Test 4: Structured Decision Support (JSON Parsing & Option Extraction)
1. Write a decision dilemma:
   > *"Should I take the job offer in Cebu or stay at my current tech firm in Manila?"*
2. Tap **Compare Options**.
3. **Expected Result:**
   - Gemma outputs structured JSON with `reflection`, `options`, `pros`, `cons`, and `question`.
   - `JsonParser.parseAiResult()` extracts side-by-side cards comparing "Move to Cebu" vs "Stay in Manila".
   - If initial output formatting is missing fences, the auto-retry prompt transparently recovers and structures the data.

### Test 5: Crisis & Safety Boundary Check
1. Write an entry containing crisis phrases (e.g., self-harm indicators).
2. **Expected Result:**
   - Safety guard immediately overrides generative output with standard supportive helpline references (National Center for Mental Health: 1553 / 0917-899-8727).
   - Generative hallucination or medical diagnostic labels are strictly avoided.

---

## 6. Airplane Mode (Zero-Network) Validation

To certify **true offline privacy**:

1. Put the physical device in **Airplane Mode**.
2. Manually verify that **Wi-Fi is OFF**, **Mobile Data is OFF**, and **Bluetooth is OFF**.
3. Perform **Test 3** (Reflection) and **Test 4** (Decision Support).
4. **Expected Result:**
   - All AI inference, reflection, local SQLite persistence, and UI rendering function with zero network access.
   - Latency remains consistent with offline GPU execution.

---

## 7. Performance & Latency Expectations

| Metric | Target on Modern SoC (Snapdragon 8 Gen 2/3, Tensor G3/G4, Apple A15+) | Mid-Range SoC (Snapdragon 778G, Dimensity 8100) |
| :--- | :--- | :--- |
| **Model Load Time** | ~1.0 – 2.5 seconds | ~3.0 – 5.0 seconds |
| **Time to First Token (TTFT)** | ~250ms – 600ms | ~700ms – 1.5s |
| **Inference Speed** | ~15 – 25 tokens/second | ~7 – 12 tokens/second |
| **RAM Consumption** | ~1.2 GB – 1.6 GB peak | ~1.2 GB – 1.6 GB peak |

---

## 8. Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **`OutOfMemoryError` / App Crash on Init** | Device physical RAM is under 4GB or background apps consumed RAM. | Close background apps, restart device, or ensure swap/zRAM is enabled. |
| **`minSdkVersion` Gradle error** | Android `minSdk` below 26. | Confirm `minSdk = 26` in `android/app/build.gradle.kts`. |
| **Engine stays in "Rule-based mode"** | Model file not found at expected path. | Verify file exists at `getApplicationDocumentsDirectory()/gemma3-1b-it-int4.task` using in-app downloader or `adb shell ls`. |
| **Slow Inference (>5s per sentence)** | Fallback to CPU delegate if GPU delegate fails to initialize. | Verify OpenCL / Vulkan drivers on device; restart device. |
