import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'screens/sanctuary_dashboard_screen.dart';

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter buildRouter(AuthService auth) {
  return GoRouter(
    refreshListenable: _AuthRefresh(auth.authChanges),
    redirect: (context, state) {
      final loggedIn = auth.currentUser != null;
      final onLogin = state.matchedLocation == '/login';
      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SanctuaryDashboardScreen()),
      GoRoute(path: '/login', builder: (_, __) => LoginScreen(auth: auth)),
    ],
  );
}