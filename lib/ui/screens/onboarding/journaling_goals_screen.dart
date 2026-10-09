import 'package:flutter/material.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';

/// 02 — Journaling Goals (Onboarding Step 1 of 4)
class JournalingGoalsScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const JournalingGoalsScreen({
    super.key,
    this.onContinue,
    this.onBack,
    this.onSkip,
  });

  @override
  State<JournalingGoalsScreen> createState() => _JournalingGoalsScreenState();
}

class _JournalingGoalsScreenState extends State<JournalingGoalsScreen> {
  final _service = OnboardingService.instance;

  static const List<_GoalOption> _goals = [
    _GoalOption(
      title: 'Understand my thoughts and feelings',
      subtitle: 'Unpack complex emotions and daily headspace.',
    ),
    _GoalOption(
      title: 'Make difficult decisions',
      subtitle: 'Compare trade-offs against my genuine priorities.',
    ),
    _GoalOption(
      title: 'Manage stress & overwhelm',
      subtitle: 'Gentle grounded reflection when feeling overloaded.',
    ),
    _GoalOption(
      title: 'Build habits & track personal growth',
      subtitle: 'Recognize evolving patterns over time.',
    ),
    _GoalOption(
      title: 'Remember important experiences',
      subtitle: 'Preserve meaningful milestones and lessons.',
    ),
    _GoalOption(
      title: 'Have a safe place to write freely',
      subtitle: 'Pure private expression without unsolicited advice.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCount = _service.selectedGoals.length;

    return Scaffold(
      backgroundColor: SolaceTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Top Navigation Header
                _buildHeader(context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        // Title & Subtitle
                        const Text(
                          'What brings you to\nSolace?',
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: SolaceTheme.textHeading,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Select what you\'d like to explore. You can change these anytime in your vault.',
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: SolaceTheme.textBody,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grounded Edge Banner
                        _buildGroundedBanner(),
                        const SizedBox(height: 16),

                        // Goal Selection Cards
                        ..._goals.map((goal) {
                          final isSelected = _service.selectedGoals.contains(goal.title);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _buildGoalCard(goal, isSelected),
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA Button & Footnote
                _buildBottomArea(selectedCount),
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
          // Back Button
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: SolaceTheme.textHeading),
            splashRadius: 22,
          ),

          // Step Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: SolaceTheme.badgeBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 3,
                  backgroundColor: SolaceTheme.primary,
                ),
                SizedBox(width: 6),
                Text(
                  'STEP 1 OF 4',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: SolaceTheme.badgeText,
                  ),
                ),
              ],
            ),
          ),

          // Skip Button
          TextButton(
            onPressed: widget.onSkip ?? widget.onContinue,
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: SolaceTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroundedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4EBDD),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFD3EEDB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa_rounded,
              size: 20,
              color: Color(0xFF1B7A52),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grounded, Private & Edge-Secure',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your reflections stay entirely on-device',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: SolaceTheme.textBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(_GoalOption goal, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _service.toggleGoal(goal.title);
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: SolaceTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? SolaceTheme.primary : SolaceTheme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? SolaceTheme.primary.withValues(alpha: 0.08)
                  : const Color(0xFF1B3C2D).withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox Circle
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isSelected ? SolaceTheme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? SolaceTheme.primary : const Color(0xFFCADBD0),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    goal.subtitle,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: SolaceTheme.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomArea(int selectedCount) {
    final buttonText = selectedCount > 0
        ? 'Continue ($selectedCount selected) →'
        : 'Continue →';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
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
            height: 52,
            child: ElevatedButton(
              onPressed: widget.onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 12, color: SolaceTheme.textMuted),
              SizedBox(width: 5),
              Text(
                'End-to-end encrypted · Stored only on your device',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: SolaceTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalOption {
  final String title;
  final String subtitle;
  const _GoalOption({required this.title, required this.subtitle});
}
