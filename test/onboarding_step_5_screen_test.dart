import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solace_ai/ui/screens/onboarding/onboarding_step_5_screen.dart';

void main() {
  testWidgets('step 5 remains usable on a short viewport',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1365, 690);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: OnboardingStep5Screen()),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    final buttonRect = tester.getRect(find.byType(ElevatedButton));
    expect(buttonRect.top, greaterThanOrEqualTo(0));
    expect(buttonRect.bottom, lessThanOrEqualTo(690));
  });
}
