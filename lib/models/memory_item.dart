/// Model representing a user-approved long term memory or stated priority in the vault
class MemoryItem {
  final String id;
  final String title;
  final String quoteOrDescription;
  final String source;
  final String category; // 'High Priority', 'Core Value', 'Life Context', 'Rule'
  final String subcategory; // 'Boundaries', 'Onboarding', 'Profile'
  final bool isQuote;
  bool isActive;
  final DateTime createdAt;

  MemoryItem({
    required this.id,
    required this.title,
    required this.quoteOrDescription,
    required this.source,
    required this.category,
    required this.subcategory,
    this.isQuote = true,
    this.isActive = true,
    required this.createdAt,
  });
}
