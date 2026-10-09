/// Base interface and data models for on-device AI operations.
abstract class LocalAi {
  Future<bool> init();
  Future<AiResult> reflect(String entry, UserContext ctx);
  Future<AiResult> compareOptions(String entry, UserContext ctx);
  String get engineName;
}

/// Context gathered from onboarding profile, approved memories, and past entries.
class UserContext {
  final List<String> goals;
  final List<String> supportStyles;
  final List<String> lifeAreas;
  final List<String> priorities;
  final List<String> approvedMemories;
  final List<String> relatedEntries;

  UserContext({
    this.goals = const [],
    this.supportStyles = const [],
    this.lifeAreas = const [],
    this.priorities = const [],
    this.approvedMemories = const [],
    List<String> relatedEntries = const [],
  }) : relatedEntries = relatedEntries.length > 3
            ? List.unmodifiable(relatedEntries.take(3))
            : List.unmodifiable(relatedEntries);
}

/// Standardized output from AI reflections and decision comparisons.
class AiResult {
  final String reflection;
  final List<OptionItem> options;
  final String? followUpQuestion;
  final String engineUsed;
  final bool usedModel;
  final String? error;

  const AiResult({
    required this.reflection,
    this.options = const [],
    this.followUpQuestion,
    required this.engineUsed,
    required this.usedModel,
    this.error,
  });
}

/// A decision option with side-by-side pros and cons.
class OptionItem {
  final String name;
  final List<String> pros;
  final List<String> cons;

  const OptionItem({
    required this.name,
    this.pros = const [],
    this.cons = const [],
  });
}
