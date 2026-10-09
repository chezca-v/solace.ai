import 'package:flutter/material.dart';
import '../../../models/memory_item.dart';
import '../../../services/journal_service.dart';
import '../../../services/memory_service.dart';
import '../../theme/solace_theme.dart';
import '../../widgets/sun_illustration.dart';

/// 08/09 — Memory Insight Detail & Sol Reflection Screen
class EntryDetailScreen extends StatefulWidget {
  final String? entryId;
  final VoidCallback? onBack;
  final VoidCallback? onCompareChoices;
  final VoidCallback? onExploreAnxiety;
  final VoidCallback? onDraftPlan;

  const EntryDetailScreen({
    super.key,
    this.entryId,
    this.onBack,
    this.onCompareChoices,
    this.onExploreAnxiety,
    this.onDraftPlan,
  });

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _selectedMoodIndex = 1; // 0: Meditating, 1: Empathetic, 2: Joyful, 3: Alert
  bool _isSavedToMemories = true;
  bool _isDismissed = false;

  final List<Map<String, dynamic>> _moods = [
    {
      'label': 'Meditating',
      'icon': Icons.self_improvement_rounded,
      'color': const Color(0xFF8B5CF6),
      'activeText': 'Meditating Mode',
    },
    {
      'label': 'Empathetic & Comforting',
      'subtitle': '(Active: Dilemma detected)',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFF10B981),
      'activeText': 'Empathetic Mode',
    },
    {
      'label': 'Joyful',
      'icon': Icons.auto_awesome_rounded,
      'color': const Color(0xFFF59E0B),
      'activeText': 'Joyful Mode',
    },
    {
      'label': 'Alert',
      'icon': Icons.lightbulb_outline_rounded,
      'color': const Color(0xFFEF4444),
      'activeText': 'Analytical Mode',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journalService = JournalService.instance;
    final entry = journalService.getEntryById(widget.entryId ?? 'entry-1');

    final title = entry?.title ??
        'Two opportunities: Lead researcher vs Founding designer';
    final content = entry?.content ??
        'I spent the afternoon staring at both offer letters. On one side, taking the Lead Researcher position at the lab offers immense institutional prestige, established funding pipelines, and instant validation from peers. Everyone I know expects me to take it.\n\nOn the other hand, the Founding Designer role at the early-stage wellness collective excites something intuitive in me. The freedom to craft design language from zero, set my own rhythms, and protect my personal calm. Yet, there is this persistent undercurrent of guilt—am I playing it too small? Why do I worry about how my resume looks more than how my everyday mornings will feel?';
    final dateStr = entry?.formattedDate ?? 'Oct 9, 2026 • 10:14 PM';
    final wordCount = entry?.wordCount ?? 428;

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

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stored on Device Badge + Timestamp
                        _buildStorageAndTimestampRow(dateStr),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: SolaceTheme.textHeading,
                            height: 1.25,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Original Journal Entry Card
                        _buildOriginalJournalCard(content, wordCount),
                        const SizedBox(height: 18),

                        // Local Privacy Synthesis Divider
                        _buildPrivacySynthesisDivider(),
                        const SizedBox(height: 18),

                        // Sol Reflection Section
                        if (!_isDismissed) ...[
                          _buildSolReflectionCard(context),
                          const SizedBox(height: 16),
                        ],

                        // Offline intelligence footnote banner
                        _buildOfflineBanner(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
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
            icon: const Icon(Icons.arrow_back_rounded,
                color: SolaceTheme.textHeading),
            splashRadius: 22,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F7EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 17,
                      color: Color(0xFF2E8B62),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Memory Insight Detail',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: SolaceTheme.primary, width: 1.5),
                  color: const Color(0xFFD4EBDD),
                ),
                child: const Center(
                  child: Text(
                    'E',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageAndTimestampRow(String dateStr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6EE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCEECD9), width: 0.8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 13, color: SolaceTheme.primaryDark),
              SizedBox(width: 4),
              Text(
                'Stored on device',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: SolaceTheme.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  dateStr,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: SolaceTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalJournalCard(String content, int wordCount) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SolaceTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 3.5,
                    backgroundColor: SolaceTheme.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ORIGINAL JOURNAL ENTRY',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: SolaceTheme.textMuted,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.edit_outlined,
                      size: 13, color: SolaceTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '$wordCount words',
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: SolaceTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Content body
          Text(
            content,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 14,
              color: SolaceTheme.textBody,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),

          // Tag chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTagChip('↻ Career Transition'),
              _buildTagChip('⚖️ Reflective Tension'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFECE5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: SolaceTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SolaceTheme.primaryDark,
        ),
      ),
    );
  }

