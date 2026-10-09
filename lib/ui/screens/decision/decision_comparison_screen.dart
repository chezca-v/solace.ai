import 'package:flutter/material.dart';
import '../../models/journal_entry.dart';
import '../../services/journal_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/memory_service.dart';
import '../../theme/solace_theme.dart';

/// 10 — Decision Comparison & Support Screen
class DecisionComparisonScreen extends StatefulWidget {
  final String? dilemmaTitle;
  final String? optionAName;
  final String? optionBName;
  final List<String>? optionAStrengths;
  final List<String>? optionATradeOffs;
  final List<String>? optionBStrengths;
  final List<String>? optionBTradeOffs;
  final int? optionAAutonomyScore;
  final int? optionAPaceScore;
  final int? optionBAutonomyScore;
  final int? optionBPaceScore;
  final List<Map<String, dynamic>>? priorities;
  final String? tensionSummary;
  final String? solSynthesis;
  final VoidCallback? onBack;
  final VoidCallback? onSaveToJournal;

  const DecisionComparisonScreen({
    super.key,
    this.dilemmaTitle,
    this.optionAName,
    this.optionBName,
    this.optionAStrengths,
    this.optionATradeOffs,
    this.optionBStrengths,
    this.optionBTradeOffs,
    this.optionAAutonomyScore,
    this.optionAPaceScore,
    this.optionBAutonomyScore,
    this.optionBPaceScore,
    this.priorities,
    this.tensionSummary,
    this.solSynthesis,
    this.onBack,
    this.onSaveToJournal,
  });

  @override
  State<DecisionComparisonScreen> createState() =>
      _DecisionComparisonScreenState();
}

class _DecisionComparisonScreenState extends State<DecisionComparisonScreen> {
  int _selectedTab = 0; // 0: Comparative Grid, 1: Detailed Breakdown
  late List<Map<String, dynamic>> _customPriorities;

  @override
  void initState() {
    super.initState();
    _customPriorities = _buildDynamicPriorities();
  }

