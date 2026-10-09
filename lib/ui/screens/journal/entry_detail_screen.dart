import 'package:flutter/material.dart';
import '../../../models/journal_entry.dart';
import '../../../models/memory_item.dart';
import '../../../services/journal_service.dart';
import '../../../services/memory_service.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';
import '../../widgets/sun_illustration.dart';
import '../decision/decision_comparison_screen.dart';

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
  bool _isSavedToMemories = false;
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

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, $hour:$minute $period • Stored on device';
  }

  @override
  Widget build(BuildContext context) {
    final journalService = JournalService.instance;
    final entry = widget.entryId != null
        ? journalService.getEntryById(widget.entryId!)
        : (journalService.entries.isNotEmpty ? journalService.entries.first : null);

    final title = entry?.title ?? 'Personal Reflection';
    final content = entry?.content ??
        'Write or speak freely to begin your sanctuary reflection. All thoughts stay encrypted on your device.';
    final dateStr = entry != null ? _formatDate(entry.createdAt) : 'Today • Stored on device';
    final wordCount = entry?.wordCount ?? (content.split(' ').where((w) => w.isNotEmpty).length);

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
                        _buildOriginalJournalCard(content, wordCount, entry?.tags),
                        const SizedBox(height: 18),

                        // Local Privacy Synthesis Divider
                        _buildPrivacySynthesisDivider(),
                        const SizedBox(height: 18),

                        // Sol Reflection Section
                        if (!_isDismissed) ...[
                          _buildSolReflectionCard(context, entry),
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
    final userInitial = OnboardingService.instance.userInitial;

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
                child: Center(
                  child: Text(
                    userInitial,
                    style: const TextStyle(
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

  Widget _buildOriginalJournalCard(String content, int wordCount, [List<String>? tags]) {
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
            children: (tags != null && tags.isNotEmpty)
                ? tags.map((t) => _buildTagChip('• $t')).toList()
                : [
                    _buildTagChip('• Mindful Reflection'),
                    _buildTagChip('• Stored Locally'),
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

  Widget _buildSolReflectionCard(BuildContext context, [JournalEntry? entry]) {
    final solReflectionText = entry?.solWhisper ??
        '“Sol has listened carefully to your reflections. When you review your priorities, pause and notice which path preserves your energy and boundaries.”';

    final connectedMemoryText = entry?.tags != null && entry!.tags.isNotEmpty
        ? '“Stated priority: ${entry.tags.join(', ')}”'
        : '“Synthesizing recurring patterns from your local sanctuary...”';

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
            width: double.infinity,
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
            child: Text(
              solReflectionText,
              style: const TextStyle(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                const SizedBox(height: 3),
                Text(
                  connectedMemoryText,
                  style: const TextStyle(
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
              onPressed: () {
                if (widget.onCompareChoices != null) {
                  widget.onCompareChoices!();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DecisionComparisonScreen(
                        dilemmaTitle: entry?.title,
                      ),
                    ),
                  );
                }
              },
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
            title: 'Explore underlying themes',
            onTap: widget.onExploreAnxiety ?? () => _showExploreAnxietyDialog(context),
          ),
          const SizedBox(height: 8),
          _buildSecondaryActionTile(
            icon: Icons.article_outlined,
            title: 'Draft mindful action plan',
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
                            title: entry?.title ?? 'Personal Insight',
                            quoteOrDescription: entry?.content != null &&
                                    entry!.content.length > 80
                                ? '${entry.content.substring(0, 80)}...'
                                : (entry?.content ?? 'Approved personal priority from reflection.'),
                            source: 'Entry: ${entry?.title ?? "Reflection"}',
                            category: 'HIGH PRIORITY',
                            subcategory: 'Insight',
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
                  onPressed: () => _showEditInterpretationDialog(context, entry, solReflectionText),
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
                  'Exploring Underlying Themes',
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
              'Sol detected nuanced themes in your reflection. Here is a grounding prompt to explore:',
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
                '“When you pause and check in with yourself right now, what is the one priority or boundary that feels most essential to protect?”',
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
                  '3-Step Mindful Action Plan',
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
                '1', 'Define your 3 non-negotiable personal boundaries.'),
            _buildPlanStep(
                '2', 'Schedule a quiet moment to reflect on each choice.'),
            _buildPlanStep(
                '3', 'Conduct a grounding check-in before finalizing decisions.'),
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

  void _showEditInterpretationDialog(BuildContext context, JournalEntry? entry, [String? initialText]) {
    final controller = TextEditingController(
      text: initialText ??
          'Your reflection and empathetic synthesis will appear here once Sol processes this entry locally on your device.',
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
              if (entry != null) {
                final updated = JournalEntry(
                  id: entry.id,
                  title: entry.title,
                  content: entry.content,
                  createdAt: entry.createdAt,
                  type: entry.type,
                  tags: entry.tags,
                  solBadge: entry.solBadge,
                  solWhisper: controller.text.trim(),
                  wordCount: entry.wordCount,
                  audioDuration: entry.audioDuration,
                  isAudioDraft: entry.isAudioDraft,
                );
                JournalService.instance.updateEntry(updated);
              }
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interpretation updated locally.'),
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
