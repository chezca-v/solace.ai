import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solace_ai/ui/screens/onboarding/journaling_goals_screen.dart';
import 'package:solace_ai/ui/screens/onboarding/personal_context_screen.dart';
import 'package:solace_ai/ui/screens/onboarding/support_preferences_screen.dart';
import 'package:solace_ai/ui/screens/welcome_screen.dart';
import 'package:solace_ai/ui/theme/solace_theme.dart';

void main() {
  testWidgets('01 — WelcomeScreen renders branding, cards and CTAs',
      (WidgetTester tester) async {
    bool startedTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: WelcomeScreen(
          onGetStarted: () => startedTapped = true,
        ),
      ),
    );

    expect(find.text('Solace AI'), findsOneWidget);
    expect(find.text('A space to come back to\nyourself.'), findsOneWidget);
    expect(find.text('Private by design. Useful offline.'), findsOneWidget);
    expect(find.text('100% Offline Capable'), findsOneWidget);
    expect(find.text('Zero Cloud Leakage'), findsOneWidget);
    expect(find.text('Capture First, Assist Third'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pump();
    expect(startedTapped, isTrue);
  });

  testWidgets('02 — JournalingGoalsScreen renders goals and handles selection',
      (WidgetTester tester) async {
    bool continueTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: JournalingGoalsScreen(
          onContinue: () => continueTapped = true,
        ),
      ),
    );

    expect(find.text('STEP 1 OF 4'), findsOneWidget);
    expect(find.text('What brings you to\nSolace?'), findsOneWidget);
    expect(find.text('Grounded, Private & Edge-Secure'), findsOneWidget);
    expect(find.text('Understand my thoughts and feelings'), findsOneWidget);
    expect(find.text('Make difficult decisions'), findsOneWidget);

    await tester.tap(find.text('Build habits & track personal growth'));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(continueTapped, isTrue);
  });

  testWidgets('03 — SupportPreferencesScreen renders support options and Sol quote',
      (WidgetTester tester) async {
    bool continueTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: SupportPreferencesScreen(
          onContinue: () => continueTapped = true,
        ),
      ),
    );

    expect(find.text('Step 2 of 4'), findsOneWidget);
    expect(find.text('TAILORED SANCTUARY'), findsOneWidget);
    expect(find.text('How would you like\nSolace to assist?'), findsOneWidget);
    expect(find.text('Listen and reflect'), findsOneWidget);
    expect(find.text('Help me compare choices'), findsOneWidget);
    expect(find.text('Ask thoughtful questions'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(continueTapped, isTrue);
  });

  testWidgets('04 — PersonalContextScreen renders life areas and input fields',
      (WidgetTester tester) async {
    bool continueTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: PersonalContextScreen(
          onContinue: () => continueTapped = true,
        ),
      ),
    );

    expect(find.text('Step 3 of 4'), findsOneWidget);
    expect(find.text('Help Solace understand your context'), findsOneWidget);
    expect(find.text('Career & Craft'), findsOneWidget);
    expect(find.text('Personal Growth'), findsOneWidget);
    expect(find.text('What are you currently working toward?'), findsOneWidget);
    expect(find.text('Any explicit boundaries for\nSol?'), findsOneWidget);
    expect(find.text('Edge Vault Security'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(continueTapped, isTrue);
  });
}
