import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int step;
  final String label;

  const OnboardingProgressHeader({
    super.key,
    required this.step,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      'STEP $step OF 5',
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: index < step
                        ? AppColors.primaryContainer
                        : AppColors.surfaceVariant.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
