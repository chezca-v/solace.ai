import 'package:test/test.dart';
import '../../lib/ai/ai_service.dart';
import '../../lib/ai/local_ai.dart';
import '../../lib/ai/rule_based_ai.dart';

class MockFailingGemma implements LocalAi {
  @override
  String get engineName => 'Gemma 3 1B (on-device)';

  @override
  Future<bool> init() async => false;

  @override
  Future<AiResult> reflect(String entry, UserContext ctx) async {
    return const AiResult(
      reflection: '',
      engineUsed: 'Gemma 3 1B (on-device)',
      usedModel: false,
      error: 'Simulated failure',
    );
  }

  @override
  Future<AiResult> compareOptions(String entry, UserContext ctx) async {
    return const AiResult(
      reflection: '',
      engineUsed: 'Gemma 3 1B (on-device)',
      usedModel: false,
      error: 'Simulated failure',
    );
  }
}

void main() {
  group('AiService', () {
    test('falls back honestly to RuleBasedAi when Gemma init fails', () async {
      final service = AiService(
        gemmaEngine: MockFailingGemma(),
        fallbackEngine: RuleBasedAi(),
      );

      final success = await service.init();
      expect(success, isTrue);
      expect(service.usingModel, isFalse);
      expect(service.engineName, equals('Rule-based mode'));

      final result = await service.reflect(
        'Testing my journal reflection',
        UserContext(),
      );

      expect(result.usedModel, isFalse);
      expect(result.engineUsed, equals('Rule-based mode'));
      expect(result.reflection, isNotEmpty);
    });
  });
}
