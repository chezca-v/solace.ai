import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedSolAvatar extends StatefulWidget {
  final double size;
  const AnimatedSolAvatar({super.key, this.size = 120});

  @override
  State<AnimatedSolAvatar> createState() => _AnimatedSolAvatarState();
}

class _AnimatedSolAvatarState extends State<AnimatedSolAvatar> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _raysController;
  late AnimationController _blinkController;
  
  late Animation<double> _floatAnimation;
  late Animation<double> _glowScaleAnimation;
  late Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Float animation (4.5s ease-in-out infinite)
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500))..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -7.0).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    
    // Glow animation (3.5s ease-in-out infinite)
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3500))..repeat(reverse: true);
    _glowScaleAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _glowOpacityAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    
    // Rays rotation (24s linear infinite)
    _raysController = AnimationController(vsync: this, duration: const Duration(seconds: 24))..repeat();
    
    // Blink animation (4s interval)
    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _startBlinking();
  }
  
  void _startBlinking() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 3850)); // Wait before blinking
      if (!mounted) break;
      await _blinkController.forward(); // Close eyes
      if (!mounted) break;
      await _blinkController.reverse(); // Open eyes
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _raysController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Transform.scale(
                scale: _glowScaleAnimation.value,
                child: Opacity(
                  opacity: _glowOpacityAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF93F6C4),
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Floating Character
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: SizedBox(
                  width: widget.size * 0.9,
                  height: widget.size * 0.9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Rays
                      AnimatedBuilder(
                        animation: _raysController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _raysController.value * 2 * pi,
                            child: SvgPicture.asset('assets/images/sol_rays.svg'),
                          );
                        },
                      ),
                      // Base Body
                      SvgPicture.asset('assets/images/sol_body_base.svg'),
                      // Blinking Eyes
                      AnimatedBuilder(
                        animation: _blinkController,
                        builder: (context, child) {
                          // Scale Y from 1.0 to 0.1 to simulate blinking
                          final scaleY = 1.0 - (_blinkController.value * 0.9);
                          return Transform(
                            transform: Matrix4.identity()..scale(1.0, scaleY, 1.0),
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/images/sol_eyes.svg'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Sparkle icon badge
          Positioned(
            bottom: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                 return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                 );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: Color(0xFF006C48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
