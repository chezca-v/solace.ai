import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';

/// Manages private local journal entries and reflections
class JournalService extends ChangeNotifier {
  static final JournalService instance = JournalService._internal();
  JournalService._internal() {
    _loadInitialSampleEntries();
  }

  factory JournalService() => instance;

  final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => List.unmodifiable(_entries);

  void _loadInitialSampleEntries() {
    if (_entries.isNotEmpty) return;

    _entries.addAll([
      JournalEntry(
        id: 'entry-1',
        title: 'Two paths: Graduate fellowship vs Startup role',
        content:
            'Feeling torn between security and creative freedom. What if I make the wrong jump? The research lab gives steady funding and deep focus, but the startup has incredible agency and immediate impact.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        type: 'Decision',
        tags: ['Contemplative', 'Career Crossroads'],
        solBadge: 'Decision comparison ready',
        solWhisper:
            'I hear the fatigue in your voice when mentioning the sprint cycles. When you\'re ready, tap Reflect with Solace to weigh this against your non-negotiables.',
        wordCount: 184,
      ),
      JournalEntry(
        id: 'entry-2',
        title: 'Walking by the reservoir at dusk',
        content:
            'Quiet moments help clear out the fog from all-day meetings. Breathing in the cool evening breeze reminded me why space and unhurried focus matter.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        type: 'Gratitude',
        tags: ['Mindfulness', 'Nature'],
        solBadge: 'Calm baseline restored',
        wordCount: 96,
      ),
    ]);
  }

  void addEntry(JournalEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void updateEntry(JournalEntry updated) {
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _entries[index] = updated;
      notifyListeners();
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  List<JournalEntry> search(String query) {
    if (query.trim().isEmpty) return _entries;
    final lower = query.toLowerCase();
    return _entries
        .where((e) =>
            e.title.toLowerCase().contains(lower) ||
            e.content.toLowerCase().contains(lower) ||
            e.tags.any((t) => t.toLowerCase().contains(lower)))
        .toList(growable: false);
  }
}
