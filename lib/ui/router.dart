import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import '../../../dashboard_screen.dart';
=======
<<<<<<< HEAD
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'screens/model_download_screen.dart';
import 'screens/onboarding/journaling_goals_screen.dart';
import 'screens/onboarding/personal_context_screen.dart';
import 'screens/onboarding/support_preferences_screen.dart';
=======
>>>>>>> b75fe5860338f5db816c5f982ef257e790856875
import 'screens/sanctuary_dashboard_screen.dart';
import 'screens/welcome_screen.dart';
>>>>>>> 83e377689f89ddf7384f8a324aa1bd224cbd7622

GoRouter buildRouter() {
  return GoRouter(
<<<<<<< HEAD
    initialLocation: '/welcome',
    refreshListenable: _AuthRefresh(auth.authChanges),
    redirect: (context, state) {
      final loggedIn = auth.currentUser != null;
      final loc = state.matchedLocation;
      final isOnboardingOrAuth =
          loc.startsWith('/onboarding') || loc == '/welcome' || loc == '/login';

      if (!loggedIn && !isOnboardingOrAuth) return '/welcome';
      if (loggedIn && (loc == '/welcome' || loc == '/login')) return '/';
      return null;
    },
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
      GoRoute(
        path: '/login',
        builder: (_, __) => LoginScreen(auth: auth),
      ),
=======
    routes: [
<<<<<<< HEAD
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
=======
      GoRoute(path: '/', builder: (_, __) => const SanctuaryDashboardScreen()),
>>>>>>> b75fe5860338f5db816c5f982ef257e790856875
>>>>>>> 83e377689f89ddf7384f8a324aa1bd224cbd7622
    ],
  );
}
