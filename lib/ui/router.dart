import 'package:go_router/go_router.dart';
import 'screens/sanctuary_dashboard_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SanctuaryDashboardScreen()),
    ],
  );
}
