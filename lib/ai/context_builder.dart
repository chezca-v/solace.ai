import 'local_ai.dart';
import 'prompts.dart';

/// Formats UserContext into compact prompt blocks for local AI inference.
class ContextBuilder {
  /// Builds a compact context summary containing onboarding profile and approved memories.
  static String buildContextSummary(UserContext ctx) {
    final buffer = StringBuffer();

    if (ctx.goals.isNotEmpty) {
      buffer.writeln('Goals: ${ctx.goals.join(', ')}');
    }
    if (ctx.priorities.isNotEmpty) {
      buffer.writeln('Priorities: ${ctx.priorities.join(', ')}');
    }
    if (ctx.supportStyles.isNotEmpty) {
      buffer.writeln('Support Preferences: ${ctx.supportStyles.join(', ')}');
    }
    if (ctx.lifeAreas.isNotEmpty) {
      buffer.writeln('Focus Life Areas: ${ctx.lifeAreas.join(', ')}');
    }
    if (ctx.approvedMemories.isNotEmpty) {
      buffer.writeln('Approved Memories:');
      for (final memory in ctx.approvedMemories) {
        buffer.writeln('- ${Prompts.truncate(memory, 150)}');
      }
    }

    return buffer.toString().trim();
  }

  /// Returns up to 3 related entries, each truncated to at most 200 characters.
  static List<String> getTruncatedRelatedEntries(UserContext ctx) {
    return ctx.relatedEntries
        .take(3)
        .map((entry) => Prompts.truncate(entry, 200))
        .toList(growable: false);
  }
}
