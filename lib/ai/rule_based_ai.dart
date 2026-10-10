import 'local_ai.dart';

/// Offline, deterministic fallback AI engine using pattern matching and keyword heuristics.
class RuleBasedAi implements LocalAi {
  @override
  String get engineName => 'Rule-based mode';

  /// Constant for vetted local crisis support hotlines.
  static const String vettedLocalHotline =
      'TODO: Connect to vetted local hotline (e.g., National Center for Mental Health Crisis Hotline: 1553 / 0917-899-8727 / 0966-351-4518; In Touch Community Services: 0917-800-1123 / 0922-893-8944).';

  static const List<String> _crisisKeywords = [
    'suicide',
    'kill myself',
    'end my life',
    'want to die',
    'self harm',
    'cutting myself',
    'hurt myself',
    'no reason to live',
    'take my life',
    'magpakamatay',
    'kitlin ang sarili',
    'kitlin ang buhay',
    'saktan ang sarili',
    'ayaw ko na mabuhay',
    'tapusin ang buhay',
    'wakasan ang buhay',
  ];

  static const List<String> _taglishMarkers = [
    ' ang ',
    ' ng ',
    ' sa ',
    ' mga ',
    ' ako ',
    ' ko ',
    ' ikaw ',
    ' mo ',
    ' siya ',
    ' kami ',
    ' tayo ',
    ' natin ',
    ' kasi ',
    ' dahil ',
    ' pero ',
    ' hindi ',
    ' di ',
    ' meron ',
    ' wala ',
    ' gusto ',
    ' ayoko ',
    ' sana ',
    ' sobrang ',
    ' talaga ',
    ' naman ',
    ' ba ',
    ' pa ',
  ];

  @override
  Future<bool> init() async => true;

  @override
  Future<String> generateDailyPrompt(UserContext ctx) async {
    if (ctx.priorities.isNotEmpty) {
      final p = ctx.priorities.join(' and ');
      return 'Take a breath. You mentioned wanting clarity on $p. How does your mind feel right now?';
    } else if (ctx.goals.isNotEmpty) {
      final g = ctx.goals.join(' and ');
      return 'Take a gentle pause. As you work toward $g, how are you feeling today?';
    }
    return 'Take a breath. How does your mind feel right now?';
  }

  /// Checks if the text contains any crisis or self-harm keywords.
  bool isCrisis(String text) {
    final lower = text.toLowerCase();
    for (final kw in _crisisKeywords) {
      if (lower.contains(kw)) return true;
    }
    return false;
  }

  /// Detects whether the input is primarily Taglish/Filipino.
  bool isTaglish(String text) {
    final lower = ' ${text.toLowerCase()} ';
    int matches = 0;
    for (final marker in _taglishMarkers) {
      if (lower.contains(marker)) {
        matches++;
        if (matches >= 2) return true;
      }
    }
    return false;
  }

  /// Identifies the dominant intent from journal text.
  String detectIntent(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('decide') ||
        lower.contains('decision') ||
        lower.contains('choose') ||
        lower.contains('choice') ||
        lower.contains('between') ||
        lower.contains(' or ') ||
        lower.contains(' o ') ||
        lower.contains(' vs ') ||
        lower.contains('desisyon') ||
        lower.contains('pili') ||
        lower.contains('kaysa')) {
      return 'decision';
    }

    if (lower.contains('stressed') ||
        lower.contains('stress') ||
        lower.contains('overwhelmed') ||
        lower.contains('anxious') ||
        lower.contains('pressure') ||
        lower.contains('burnout') ||
        lower.contains('pagod') ||
        lower.contains('bigat') ||
        lower.contains('hirap') ||
        lower.contains('kaba') ||
        lower.contains('takot')) {
      return 'stress';
    }

    if (lower.contains('frustrated') ||
        lower.contains('angry') ||
        lower.contains('annoyed') ||
        lower.contains('rant') ||
        lower.contains('hate') ||
        lower.contains('galit') ||
        lower.contains('inis') ||
        lower.contains('bwisit') ||
        lower.contains('asar') ||
        lower.contains('lungkot') ||
        lower.contains('crying')) {
      return 'venting';
    }

    if (lower.contains('plan') ||
        lower.contains('goal') ||
        lower.contains('schedule') ||
        lower.contains('todo') ||
        lower.contains('routine') ||
        lower.contains('plano') ||
        lower.contains('target') ||
        lower.contains('hakbang')) {
      return 'planning';
    }

