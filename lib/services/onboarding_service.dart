import 'package:flutter/foundation.dart';
import '../ai/local_ai.dart';

/// Manages and retains the user's onboarding profile preferences
/// (Goals, Support Preferences, Life Areas, Priorities, and Boundaries)
class OnboardingService extends ChangeNotifier {
  static final OnboardingService instance = OnboardingService._internal();
  OnboardingService._internal();

  factory OnboardingService() => instance;

  final Set<String> _selectedGoals = {
    'Understand my thoughts and feelings',
    'Make difficult decisions',
    'Manage stress & overwhelm',
  };

  final Set<String> _selectedSupportStyles = {
    'Listen and reflect',
    'Help me compare choices',
    'Ask thoughtful questions',
  };

  final Set<String> _selectedLifeAreas = {
    'Career & Craft',
    'Personal Growth',
    'Creative Autonomy',
  };

  String _workingToward =
      'Balancing a career transition without triggering burnout or sacrificing creative freedom.';
  String _explicitBoundaries = 'Don\'t offer advice unless I specifically request it.';

  // Getters
  Set<String> get selectedGoals => Set.unmodifiable(_selectedGoals);
  Set<String> get selectedSupportStyles => Set.unmodifiable(_selectedSupportStyles);
  Set<String> get selectedLifeAreas => Set.unmodifiable(_selectedLifeAreas);
  String get workingToward => _workingToward;
  String get explicitBoundaries => _explicitBoundaries;

  // Mutators
  void toggleGoal(String goal) {
    if (_selectedGoals.contains(goal)) {
      _selectedGoals.remove(goal);
    } else {
      _selectedGoals.add(goal);
    }
    notifyListeners();
  }

  void toggleSupportStyle(String style) {
    if (_selectedSupportStyles.contains(style)) {
      _selectedSupportStyles.remove(style);
    } else {
      _selectedSupportStyles.add(style);
    }
    notifyListeners();
  }

  void toggleLifeArea(String area) {
    if (_selectedLifeAreas.contains(area)) {
      _selectedLifeAreas.remove(area);
    } else {
      _selectedLifeAreas.add(area);
    }
    notifyListeners();
  }

  void setWorkingToward(String text) {
    _workingToward = text;
    notifyListeners();
  }

  void setExplicitBoundaries(String text) {
    _explicitBoundaries = text;
    notifyListeners();
  }

  void addBoundaryRule(String rule) {
    if (_explicitBoundaries.trim().isEmpty) {
      _explicitBoundaries = rule;
    } else if (!_explicitBoundaries.contains(rule)) {
      _explicitBoundaries = '$_explicitBoundaries. $rule';
    }
    notifyListeners();
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
