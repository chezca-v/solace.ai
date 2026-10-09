/// System and task prompt templates for Solace on-device AI.
class Prompts {
  static const String systemPrompt =
      "You are Solace, a private journaling companion. "
      "Reflect the user's words in 2 sentences. "
      "Do not give a verdict, do not diagnose, use only the context provided. "
      "If unsure, say so. "
      "Reply in the user's language (English, Filipino, or Taglish).";

  static const String jsonRetryInstruction = "Return only valid JSON.";

  /// Truncates text to maxChars without cutting mid-word where possible.
  static String truncate(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars).trim()}...';
  }

  /// Builds a reflection prompt using the journal entry and optional context.
  static String buildReflectionPrompt(
    String entry, {
    String? contextBlock,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(systemPrompt);
    buffer.writeln();

    if (contextBlock != null && contextBlock.trim().isNotEmpty) {
      buffer.writeln('Context:');
      buffer.writeln(contextBlock.trim());
      buffer.writeln();
    }

    buffer.writeln('Journal Entry:');
    buffer.writeln(entry.trim());
    buffer.writeln();
    buffer.writeln(
      'Respond with a 2-sentence reflection that gently mirrors the user feelings and phrasing, '
      'followed by one gentle question.',
    );

    return buffer.toString();
  }

  /// Builds a decision comparison prompt that strictly requires JSON output.
  static String buildDecisionPrompt({
    required String entry,
    List<String> priorities = const [],
    List<String> relatedEntries = const [],
    String? contextBlock,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(systemPrompt);
    buffer.writeln();

    if (contextBlock != null && contextBlock.trim().isNotEmpty) {
      buffer.writeln('Context:');
      buffer.writeln(contextBlock.trim());
      buffer.writeln();
    }

    if (priorities.isNotEmpty) {
      buffer.writeln('User Priorities:');
      for (final p in priorities) {
        buffer.writeln('- $p');
      }
      buffer.writeln();
    }

    if (relatedEntries.isNotEmpty) {
      buffer.writeln('Related Past Entries:');
      for (final rel in relatedEntries.take(3)) {
        buffer.writeln('- ${truncate(rel, 200)}');
      }
      buffer.writeln();
    }

    buffer.writeln('Journal Entry:');
    buffer.writeln(entry.trim());
    buffer.writeln();
    buffer.writeln(
      'Analyze the decision options from the journal entry. '
      'Output ONLY a raw JSON object with this exact schema and no other text:\n'
      '{\n'
      '  "reflection": "2-sentence reflection mirroring user words",\n'
      '  "options": [\n'
      '    {\n'
      '      "name": "Option name",\n'
      '      "pros": ["Pro 1", "Pro 2"],\n'
      '      "cons": ["Con 1", "Con 2"]\n'
      '    }\n'
      '  ],\n'
      '  "question": "Gentle follow-up question"\n'
      '}',
    );

    return buffer.toString();
  }

  /// Builds a prompt to generate a personalized short daily check-in question.
  static String buildDailyPrompt({
    List<String> goals = const [],
    List<String> priorities = const [],
  }) {
    final buffer = StringBuffer();
    buffer.writeln(systemPrompt);
    buffer.writeln();

    if (goals.isNotEmpty || priorities.isNotEmpty) {
      buffer.writeln('User Context:');
      if (goals.isNotEmpty) {
        buffer.writeln('Goals: ${goals.join(", ")}');
      }
      if (priorities.isNotEmpty) {
        buffer.writeln('Priorities: ${priorities.join(", ")}');
      }
      buffer.writeln();
    }

    buffer.writeln(
      'Based on the user\'s context, generate exactly one short, gentle question '
      'to ask them how they are doing today. Keep it under 15 words. '
      'Do not include any other text or explanation. '
      'Example: "Take a breath. How does your mind feel right now?"',
    );

    return buffer.toString();
  }
}
