import 'package:go_router/go_router.dart';
import 'screens/decision/decision_comparison_screen.dart';
import 'screens/home/sanctuary_home_screen.dart';
import 'screens/journal/entry_detail_screen.dart';
import 'screens/journal/journal_editor_screen.dart';
import 'screens/journal/voice_journaling_screen.dart';
import 'screens/memories/memory_vault_screen.dart';
import 'screens/model_download_screen.dart';
import 'screens/onboarding/journaling_goals_screen.dart';
import 'screens/onboarding/personal_context_screen.dart';
import 'screens/onboarding/support_preferences_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/welcome_screen.dart';

/// Global router defining navigation across Solace AI
final GoRouter solaceRouter = GoRouter(
  initialLocation: '/welcome',
  errorBuilder: (context, state) => const SanctuaryHomeScreen(),
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
        onContinue: () => context.go('/'),
        onBack: () => context.go('/onboarding/preferences'),
        onSkip: () => context.go('/'),
      ),
    ),

    // Optional SLM Download / Setup
    GoRoute(
      path: '/onboarding/download',
      builder: (context, state) => ModelDownloadScreen(
        onComplete: () => context.go('/'),
        destinationScreen: const SanctuaryHomeScreen(),
      ),
    ),

    // 06 — Sanctuary Home Dashboard (Root)
    GoRoute(
      path: '/',
      builder: (context, state) => SanctuaryHomeScreen(
        onNewEntry: () => context.go('/journal/new'),
        onVoiceEntry: () => context.go('/journal/voice'),
        onSelectEntry: (id) => context.go('/entry/$id'),
        onMemoriesTab: () => context.go('/memories'),
        onJournalTab: () => context.go('/journal/new'),
        onSettingsTab: () => context.go('/settings'),
      ),
    ),

    // Common navigation aliases
    GoRoute(
      path: '/home',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/sanctuary',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/journal',
      redirect: (context, state) => '/journal/new',
    ),

    // 07 — Journal Editor
    GoRoute(
      path: '/journal/new',
      builder: (context, state) => JournalEditorScreen(
        onBack: () => context.go('/'),
        onOpenVoice: () => context.go('/journal/voice'),
        onReflectWithSolace: (entry) => context.go('/entry/${entry.id}'),
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

    // 08/09 — Memory Insight Detail & Sol Reflection
    GoRoute(
      path: '/entry/:id',
      builder: (context, state) {
        final entryId = state.pathParameters['id'] ?? 'entry-1';
        return EntryDetailScreen(
          entryId: entryId,
          onBack: () => context.go('/'),
          onCompareChoices: () => context.go('/decision'),
        );
      },
    ),

    // 10 — Decision Comparison & Dynamic Tension Analysis
    GoRoute(
      path: '/decision',
      builder: (context, state) => DecisionComparisonScreen(
        onBack: () => context.go('/entry/entry-1'),
        onSaveToJournal: () => context.go('/'),
      ),
    ),

    // 11 — Personal Memory Vault
    GoRoute(
      path: '/memories',
      builder: (context, state) => MemoryVaultScreen(
        onBack: () => context.go('/'),
        onHomeTab: () => context.go('/'),
        onJournalTab: () => context.go('/journal/new'),
        onSettingsTab: () => context.go('/settings'),
      ),
    ),

    // 12 — Settings & Privacy Sanctuary
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(
        onBack: () => context.go('/'),
        onHomeTab: () => context.go('/'),
        onJournalTab: () => context.go('/journal/new'),
        onMemoriesTab: () => context.go('/memories'),
      ),
    ),
  ],
);
