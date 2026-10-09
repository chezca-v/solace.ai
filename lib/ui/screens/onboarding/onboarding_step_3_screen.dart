import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/onboarding_service.dart';
import '../../widgets/onboarding_app_bar.dart';
import '../../widgets/onboarding_progress_header.dart';
import 'onboarding_step_4_screen.dart';

class OnboardingStep3Screen extends StatefulWidget {
  const OnboardingStep3Screen({super.key});

  @override
  State<OnboardingStep3Screen> createState() => _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends State<OnboardingStep3Screen> {
  final List<Map<String, dynamic>> _lifeAreas = [
    {'icon': Icons.work_outline, 'label': 'Work & Craft'},
    {'icon': Icons.psychology_outlined, 'label': 'Personal Growth'},
    {'icon': Icons.school_outlined, 'label': 'School & Studies'},
    {'icon': Icons.favorite_outline, 'label': 'Relationships'},
    {'icon': Icons.bolt_outlined, 'label': 'Health & Energy'},
    {'icon': Icons.palette_outlined, 'label': 'Creative Autonomy'},
  ];

  final Set<int> _selectedLifeAreas = {};
  
  final TextEditingController _focusController = TextEditingController(text: 'Navigating my new job role without sacrificing evening downtime and creative writing...');

  final List<Map<String, String>> _boundaries = [
    {'title': 'No unsolicited advice', 'activeLabel': 'Listening first'},
    {'title': 'Keep responses concise', 'activeLabel': 'Active'},
    {'title': 'Focus on open questions', 'activeLabel': 'Active'},
  ];

  final Set<int> _selectedBoundaries = {0}; // First one active by default in HTML

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      appBar: const OnboardingAppBar(title: 'Personal Context'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const OnboardingProgressHeader(step: 3, label: 'Context'),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Empathic Guidance
                      Row(
                        children: [
                          Text(
                            'Understand my context',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.local_florist, color: AppColors.primaryContainer, size: 24),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16, color: AppColors.bodyForest, height: 1.5),
                          children: [
                            TextSpan(
                              text: 'Optional: ',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(text: 'What matters most right now? Gives Sol helpful context to provide grounded, deeply relevant reflections.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 1: Life Areas (Multi-select Delightful Chips)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Active Life Areas',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                          ),
                          Text(
                            'Choose any',
                            style: TextStyle(fontSize: 13, color: AppColors.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(_lifeAreas.length, (index) {
                          final area = _lifeAreas[index];
                          final isSelected = _selectedLifeAreas.contains(index);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedLifeAreas.remove(index);
                                } else {
                                  _selectedLifeAreas.add(index);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: const Color(0xFF4CAF82).withOpacity(0.25),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    )
                                  else
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(area['icon'], size: 16, color: isSelected ? AppColors.onPrimary : AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    area['label'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? AppColors.onPrimary : AppColors.bodyForest,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.add,
                                    size: 16,
                                    color: isSelected ? AppColors.onPrimary : AppColors.bodyForest.withOpacity(isSelected ? 1.0 : 0.6),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 24),
                      // Section 2: Current Focus / Priorities Text Area
                      const Text(
                        'What are you currently working toward?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF82).withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Icon(Icons.edit_note, color: AppColors.primaryContainer, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _focusController,
                                    maxLength: 240,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: 'E.g., Navigating my new job role without sacrificing evening downtime...',
                                      hintStyle: TextStyle(color: AppColors.secondary),
                                      counterText: '', // Hide default counter
                                    ),
                                    style: const TextStyle(fontSize: 16, color: AppColors.bodyForest),
                                    onChanged: (val) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xFFCEE9DA), width: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.lock, size: 16, color: AppColors.secondary),
                                      SizedBox(width: 6),
                                      Text(
                                        'Confidential Context',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${_focusController.text.length} / 240 chars',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Section 3: Conversational Boundaries with Sol
                      Row(
                        children: const [
                          Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Any explicit boundaries for Sol?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: List.generate(_boundaries.length, (index) {
                          final boundary = _boundaries[index];
                          final isActive = _selectedBoundaries.contains(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isActive) {
                                    _selectedBoundaries.remove(index);
                                  } else {
                                    _selectedBoundaries.add(index);
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isActive ? AppColors.aiBubble : AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isActive ? Icons.check_box : Icons.check_box_outline_blank,
                                          size: 18,
                                          color: isActive ? AppColors.primaryContainer : AppColors.secondary,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          boundary['title']!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: isActive ? AppColors.inverseSurface : AppColors.bodyForest,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      isActive ? boundary['activeLabel']! : '+ Add',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 24),
                      // Edge Vault Security Privacy Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFFAEB), // surface-container-low
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.security, size: 18, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 13, color: AppColors.bodyForest, height: 1.4),
                                  children: [
                                    TextSpan(
                                      text: 'Edge Vault Security: ',
                                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.inverseSurface),
                                    ),
                                    TextSpan(text: 'Stored strictly in your local device vault. Never uploaded or trained on.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
                        final selectedAreaStrings = _selectedLifeAreas.map((i) => _lifeAreas[i]['label'] as String).toSet();
                        final selectedBoundaryStrings = _selectedBoundaries.map((i) => _boundaries[i]['title'] as String).join('. ');
                        
                        OnboardingService.instance.setLifeAreas(selectedAreaStrings);
                        OnboardingService.instance.setWorkingToward(_focusController.text);
                        OnboardingService.instance.setExplicitBoundaries(selectedBoundaryStrings);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingStep4Screen(),
                          ),
                        );
                      },
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
                            'Continue',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Skip this step'),
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
