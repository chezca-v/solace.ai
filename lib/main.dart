import 'package:flutter/material.dart';
import 'ui/router.dart';
import 'ui/theme/solace_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Solace AI',
      debugShowCheckedModeBanner: false,
      theme: SolaceTheme.themeData,
      routerConfig: buildRouter(),
    );
  }
}
