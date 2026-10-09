import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'ui/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final auth = AuthService(FirebaseAuth.instance);
  await auth.authChanges.first; // wait for the saved session to be restored
  runApp(MyApp(router: buildRouter(auth)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Solace',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      routerConfig: router,
    );
  }
}