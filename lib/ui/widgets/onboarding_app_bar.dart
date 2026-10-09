import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const OnboardingAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.canvasBackground.withOpacity(0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.bodyForest),
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
      title: Text(
        title,
        style: const TextStyle(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
