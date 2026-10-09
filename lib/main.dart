import 'package:flutter/material.dart';
import 'ui/router.dart';
import 'ui/theme/solace_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SolaceApp());
}

class SolaceApp extends StatelessWidget {
  const SolaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Solace AI',
      debugShowCheckedModeBanner: false,
      theme: SolaceTheme.themeData,
      routerConfig: solaceRouter,
    );
  }
}
