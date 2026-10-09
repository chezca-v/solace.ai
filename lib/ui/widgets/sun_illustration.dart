import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom kawaii glowing Sun illustration with radiant rays and sparkle badge
/// matching the Solace Welcome Screen design.
class SunIllustration extends StatelessWidget {
  final double size;

  const SunIllustration({
    super.key,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sun Body + Rays + Ambient Glow + Kawaii Face
          CustomPaint(
            size: Size(size, size),
            painter: _SunPainter(),
          ),

          // Sparkle circular badge at bottom-right of sun
          Positioned(
            right: size * 0.12,
            bottom: size * 0.08,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF166E49).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: size * 0.15,
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

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final coreRadius = size.width * 0.26;

    // 1. Soft Ambient Green-Gold Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFB7F499).withValues(alpha: 0.45),
          const Color(0xFFFEF08A).withValues(alpha: 0.35),
          const Color(0xFFF7FAF7).withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
    canvas.drawCircle(center, size.width * 0.5, glowPaint);

    // 2. 12 Soft Radiant Sun Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFDE047)
      ..style = PaintingStyle.fill;

    final rayCount = 12;
    final rayLength = coreRadius * 0.32;
    final rayWidth = coreRadius * 0.16;
    final rayStartDist = coreRadius * 1.08;

    for (int i = 0; i < rayCount; i++) {
      final angle = i * (2 * math.pi / rayCount);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final rayRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -rayStartDist - rayLength / 2),
          width: rayWidth,
          height: rayLength,
        ),
        Radius.circular(rayWidth / 2),
      );
      canvas.drawRRect(rayRect, rayPaint);
      canvas.restore();
    }

    // 3. Central Sun Sphere with warm gradient
    final sunBodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.3),
        radius: 0.95,
        colors: const [
          Color(0xFFFEF3C7),
          Color(0xFFFDE047),
          Color(0xFFFBBF24),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));
    canvas.drawCircle(center, coreRadius, sunBodyPaint);

    // 4. Kawaii Face Features

    // Eyes
    final eyeRadius = coreRadius * 0.095;
    final leftEyeCenter = Offset(center.dx - coreRadius * 0.32, center.dy - coreRadius * 0.06);
    final rightEyeCenter = Offset(center.dx + coreRadius * 0.32, center.dy - coreRadius * 0.06);

    final eyePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);

    // Eye catchlights (sparkle dots in eyes)
    final catchlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(leftEyeCenter.dx - eyeRadius * 0.3, leftEyeCenter.dy - eyeRadius * 0.3),
      eyeRadius * 0.35,
      catchlightPaint,
    );
    canvas.drawCircle(
      Offset(rightEyeCenter.dx - eyeRadius * 0.3, rightEyeCenter.dy - eyeRadius * 0.3),
      eyeRadius * 0.35,
      catchlightPaint,
    );

    // Cute teal beauty dot above right eye
    final tealDotPaint = Paint()
      ..color = const Color(0xFF0D9488)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + coreRadius * 0.38, center.dy - coreRadius * 0.28),
      coreRadius * 0.05,
      tealDotPaint,
    );

    // Cute Blush Cheeks
    final blushPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF87171).withValues(alpha: 0.5),
          const Color(0xFFF87171).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx - coreRadius * 0.46, center.dy + coreRadius * 0.12),
        radius: coreRadius * 0.16,
      ));
    canvas.drawCircle(
      Offset(center.dx - coreRadius * 0.46, center.dy + coreRadius * 0.12),
      coreRadius * 0.16,
      blushPaint,
    );

    final rightBlushPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF87171).withValues(alpha: 0.5),
          const Color(0xFFF87171).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx + coreRadius * 0.46, center.dy + coreRadius * 0.12),
        radius: coreRadius * 0.16,
      ));
    canvas.drawCircle(
      Offset(center.dx + coreRadius * 0.46, center.dy + coreRadius * 0.12),
      coreRadius * 0.16,
      rightBlushPaint,
    );

    // Gentle Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = coreRadius * 0.07
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(center.dx - coreRadius * 0.16, center.dy + coreRadius * 0.08);
    smilePath.quadraticBezierTo(
      center.dx,
      center.dy + coreRadius * 0.24,
      center.dx + coreRadius * 0.16,
      center.dy + coreRadius * 0.08,
    );
    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
