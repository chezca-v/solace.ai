import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../models/journal_entry.dart';

/// Manages private local journal entries and reflections
class JournalService extends ChangeNotifier {
  static final JournalService instance = JournalService._internal();
  JournalService._internal();

  factory JournalService() => instance;

  List<JournalEntry> _entries = [];
  bool _isInitialized = false;

  List<JournalEntry> get entries => List.unmodifiable(_entries);

  Future<void> init() async {
    if (_isInitialized) return;
    
    // SQLite does not support web. If running on web, fallback to in-memory list
    if (kIsWeb) {
      _loadInitialSampleEntries();
      _isInitialized = true;
      return;
    }

    await _loadFromDb();
    
    // If DB is empty, populate with samples
    if (_entries.isEmpty) {
      _loadInitialSampleEntries();
      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        for (final e in _entries) {
          await db.insert('entries', e.toMap());
        }
      }
    }
    _isInitialized = true;
  }

  Future<void> _loadFromDb() async {
    final db = await DatabaseHelper.instance.database;
    if (db == null) return;
    final List<Map<String, dynamic>> maps = await db.query('entries', orderBy: 'created_at DESC');
    _entries = maps.map((map) => JournalEntry.fromMap(map)).toList();
    notifyListeners();
  }

  void _loadInitialSampleEntries() {
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
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    _entries.insert(0, entry);
    notifyListeners();
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.insert('entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> updateEntry(JournalEntry updated) async {
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _entries[index] = updated;
      notifyListeners();
      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        await db.update(
          'entries',
          updated.toMap(),
          where: 'id = ?',
          whereArgs: [updated.id],
        );
      }
    }
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.delete(
        'entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  JournalEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
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
