import 'package:flutter/material.dart';
import '../theme/solace_theme.dart';
import '../widgets/sun_illustration.dart';

/// 01 — Welcome Screen (Landing Page)
///
/// The introductory landing screen for Solace AI highlighting
/// offline-first privacy, local SQLite persistence, and mindful journaling.
class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onGetStarted;
  final VoidCallback? onRestoreBackup;

  const WelcomeScreen({
    super.key,
    this.onGetStarted,
    this.onRestoreBackup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaceTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // Sun Artwork with Radiant Rays & Sparkle Badge
                  const SunIllustration(size: 136),
                  const SizedBox(height: 16),

                  // Privacy & Offline Badge Pill
                  _buildPrivacyBadge(),
                  const SizedBox(height: 16),

                  // App Name
                  const Text(
                    'Solace AI',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Main Headline
                  const Text(
                    'A space to come back to\nyourself.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: SolaceTheme.textHeading,
                      height: 1.22,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Descriptive Subtitle
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Your private AI journal that understands you, remembers what matters, and helps you think clearly—even without an internet connection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: SolaceTheme.textBody,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3 Feature Cards
                  _buildFeatureCard(
                    icon: Icons.wifi_off_rounded,
                    title: '100% Offline Capable',
                    subtitle:
                        'Journal and reflect anywhere, from airplanes to off-grid retreats.',
                  ),
                  const SizedBox(height: 12),

                  _buildFeatureCard(
                    icon: Icons.lock_outline_rounded,
                    title: 'Zero Cloud Leakage',
                    subtitle:
                        'Stored in encrypted SQLite locally on your physical device.',
                  ),
                  const SizedBox(height: 12),

                  _buildFeatureCard(
                    icon: Icons.edit_note_rounded,
                    title: 'Capture First, Assist Third',
                    subtitle:
                        'Write freely; Solace only assists thoughtfully when invited.',
                  ),
                  const SizedBox(height: 28),

                  // Primary CTA: "Get Started →"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onGetStarted ?? () => _defaultOnGetStarted(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SolaceTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: SolaceTheme.primary.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary CTA: "↺ Restore Encrypted Backup"
                  TextButton.icon(
                    onPressed: onRestoreBackup ?? () => _showRestoreBackupSheet(context),
                    icon: const Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: SolaceTheme.textMuted,
                    ),
                    label: const Text(
                      'Restore Encrypted Backup',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SolaceTheme.textBody,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: SolaceTheme.textBody,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Privacy Badge pill at the top
  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: SolaceTheme.badgeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SolaceTheme.badgeBorder,
          width: 0.8,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 14,
            color: SolaceTheme.badgeText,
          ),
          SizedBox(width: 6),
          Text(
            'Private by design. Useful offline.',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: SolaceTheme.badgeText,
            ),
          ),
        ],
      ),
    );
  }

  /// Feature information card
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SolaceTheme.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B3C2D).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon in mint circular container
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: SolaceTheme.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: SolaceTheme.iconColor,
            ),
          ),
          const SizedBox(width: 14),

          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
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
    );
  }

  void _defaultOnGetStarted(BuildContext context) {
    // Navigation to the next step in onboarding or auth
    Navigator.of(context).pushNamed('/login');
  }

  void _showRestoreBackupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                Icon(Icons.lock_rounded, color: SolaceTheme.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  'Restore Encrypted Backup',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Select an encrypted Solace backup (.solace) file from your local storage to restore your journal entries and memories.',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 14,
                color: SolaceTheme.textBody,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select backup file to restore.'),
                      backgroundColor: SolaceTheme.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.file_open_rounded, size: 18),
                label: const Text('Select Backup File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
