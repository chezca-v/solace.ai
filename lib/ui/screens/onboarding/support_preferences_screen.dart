import 'package:flutter/material.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';

/// 03 — Support Preferences (Onboarding Step 2 of 4)
class SupportPreferencesScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const SupportPreferencesScreen({
    super.key,
    this.onContinue,
    this.onBack,
    this.onSkip,
  });

  @override
  State<SupportPreferencesScreen> createState() => _SupportPreferencesScreenState();
}

class _SupportPreferencesScreenState extends State<SupportPreferencesScreen> {
  final _service = OnboardingService.instance;

  static const List<_SupportStyleOption> _styles = [
    _SupportStyleOption(
      icon: Icons.hearing_rounded,
      title: 'Listen and reflect',
      subtitle: 'Rephrase my thoughts back to me with empathy and clarity.',
    ),
    _SupportStyleOption(
      icon: Icons.balance_rounded,
      title: 'Help me compare choices',
      subtitle: 'Break down dilemmas into criteria and trade-offs.',
    ),
    _SupportStyleOption(
      icon: Icons.psychology_alt_rounded,
      title: 'Ask thoughtful questions',
      subtitle: 'Prompt deeper self-inquiry rather than quick conclusions.',
    ),
    _SupportStyleOption(
      icon: Icons.directions_walk_rounded,
      title: 'Help me find practical next steps',
      subtitle: 'Actionable, low-pressure micro-commitments.',
    ),
    _SupportStyleOption(
      icon: Icons.hub_rounded,
      title: 'Help me recognize recurring patterns',
      subtitle: 'Surface themes across past entries with permission.',
    ),
  ];

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

                        // Tailored Sanctuary Tag
                        _buildTag(),
                        const SizedBox(height: 10),

                        // Title & Subtitle
                        const Text(
                          'How would you like\nSolace to assist?',
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
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: SolaceTheme.textBody,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: 'Tell Sol your preferred response style when you tap ',
                              ),
                              TextSpan(
                                text: '"Reflect with Solace"',
                                style: TextStyle(
                                  color: SolaceTheme.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '. You can update this anytime.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Support Style Selection Cards
                        ..._styles.map((style) {
                          final isSelected =
                              _service.selectedSupportStyles.contains(style.title);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _buildStyleCard(style, isSelected),
                          );
                        }),
                        const SizedBox(height: 6),

                        // Sol Quote Banner
                        _buildSolQuoteBanner(),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA Button & Footnote
                _buildBottomArea(),
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
                  'Step 2 of 4',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
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

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco_rounded,
            size: 13,
            color: SolaceTheme.primaryDark,
          ),
          SizedBox(width: 5),
          Text(
            'TAILORED SANCTUARY',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: SolaceTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(_SupportStyleOption style, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _service.toggleSupportStyle(style.title);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading Icon in Mint Circle
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: SolaceTheme.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                style.icon,
                size: 20,
                color: SolaceTheme.iconColor,
              ),
            ),
            const SizedBox(width: 14),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.title,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    style.subtitle,
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
            const SizedBox(width: 10),

            // Trailing Checkbox Circle
            Container(
              width: 22,
              height: 22,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSolQuoteBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4EBDD),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFD3EEDB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              size: 19,
              color: Color(0xFF1B7A52),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sol • Private Edge Intelligence',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '"Solace never judges, scores, or diagnoses. You always set the tone."',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: SolaceTheme.textBody,
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

  Widget _buildBottomArea() {
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
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
                'Encrypted & stored strictly on this device',
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

class _SupportStyleOption {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SupportStyleOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
