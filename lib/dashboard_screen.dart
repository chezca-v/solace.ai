import 'package:flutter/material.dart';
import 'ui/widgets/animated_sol_avatar.dart';
import 'ui/screens/onboarding/onboarding_step_1_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color canvasBackground = Color(0xFFF4F8F5);
    const Color onSurface = Color(0xFF082017);
    const Color primary = Color(0xFF006C48);
    const Color primaryContainer = Color(0xFF4CAF82);
    const Color onPrimary = Color(0xFFFFFFFF);
    const Color aiBubble = Color(0xFFE3F2EC);
    const Color onTertiaryContainer = Color(0xFF193B2C);
    const Color inverseSurface = Color(0xFF1E352B);
    const Color bodyForest = Color(0xFF2D4A3E);
    const Color surfaceContainerLowest = Color(0xFFFFFFFF);
    const Color surfaceContainerLow = Color(0xFFDFFAEB);
    const Color onSurfaceVariant = Color(0xFF3E4942);

    return Scaffold(
      backgroundColor: canvasBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar Section
                const SizedBox(height: 16),
                const Center(
                  child: AnimatedSolAvatar(size: 130),
                ),
                const SizedBox(height: 32),

                // Title Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: aiBubble,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user, size: 16, color: primary),
                      SizedBox(width: 6),
                      Text(
                        'Private by design. Useful offline.',
                        style: TextStyle(
                          color: onTertiaryContainer,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Solace AI',
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A space to come back to yourself.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: inverseSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your private AI journal that understands you, remembers what matters, and helps you think clearly—even without an internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bodyForest,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Features List
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    const _FeatureCard(
                      icon: Icons.wifi_off,
                      title: '100% Offline Capable',
                      description: 'Journal and reflect anywhere, from airplanes to off-grid retreats.',
                      bgColor: surfaceContainerLowest,
                      iconBgColor: surfaceContainerLow,
                      iconColor: primary,
                      titleColor: inverseSurface,
                      descColor: bodyForest,
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.enhanced_encryption,
                      title: 'Zero Cloud Leakage',
                      description: 'Stored in encrypted SQLite locally on your physical device.',
                      bgColor: surfaceContainerLowest,
                      iconBgColor: surfaceContainerLow,
                      iconColor: primary,
                      titleColor: inverseSurface,
                      descColor: bodyForest,
                    ),
                    const SizedBox(height: 12),
                    const _FeatureCard(
                      icon: Icons.draw,
                      title: 'Capture First, Assist Third',
                      description: 'Write freely; Solace only assists thoughtfully when invited.',
                      bgColor: surfaceContainerLowest,
                      iconBgColor: surfaceContainerLow,
                      iconColor: primary,
                      titleColor: inverseSurface,
                      descColor: bodyForest,
                    ),
                  ],
                ),

              // Bottom Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingStep1Screen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryContainer,
                    foregroundColor: onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings_backup_restore, size: 18),
                label: const Text('Restore Encrypted Backup'),
                style: TextButton.styleFrom(
                  foregroundColor: onSurfaceVariant,
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color bgColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color titleColor;
  final Color descColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.titleColor,
    required this.descColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: descColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
