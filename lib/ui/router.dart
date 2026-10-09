import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home/sanctuary_home_screen.dart';
import 'screens/journal/journal_editor_screen.dart';
import 'screens/journal/voice_journaling_screen.dart';
import 'screens/model_download_screen.dart';
import 'screens/onboarding/journaling_goals_screen.dart';
import 'screens/onboarding/personal_context_screen.dart';
import 'screens/onboarding/support_preferences_screen.dart';
import 'screens/welcome_screen.dart';

/// Global router defining navigation across Solace AI
final GoRouter solaceRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    // 01 — Welcome Screen (Landing)
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(
        onGetStarted: () => context.go('/onboarding/goals'),
      ),
    ),

    // 02 — Journaling Goals (Step 1 of 4)
    GoRoute(
      path: '/onboarding/goals',
      builder: (context, state) => JournalingGoalsScreen(
        onContinue: () => context.go('/onboarding/preferences'),
        onBack: () => context.go('/welcome'),
        onSkip: () => context.go('/onboarding/preferences'),
      ),
    ),

    // 03 — Support Preferences (Step 2 of 4)
    GoRoute(
      path: '/onboarding/preferences',
      builder: (context, state) => SupportPreferencesScreen(
        onContinue: () => context.go('/onboarding/context'),
        onBack: () => context.go('/onboarding/goals'),
        onSkip: () => context.go('/onboarding/context'),
      ),
    ),

    // 04 — Personal Context (Step 3 of 4)
    GoRoute(
      path: '/onboarding/context',
      builder: (context, state) => PersonalContextScreen(
        onContinue: () => context.go('/onboarding/download'),
        onBack: () => context.go('/onboarding/preferences'),
        onSkip: () => context.go('/onboarding/download'),
      ),
    ),

    // 05 — Model Setup & SLM Download
    GoRoute(
      path: '/onboarding/download',
      builder: (context, state) => const ModelDownloadScreen(
        destinationScreen: SanctuaryHomeScreen(),
      ),
    ),

    // 06 — Sanctuary Home Dashboard
    GoRoute(
      path: '/',
      builder: (context, state) => SanctuaryHomeScreen(
        onNewEntry: () => context.go('/journal/new'),
        onVoiceEntry: () => context.go('/journal/voice'),
      ),
    ),

    // 07 — Journal Editor (Text)
    GoRoute(
      path: '/journal/new',
      builder: (context, state) => JournalEditorScreen(
        onBack: () => context.go('/'),
        onOpenVoice: () => context.go('/journal/voice'),
      ),
    ),

    // 07A & 07B — Voice Journaling (Recording & Transcribed Reflection)
    GoRoute(
      path: '/journal/voice',
      builder: (context, state) => VoiceJournalingScreen(
        onBack: () => context.go('/'),
        onSwitchToWrite: () => context.go('/journal/new'),
      ),
    ),
  ],
);
