import 'package:flutter/foundation.dart';
import '../models/memory_item.dart';

/// Service managing user-approved personal memories and decision weights
class MemoryService extends ChangeNotifier {
  static final MemoryService instance = MemoryService._internal();
  MemoryService._internal() {
    _loadSampleMemories();
  }

  factory MemoryService() => instance;

  final List<MemoryItem> _memories = [];

  List<MemoryItem> get memories => List.unmodifiable(_memories);

  int get activeCount => _memories.where((m) => m.isActive).length;

  void _loadSampleMemories() {
    if (_memories.isNotEmpty) return;

    _memories.addAll([
      MemoryItem(
        id: 'mem-1',
        title: 'Sustainable Pace & Burnout Prevention',
        quoteOrDescription:
            '“I must not take on 60+ hour sprint cycles this year.”',
        source: 'Entry on Oct 2: Setting Q4 Boundaries',
        category: 'HIGH PRIORITY',
        subcategory: 'Oct 2 • Boundaries',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      MemoryItem(
        id: 'mem-2',
        title: 'Creative Autonomy in Design',
        quoteOrDescription:
            '“Need freedom to define visual design from scratch.”',
        source: 'Onboarding Goal: Make difficult decisions',
        category: 'CORE VALUE',
        subcategory: 'Onboarding',
        isQuote: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      MemoryItem(
        id: 'mem-3',
        title: 'Career Pivot between Academia & Tech',
        quoteOrDescription:
            'Transitioned from 5 years of cognitive psychology research to human-computer interaction product design. Prefers rigorous frameworks over fast heuristics.',
        source: 'User-defined profile note',
        category: 'LIFE CONTEXT',
        subcategory: 'Profile',
        isQuote: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ]);
  }

  void toggleMemory(String id) {
    final index = _memories.indexWhere((m) => m.id == id);
    if (index != -1) {
      _memories[index].isActive = !_memories[index].isActive;
      notifyListeners();
    }
  }

  void addMemory(MemoryItem item) {
    _memories.insert(0, item);
    notifyListeners();
  }

  void deleteMemory(String id) {
    _memories.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
