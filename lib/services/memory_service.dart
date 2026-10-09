import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../models/memory_item.dart';

/// Service managing user-approved personal memories and decision weights in SQLite
class MemoryService extends ChangeNotifier {
  static final MemoryService instance = MemoryService._internal();
  MemoryService._internal();

  factory MemoryService() => instance;

  final List<MemoryItem> _memories = [];
  bool _isInitialized = false;

  List<MemoryItem> get memories => List.unmodifiable(_memories);

  int get activeCount => _memories.where((m) => m.isActive).length;

  Future<void> init() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      _loadSampleMemories();
      _isInitialized = true;
      return;
    }

    await _loadFromDb();

    if (_memories.isEmpty) {
      _loadSampleMemories();
      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        for (final m in _memories) {
          await db.insert('memories', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    _isInitialized = true;
  }

  Future<void> _loadFromDb() async {
    final db = await DatabaseHelper.instance.database;
    if (db == null) return;
    final List<Map<String, dynamic>> maps = await db.query('memories', orderBy: 'created_at DESC');
    _memories.clear();
    _memories.addAll(maps.map((map) => MemoryItem.fromMap(map)).toList());
    notifyListeners();
  }

  void _loadSampleMemories() {
    if (_memories.isNotEmpty) return;

    _memories.addAll([
      MemoryItem(
        id: 'mem-1',
        title: 'Sustainable Pace & Boundaries',
        quoteOrDescription:
            '“Prioritize sustainable pacing and mental clarity over excessive urgency.”',
        source: 'Sanctuary reflection',
        category: 'HIGH PRIORITY',
        subcategory: 'Boundaries',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      MemoryItem(
        id: 'mem-2',
        title: 'Core Values & Mindful Living',
        quoteOrDescription:
            '“Seek alignment with personal values and intentional decision making.”',
        source: 'Core Sanctuary Priority',
        category: 'CORE VALUE',
        subcategory: 'Values',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      MemoryItem(
        id: 'mem-3',
        title: 'Local Privacy & Sovereignty',
        quoteOrDescription:
            'All reflections, memories, and decision structures remain strictly encrypted and processed on this local device.',
        source: 'Sanctuary Protocol',
        category: 'LIFE CONTEXT',
        subcategory: 'Privacy',
        isQuote: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ]);
    notifyListeners();
  }

  Future<void> toggleMemory(String id) async {
    final index = _memories.indexWhere((m) => m.id == id);
    if (index != -1) {
      _memories[index].isActive = !_memories[index].isActive;
      notifyListeners();

      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        await db.update(
          'memories',
          {'is_active': _memories[index].isActive ? 1 : 0},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
  }

  Future<void> addMemory(MemoryItem item) async {
    _memories.insert(0, item);
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.insert('memories', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> updateMemory(MemoryItem item) async {
    final index = _memories.indexWhere((m) => m.id == item.id);
    if (index != -1) {
      _memories[index] = item;
      notifyListeners();

      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        await db.update(
          'memories',
          item.toMap(),
          where: 'id = ?',
          whereArgs: [item.id],
        );
      }
    }
  }

  Future<void> deleteMemory(String id) async {
    _memories.removeWhere((m) => m.id == id);
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.delete(
        'memories',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