    return 'general';
  }

  @override
  Future<AiResult> reflect(String entry, UserContext ctx) async {
    if (isCrisis(entry)) {
      return _buildCrisisResult();
    }

    final taglish = isTaglish(entry);
    final intent = detectIntent(entry);
    final topic = _extractKeyTopic(entry);

    String sentence1;
    String sentence2;
    String question;

    if (taglish) {
      switch (intent) {
        case 'stress':
          sentence1 =
              'Mukhang ramdam mo ang labis na bigat at pagod kaugnay ng $topic ngayon.';
          sentence2 =
              'Mahalaga na nabibigyan mo ng puwang ang sarili mong maramdaman ito nang hindi nagmamadali.';
          question =
              'Ano ang isang maliit na bagay na makapagbibigay sa iyo ng kaunting ginhawa ngayon?';
          break;
        case 'venting':
          sentence1 =
              'Naririnig ko ang matinding inis at damdamin mo tungkol sa $topic.';
          sentence2 =
              'Ang pagsusulat nito ay isang magandang paraan upang maipahayag ang iyong nararamdaman.';
          question =
              'Ano kaya ang pinakamalaking dahilan kung bakit ito labis na nakakaapekto sa iyo?';
          break;
        case 'planning':
          sentence1 =
              'Mukhang pinag-iisipan mo nang mabuti ang iyong mga susunod na hakbang para sa $topic.';
          sentence2 =
              'Ang paglatag ng plano ay nakakatulong upang maging mas malinaw ang iyong direksyon.';
          question =
              'Ano ang pinakaunang hakbang na kaya mong simulan nang walang pag-aalinlangan?';
          break;
        case 'decision':
          sentence1 =
              'Mukhang pinagtitimbang mo ang mga posibleng opsyon para sa $topic.';
          sentence2 =
              'Normal lamang na makaramdam ng pag-aalinlangan kapag mahalaga ang desisyong hinaharap.';
          question =
              'Alin sa mga opsyon ang mas malapit sa iyong mga kasalukuyang prayoridad?';
          break;
        default:
          sentence1 =
              'Mukhang marami kang pinag-iisipan tungkol sa $topic sa mga sandaling ito.';
          sentence2 =
              'Ang pagbibigay-pansin sa iyong iniisip ay patunay ng malasakit mo sa iyong sarili.';
          question =
              'Ano ang pinakamahalagang aral o damdamin na lumulutang para sa iyo ngayon?';
      }
    } else {
      switch (intent) {
        case 'stress':
          sentence1 =
              'It sounds like you might be feeling overwhelmed by the weight of $topic right now.';
          sentence2 =
              'Allowing yourself to slow down and acknowledge this pressure is an essential part of self-care.';
          question =
              'What is one small boundary or comfort that could help you breathe a bit easier today?';
          break;
        case 'venting':
          sentence1 =
              'It sounds like you might be carrying a lot of frustration around $topic.';
          sentence2 =
              'Expressing these raw thoughts freely is a healthy way to release built-up tension.';
          question =
              'What part of this situation feels most outside of your control right now?';
          break;
        case 'planning':
          sentence1 =
              'It sounds like you are actively organizing your intentions and next steps regarding $topic.';
          sentence2 =
              'Mapping things out can turn overwhelming ideas into manageable actions.';
          question =
              'What is the very first step you can take today that feels realistic?';
          break;
        case 'decision':
          sentence1 =
              'It sounds like you might be weighing different paths concerning $topic.';
          sentence2 =
              'Taking time to consider each direction helps you stay true to what matters most.';
          question =
              'Which direction feels most aligned with your personal values right now?';
          break;
        default:
          sentence1 = _randomize([
            'It sounds like you are deeply reflecting on "$topic" today.',
            'I hear your thoughts about $topic.',
            'You are bringing a lot of awareness to $topic right now.'
          ]);
          sentence2 = _randomize([
            'Putting your experiences into words creates meaningful space to understand yourself better.',
            'Taking time to unpack this shows a lot of care for your mental well-being.',
            'Acknowledging these feelings is the first step toward clarity.'
          ]);
          question = _randomize([
            'What thought or feeling stands out most to you from what you just wrote?',
            'How does it feel to finally express this?',
            'What is the kindest thing you could tell yourself about this right now?'
          ]);
      }
    }

    return AiResult(
      reflection: '$sentence1 $sentence2',
      followUpQuestion: question,
      engineUsed: engineName,
      usedModel: false,
    );
  }

  @override
  Future<AiResult> compareOptions(String entry, UserContext ctx) async {
    if (isCrisis(entry)) {
      return _buildCrisisResult();
    }

    final parsed = _extractOptionsFromEntry(entry);
    if (parsed == null) {
      return AiResult(
        reflection:
            'It sounds like you might be facing an important decision, but the specific choices are still taking shape. Clarifying each option can make the path forward clearer.',
        options: const [],
        followUpQuestion:
            'Could you list the two or three specific options you are deciding between?',
        engineUsed: engineName,
        usedModel: false,
      );
    }

    final optionA = parsed.$1;
    final optionB = parsed.$2;

    final priorityHint = ctx.priorities.isNotEmpty
        ? ctx.priorities.first
        : 'personal peace';

    final options = [
      OptionItem(
        name: optionA,
        pros: [
          'Directly addresses immediate needs',
          'May support your priority for $priorityHint',
        ],
        cons: [
          'Requires time and focus to see through',
          'Could require adjustments in other areas',
        ],
      ),
      OptionItem(
        name: optionB,
        pros: [
          'Offers an alternative perspective or path',
          'May preserve flexibility in the near term',
        ],
        cons: [
          'May delay resolving the root dilemma',
          'Worth checking against your long-term goals',
        ],
      ),
    ];

    final reflection =
        'It sounds like you might be weighing the choice between "$optionA" and "$optionB". Examining both directions side by side can help clarify what is truly best for you.';

    return AiResult(
      reflection: reflection,
      options: options,
      followUpQuestion:
          'When you picture yourself choosing "$optionA", how does your body and mind feel compared to "$optionB"?',
      engineUsed: engineName,
      usedModel: false,
    );
  }

  AiResult _buildCrisisResult() {
    return const AiResult(
      reflection:
          'I hear how much pain you are going through right now, and I want you to know that you do not have to carry this alone. Please connect with someone who can support you right now.',
      options: [],
      followUpQuestion: vettedLocalHotline,
      engineUsed: 'Rule-based mode',
      usedModel: false,
    );
  }

  (String, String)? _extractOptionsFromEntry(String entry) {
    final clean = entry.trim();

    // Pattern 1: between X and Y
    final betweenRegex = RegExp(
      r'between\s+(.+?)\s+(?:and|o|or)\s+(.+)',
      caseSensitive: false,
    );
    final betweenMatch = betweenRegex.firstMatch(clean);
    if (betweenMatch != null) {
      final opt1 = _cleanOptionName(betweenMatch.group(1) ?? '');
      final opt2 = _cleanOptionName(betweenMatch.group(2) ?? '');
      if (opt1.isNotEmpty && opt2.isNotEmpty) return (opt1, opt2);
    }

    // Pattern 2: X vs/versus/kaysa/or/o Y
    final splitRegex = RegExp(
      r'\s+(?:vs\.?|versus|kaysa\s+sa|kaysa|\bor\b|\bo\b)\s+',
      caseSensitive: false,
    );
    final parts = clean.split(splitRegex);
    if (parts.length >= 2) {
      final opt1 = _cleanOptionName(parts[0]);
      final opt2 = _cleanOptionName(parts[1]);
      if (opt1.isNotEmpty && opt2.isNotEmpty) return (opt1, opt2);
    }

    return null;
  }

  String _cleanOptionName(String raw) {
    var text = raw.trim();
    final removePrefixes = [
      'choosing between',
      'deciding between',
      'should i',
      'whether to',
      'i should',
      'gusto kong',
      'pipiliin ko ba ang',
      'pipiliin ko ba',
    ];
    for (final prefix in removePrefixes) {
      if (text.toLowerCase().startsWith(prefix)) {
        text = text.substring(prefix.length).trim();
      }
    }
    // Remove trailing punctuation
    text = text.replaceAll(RegExp(r'[\.\?\!\,\;]+$'), '').trim();
    if (text.length > 50) {
      text = '${text.substring(0, 47)}...';
    }
    return text;
  }

  String _extractKeyTopic(String entry) {
    final cleanText = entry.replaceAll(RegExp(r'[^\w\s]'), ' ').trim();
    if (cleanText.isEmpty) return 'your situation';
    
    // Just take the first few words as a natural phrase instead of wrapping it in parentheses
    final words = cleanText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length <= 6) return cleanText.toLowerCase();
    
    return '${words.take(6).join(' ').toLowerCase()}...';
  }

  // Add some randomization to sentence structures so it feels dynamic
  String _randomize(List<String> options) {
    return options[DateTime.now().millisecondsSinceEpoch % options.length];
  }
}
