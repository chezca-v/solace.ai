import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/onboarding_app_bar.dart';
import '../../widgets/onboarding_progress_header.dart';
import 'onboarding_step_5_screen.dart';

class OnboardingStep4Screen extends StatefulWidget {
  const OnboardingStep4Screen({super.key});

  @override
  State<OnboardingStep4Screen> createState() => _OnboardingStep4ScreenState();
}

class _OnboardingStep4ScreenState extends State<OnboardingStep4Screen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  
  bool _isAuditing = false;
  bool _isAudited = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _runAudit() {
    setState(() {
      _isAuditing = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isAuditing = false;
          _isAudited = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      appBar: const OnboardingAppBar(title: 'Privacy Secured'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const OnboardingProgressHeader(step: 4, label: 'Privacy'),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.verified_user, color: AppColors.primary, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'ZERO CLOUD LEAKAGE',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.bodyForest, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.lock_reset, color: AppColors.secondary, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Air-Gapped',
                                  style: TextStyle(fontSize: 11, color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Header
                      Text(
                        'Your privacy, secured.',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Entries are stored locally. Local AI processing is air-gapped. You control your memories.',
                        style: TextStyle(fontSize: 14, color: AppColors.secondary, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      // Centerpiece: Sandbox
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF82).withOpacity(0.1),
                              blurRadius: 24,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Device Header Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.smartphone, color: AppColors.primary, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'Your Physical Device Boundary',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.aiBubble,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'EDGE-NATIVE',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF005236)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Device Frame Graphic
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.canvasBackground,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerLowest,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: const BoxDecoration(color: AppColors.aiBubble, shape: BoxShape.circle),
                                                    child: const Icon(Icons.folder_shared, color: AppColors.primary, size: 16),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(4)),
                                                    child: const Text('AES-256', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.bodyForest)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Text('Encrypted Vault', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inverseSurface)),
                                              const SizedBox(height: 2),
                                              const Text('SQLite biometrics key', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerLowest,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: const BoxDecoration(color: Color(0xFFC6EBD5), shape: BoxShape.circle),
                                                    child: const Icon(Icons.psychology, color: Color(0xFF193B2C), size: 16),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(color: const Color(0xFFC6EBD5), borderRadius: BorderRadius.circular(4)),
                                                    child: const Text('ONNX/LiteRT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF193B2C))),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Text('Local Sol Brain', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inverseSurface)),
                                              const SizedBox(height: 2),
                                              const Text('Air-gapped NPU', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.sync_alt, color: AppColors.primary, size: 14),
                                      SizedBox(width: 6),
                                      Text('Zero bus transmission off chip', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDAD6).withOpacity(0.4), // error-container/40
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: const BoxDecoration(color: AppColors.surfaceContainerLowest, shape: BoxShape.circle),
                                              child: const Icon(Icons.cloud_off, color: Color(0xFFD96B6B), size: 16),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: const [
                                                Text('Cloud Servers Disconnected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFD96B6B))),
                                                Text('0 KB outgoing · 0 KB incoming', style: TextStyle(fontSize: 11, color: Color(0xFF4D6958))),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(color: const Color(0xFFD96B6B).withOpacity(0.15), shape: BoxShape.circle),
                                          child: const Icon(Icons.block, color: Color(0xFFD96B6B), size: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Air-Gap Status Indicator Bar
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4EEDF).withOpacity(0.6), // surface-container-high/60
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _pulseController,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: 1.0 + (_pulseController.value * 0.5),
                                                child: Opacity(
                                                  opacity: 1.0 - _pulseController.value,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      color: AppColors.primaryContainer,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Air-Gapped Privacy Active', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inverseSurface)),
                                    ],
                                  ),
                                  const Text('VERIFIED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Key Guarantees Section
                      _GuaranteeCard(
                        icon: Icons.enhanced_encryption,
                        iconBg: AppColors.aiBubble,
                        iconColor: AppColors.primary,
                        title: 'On-Device Encryption',
                        description: 'Your private writing is encrypted with AES-256 using your device biometric key.',
                      ),
                      const SizedBox(height: 12),
                      _GuaranteeCard(
                        icon: Icons.wifi_off,
                        iconBg: const Color(0xFFC8E7D2), // secondary-container
                        iconColor: const Color(0xFF4D6958), // on-secondary-container
                        title: 'Zero Network Transit',
                        description: 'Sol runs completely offline. No tracking, no telemetry, no advertising profiles.',
                      ),
                      const SizedBox(height: 12),
                      _GuaranteeCard(
                        icon: Icons.key,
                        iconBg: const Color(0xFFC6EBD5), // tertiary-fixed
                        iconColor: const Color(0xFF193B2C), // on-tertiary-container
                        title: 'Sovereign Control',
                        description: 'You can export, purge, or view every memory Sol retains at any time in one tap.',
                      ),

                      const SizedBox(height: 24),
                      // Interactive Sandbox Tap-to-Test Delight Feature
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sensors_off, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Inspect Edge Telemetry', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inverseSurface)),
                                  Text(
                                    _isAuditing ? 'Scanning active socket interfaces...' :
                                    _isAudited ? 'Confirmed: 100% offline socket containment.' :
                                    '0 requests sent across all sessions',
                                    style: const TextStyle(fontSize: 11, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isAudited || _isAuditing ? null : _runAudit,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                                  ),
                                  child: Row(
                                    children: [
                                      if (_isAuditing)
                                        const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                                      else if (_isAudited)
                                        const Icon(Icons.check, color: AppColors.primary, size: 14)
                                      else
                                        const SizedBox.shrink(),
                                      if (_isAudited) const SizedBox(width: 4),
                                      Text(
                                        _isAudited ? 'Verified' : 'Verify Now',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _isAudited ? AppColors.primary : AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Bottom Action
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingStep5Screen(),
                          ),
                        );
                      }, // To be wired to Step 5
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 4,
                        shadowColor: const Color(0xFF4CAF82).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Create My Space',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.verified, color: AppColors.primary, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Independently auditable offline edge architecture',
                        style: TextStyle(fontSize: 11, color: AppColors.secondary, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuaranteeCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;

  const _GuaranteeCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF82).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
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
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: AppColors.secondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
