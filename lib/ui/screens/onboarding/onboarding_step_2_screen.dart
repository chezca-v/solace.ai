import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'onboarding_step_3_screen.dart';

class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Understand thoughts',
      'subtitle': 'Unpack complex emotions and daily headspace.',
      'icon': Icons.psychology_alt,
    },
    {
      'title': 'Manage stress',
      'subtitle': 'Gentle grounded reflection when feeling overloaded.',
      'icon': Icons.air,
    },
    {
      'title': 'Make difficult decisions',
      'subtitle': 'Compare trade-offs against my genuine priorities.',
      'icon': Icons.balance,
    },
    {
      'title': 'Track habits',
      'subtitle': 'Recognize evolving patterns and rituals over time.',
      'icon': Icons.autorenew,
    },
    {
      'title': 'Remember experiences',
      'subtitle': 'Preserve meaningful milestones and life lessons.',
      'icon': Icons.bookmark_border,
    },
  ];

  final Set<int> _selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      appBar: AppBar(
        backgroundColor: AppColors.canvasBackground.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.bodyForest),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Journaling Goals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.inverseSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(fontSize: 13, color: AppColors.secondary),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida/AEtjO1VTW28s9F5nAumb5HD_s_f6oKhP829n6u7izTeQXvnBc1xHEElSdKPl5yjjXLiYiGHXfxeMRALGF1imafC384vVcuTgtCaFnRJGkHSK34rT0f8Et6jFzBAkvO-EQT-GE2AAgSX4sSKV4nHXlxW9V8Z8mblgPgjU8LjavRZpQMjUJz1oUERs7kp_XBRyjfOX_gv9r1f6TlLvGoHLLPQK-4iG6-Mj2HoAixOVyMEfEIX5-80NjOwzXpAMHpA'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Progress Header
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.aiBubble,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.spa, color: AppColors.primary, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'STEP 2 OF 5',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.bodyForest,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Intentions',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Multi-segment Progress Bar
                    Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: Container(
                            height: 6,
                            margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                            decoration: BoxDecoration(
                              color: index < 2 ? AppColors.primaryContainer : AppColors.surfaceVariant.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ambient Companion Greeting Bubble
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC6EBD5), // tertiary-fixed
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.energy_savings_leaf, color: AppColors.primary, size: 20),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.solarAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.surfaceContainerLow, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Solace Guide',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.bodyForest,
                                    ),
                                  ),
                                  Text(
                                    'Tuning reflective prompts to your personal pace',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.secondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Title & Description
                      Text(
                        'What brings you here?',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Select what you'd like to explore. You can change these anytime in your encrypted sanctuary vault.",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Interactive Goal Cards Form
                      ...List.generate(_goals.length, (index) {
                        final goal = _goals[index];
                        final isSelected = _selectedIndices.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedIndices.remove(index);
                                } else {
                                  _selectedIndices.add(index);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.aiBubble : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: const Color(0xFF4CAF82).withOpacity(0.12),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    )
                                  else
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: isSelected ? AppColors.onPrimary : Colors.transparent,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                goal['title'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.inverseSurface,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              goal['icon'],
                                              size: 18,
                                              color: isSelected ? AppColors.primary : AppColors.secondary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          goal['subtitle'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected ? AppColors.bodyForest : AppColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      // Trust & Privacy Badge
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock, size: 15, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Encrypted & stored strictly on this device',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Action
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: ElevatedButton(
                  onPressed: _selectedIndices.isNotEmpty ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingStep3Screen(),
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    disabledBackgroundColor: AppColors.primaryContainer.withOpacity(0.5),
                    foregroundColor: AppColors.onPrimary,
                    disabledForegroundColor: AppColors.onPrimary.withOpacity(0.9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_selectedIndices.isNotEmpty ? 'Continue (${_selectedIndices.length} selected)' : 'Select at least 1 goal'),
                      if (_selectedIndices.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
