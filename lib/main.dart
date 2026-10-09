import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'services/journal_service.dart';
import 'services/onboarding_service.dart';
import 'services/memory_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JournalService.instance.init();
  await OnboardingService.instance.init();
  await MemoryService.instance.init();
  runApp(const SolaceApp());
}

class SolaceApp extends StatelessWidget {
  const SolaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solace.ai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
