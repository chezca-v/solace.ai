import 'package:test/test.dart';
import 'package:solace_ai/ai/json_parser.dart';

void main() {
  group('JsonParser', () {
    test('parses clean, valid JSON', () {
      const rawJson = '''
      {
        "reflection": "It sounds like you are feeling torn about moving.",
        "options": [
          {
            "name": "Move to new apartment",
            "pros": ["Shorter commute", "Better space"],
            "cons": ["Higher rent"]
          },
          {
            "name": "Stay in current place",
            "pros": ["Cheaper", "Familiar neighborhood"],
            "cons": ["Long commute"]
          }
        ],
        "question": "Which option gives you more peace of mind?"
      }
      ''';

      final parsedMap = JsonParser.parseJsonObject(rawJson);
      expect(parsedMap, isNotNull);
      expect(parsedMap!['reflection'], contains('feeling torn'));
      expect(parsedMap['options'], isA<List>());

      final result = JsonParser.parseAiResult(
        rawJson,
        engineUsed: 'TestEngine',
        usedModel: true,
      );
      expect(result, isNotNull);
      expect(result!.reflection, contains('feeling torn'));
      expect(result.options.length, equals(2));
      expect(result.options[0].name, equals('Move to new apartment'));
      expect(result.options[0].pros.length, equals(2));
      expect(result.options[0].cons.length, equals(1));
      expect(result.followUpQuestion, contains('peace of mind'));
      expect(result.engineUsed, equals('TestEngine'));
      expect(result.usedModel, isTrue);
    });

    test('extracts JSON enclosed in markdown code fences and commentary', () {
      const fencedJson = '''
      Here is my decision analysis for your journal entry:
      ```json
      {
        "reflection": "You are balancing two clear possibilities.",
        "options": [
          {
            "name": "Option A",
            "pros": ["Pro 1"],
            "cons": ["Con 1"]
          }
        ],
        "question": "What is your next intuition?"
      }
      ```
      Hope this helps you reflect!
      ''';

      final result = JsonParser.parseAiResult(
        fencedJson,
        engineUsed: 'TestEngine',
        usedModel: true,
      );
      expect(result, isNotNull);
      expect(result!.reflection,
          equals('You are balancing two clear possibilities.'));
      expect(result.options.length, equals(1));
      expect(result.options.first.name, equals('Option A'));
      expect(result.followUpQuestion, equals('What is your next intuition?'));
    });

    test('handles code fences without json identifier', () {
      const fencedNoTag = '''
      ```
      {
        "reflection": "Reflecting on your day.",
        "options": [],
        "question": "How do you feel now?"
      }
      ```
      ''';

      final result = JsonParser.parseAiResult(
        fencedNoTag,
        engineUsed: 'TestEngine',
        usedModel: true,
      );
      expect(result, isNotNull);
      expect(result!.reflection, equals('Reflecting on your day.'));
      expect(result.options, isEmpty);
    });

    test('returns null gracefully on garbage text without throwing', () {
      expect(
          JsonParser.parseJsonObject(
              'This is random text with no JSON at all.'),
          isNull);
      expect(JsonParser.parseJsonObject('{ incomplete json: "broken" ...'),
          isNull);
      expect(JsonParser.parseJsonObject(''), isNull);
      expect(JsonParser.parseJsonObject('   '), isNull);
      expect(JsonParser.parseJsonObject(null), isNull);

      final result = JsonParser.parseAiResult(
        'Just plain gibberish',
        engineUsed: 'TestEngine',
        usedModel: false,
      );
      expect(result, isNull);
    });

    test('returns null when required reflection field is missing or empty', () {
      const missingReflection = '''
      {
        "options": [],
        "question": "No reflection provided"
      }
      ''';

      final result = JsonParser.parseAiResult(
        missingReflection,
        engineUsed: 'TestEngine',
        usedModel: true,
      );
      expect(result, isNull);
    });
  });
}
