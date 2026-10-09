import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solace_ai/main.dart';
import 'package:solace_ai/ui/router.dart';

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

  testWidgets('E2E Complete Onboarding and Sanctuary Navigation Flow',
      (WidgetTester tester) async {
    setTestDeviceSize(tester);

    // 1. Launch App starting at /welcome
    solaceRouter.go('/welcome');
    await tester.pumpWidget(const SolaceApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Solace AI'), findsWidgets);
    expect(find.text('A space to come back to\nyourself.'), findsOneWidget);

    // 2. Tap Get Started -> Navigate to /onboarding/goals
    await tester.tap(find.text('Get Started'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('What brings you to\nSolace?'), findsOneWidget);

    // 3. Tap Continue -> Navigate to /onboarding/preferences
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('How would you like\nSolace to assist?'), findsOneWidget);

    // 4. Tap Continue -> Navigate to /onboarding/context
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Help Solace understand your context'), findsOneWidget);

    // 5. Tap Continue -> Navigate to Sanctuary Home (/)
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Good morning,\nElena'), findsOneWidget);
    expect(find.text('Sol is active on-device'), findsOneWidget);
    expect(find.text('Your Recent Reflections'), findsOneWidget);

    // 6. Tap New Entry -> Navigate to /journal/new
    await tester.tap(find.text('New Entry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('New Reflection'), findsOneWidget);
    expect(find.text('Reflect with Solace'), findsOneWidget);

    // 7. Tap Reflect with Solace -> Verify On-Device AI dialog
    await tester.tap(find.text('Reflect with Solace'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Solace Reflection'), findsOneWidget);
    expect(find.text('Generated 100% on-device'), findsOneWidget);

    // Close Dialog
    await tester.tap(find.text('Return to Sanctuary'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // 8. Go to Memory Vault (/memories)
    solaceRouter.go('/memories');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Personal Memory Vault'), findsOneWidget);
    expect(find.text('Add Custom Rule or Priority'), findsOneWidget);

    // 9. Go to Settings (/settings)
    solaceRouter.go('/settings');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Settings & Privacy'), findsOneWidget);
    expect(find.text('Zero-Trace Data Deletion'), findsOneWidget);

    // 10. Go to Decision Comparison (/decision)
    solaceRouter.go('/decision');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Decision Comparison'), findsOneWidget);
    expect(find.text('Save Decision Summary to Journal'), findsOneWidget);

    // 11. Go to Voice Journaling (/journal/voice)
    solaceRouter.go('/journal/voice');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Listening to your thoughts with whisper-edge AI...'), findsOneWidget);

    // 12. Go to Model Download Screen (/onboarding/download)
    solaceRouter.go('/onboarding/download');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Preparing your Sanctuary'), findsOneWidget);
    expect(find.text('Enter Sanctuary'), findsOneWidget);

    // Tap Enter Sanctuary -> Returns to Home (/)
    await tester.tap(find.text('Enter Sanctuary'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Good morning,\nElena'), findsOneWidget);
  });
}
