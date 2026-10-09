import 'dart:async';
import 'gemma_ai.dart';
import 'local_ai.dart';
import 'rule_based_ai.dart';

/// Central singleton service orchestrating on-device AI inference with automatic fallback.
class AiService {
  AiService._internal({LocalAi? gemmaEngine, LocalAi? fallbackEngine})
      : _gemmaEngine = gemmaEngine ?? GemmaAi(),
        _ruleBasedEngine = fallbackEngine ?? RuleBasedAi();

  static final AiService instance = AiService._internal();

  factory AiService({LocalAi? gemmaEngine, LocalAi? fallbackEngine}) {
    if (gemmaEngine != null || fallbackEngine != null) {
      return AiService._internal(
        gemmaEngine: gemmaEngine,
        fallbackEngine: fallbackEngine,
      );
    }
    return instance;
  }

  final LocalAi _gemmaEngine;
  final LocalAi _ruleBasedEngine;
  bool _isModelReady = false;

  /// Human-readable name of the currently active AI engine.
  String get engineName =>
      _isModelReady ? _gemmaEngine.engineName : _ruleBasedEngine.engineName;

  /// True only when the on-device SLM is initialized and active.
  bool get usingModel => _isModelReady;

  /// Initializes the AI service, attempting to boot Gemma before falling back to rule-based mode.
  Future<bool> init() async {
    try {
      final gemmaSuccess = await _gemmaEngine.init();
      if (gemmaSuccess) {
        _isModelReady = true;
        return true;
      }
    } catch (_) {
      _isModelReady = false;
    }

    await _ruleBasedEngine.init();
    _isModelReady = false;
    return true;
  }

  /// Generates a two-sentence reflection and gentle follow-up question.
  Future<AiResult> reflect(String entry, UserContext ctx) async {
    if (_isModelReady) {
      try {
        final result = await _gemmaEngine
            .reflect(entry, ctx)
            .timeout(const Duration(seconds: 30));

        if (result.error == null && result.reflection.trim().isNotEmpty) {
          return result;
        }
      } catch (_) {
        // Fall through to rule-based fallback on timeout, error, or invalid output
      }
    }

    final fallbackResult = await _ruleBasedEngine.reflect(entry, ctx);
    return AiResult(
      reflection: fallbackResult.reflection,
      options: fallbackResult.options,
      followUpQuestion: fallbackResult.followUpQuestion,
      engineUsed: _isModelReady
          ? '${_ruleBasedEngine.engineName} (fallback)'
          : _ruleBasedEngine.engineName,
      usedModel: false,
    );
  }

  /// Generates a personalized daily check-in prompt based on context.
  Future<String> generateDailyPrompt(UserContext ctx) async {
    if (_isModelReady) {
      try {
        final prompt = await _gemmaEngine
            .generateDailyPrompt(ctx)
            .timeout(const Duration(seconds: 15));
        if (prompt.trim().isNotEmpty) return prompt;
      } catch (_) {
        // Fallback on timeout or error
      }
    }
    return await _ruleBasedEngine.generateDailyPrompt(ctx);
  }

  /// Analyzes trade-offs and generates a side-by-side option comparison.
  Future<AiResult> compareOptions(String entry, UserContext ctx) async {
    if (_isModelReady) {
      try {
        final result = await _gemmaEngine
            .compareOptions(entry, ctx)
            .timeout(const Duration(seconds: 30));

        if (result.error == null && result.reflection.trim().isNotEmpty) {
          return result;
        }
      } catch (_) {
        // Fall through to rule-based fallback on timeout, error, or invalid output
      }
    }

    final fallbackResult = await _ruleBasedEngine.compareOptions(entry, ctx);
    return AiResult(
      reflection: fallbackResult.reflection,
      options: fallbackResult.options,
      followUpQuestion: fallbackResult.followUpQuestion,
      engineUsed: _isModelReady
          ? '${_ruleBasedEngine.engineName} (fallback)'
          : _ruleBasedEngine.engineName,
      usedModel: false,
    );
  }
}
