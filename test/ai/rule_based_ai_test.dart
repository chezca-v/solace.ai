import 'package:test/test.dart';
import '../../lib/ai/local_ai.dart';
import '../../lib/ai/rule_based_ai.dart';

void main() {
  group('RuleBasedAi', () {
    late RuleBasedAi ai;
    late UserContext context;

    setUp(() {
      ai = RuleBasedAi();
      context = UserContext(
        goals: ['Work-life balance', 'Mindfulness'],
        priorities: ['Mental peace', 'Career growth'],
        supportStyles: ['Gentle reflection'],
        lifeAreas: ['Career', 'Wellness'],
      );
    });

    test('initializes successfully and reports correct engine name', () async {
      final initResult = await ai.init();
      expect(initResult, isTrue);
      expect(ai.engineName, equals('Rule-based mode'));
    });

    test('detects decision entry in English and compares options side by side', () async {
      const entry = 'I am choosing between accepting the job offer and staying at my current company.';
      final result = await ai.compareOptions(entry, context);

      expect(result.usedModel, isFalse);
      expect(result.engineUsed, equals('Rule-based mode'));
      expect(result.options.length, equals(2));
      expect(result.options[0].name.toLowerCase(), contains('accepting the job offer'));
      expect(result.options[1].name.toLowerCase(), contains('staying at my current company'));
      expect(result.options[0].pros, isNotEmpty);
      expect(result.options[0].cons, isNotEmpty);
      expect(result.reflection, contains('weighing the choice'));
      expect(result.followUpQuestion, contains('how does your body and mind feel'));
    });

    test('detects Taglish entry and provides empathetic reflection in Taglish', () async {
      const entry = 'Sobrang pagod na ako sa trabaho ko kasi ang daming deadlines at pressure.';
      final result = await ai.reflect(entry, context);

      expect(result.usedModel, isFalse);
      expect(result.engineUsed, equals('Rule-based mode'));
      expect(result.reflection, contains('Mukhang ramdam mo ang labis na bigat'));
      expect(result.followUpQuestion, contains('ginhawa'));
    });

    test('triggers crisis safety response on self-harm or suicide keywords', () async {
      const englishCrisis = 'I feel completely hopeless and I just want to end my life.';
      final resultEn = await ai.reflect(englishCrisis, context);

      expect(resultEn.usedModel, isFalse);
      expect(resultEn.reflection, contains('you do not have to carry this alone'));
      expect(resultEn.followUpQuestion, contains('National Center for Mental Health'));
      expect(resultEn.options, isEmpty);

      const taglishCrisis = 'Ayoko na talaga, gusto ko na magpakamatay.';
      final resultTl = await ai.reflect(taglishCrisis, context);

      expect(resultTl.usedModel, isFalse);
      expect(resultTl.reflection, contains('you do not have to carry this alone'));
      expect(resultTl.followUpQuestion, contains('National Center for Mental Health'));
      expect(resultTl.options, isEmpty);
    });

    test('avoids medical diagnoses and uses non-judgmental tentative phrasing', () async {
      const entry = 'I have been crying every day and feeling super anxious and worthless.';
      final result = await ai.reflect(entry, context);

      expect(result.reflection.toLowerCase(), isNot(contains('you have depression')));
      expect(result.reflection.toLowerCase(), isNot(contains('you have anxiety disorder')));
      expect(result.reflection, contains('It sounds like you might be'));
    });
  });
}
