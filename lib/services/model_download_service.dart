import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Top-level helper to download the Gemma 3 1B IT model directly into the app documents directory.
Future<void> downloadGemmaModel(Function(double progress) onProgress) async {
  final appDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDir.path}/gemma3-1b-it-int4.task';

  // Check if model is already downloaded
  if (await File(filePath).exists()) {
    return; // Already installed!
  }

  // Direct download link from Hugging Face
  const modelUrl =
      'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task';

  final dio = Dio();
  await dio.download(
    modelUrl,
    filePath,
    onReceiveProgress: (received, total) {
      if (total != -1) {
        final progress = received / total;
        onProgress(progress); // Pass progress to update UI bar (0.0 to 1.0)
      }
    },
  );
}

/// Service class managing the lifecycle and status of the Gemma SLM model file.
class ModelDownloadService {
  static const String modelFileName = 'gemma3-1b-it-int4.task';
  static const String modelUrl =
      'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task';

  /// Resolves the absolute path where the model is stored on the device.
  static Future<String> getModelFilePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/$modelFileName';
  }

  /// Checks if the model binary is already present in internal storage.
  static Future<bool> isModelDownloaded() async {
    final filePath = await getModelFilePath();
    return File(filePath).exists();
  }

  /// Downloads the model file with progress callback.
  static Future<void> downloadModel({
    required Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final filePath = await getModelFilePath();

    if (await File(filePath).exists()) {
      onProgress(1.0);
      return;
    }

    final dio = Dio();
    await dio.download(
      modelUrl,
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = received / total;
          onProgress(progress.clamp(0.0, 1.0));
        }
      },
    );
  }
}