  List<Map<String, dynamic>> _buildDynamicPriorities() {
    if (widget.priorities != null && widget.priorities!.isNotEmpty) {
      return List.from(widget.priorities!);
    }

    final onboarding = OnboardingService.instance;
    final memories = MemoryService.instance.memories.where((m) => m.isActive).toList();
    final list = <Map<String, dynamic>>[];

    if (onboarding.workingToward.trim().isNotEmpty) {
      list.add({
        'title': onboarding.workingToward.trim(),
        'weight': 'Weight: High',
        'isHigh': true,
      });
    }

    if (onboarding.explicitBoundaries.trim().isNotEmpty) {
      list.add({
        'title': 'Boundary: ${onboarding.explicitBoundaries.trim()}',
        'weight': 'Weight: High',
        'isHigh': true,
      });
    }

    for (final goal in onboarding.selectedGoals) {
      if (list.length < 3) {
        list.add({
          'title': goal,
          'weight': 'Weight: Med',
          'isHigh': false,
        });
      }
    }

    for (final mem in memories) {
      if (list.length < 3) {
        list.add({
          'title': mem.title,
          'weight': mem.category == 'HIGH PRIORITY' ? 'Weight: High' : 'Weight: Med',
          'isHigh': mem.category == 'HIGH PRIORITY',
        });
      }
    }

    if (list.isEmpty) {
      list.addAll([
        {
          'title': 'Autonomy & Schedule Control',
          'weight': 'Weight: High',
          'isHigh': true,
        },
        {
          'title': 'Sustainable Pace / Burnout Prevention',
          'weight': 'Weight: High',
          'isHigh': true,
        },
        {
          'title': 'Long-term Value Alignment',
          'weight': 'Weight: Med',
          'isHigh': false,
        },
      ]);
    }

    return list;
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

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag & Title
                        _buildTitleSection(),
                        const SizedBox(height: 14),

                        // Active Dilemma & Stated Priorities Card
                        _buildActiveDilemmaCard(),
                        const SizedBox(height: 14),

                        // Segmented View Toggle
                        _buildSegmentedToggle(),
                        const SizedBox(height: 14),

                        // Comparative Columns
                        _buildComparativeGrid(),
                        const SizedBox(height: 16),

                        // Dynamic Tension Analysis Card
                        _buildDynamicTensionCard(),
                        const SizedBox(height: 16),

                        // Sol's Synthesis Card
                        _buildSolSynthesisCard(context),
                        const SizedBox(height: 16),

                        // Privacy Footer Banner
                        _buildPrivacyBanner(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons
                _buildBottomButtons(context),
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
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                'Decision Support',
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
            child: Center(
              child: Text(
                userInitial,
                style: const TextStyle(
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

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.spa_rounded,
                      size: 13, color: SolaceTheme.primaryDark),
                  SizedBox(width: 5),
                  Text(
                    'DECISION ARCHITECTURE',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Decision Comparison',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: SolaceTheme.textHeading,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Grounded in your approved personal priorities',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 13,
            color: SolaceTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveDilemmaCard() {
    final effectiveDilemma = widget.dilemmaTitle ??
        (OnboardingService.instance.workingToward.trim().isNotEmpty
            ? OnboardingService.instance.workingToward.trim()
            : 'Balancing Immediate Demands vs. Sustainable Focus');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '• ACTIVE DILEMMA',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: SolaceTheme.primaryDark,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: SolaceTheme.surfaceWhite,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.balance_rounded,
                    size: 17, color: SolaceTheme.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            effectiveDilemma,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SolaceTheme.textHeading,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.lock_rounded, size: 12, color: SolaceTheme.primaryDark),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Retrieved from your private on-device journal vault',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    color: SolaceTheme.textBody,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stated Priorities Weights
          ..._customPriorities.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: _buildPriorityWeightRow(
                  title: p['title'] as String,
                  weight: p['weight'] as String,
                  isHigh: p['isHigh'] as bool? ?? false,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPriorityWeightRow({
    required String title,
    required String weight,
    required bool isHigh,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 16, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isHigh ? const Color(0xFFFFE4E6) : const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              weight,
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: isHigh ? const Color(0xFFBE123C) : const Color(0xFF047857),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF5F0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = 0),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? SolaceTheme.surfaceWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _selectedTab == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                          )
                        ]
                      : null,
                ),
                child: Text(
                  'Comparative Grid',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight:
                        _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                    color: _selectedTab == 0
                        ? SolaceTheme.textHeading
                        : SolaceTheme.textMuted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = 1),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? SolaceTheme.surfaceWhite
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Detailed Breakdown',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight:
                        _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                    color: _selectedTab == 1
                        ? SolaceTheme.textHeading
                        : SolaceTheme.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparativeGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Option A
        Expanded(
          child: _buildOptionColumn(
            optionTag: 'OPTION A',
            optionName: widget.optionAName ?? 'Protected Pacing',
            icon: Icons.lightbulb_outline_rounded,
            strengths: widget.optionAStrengths ?? [
              'Predictable cadence',
              'Preserves emotional energy',
              'Protected boundaries',
            ],
            tradeOffs: widget.optionATradeOffs ?? [
              'Slower initial rollout',
              'Requires turning down requests',
            ],
            autonomyScore: widget.optionAAutonomyScore ?? 8,
            paceScore: widget.optionAPaceScore ?? 9,
            bottomTag: '🌱 Sustainable Pace',
            isPaceWarning: false,
          ),
        ),
        const SizedBox(width: 12),

        // Option B
        Expanded(
          child: _buildOptionColumn(
            optionTag: 'OPTION B',
            optionName: widget.optionBName ?? 'Rapid Expansion',
            icon: Icons.rocket_launch_outlined,
            strengths: widget.optionBStrengths ?? [
              'High velocity output',
              'Immediate agency',
              'Fast development cycles',
            ],
            tradeOffs: widget.optionBTradeOffs ?? [
              'High cognitive load',
              'Risk of burnout',
            ],
            autonomyScore: widget.optionBAutonomyScore ?? 9,
            paceScore: widget.optionBPaceScore ?? 5,
            bottomTag: '📈 Maximum Agency',
            isPaceWarning: false,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionColumn({
    required String optionTag,
    required String optionName,
    required IconData icon,
    required List<String> strengths,
    required List<String> tradeOffs,
    required int autonomyScore,
    required int paceScore,
    required String bottomTag,
    required bool isPaceWarning,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: SolaceTheme.primaryDark),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      optionTag,
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                    Text(
                      optionName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Strengths Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6EE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '👍 STRENGTHS',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                ...strengths.map((s) => Text(
                      '• $s',
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: SolaceTheme.textBody,
                        height: 1.35,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Trade-Offs Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚖️ TRADE-OFFS',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 4),
                ...tradeOffs.map((t) => Text(
                      '• $t',
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: Color(0xFF4B5563),
                        height: 1.35,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Priority Alignment Scores
          const Text(
            'PRIORITY ALIGNMENT',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 6),

          // Autonomy Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Autonomy',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Text('$autonomyScore/10',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: autonomyScore / 10,
              minHeight: 5,
              backgroundColor: const Color(0xFFEDF5F0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(SolaceTheme.primary),
            ),
          ),
          const SizedBox(height: 8),

          // Sustainable Pace Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Sustainable Pace',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Text('$paceScore/10',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isPaceWarning
                        ? const Color(0xFFEF4444)
                        : SolaceTheme.textHeading,
                  )),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: paceScore / 10,
              minHeight: 5,
              backgroundColor: const Color(0xFFEDF5F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isPaceWarning
                    ? const Color(0xFFF87171)
                    : SolaceTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bottom Tag
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF5F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              bottomTag,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTensionCard() {
    final optA = widget.optionAName ?? 'Protected Pacing';
    final optB = widget.optionBName ?? 'Rapid Expansion';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: SolaceTheme.primary, width: 3.5),
            ),
            child: const Center(
              child: Icon(Icons.lock_rounded,
                  size: 16, color: SolaceTheme.primaryDark),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• DYNAMIC TENSION ANALYSIS',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.tensionSummary ??
                      'A natural tension exists between structured predictability ($optA) and fast momentum ($optB).',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.textHeading,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolSynthesisCard(BuildContext context) {
    final optA = widget.optionAName ?? 'Protected Pacing';
    final optB = widget.optionBName ?? 'Rapid Expansion';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4EBDD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    size: 16, color: SolaceTheme.primaryDark),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sol\'s Synthesis',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    Text(
                      'Reflected against your recorded priorities and memories',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 10.5,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.solSynthesis ??
                'Notice how $optA protects your long-term mental clarity and boundary for sustainable pacing, while $optB accelerates direct agency. Consider if a hybrid approach can capture key upsides while honoring your baseline boundaries.',
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: SolaceTheme.textHeading,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('🎯 Define 3 Boundaries'),
                backgroundColor: SolaceTheme.surfaceWhite,
                side: const BorderSide(color: Color(0xFFD4EBDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                  _showAdjustWeightsSheet(context);
                },
              ),
              ActionChip(
                label: const Text('⏳ Simulate 6 months out'),
                backgroundColor: SolaceTheme.surfaceWhite,
                side: const BorderSide(color: Color(0xFFD4EBDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Simulating long-term projection locally...')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E36),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, size: 16, color: Color(0xFF86EFAC)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Private on-device decision space — zero telemetry shared.',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
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
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                final summaryTitle = widget.dilemmaTitle ?? 'Decision Analysis & Synthesis';
                final tension = widget.tensionSummary ?? 'Comparative analysis of choices';
                final synthesis = widget.solSynthesis ??
                    'Balanced alignment with stated priorities and boundaries.';
                final fullContent = '$tension\n\nSolace Synthesis:\n$synthesis';

                final entry = JournalEntry(
                  id: 'decision-${DateTime.now().millisecondsSinceEpoch}',
                  title: summaryTitle,
                  content: fullContent,
                  createdAt: DateTime.now(),
                  type: 'Decision',
                  tags: ['Decision', 'Tension Analysis'],
                  solBadge: 'Decision Saved',
                  solWhisper: synthesis,
                  wordCount: fullContent.split(' ').where((w) => w.isNotEmpty).length,
                );

                await JournalService.instance.addEntry(entry);
                widget.onSaveToJournal?.call();

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Decision summary saved to private journal database.'),
                    backgroundColor: SolaceTheme.primary,
                  ),
                );
              },
              icon: const Icon(Icons.bookmark_outline_rounded,
                  size: 18, color: Colors.white),
              label: const Text(
                'Save Decision Summary to Journal',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () => _showAdjustWeightsSheet(context),
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: const Text(
                'Ask Solace to adjust weights',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: SolaceTheme.textHeading,
                side: const BorderSide(color: SolaceTheme.cardBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdjustWeightsSheet(BuildContext context) {
    final titleCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SolaceTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adjust Decision Weights & Priorities',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_customPriorities.length, (i) {
                  final item = _customPriorities[i];
                  final isHigh = item['isHigh'] as bool? ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _customPriorities[i]['isHigh'] = !isHigh;
                              _customPriorities[i]['weight'] =
                                  !isHigh ? 'Weight: High' : 'Weight: Med';
                            });
                            setState(() {});
                          },
                          child: Text(isHigh ? 'Set to Medium' : 'Set to High'),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Add Custom Decision Factor',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.trim().isNotEmpty) {
                        setState(() {
                          _customPriorities.add({
                            'title': titleCtrl.text.trim(),
                            'weight': 'Weight: High',
                            'isHigh': true,
                          });
                        });
                      }
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Decision weights updated.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SolaceTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Apply Weights'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
