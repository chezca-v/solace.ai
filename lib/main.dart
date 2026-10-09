import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'ui/router.dart';
import 'ui/theme/solace_theme.dart';
=======
import 'theme/app_theme.dart';
import 'dashboard_screen.dart';
>>>>>>> b75fe5860338f5db816c5f982ef257e790856875

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp.router(
      title: 'Solace AI',
      debugShowCheckedModeBanner: false,
      theme: SolaceTheme.themeData,
      routerConfig: router,
=======
    return MaterialApp(
      title: 'Solace.ai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
>>>>>>> b75fe5860338f5db816c5f982ef257e790856875
    );
  }
}
