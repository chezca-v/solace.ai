import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solace_ai/ui/screens/home/sanctuary_home_screen.dart';
import 'package:solace_ai/ui/screens/journal/journal_editor_screen.dart';
import 'package:solace_ai/ui/screens/journal/voice_journaling_screen.dart';
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

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(continueTapped, isTrue);
  });

  testWidgets('06 — SanctuaryHomeScreen renders greeting, prompt, rhythm, and reflections',
      (WidgetTester tester) async {
    bool newEntryTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: SanctuaryHomeScreen(
          onNewEntry: () => newEntryTapped = true,
        ),
      ),
    );

    expect(find.text('Good morning,\nElena'), findsOneWidget);
    expect(find.text('Sol is active on-device'), findsOneWidget);
    expect(find.text('Sol\'s Gentle Prompt'), findsOneWidget);
    expect(find.text('Mind Rhythm'), findsOneWidget);
    expect(find.text('Your Recent Reflections'), findsOneWidget);

    await tester.tap(find.text('New Entry'));
    await tester.pump();
    expect(newEntryTapped, isTrue);
  });

  testWidgets('07 — JournalEditorScreen renders editor body, seed and tags',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const JournalEditorScreen(),
      ),
    );

    expect(find.text('New Reflection'), findsOneWidget);
    expect(find.text('Gentle Reflection Seed'), findsOneWidget);
    expect(find.text('TUNING:'), findsOneWidget);
    expect(find.text('Reflect with Solace'), findsOneWidget);
    expect(find.text('Save Entry'), findsOneWidget);
  });

  testWidgets('07A & 07B — VoiceJournalingScreen renders recording and transcribe flow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const VoiceJournalingScreen(),
      ),
    );

    expect(find.text('Listening to your thoughts with whisper-edge AI...'), findsOneWidget);
    expect(find.text('Transcribe'), findsOneWidget);

    // Tap Transcribe to switch to 07B
    await tester.tap(find.text('Transcribe'));
    await tester.pumpAndSettle();

    expect(find.text('Empathetic Mode Activated'), findsOneWidget);
    expect(find.text('SOL\'S WHISPER'), findsOneWidget);
    expect(find.text('Reflect with Solace →'), findsOneWidget);
  });
}
