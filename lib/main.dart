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
      theme: SolaceTheme.themeData,
      routerConfig: solaceRouter,
=======
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
>>>>>>> 2f3b8ea464cb694b060fb7f0a67c68af2572727a
    );
  }
}
