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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quote_or_description': quoteOrDescription,
      'source': source,
      'category': category,
      'subcategory': subcategory,
      'is_quote': isQuote ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MemoryItem.fromMap(Map<String, dynamic> map) {
    return MemoryItem(
      id: map['id'] as String,
      title: map['title'] as String,
      quoteOrDescription: map['quote_or_description'] as String,
      source: map['source'] as String,
      category: map['category'] as String,
      subcategory: map['subcategory'] as String,
      isQuote: (map['is_quote'] as int?) == 1,
      isActive: (map['is_active'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
