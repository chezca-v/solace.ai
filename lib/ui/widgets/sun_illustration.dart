import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The official animated mascot logo for Solace AI ("Sol").
///
/// Features:
/// - Smooth floating & tilting motion (solFloat)
/// - Pulsing ambient aura halo with golden-emerald glow (solAuraBreathe)
/// - Rotating radiant sun rays (solRaysRotate & solRayPulse)
/// - Animated kawaii face with expressive blinking eyes and glowing cheeks
/// - Waving emerald sprout leaf with sparkle highlight (solSproutWave)
class SunIllustration extends StatefulWidget {
  final double size;
  final bool animate;
  final bool showBadge;

  const SunIllustration({
    super.key,
    this.size = 140,
    this.animate = true,
    this.showBadge = false,
  });

  @override
  State<SunIllustration> createState() => _SunIllustrationState();
}

class _SunIllustrationState extends State<SunIllustration>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _raysController;
  late AnimationController _pulseController;
  late AnimationController _sproutController;
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();

    // 1. Floating vertical bob & tilt (4s cycle)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // 2. Continuous 360-deg rays rotation (28s cycle)
    _raysController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 28000),
    );

    // 3. Aura & ray pulse breathing (3s cycle)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // 4. Sprout leaf wave oscillation (2.5s cycle)
    _sproutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // 5. Natural eye blink (4.5s cycle)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    if (widget.animate) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _floatController.repeat();
    _raysController.repeat();
    _pulseController.repeat(reverse: true);
    _sproutController.repeat(reverse: true);
    _blinkController.repeat();
  }

  void _stopAnimations() {
    _floatController.stop();
    _raysController.stop();
    _pulseController.stop();
    _sproutController.stop();
    _blinkController.stop();
  }

  @override
  void didUpdateWidget(covariant SunIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _raysController.dispose();
    _pulseController.dispose();
    _sproutController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              _floatController,
              _raysController,
              _pulseController,
              _sproutController,
              _blinkController,
            ]),
            builder: (context, _) {
              // Float translation & tilt calculation
              // 0% -> 0, 25% -> -4px & +1.5deg, 50% -> -8px & 0deg, 75% -> -3px & -1.5deg
              final fv = _floatController.value;
              double floatY = 0.0;
              double floatRot = 0.0;
              if (fv <= 0.25) {
                final t = fv / 0.25;
                floatY = -4.0 * t;
                floatRot = (1.5 * math.pi / 180.0) * t;
              } else if (fv <= 0.50) {
                final t = (fv - 0.25) / 0.25;
                floatY = -4.0 - (4.0 * t);
                floatRot = (1.5 * math.pi / 180.0) * (1.0 - t);
              } else if (fv <= 0.75) {
                final t = (fv - 0.50) / 0.25;
                floatY = -8.0 + (5.0 * t);
                floatRot = -(1.5 * math.pi / 180.0) * t;
              } else {
                final t = (fv - 0.75) / 0.25;
                floatY = -3.0 + (3.0 * t);
                floatRot = -(1.5 * math.pi / 180.0) * (1.0 - t);
              }

              // Aura & pulse calculations
              final pv = _pulseController.value;
              final auraScale = 0.92 + (0.23 * pv); // 0.92 -> 1.15
              final auraOpacity = 0.55 + (0.40 * pv); // 0.55 -> 0.95
              final rayStrokeWidth = 4.0 + (1.5 * pv); // 4.0 -> 5.5
              final rayOpacity = 0.70 + (0.30 * pv); // 0.70 -> 1.0
              final cheekScale = 1.0 + (0.18 * pv); // 1.0 -> 1.18
              final cheekOpacity = 0.80 + (0.18 * pv); // 0.80 -> 0.98

              // Rays rotation
              final raysAngle = _raysController.value * 2.0 * math.pi;

              // Sprout wave rotation (0 -> 18 degrees)
              final sproutAngle =
                  _sproutController.value * (18.0 * math.pi / 180.0);

              // Eye blink (quick blink at 94% - 98% of 4.5s cycle)
              final bv = _blinkController.value;
              double blinkScaleY = 1.0;
              if (bv >= 0.94 && bv < 0.96) {
                final t = (bv - 0.94) / 0.02;
                blinkScaleY = 1.0 - (0.9 * t); // 1.0 -> 0.1
              } else if (bv >= 0.96 && bv <= 0.98) {
                final t = (bv - 0.96) / 0.02;
                blinkScaleY = 0.1 + (0.9 * t); // 0.1 -> 1.0
              }

              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _SolAnimatedPainter(
                  floatY: widget.animate ? floatY : 0.0,
                  floatRotation: widget.animate ? floatRot : 0.0,
                  raysAngle: widget.animate ? raysAngle : 0.0,
                  auraScale: widget.animate ? auraScale : 1.0,
                  auraOpacity: widget.animate ? auraOpacity : 0.75,
                  rayStrokeWidth: widget.animate ? rayStrokeWidth : 4.0,
                  rayOpacity: widget.animate ? rayOpacity : 0.85,
                  sproutAngle: widget.animate ? sproutAngle : 0.0,
                  blinkScaleY: widget.animate ? blinkScaleY : 1.0,
                  cheekScale: widget.animate ? cheekScale : 1.0,
                  cheekOpacity: widget.animate ? cheekOpacity : 0.85,
                ),
              );
            },
          ),

          // Optional Sparkle circular badge
          if (widget.showBadge)
            Positioned(
              right: widget.size * 0.08,
              bottom: widget.size * 0.06,
              child: Container(
                width: widget.size * 0.28,
                height: widget.size * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF166E49).withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: widget.size * 0.16,
                    color: const Color(0xFF166E49),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Convenience alias for Sol's animated mascot logo
typedef SolAnimatedLogo = SunIllustration;

/// Custom painter translating the exact Sol SVG geometry and gradients to canvas
class _SolAnimatedPainter extends CustomPainter {
  final double floatY;
  final double floatRotation;
  final double raysAngle;
  final double auraScale;
  final double auraOpacity;
  final double rayStrokeWidth;
  final double rayOpacity;
  final double sproutAngle;
  final double blinkScaleY;
  final double cheekScale;
  final double cheekOpacity;

  _SolAnimatedPainter({
    required this.floatY,
    required this.floatRotation,
    required this.raysAngle,
    required this.auraScale,
    required this.auraOpacity,
    required this.rayStrokeWidth,
    required this.rayOpacity,
    required this.sproutAngle,
    required this.blinkScaleY,
    required this.cheekScale,
    required this.cheekOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Normalizing SVG viewBox 140x140 to target widget dimensions
    final scale = size.width / 140.0;
    canvas.save();
    canvas.scale(scale, scale);

    // 1. Floating Group Transform (Origin: 70, 70)
    canvas.save();
    canvas.translate(70, 70);
    canvas.translate(0, floatY);
    canvas.rotate(floatRotation);
    canvas.translate(-70, -70);

    // 2. Ambient Pulsing Aura Glow (solGlowHalo)
    final haloCenter = const Offset(70, 70);
    final haloRadius = 56.0 * auraScale;

    final haloShader = RadialGradient(
      colors: [
        const Color(0xFFFFEAA7).withOpacity((0.85 * auraOpacity).clamp(0.0, 1.0)),
        const Color(0xFFFFD166).withOpacity((0.35 * auraOpacity).clamp(0.0, 1.0)),
        const Color(0xFF4CAF82).withOpacity(0.0),
      ],
      stops: const [0.0, 0.60, 1.0],
    ).createShader(Rect.fromCircle(center: haloCenter, radius: haloRadius));

    final haloPaint = Paint()
      ..shader = haloShader
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7.0);

    canvas.drawCircle(haloCenter, haloRadius, haloPaint);

    // 3. Slowly Rotating Sun Rays (8 rays, stroke width 4 -> 5.5, color #FFD166)
    canvas.save();
    canvas.translate(70, 70);
    canvas.rotate(raysAngle);
    canvas.translate(-70, -70);

    final rayPaint = Paint()
      ..color = const Color(0xFFFFD166).withOpacity(rayOpacity.clamp(0.0, 1.0))
      ..strokeWidth = rayStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 8 Cardinal and Diagonal Ray lines
    canvas.drawLine(const Offset(70, 14), const Offset(70, 4), rayPaint);
    canvas.drawLine(const Offset(70, 126), const Offset(70, 136), rayPaint);
    canvas.drawLine(const Offset(14, 70), const Offset(4, 70), rayPaint);
    canvas.drawLine(const Offset(126, 70), const Offset(136, 70), rayPaint);
    canvas.drawLine(const Offset(30, 30), const Offset(23, 23), rayPaint);
    canvas.drawLine(const Offset(110, 110), const Offset(117, 117), rayPaint);
    canvas.drawLine(const Offset(30, 110), const Offset(23, 117), rayPaint);
    canvas.drawLine(const Offset(110, 30), const Offset(117, 23), rayPaint);

    canvas.restore(); // restore rays rotation

    // 4. Glowing Sun Sphere Body with Drop Shadow
    // Drop shadow: 0 6px 16px rgba(255, 178, 36, 0.45)
    final shadowPaint = Paint()
      ..color = const Color(0xFFFFB224).withOpacity(0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawCircle(const Offset(70, 76), 44, shadowPaint);

    // Body radial gradient: #FFF8B8 -> #FFD166 -> #FF9E00
    final bodyShader = const RadialGradient(
      center: Alignment(0.0, 0.0),
      radius: 0.9,
      colors: [
        Color(0xFFFFF8B8),
        Color(0xFFFFD166),
        Color(0xFFFF9E00),
      ],
      stops: [0.0, 0.65, 1.0],
    ).createShader(Rect.fromCircle(center: const Offset(70, 70), radius: 44));

    final bodyPaint = Paint()
      ..shader = bodyShader
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(70, 70), 44, bodyPaint);

    // Body border stroke: #FFF3B0, width 2
    final bodyBorder = Paint()
      ..color = const Color(0xFFFFF3B0)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(70, 70), 44, bodyBorder);

    // 5. Cute Facial Features

    // Eyes: Cheerful Curved Arched Eyes (with blink animation)
    // Left eye: M 52 64 Q 58 56 64 64
    // Right eye: M 76 64 Q 82 56 88 64
    canvas.save();
    canvas.translate(70, 62);
    canvas.scale(1.0, blinkScaleY);
    canvas.translate(-70, -62);

    final eyePaint = Paint()
      ..color = const Color(0xFF2D3142)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final leftEye = Path()
      ..moveTo(52, 64)
      ..quadraticBezierTo(58, 56, 64, 64);
    canvas.drawPath(leftEye, eyePaint);

    final rightEye = Path()
      ..moveTo(76, 64)
      ..quadraticBezierTo(82, 56, 88, 64);
    canvas.drawPath(rightEye, eyePaint);

    canvas.restore(); // restore eye blink

    // Rosy Cheeks: #FF8FAB, r=7 at (50, 73) and (90, 73)
    final cheekPaint = Paint()
      ..color =
          const Color(0xFFFF8FAB).withOpacity(cheekOpacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    // Left cheek
    canvas.save();
    canvas.translate(50, 73);
    canvas.scale(cheekScale, cheekScale);
    canvas.drawCircle(Offset.zero, 7, cheekPaint);
    canvas.restore();

    // Right cheek
    canvas.save();
    canvas.translate(90, 73);
    canvas.scale(cheekScale, cheekScale);
    canvas.drawCircle(Offset.zero, 7, cheekPaint);
    canvas.restore();

    // Warm Joyful Smile: M 62 73 Q 70 84 78 73 Z
    final smilePath = Path()
      ..moveTo(62, 73)
      ..quadraticBezierTo(70, 84, 78, 73)
      ..close();
    final smilePaint = Paint()
      ..color = const Color(0xFF2D3142)
      ..style = PaintingStyle.fill;
    canvas.drawPath(smilePath, smilePaint);

    // Pink Tongue: M 65 75 Q 70 82 75 75 Z
    final tonguePath = Path()
      ..moveTo(65, 75)
      ..quadraticBezierTo(70, 82, 75, 75)
      ..close();
    final tonguePaint = Paint()
      ..color = const Color(0xFFFF6B8B)
      ..style = PaintingStyle.fill;
    canvas.drawPath(tonguePath, tonguePaint);

    // 6. Dynamic Waving Leaf Sprout on Sol's Ear (Origin: 104, 54)
    canvas.save();
    canvas.translate(104, 54);
    canvas.rotate(sproutAngle);
    canvas.translate(-104, -54);

    // Leaf: M 103 52 C 110 46 117 52 113 60 C 109 64 102 60 103 52 Z
    final leafPath = Path()
      ..moveTo(103, 52)
      ..cubicTo(110, 46, 117, 52, 113, 60)
      ..cubicTo(109, 64, 102, 60, 103, 52)
      ..close();

    final leafFill = Paint()
      ..color = const Color(0xFF4CAF82)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafPath, leafFill);

    final leafBorder = Paint()
      ..color = const Color(0xFF2D3142)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(leafPath, leafBorder);

    // Leaf white glint sparkle: cx 111, cy 54, r 1.8
    final glintPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(111, 54), 1.8, glintPaint);

    canvas.restore(); // restore sprout rotation

    // Restore floating group & scale
    canvas.restore(); // restore float
    canvas.restore(); // restore canvas scale
  }

  @override
  bool shouldRepaint(covariant _SolAnimatedPainter oldDelegate) {
    return floatY != oldDelegate.floatY ||
        floatRotation != oldDelegate.floatRotation ||
        raysAngle != oldDelegate.raysAngle ||
        auraScale != oldDelegate.auraScale ||
        auraOpacity != oldDelegate.auraOpacity ||
        rayStrokeWidth != oldDelegate.rayStrokeWidth ||
        rayOpacity != oldDelegate.rayOpacity ||
        sproutAngle != oldDelegate.sproutAngle ||
        blinkScaleY != oldDelegate.blinkScaleY ||
        cheekScale != oldDelegate.cheekScale ||
        cheekOpacity != oldDelegate.cheekOpacity;
  }
}
