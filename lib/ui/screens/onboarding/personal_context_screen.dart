import 'package:flutter/material.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';

/// 04 — Personal Context (Onboarding Step 3 of 4)
class PersonalContextScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const PersonalContextScreen({
    super.key,
    this.onContinue,
    this.onBack,
    this.onSkip,
  });

  @override
  State<PersonalContextScreen> createState() => _PersonalContextScreenState();
}

class _PersonalContextScreenState extends State<PersonalContextScreen> {
  final _service = OnboardingService.instance;
  late final TextEditingController _workingTowardController;
  late final TextEditingController _boundariesController;

  static const List<_LifeAreaChip> _lifeAreas = [
    _LifeAreaChip(label: 'Career & Craft', icon: Icons.work_outline_rounded),
    _LifeAreaChip(label: 'Personal Growth', icon: Icons.spa_outlined),
    _LifeAreaChip(label: 'Creative Autonomy', icon: Icons.palette_outlined),
    _LifeAreaChip(label: 'Relationships', icon: Icons.favorite_border_rounded),
    _LifeAreaChip(label: 'Health & Energy', icon: Icons.bolt_rounded),
    _LifeAreaChip(label: 'Family', icon: Icons.home_outlined),
    _LifeAreaChip(label: 'Studies', icon: Icons.menu_book_rounded),
  ];

  static const List<String> _quickBoundaries = [
    'No prescriptive advice',
    'Keep responses brief',
    'Prioritize open questions',
  ];

  @override
  void initState() {
    super.initState();
    _workingTowardController =
        TextEditingController(text: _service.workingToward);
    _boundariesController =
        TextEditingController(text: _service.explicitBoundaries);
  }

  @override
  void dispose() {
    _workingTowardController.dispose();
    _boundariesController.dispose();
    super.dispose();
  }

  void _onSaveAndContinue() {
    _service.setWorkingToward(_workingTowardController.text.trim());
    _service.setExplicitBoundaries(_boundariesController.text.trim());
    widget.onContinue?.call();
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
                // Top Navigation Header
                _buildHeader(context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Context Info Banner
                        _buildTopInfoBanner(),
                        const SizedBox(height: 14),

                        // Section 1: Life Areas
                        _buildLifeAreasSection(),
                        const SizedBox(height: 14),

                        // Section 2: What are you currently working toward?
                        _buildWorkingTowardSection(),
                        const SizedBox(height: 14),

                        // Section 3: Explicit Boundaries
                        _buildBoundariesSection(),
                        const SizedBox(height: 14),

                        // Edge Vault Security Card
                        _buildVaultSecurityCard(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom Buttons
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
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: SolaceTheme.textHeading),
            splashRadius: 22,
          ),
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
                  'Step 3 of 4',
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
          TextButton(
            onPressed: widget.onSkip ?? _onSaveAndContinue,
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

  Widget _buildTopInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4EBDD),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFD3EEDB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              size: 22,
              color: Color(0xFF1B7A52),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help Solace understand your context',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Optional. Gives Solace background to provide grounded, deeply relevant reflections.',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12,
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

  Widget _buildLifeAreasSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.spa_rounded, size: 16, color: SolaceTheme.primary),
                  SizedBox(width: 6),
                  Text(
                    'Life areas that matter\nmost right now',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: SolaceTheme.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Select\nmultiple',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.primaryDark,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose spaces where you want intentional mental quiet or exploration.',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 12,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _lifeAreas.map((area) {
              final isSelected = _service.selectedLifeAreas.contains(area.label);
              return InkWell(
                onTap: () {
                  setState(() {
                    _service.toggleLifeArea(area.label);
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? SolaceTheme.primary
                        : const Color(0xFFEDF5F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? SolaceTheme.primary
                          : const Color(0xFFD6E8DC),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        area.icon,
                        size: 14,
                        color: isSelected ? Colors.white : SolaceTheme.textHeading,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        area.label,
                        style: TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : SolaceTheme.textHeading,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingTowardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.explore_outlined, size: 16, color: SolaceTheme.primary),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'What are you currently working toward?',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'A goal, transition, or subtle state of mind you are nurturing.',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 12,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6EE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0E9D9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _workingTowardController,
                  maxLines: 3,
                  maxLength: 240,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13,
                    color: SolaceTheme.textHeading,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Describe your current focus or goal...',
                    hintStyle: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 13,
                      color: SolaceTheme.textMuted,
                    ),
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                Text(
                  '${_workingTowardController.text.length} / 240 chars',
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
    );
  }

  Widget _buildBoundariesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: SolaceTheme.primary),
                  SizedBox(width: 6),
                  Text(
                    'Any explicit boundaries for\nSol?',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Text(
                'Your\nRules',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Guidelines for how Sol speaks, holds space, or steps back.',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 12,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6EE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0E9D9)),
            ),
            child: TextField(
              controller: _boundariesController,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13,
                color: SolaceTheme.textHeading,
                height: 1.4,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'e.g., Don\'t offer advice unless I specifically request it.',
                hintStyle: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13,
                  color: SolaceTheme.textMuted,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _quickBoundaries.map((rule) {
              return ActionChip(
                label: Text(
                  '+ $rule',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
                backgroundColor: const Color(0xFFEDF5F0),
                side: const BorderSide(color: Color(0xFFD6E8DC), width: 0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                  setState(() {
                    if (_boundariesController.text.trim().isEmpty) {
                      _boundariesController.text = rule;
                    } else if (!_boundariesController.text.contains(rule)) {
                      _boundariesController.text =
                          '${_boundariesController.text.trim()}. $rule';
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultSecurityCard() {
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
      child: const Row(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 22,
            color: Color(0xFF1B7A52),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edge Vault Security',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'This context is stored strictly in your local device vault and never leaves your phone.',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    color: SolaceTheme.textBody,
                    height: 1.3,
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
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
              onPressed: _onSaveAndContinue,
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
          const SizedBox(height: 4),
          TextButton(
            onPressed: widget.onSkip ?? _onSaveAndContinue,
            child: const Text(
              'Skip this step',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SolaceTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeAreaChip {
  final String label;
  final IconData icon;
  const _LifeAreaChip({required this.label, required this.icon});
}
