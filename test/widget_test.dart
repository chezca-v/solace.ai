import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solace_ai/ui/screens/decision/decision_comparison_screen.dart';
import 'package:solace_ai/ui/screens/home/sanctuary_home_screen.dart';
import 'package:solace_ai/ui/screens/journal/entry_detail_screen.dart';
import 'package:solace_ai/ui/screens/journal/journal_editor_screen.dart';
import 'package:solace_ai/ui/screens/journal/voice_journaling_screen.dart';
import 'package:solace_ai/ui/screens/memories/memory_vault_screen.dart';
import 'package:solace_ai/ui/screens/onboarding/journaling_goals_screen.dart';
import 'package:solace_ai/ui/screens/onboarding/personal_context_screen.dart';
import 'package:solace_ai/ui/screens/onboarding/support_preferences_screen.dart';
import 'package:solace_ai/ui/screens/settings/settings_screen.dart';
import 'package:solace_ai/ui/screens/welcome_screen.dart';
import 'package:solace_ai/ui/theme/solace_theme.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  void setTestDeviceSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('01 — WelcomeScreen renders branding, cards and CTAs',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    setTestDeviceSize(tester);
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Empathetic Mode Activated'), findsOneWidget);
    expect(find.text('SOL\'S WHISPER'), findsOneWidget);
    expect(find.text('Reflect with Solace →'), findsOneWidget);
  });

  testWidgets('08/09 — EntryDetailScreen renders journal and Sol reflection synthesis',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const EntryDetailScreen(
          entryId: 'entry-1',
        ),
      ),
    );

    expect(find.text('Memory Insight Detail'), findsOneWidget);
    expect(find.text('ORIGINAL JOURNAL ENTRY'), findsOneWidget);
    expect(find.text('Sol Reflection'), findsOneWidget);
    expect(find.text('Compare Choices based on Priorities'), findsOneWidget);
    expect(find.text('Save insight to memories'), findsOneWidget);
  });

  testWidgets('10 — DecisionComparisonScreen renders comparative columns and tension',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const DecisionComparisonScreen(),
      ),
    );

    expect(find.text('Decision Comparison'), findsOneWidget);
    expect(find.text('• ACTIVE DILEMMA'), findsOneWidget);
    expect(find.text('Comparative Grid'), findsOneWidget);
    expect(find.text('• DYNAMIC TENSION ANALYSIS'), findsOneWidget);
    expect(find.text('Save Decision Summary to Journal'), findsOneWidget);
  });

  testWidgets('11 — MemoryVaultScreen renders zero leakage status, filters, and memories',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const MemoryVaultScreen(),
      ),
    );

    expect(find.text('Personal Memory Vault'), findsOneWidget);
    expect(find.text('ZERO LEAKAGE'), findsWidgets);
    expect(find.text('Add Custom Rule or Priority'), findsOneWidget);
    expect(find.text('Solace never assumes.'), findsOneWidget);
  });

  testWidgets('12 — SettingsScreen renders Edge AI engine, toggles, emergency hub, and deletion',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: SolaceTheme.themeData,
        home: const SettingsScreen(),
      ),
    );

    expect(find.text('Settings & Privacy'), findsOneWidget);
    expect(find.text('Privacy Sanctuary'), findsOneWidget);
    expect(find.text('Edge AI Engine'), findsOneWidget);
    expect(find.text('ONNX Runtime Mobile v1.2 — Ready Offline'), findsOneWidget);
    expect(find.text('Memory & Context Boundaries'), findsOneWidget);
    expect(find.text('Allow local memory retrieval'), findsOneWidget);
    expect(find.text('Prompt before saving recurring themes'), findsOneWidget);
    expect(find.text('Biometric App Lock'), findsOneWidget);
    expect(find.text('Data Vault & Offline Care'), findsOneWidget);
    expect(find.text('Offline Crisis\n& Emergency Hub'), findsOneWidget);
    expect(find.text('Export Encrypted SQLite Database'), findsOneWidget);
    expect(find.text('Local Storage Allocated'), findsOneWidget);
    expect(find.text('Complete Sovereignty'), findsOneWidget);
    expect(find.text('Zero-Trace Data Deletion'), findsOneWidget);
    expect(find.text('Erase All Local Data & Reset Model'), findsOneWidget);
    expect(find.text('SOLACE OPERATES STRICTLY CLIENT-SIDE'), findsOneWidget);
  });
}
