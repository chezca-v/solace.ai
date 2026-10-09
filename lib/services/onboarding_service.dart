import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';
import '../ai/local_ai.dart';

/// Manages and retains the user's onboarding profile preferences
/// (Goals, Support Preferences, Life Areas, Priorities, and Boundaries)
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

  // Getters
  Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);
  Set<String> get selectedSupportStyles => Set.unmodifiable(_selectedSupportStyles);
  Set<String> get selectedLifeAreas => Set.unmodifiable(_selectedLifeAreas);
  String get workingToward => _workingToward;
  String get explicitBoundaries => _explicitBoundaries;

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
  }

  Future<void> setWorkingToward(String text) async {
    _workingToward = text;
    notifyListeners();
    await _saveToDb('workingToward', text);
  }

  Future<void> setExplicitBoundaries(String text) async {
    _explicitBoundaries = text;
    notifyListeners();
    await _saveToDb('explicitBoundaries', text);
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
      approvedMemories: const [],
      relatedEntries: const [],
    );
  }
}