  Widget _buildPrivacySynthesisDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFD4EBDD), thickness: 1),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6EE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hub_outlined, size: 13, color: SolaceTheme.primaryDark),
              SizedBox(width: 5),
              Text(
                'Local Privacy Synthesis',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFD4EBDD), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSolReflectionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood selector pills
          _buildMoodSelector(),
          const SizedBox(height: 16),

          // Sol Mascot Centerpiece
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 90 + (_pulseController.value * 12),
                      height: 90 + (_pulseController.value * 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981)
                            .withOpacity(0.12 - (_pulseController.value * 0.06)),
                      ),
                    );
                  },
                ),
                Container(
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFC7EBD7),
                  ),
                  child: const Center(
                    child: SunIllustration(
                      size: 64,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sol Reflection Subtitle & Model Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD3F2DF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wb_sunny_rounded,
                          size: 15, color: Color(0xFF166E49)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sol Reflection',
                            style: TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: SolaceTheme.textHeading,
                            ),
                          ),
                          Text(
                            'On-device neural core • ${_moods[_selectedMoodIndex]['activeText']}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 11,
                              color: SolaceTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F2DF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBBE5CD)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF166E49)),
                    SizedBox(width: 2),
                    Text(
                      'ONNX Mobile v1.2',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF166E49),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Reflection Quote Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SolaceTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD4EBDD)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              '“It sounds like both opportunities matter to you, and choosing one feels like losing something. Your anxiety seems focused on prestige, but your recorded priorities highlight autonomy and sustainable pacing.”',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: SolaceTheme.textHeading,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Connected past memory chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F4E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCEECD9)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.link_rounded, size: 14, color: Color(0xFF1B7A52)),
                    SizedBox(width: 5),
                    Text(
                      'Connected to past memory',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B7A52),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  '“Stated priority: Avoid burnout in Q4” (Oct 2)',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: SolaceTheme.textHeading,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section Subtitle
          const Text(
            'ON-DEVICE NEURAL CORE • EMPATHETIC MODE',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: SolaceTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 10),

          // Primary CTA Button: Compare Choices based on Priorities
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onCompareChoices ??
                  () => _showDecisionComparison(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.balance_rounded, size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Compare Choices based on Priorities',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Secondary Action Buttons
          _buildSecondaryActionTile(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Explore this anxiety',
            onTap: widget.onExploreAnxiety ?? () => _showExploreAnxietyDialog(context),
          ),
          const SizedBox(height: 8),
          _buildSecondaryActionTile(
            icon: Icons.article_outlined,
            title: 'Draft action plan',
            onTap: widget.onDraftPlan ?? () => _showActionPlanDialog(context),
          ),
          const SizedBox(height: 14),

          // Save insight to memories toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: SolaceTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4EBDD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.folder_special_outlined,
                          size: 16, color: SolaceTheme.primaryDark),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Save insight to memories',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: SolaceTheme.textHeading,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isSavedToMemories,
                    onChanged: (val) {
                      setState(() => _isSavedToMemories = val);
                      if (val) {
                        MemoryService.instance.addMemory(
                          MemoryItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: 'Career Dilemma: Research vs Founding Designer',
                            quoteOrDescription:
                                'Prioritizes autonomy & sustainable pacing over institutional prestige.',
                            source: 'Entry on Oct 9: Two opportunities',
                            category: 'HIGH PRIORITY',
                            subcategory: 'Career',
                            createdAt: DateTime.now(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insight saved to Personal Memory Vault!'),
                            backgroundColor: SolaceTheme.primaryDark,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    activeColor: SolaceTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Edit interpretation & Dismiss Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditInterpretationDialog(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: SolaceTheme.surfaceWhite,
                    side: const BorderSide(color: Color(0xFFCEECD9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.edit_outlined,
                      size: 14, color: SolaceTheme.textBody),
                  label: const Text(
                    'Edit interpretation',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _isDismissed = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Reflection dismissed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.white,
                          onPressed: () => setState(() => _isDismissed = false),
                        ),
                        backgroundColor: SolaceTheme.textHeading,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: SolaceTheme.surfaceWhite,
                    side: const BorderSide(color: Color(0xFFCEECD9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.visibility_off_outlined,
                      size: 14, color: SolaceTheme.textMuted),
                  label: const Text(
                    'Dismiss',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SolaceTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_moods.length, (index) {
          final mood = _moods[index];
          final isSelected = _selectedMoodIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _selectedMoodIndex = index),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? SolaceTheme.surfaceWhite
                      : const Color(0xFFDFF0E6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      mood['icon'] as IconData,
                      size: 14,
                      color: mood['color'] as Color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mood['label'] as String,
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? SolaceTheme.textHeading
                            : SolaceTheme.textBody,
                      ),
                    ),
                    if (mood.containsKey('subtitle')) ...[
                      const SizedBox(width: 4),
                      Text(
                        mood['subtitle'] as String,
                        style: const TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSecondaryActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: SolaceTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD4EBDD)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: SolaceTheme.primaryDark),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: SolaceTheme.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCEECD9)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, size: 18, color: SolaceTheme.primaryDark),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Offline intelligence maintains absolute privacy: this journal was analyzed directly by your phone’s processor without cloud transit.',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 11.5,
                color: Color(0xFF1B7A52),
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDecisionComparison(BuildContext context) {
    Navigator.of(context).pushNamed('/decision');
  }

  void _showExploreAnxietyDialog(BuildContext context) {
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
            const Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    color: SolaceTheme.primaryDark),
                SizedBox(width: 8),
                Text(
                  'Exploring Career Anxiety',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Sol detected a tension between internal satisfaction and external expectations. Here is a grounding reflection:',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13.5,
                color: SolaceTheme.textBody,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F8F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                '“When you imagine waking up on a Tuesday 6 months from now, what energizes you more: the prestige on your CV, or the creative ownership in your studio?”',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Return to Insight'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionPlanDialog(BuildContext context) {
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
            const Row(
              children: [
                Icon(Icons.checklist_rounded, color: SolaceTheme.primaryDark),
                SizedBox(width: 8),
                Text(
                  '3-Step Boundary Action Plan',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildPlanStep(
                '1', 'List your 3 non-negotiable weekly sprint boundaries.'),
            _buildPlanStep(
                '2', 'Schedule a 30-min clarifying call with the founding team.'),
            _buildPlanStep(
                '3', 'Conduct a somatic check-in before signing any contract.'),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Adopt Action Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFFD3F2DF),
            child: Text(
              num,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13,
                color: SolaceTheme.textHeading,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditInterpretationDialog(BuildContext context) {
    final controller = TextEditingController(
      text:
          'It sounds like both opportunities matter to you, and choosing one feels like losing something. Your anxiety seems focused on prestige, but your recorded priorities highlight autonomy and sustainable pacing.',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SolaceTheme.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Edit AI Interpretation',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FBF9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interpretation refined locally.'),
                  backgroundColor: SolaceTheme.primaryDark,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SolaceTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
