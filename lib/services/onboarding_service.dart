import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../ai/local_ai.dart';
import 'journal_service.dart';
import 'memory_service.dart';

/// Manages and retains the user's onboarding profile preferences and settings
/// (Goals, Support Preferences, Life Areas, Priorities, Boundaries, Settings Toggles)
class OnboardingService extends ChangeNotifier {
  static final OnboardingService instance = OnboardingService._internal();
  OnboardingService._internal();

  factory OnboardingService() => instance;

  bool _isInitialized = false;

  Set<String> _selectedGoals = {};
  Set<String> _selectedSupportStyles = {};
  Set<String> _selectedLifeAreas = {};
  String _workingToward = '';
  String _explicitBoundaries = '';
  String _userName = '';

  // Settings Toggles
  bool _edgeAiEnabled = true;
  bool _allowMemoryRetrieval = true;
  bool _promptBeforeSavingThemes = true;
  bool _biometricAppLock = false;

  // Getters
  Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);
  Set<String> get selectedSupportStyles => Set.unmodifiable(_selectedSupportStyles);
  Set<String> get selectedLifeAreas => Set.unmodifiable(_selectedLifeAreas);
  String get workingToward => _workingToward;
  String get explicitBoundaries => _explicitBoundaries;
  String get userName => _userName;

  String get userInitial => _userName.trim().isNotEmpty ? _userName.trim()[0].toUpperCase() : 'S';

  bool get edgeAiEnabled => _edgeAiEnabled;
  bool get allowMemoryRetrieval => _allowMemoryRetrieval;
  bool get promptBeforeSavingThemes => _promptBeforeSavingThemes;
  bool get biometricAppLock => _biometricAppLock;

  Future<void> init() async {
    if (_isInitialized) return;
    if (kIsWeb) {
      _isInitialized = true;
      return;
    }

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('user_preferences');
      for (final map in maps) {
        final key = map['key'] as String;
        final value = map['value'] as String;
        
        try {
          if (key == 'selectedGoals') _selectedGoals = Set<String>.from(jsonDecode(value));
          if (key == 'selectedSupportStyles') _selectedSupportStyles = Set<String>.from(jsonDecode(value));
          if (key == 'selectedLifeAreas') _selectedLifeAreas = Set<String>.from(jsonDecode(value));
          if (key == 'workingToward') _workingToward = value;
          if (key == 'explicitBoundaries') _explicitBoundaries = value;
          if (key == 'userName') _userName = value;
          if (key == 'edgeAiEnabled') _edgeAiEnabled = value == 'true';
          if (key == 'allowMemoryRetrieval') _allowMemoryRetrieval = value == 'true';
          if (key == 'promptBeforeSavingThemes') _promptBeforeSavingThemes = value == 'true';
          if (key == 'biometricAppLock') _biometricAppLock = value == 'true';
        } catch (_) {}
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveToDb(String key, String value) async {
    if (kIsWeb) return;
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.insert('user_preferences', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> setGoals(Set<String> goals) async {
    _selectedGoals = Set.from(goals);
    notifyListeners();
    await _saveToDb('selectedGoals', jsonEncode(_selectedGoals.toList()));
    await MemoryService.instance.syncWithOnboarding(this);
  }

  Future<void> setSupportStyles(Set<String> styles) async {
    _selectedSupportStyles = Set.from(styles);
    notifyListeners();
    await _saveToDb('selectedSupportStyles', jsonEncode(_selectedSupportStyles.toList()));
  }

  Future<void> setLifeAreas(Set<String> areas) async {
    _selectedLifeAreas = Set.from(areas);
    notifyListeners();
    await _saveToDb('selectedLifeAreas', jsonEncode(_selectedLifeAreas.toList()));
    await MemoryService.instance.syncWithOnboarding(this);
  }

  Future<void> setWorkingToward(String text) async {
    _workingToward = text;
    notifyListeners();
    await _saveToDb('workingToward', text);
    await MemoryService.instance.syncWithOnboarding(this);
  }

  Future<void> setExplicitBoundaries(String text) async {
    _explicitBoundaries = text;
    notifyListeners();
    await _saveToDb('explicitBoundaries', text);
    await MemoryService.instance.syncWithOnboarding(this);
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    notifyListeners();
    await _saveToDb('userName', name);
  }

  Future<void> setEdgeAiEnabled(bool val) async {
    _edgeAiEnabled = val;
    notifyListeners();
    await _saveToDb('edgeAiEnabled', val.toString());
  }

  Future<void> setAllowMemoryRetrieval(bool val) async {
    _allowMemoryRetrieval = val;
    notifyListeners();
    await _saveToDb('allowMemoryRetrieval', val.toString());
  }

  Future<void> setPromptBeforeSavingThemes(bool val) async {
    _promptBeforeSavingThemes = val;
    notifyListeners();
    await _saveToDb('promptBeforeSavingThemes', val.toString());
  }

  Future<void> setBiometricAppLock(bool val) async {
    _biometricAppLock = val;
    notifyListeners();
    await _saveToDb('biometricAppLock', val.toString());
  }

  /// Wipes all tables in SQLite (entries, user_preferences, memories) and clears memory
  Future<void> wipeAllData() async {
    _selectedGoals.clear();
    _selectedSupportStyles.clear();
    _selectedLifeAreas.clear();
    _workingToward = '';
    _explicitBoundaries = '';
    _userName = '';
    _edgeAiEnabled = true;
    _allowMemoryRetrieval = true;
    _promptBeforeSavingThemes = true;
    _biometricAppLock = false;
    notifyListeners();

    await JournalService.instance.clearAllEntries();
    await MemoryService.instance.clearAllMemories();

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      await db.delete('user_preferences');
      await db.delete('entries');
      await db.delete('memories');
    }
  }

  /// Converts the captured onboarding preferences into a UserContext for the local AI engine
  UserContext toUserContext() {
    final prioritiesList = <String>[];
    if (_workingToward.trim().isNotEmpty) {
      prioritiesList.add(_workingToward.trim());
    }
    if (_explicitBoundaries.trim().isNotEmpty) {
      prioritiesList.add('Boundaries: ${_explicitBoundaries.trim()}');
    }

    return UserContext(
      goals: _selectedGoals.toList(growable: false),
      supportStyles: _selectedSupportStyles.toList(growable: false),
      lifeAreas: _selectedLifeAreas.toList(growable: false),
      priorities: prioritiesList,
      approvedMemories: MemoryService.instance.memories.where((m) => m.isActive).map((m) => m.title).toList(),
      relatedEntries: JournalService.instance.entries.map((e) => e.title).toList(),
    );
  }
}
