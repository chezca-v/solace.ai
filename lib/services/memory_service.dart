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
      _loadDynamicMemories();
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

  void _loadDynamicMemories() {
    if (_memories.isNotEmpty) return;

    final onboarding = OnboardingService.instance;
    final generated = <MemoryItem>[];

    if (onboarding.workingToward.trim().isNotEmpty) {
      generated.add(
        MemoryItem(
          id: 'mem-focus',
          title: onboarding.workingToward.trim(),
          quoteOrDescription: '“${onboarding.workingToward.trim()}”',
          source: 'Stated Sanctuary Focus',
          category: 'HIGH PRIORITY',
          subcategory: 'Current Focus',
          isQuote: true,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
    }

    if (onboarding.explicitBoundaries.trim().isNotEmpty) {
      generated.add(
        MemoryItem(
          id: 'mem-boundary',
          title: 'Protected Boundary',
          quoteOrDescription: '“${onboarding.explicitBoundaries.trim()}”',
          source: 'Personal Sanctuary Rule',
          category: 'HIGH PRIORITY',
          subcategory: 'Boundaries',
          isQuote: true,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );
    }

    for (final goal in onboarding.selectedGoals) {
      generated.add(
        MemoryItem(
          id: 'mem-goal-${goal.hashCode}',
          title: goal,
          quoteOrDescription: 'Personal intention: $goal',
          source: 'Sanctuary Goals',
          category: 'CORE VALUE',
          subcategory: 'Growth Goal',
          isQuote: false,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      );
    }

    for (final area in onboarding.selectedLifeAreas) {
      generated.add(
        MemoryItem(
          id: 'mem-area-${area.hashCode}',
          title: 'Life Domain: $area',
          quoteOrDescription: 'Active life context: $area',
          source: 'Sanctuary Context',
          category: 'LIFE CONTEXT',
          subcategory: 'Context',
          isQuote: false,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      );
    }

    if (generated.isEmpty) {
      generated.addAll([
        MemoryItem(
          id: 'mem-default-1',
          title: 'Sustainable Pace & Boundaries',
          quoteOrDescription:
              '“Prioritize sustainable pacing and mental clarity over excessive urgency.”',
          source: 'Sanctuary reflection',
          category: 'HIGH PRIORITY',
          subcategory: 'Boundaries',
          isQuote: true,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        MemoryItem(
          id: 'mem-default-2',
          title: 'Local Privacy & Sovereignty',
          quoteOrDescription:
              'All reflections, memories, and decision structures remain strictly encrypted and processed on this local device.',
          source: 'Sanctuary Protocol',
          category: 'LIFE CONTEXT',
          subcategory: 'Privacy',
          isQuote: false,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ]);
    }

    _memories.addAll(generated);
    notifyListeners();
  }

  /// Synchronize memories with updated onboarding preferences
  Future<void> syncWithOnboarding(OnboardingService onboarding) async {
    final focus = onboarding.workingToward.trim();
    final boundary = onboarding.explicitBoundaries.trim();

    if (focus.isNotEmpty) {
      final existingIndex = _memories.indexWhere((m) => m.id == 'mem-focus');
      final item = MemoryItem(
        id: 'mem-focus',
        title: focus,
        quoteOrDescription: '“$focus”',
        source: 'Stated Sanctuary Focus',
        category: 'HIGH PRIORITY',
        subcategory: 'Current Focus',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now(),
      );
      if (existingIndex != -1) {
        await updateMemory(item);
      } else {
        await addMemory(item);
      }
    }

    if (boundary.isNotEmpty) {
      final existingIndex = _memories.indexWhere((m) => m.id == 'mem-boundary');
      final item = MemoryItem(
        id: 'mem-boundary',
        title: 'Protected Boundary',
        quoteOrDescription: '“$boundary”',
        source: 'Personal Sanctuary Rule',
        category: 'HIGH PRIORITY',
        subcategory: 'Boundaries',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now(),
      );
      if (existingIndex != -1) {
        await updateMemory(item);
      } else {
        await addMemory(item);
      }
    }

    for (final goal in onboarding.selectedGoals) {
      final id = 'mem-goal-${goal.hashCode}';
      if (!_memories.any((m) => m.id == id || m.title == goal)) {
        await addMemory(
          MemoryItem(
            id: id,
            title: goal,
            quoteOrDescription: 'Personal intention: $goal',
            source: 'Sanctuary Goals',
            category: 'CORE VALUE',
            subcategory: 'Growth Goal',
            isQuote: false,
            isActive: true,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
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

  Future<void> clearAllMemories() async {
    _memories.clear();
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.delete('memories');
    }
  }
}

