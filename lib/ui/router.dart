import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/model_download_screen.dart';
import 'screens/onboarding/journaling_goals_screen.dart';
import 'screens/onboarding/personal_context_screen.dart';
import 'screens/onboarding/support_preferences_screen.dart';
import 'screens/sanctuary_dashboard_screen.dart';
import 'screens/welcome_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(
          onGetStarted: () => context.go('/onboarding/goals'),
        ),
      ),
      GoRoute(
        path: '/onboarding/goals',
        builder: (context, state) => JournalingGoalsScreen(
          onContinue: () => context.go('/onboarding/preferences'),
          onBack: () => context.go('/welcome'),
          onSkip: () => context.go('/onboarding/preferences'),
        ),
      ),
      GoRoute(
        path: '/onboarding/preferences',
        builder: (context, state) => SupportPreferencesScreen(
          onContinue: () => context.go('/onboarding/context'),
          onBack: () => context.go('/onboarding/goals'),
          onSkip: () => context.go('/onboarding/context'),
        ),
      ),
      GoRoute(
        path: '/onboarding/context',
        builder: (context, state) => PersonalContextScreen(
          onContinue: () => context.go('/onboarding/download'),
          onBack: () => context.go('/onboarding/preferences'),
          onSkip: () => context.go('/onboarding/download'),
        ),
      ),
      GoRoute(
        path: '/onboarding/download',
        builder: (context, state) => const ModelDownloadScreen(
          destinationScreen: SanctuaryDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const SanctuaryDashboardScreen(),
      ),
    ],
  );
}
