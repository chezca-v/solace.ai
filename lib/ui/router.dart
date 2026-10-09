import 'package:go_router/go_router.dart';
import '../../../dashboard_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
    ],
  );
}
