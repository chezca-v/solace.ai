import 'dart:convert';
import 'local_ai.dart';

/// Safe JSON extractor and parser for on-device AI outputs.
class JsonParser {
  /// Extracts and decodes the first valid JSON object from raw model text.
  /// Handles code fences and surrounding commentary without throwing exceptions.
  static Map<String, dynamic>? parseJsonObject(String? rawText) {
    if (rawText == null || rawText.trim().isEmpty) {
      return null;
    }

    try {
      var cleaned = rawText.trim();

      // Remove markdown code fences if present
      if (cleaned.startsWith('```')) {
        final lines = cleaned.split('\n');
        if (lines.isNotEmpty && lines.first.startsWith('```')) {
          lines.removeAt(0);
        }
        if (lines.isNotEmpty && lines.last.trim().startsWith('```')) {
          lines.removeLast();
        }
        cleaned = lines.join('\n').trim();
      }

      final firstBrace = cleaned.indexOf('{');
      final lastBrace = cleaned.lastIndexOf('}');

      if (firstBrace == -1 || lastBrace == -1 || firstBrace > lastBrace) {
        return null;
      }

      final jsonSubstring = cleaned.substring(firstBrace, lastBrace + 1);
      final decoded = jsonDecode(jsonSubstring);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Parses raw text into an AiResult instance, validating expected fields.
  static AiResult? parseAiResult(
    String? rawText, {
    required String engineUsed,
    required bool usedModel,
  }) {
    final map = parseJsonObject(rawText);
    if (map == null) return null;

    try {
      final reflection = map['reflection']?.toString() ?? '';
      if (reflection.isEmpty) return null;

      final question = map['question']?.toString() ??
          map['followUpQuestion']?.toString();

      final rawOptions = map['options'];
      final List<OptionItem> options = [];

      if (rawOptions is List) {
        for (final item in rawOptions) {
          if (item is Map) {
            final name = item['name']?.toString() ?? '';
            final pros = item['pros'] is List
                ? (item['pros'] as List).map((e) => e.toString()).toList()
                : <String>[];
            final cons = item['cons'] is List
                ? (item['cons'] as List).map((e) => e.toString()).toList()
                : <String>[];

            if (name.isNotEmpty || pros.isNotEmpty || cons.isNotEmpty) {
              options.add(OptionItem(name: name, pros: pros, cons: cons));
            }
          }
        }
      }

      return AiResult(
        reflection: reflection,
        options: options,
        followUpQuestion: question,
        engineUsed: engineUsed,
        usedModel: usedModel,
      );
    } catch (_) {
      return null;
    }
  }
}
