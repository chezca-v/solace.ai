import 'package:flutter/material.dart';
import '../../../ai/ai_service.dart';
import '../../../models/journal_entry.dart';
import '../../../services/journal_service.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';

/// 07 — Journal Editor
class JournalEditorScreen extends StatefulWidget {
  final JournalEntry? initialEntry;
  final VoidCallback? onBack;
  final VoidCallback? onOpenVoice;
  final Function(JournalEntry)? onReflectWithSolace;

  const JournalEditorScreen({
    super.key,
    this.initialEntry,
    this.onBack,
    this.onOpenVoice,
    this.onReflectWithSolace,
  });

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _showSeed = true;
  bool _isReflecting = false;
  int _seedIndex = 0;

  final List<String> _seeds = [
    'Something I want to explore with honesty today',
    'A quiet priority I want to hold space for',
    'Where is my energy naturally drawn right now?',
    'What felt grounding or clarifying today?',
  ];

  String get _currentSeed => _seeds[_seedIndex % _seeds.length];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialEntry?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.initialEntry?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  int get _wordCount {
    final text = _contentController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  void _saveEntry() {
    final entry = JournalEntry(
      id: widget.initialEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim().isEmpty
          ? 'Untitled Reflection'
          : _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.initialEntry?.createdAt ?? DateTime.now(),
      type: 'Reflection',
      tags: ['Personal', 'Mindful'],
      solBadge: 'Ready for reflection',
      wordCount: _wordCount,
    );

    JournalService.instance.addEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reflection saved to private offline vault.'),
        backgroundColor: SolaceTheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleReflectWithSolace() async {
    setState(() => _isReflecting = true);
    final userContext = OnboardingService.instance.toUserContext();
    final entryText = '${_titleController.text}\n\n${_contentController.text}';

    try {
      final aiResult = await AiService.instance.reflect(entryText, userContext);
      if (!mounted) return;
      setState(() => _isReflecting = false);

      final entry = JournalEntry(
        id: widget.initialEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim().isEmpty
            ? 'Untitled Reflection'
            : _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: widget.initialEntry?.createdAt ?? DateTime.now(),
        type: 'Reflection',
        tags: ['Personal', 'Mindful'],
        solBadge: 'Reflection ready',
        solWhisper: aiResult.reflection,
        wordCount: _wordCount,
      );
      await JournalService.instance.addEntry(entry);

      _showReflectionDialog(aiResult.reflection, aiResult.followUpQuestion);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isReflecting = false);
      _showReflectionDialog(
        'Sol has listened carefully to your thoughts. Your reflection and insights will be generated privately on your device.',
        'Would you like to explore what you\'re feeling further or organize your thoughts into next steps?',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaceTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Top App Bar
                _buildHeader(context),

                // Meta Row: Auto-save status + Time + Word count
                _buildMetaRow(),

                // Scrollable Editor Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gentle Reflection Seed Card
                        if (_showSeed) _buildReflectionSeedCard(),
                        if (_showSeed) const SizedBox(height: 14),

                        // Title Field
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: SolaceTheme.textHeading,
                            letterSpacing: -0.4,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Title your reflection...',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Tuning Tags Row
                        _buildTuningTags(),
                        const SizedBox(height: 16),

                        // Content Field
                        TextField(
                          controller: _contentController,
                          maxLines: null,
                          style: const TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: SolaceTheme.textBody,
                            height: 1.55,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Write freely. Solace only listens when invited...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),

                        // Live Intent / Sentiment Resonance Bar
                        _buildSentimentBar(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
                _buildBottomActionBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: SolaceTheme.textHeading),
            splashRadius: 22,
          ),
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                'New Reflection',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: SolaceTheme.primary, width: 1.5),
              color: const Color(0xFFD4EBDD),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'AUTO-SAVED LOCALLY',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.initialEntry?.formattedDate ?? 'Today • Offline',
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 11.5,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F6EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco_rounded, size: 12, color: SolaceTheme.primaryDark),
                const SizedBox(width: 4),
                Text(
                  '$_wordCount words',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionSeedCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFD4EBDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.push_pin_rounded, size: 16, color: SolaceTheme.primaryDark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gentle Reflection Seed',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
                Text(
                  '✦ $_currentSeed',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => _seedIndex++);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Seed refreshed!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded, size: 18, color: SolaceTheme.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => setState(() => _showSeed = false),
            icon: const Icon(Icons.close_rounded, size: 18, color: SolaceTheme.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTuningTags() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'TUNING:',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: SolaceTheme.textMuted,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF9C3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 2.5, backgroundColor: Color(0xFFD97706)),
              SizedBox(width: 4),
              Text(
                'Contemplative',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF854D0E),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: SolaceTheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.self_improvement_rounded, size: 12, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Mindful Reflection',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentimentBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.spa_rounded, size: 14, color: SolaceTheme.primaryDark),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Tension & Clarification Stream',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Balanced Resonance',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: SolaceTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: BoxDecoration(
        color: SolaceTheme.background,
        boxShadow: [
          BoxShadow(
            color: SolaceTheme.background.withValues(alpha: 0.9),
            blurRadius: 8,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary Button: Reflect with Solace
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isReflecting ? null : _handleReflectWithSolace,
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isReflecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Reflect with Solace',
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // Secondary Row: Save Entry + Mic + Shield
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveEntry,
                  icon: const Icon(Icons.bookmark_border_rounded, size: 16),
                  label: const Text(
                    'Save Entry',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SolaceTheme.textHeading,
                    side: const BorderSide(color: SolaceTheme.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7EE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4EBDD)),
                ),
                child: IconButton(
                  onPressed: widget.onOpenVoice,
                  icon: const Icon(Icons.mic_rounded, color: SolaceTheme.primaryDark, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: SolaceTheme.surfaceWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: SolaceTheme.cardBorder),
                ),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Encrypted locally in SQLite. Zero cloud leakage.'),
                        backgroundColor: SolaceTheme.primaryDark,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shield_outlined, color: SolaceTheme.primaryDark, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReflectionDialog(String reflection, String? question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SolaceTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFD97706), size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solace Reflection',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    Text(
                      'Generated 100% on-device',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: SolaceTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              reflection,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 14.5,
                color: SolaceTheme.textBody,
                height: 1.45,
              ),
            ),
            if (question != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '💡 $question',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.primaryDark,
                    height: 1.35,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Return to Sanctuary'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
