import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SolaceApp());
}

class SolaceApp extends StatelessWidget {
  const SolaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solace.ai',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
=======
      theme: SolaceTheme.themeData,
<<<<<<< HEAD
      routerConfig: solaceRouter,
=======
      routerConfig: buildRouter(),
>>>>>>> d522cf191db37f3c5de497b8c25103064042fb9f
>>>>>>> d3e0289d4857cc5bb26659acfd9007aa8f82e0a6
    );
  }
}
