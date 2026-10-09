import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/onboarding_service.dart';
import '../../widgets/onboarding_app_bar.dart';
import '../../widgets/onboarding_progress_header.dart';
import 'onboarding_step_2_screen.dart';

class OnboardingStep1Screen extends StatefulWidget {
  const OnboardingStep1Screen({super.key});

  @override
  State<OnboardingStep1Screen> createState() => _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends State<OnboardingStep1Screen> {
  final List<Map<String, String>> _goals = [
    {
      'title': 'Understand my thoughts and feelings',
      'subtitle': 'Unpack complex emotions and daily headspace.',
    },
    {
      'title': 'Make difficult decisions',
      'subtitle': 'Compare trade-offs against my genuine priorities.',
    },
    {
      'title': 'Manage stress & overwhelm',
      'subtitle': 'Gentle grounded reflection when feeling overloaded.',
    },
    {
      'title': 'Build habits & track personal growth',
      'subtitle': 'Recognize evolving patterns over time.',
    },
    {
      'title': 'Remember important experiences',
      'subtitle': 'Preserve meaningful milestones and lessons.',
    },
    {
      'title': 'Have a safe place to write freely',
      'subtitle': 'Pure private expression without unsolicited advice.',
    },
  ];

  final Set<int> _selectedIndices = {};
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OnboardingAppBar(
        title: 'Welcome to Solace',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const OnboardingProgressHeader(step: 1, label: 'Goals'),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        'What brings you to Solace?',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      const Text(
                        "Select what you'd like to explore. You can change these anytime in your vault.",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Ambient Companion Affirmation Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.aiBubble,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.spa, color: AppColors.primary, size: 24),
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grounded, Private & Edge-Secure',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.bodyForest,
                                    ),
                                  ),
                                  Text(
                                    'Your reflections stay entirely on-device',
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
                      
                      // Name Input
                      const Text(
                        'What should Solace call you?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your preferred name',
                          filled: true,
                          fillColor: AppColors.surfaceContainerLowest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 24),

                      // Multi-select Goal Cards List
                      const Text(
                        'What brings you here?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_goals.length, (index) {
                        final goal = _goals[index];
                        final isSelected = _selectedIndices.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
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
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected 
                                    ? Border.all(color: AppColors.primaryContainer, width: 2)
                                    : Border.all(color: Colors.transparent, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
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
                                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
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
                                        Text(
                                          goal['title']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? AppColors.primary : AppColors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          goal['subtitle']!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.secondary,
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Action Section
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: (_selectedIndices.isNotEmpty && _nameController.text.trim().isNotEmpty) ? () {
                         final selectedGoalStrings = _selectedIndices.map((i) => _goals[i]['title']!).toSet();
                         OnboardingService.instance.setGoals(selectedGoalStrings);
                         OnboardingService.instance.setUserName(_nameController.text.trim());
                         Navigator.of(context).push(
                           MaterialPageRoute(
                             builder: (context) => const OnboardingStep2Screen(),
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
                          const Text('Continue'),
                          if (_selectedIndices.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF77D9A9).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_selectedIndices.length} selected',
                                style: const TextStyle(fontSize: 13, color: AppColors.onPrimary),
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 14, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'End-to-end encrypted · Stored only on your device',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
