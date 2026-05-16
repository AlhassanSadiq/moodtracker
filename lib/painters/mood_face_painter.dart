import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/mood_entry.dart';

class MoodFacePainter extends CustomPainter {
  final MoodType mood;
  final Color faceColor;
  final Color featureColor;
  final double animationValue;

  MoodFacePainter({
    required this.mood,
    required this.faceColor,
    this.featureColor = Colors.white,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;

    _drawFaceBackground(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawEyebrows(canvas, center, radius);
    _drawMouth(canvas, center, radius);
    if (mood == MoodType.happy || mood == MoodType.excited) {
      _drawCheeks(canvas, center, radius);
    }
  }

  void _drawFaceBackground(Canvas canvas, Offset center, double radius) {
    // Outer glow
    final glowPaint = Paint()
      ..color = faceColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, radius + 4, glowPaint);

    // Face fill
    final facePaint = Paint()..color = faceColor;
    canvas.drawCircle(center, radius, facePaint);

    // Face border
    final borderPaint = Paint()
      ..color = faceColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()..color = featureColor;
    final eyeRadius = radius * 0.085;
    final eyeY = center.dy - radius * 0.18;
    final eyeOffsetX = radius * 0.30;

    switch (mood) {
      case MoodType.happy:
      case MoodType.excited:
        // Happy/Excited eyes: curved arcs (closed, smiling)
        _drawHappyEye(
            canvas, Offset(center.dx - eyeOffsetX, eyeY), eyeRadius, featureColor);
        _drawHappyEye(
            canvas, Offset(center.dx + eyeOffsetX, eyeY), eyeRadius, featureColor);
        break;
      case MoodType.neutral:
        // Neutral eyes: plain circles
        canvas.drawCircle(
            Offset(center.dx - eyeOffsetX, eyeY), eyeRadius, eyePaint);
        canvas.drawCircle(
            Offset(center.dx + eyeOffsetX, eyeY), eyeRadius, eyePaint);
        // Pupils
        final pupilPaint = Paint()..color = faceColor.withValues(alpha: 0.8);
        canvas.drawCircle(
            Offset(center.dx - eyeOffsetX, eyeY), eyeRadius * 0.45, pupilPaint);
        canvas.drawCircle(
            Offset(center.dx + eyeOffsetX, eyeY), eyeRadius * 0.45, pupilPaint);
        break;
      case MoodType.sad:
        // Sad eyes: drooping, slightly downturned at outer corners
        _drawSadEye(
            canvas, Offset(center.dx - eyeOffsetX, eyeY + radius * 0.04),
            eyeRadius, featureColor, faceColor);
        _drawSadEye(
            canvas, Offset(center.dx + eyeOffsetX, eyeY + radius * 0.04),
            eyeRadius, featureColor, faceColor);
        break;
    }
  }

  void _drawHappyEye(
      Canvas canvas, Offset center, double eyeRadius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = eyeRadius * 0.55
      ..strokeCap = StrokeCap.round;

    // Arc drawn as smile shape (upside-down arc = closed happy eye)
    final rect = Rect.fromCenter(
        center: center, width: eyeRadius * 2.2, height: eyeRadius * 1.8);
    canvas.drawArc(rect, math.pi, math.pi, false, paint);
  }

  void _drawSadEye(Canvas canvas, Offset center, double eyeRadius, Color color,
      Color faceColor) {
    // Sad eyes are wider and have a slightly downward inner corner look
    final fillPaint = Paint()..color = color;
    canvas.drawOval(
        Rect.fromCenter(
            center: center,
            width: eyeRadius * 2.0,
            height: eyeRadius * 1.6),
        fillPaint);
    // Pupil
    final pupilPaint = Paint()..color = faceColor.withValues(alpha: 0.75);
    canvas.drawCircle(
        Offset(center.dx, center.dy + eyeRadius * 0.1), eyeRadius * 0.5, pupilPaint);
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius) {
    final browPaint = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.07
      ..strokeCap = StrokeCap.round;

    final browY = center.dy - radius * 0.40;
    final browOffsetX = radius * 0.30;
    final browHalfWidth = radius * 0.22;

    switch (mood) {
      case MoodType.happy:
        // Raised, arched brows (positive expression)
        _drawArch(canvas, Offset(center.dx - browOffsetX, browY),
            browHalfWidth, radius * 0.07, browPaint, false);
        _drawArch(canvas, Offset(center.dx + browOffsetX, browY),
            browHalfWidth, radius * 0.07, browPaint, false);
        break;
      case MoodType.excited:
        // Even higher arched brows
        _drawArch(canvas, Offset(center.dx - browOffsetX, browY - radius * 0.05),
            browHalfWidth, radius * 0.1, browPaint, false);
        _drawArch(canvas, Offset(center.dx + browOffsetX, browY - radius * 0.05),
            browHalfWidth, radius * 0.1, browPaint, false);
        break;
      case MoodType.neutral:
        // Flat, horizontal brows
        canvas.drawLine(
            Offset(center.dx - browOffsetX - browHalfWidth,
                browY + radius * 0.02),
            Offset(center.dx - browOffsetX + browHalfWidth,
                browY + radius * 0.02),
            browPaint);
        canvas.drawLine(
            Offset(center.dx + browOffsetX - browHalfWidth,
                browY + radius * 0.02),
            Offset(center.dx + browOffsetX + browHalfWidth,
                browY + radius * 0.02),
            browPaint);
        break;
      case MoodType.sad:
        // Inner corners raised → furrowed, worried brows
        _drawSadBrow(canvas,
            Offset(center.dx - browOffsetX, browY + radius * 0.05),
            browHalfWidth, radius * 0.09, browPaint, true);
        _drawSadBrow(canvas,
            Offset(center.dx + browOffsetX, browY + radius * 0.05),
            browHalfWidth, radius * 0.09, browPaint, false);
        break;
    }
  }

  void _drawArch(Canvas canvas, Offset center, double halfWidth, double archHeight,
      Paint paint, bool invertArch) {
    final path = Path();
    path.moveTo(center.dx - halfWidth, center.dy);
    path.quadraticBezierTo(
        center.dx,
        invertArch ? center.dy + archHeight : center.dy - archHeight,
        center.dx + halfWidth,
        center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawSadBrow(Canvas canvas, Offset center, double halfWidth,
      double archHeight, Paint paint, bool isLeft) {
    final path = Path();
    if (isLeft) {
      // Left brow: inner end (right side) is higher
      path.moveTo(center.dx - halfWidth, center.dy + archHeight * 0.5);
      path.quadraticBezierTo(
          center.dx, center.dy - archHeight * 0.3, center.dx + halfWidth, center.dy - archHeight);
    } else {
      // Right brow: inner end (left side) is higher
      path.moveTo(center.dx - halfWidth, center.dy - archHeight);
      path.quadraticBezierTo(
          center.dx, center.dy - archHeight * 0.3, center.dx + halfWidth, center.dy + archHeight * 0.5);
    }
    canvas.drawPath(path, paint);
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.09
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.30;
    final mouthHalfWidth = radius * 0.30;

    switch (mood) {
      case MoodType.happy:
        // Big smile arc curving upward
        final rect = Rect.fromCenter(
            center: Offset(center.dx, mouthY - radius * 0.05),
            width: mouthHalfWidth * 2.2,
            height: radius * 0.55);
        canvas.drawArc(rect, 0, math.pi, false, mouthPaint);
        break;
      case MoodType.excited:
        // Wide open mouth (D-shape)
        final openMouthPaint = Paint()..color = featureColor;
        final rect = Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: mouthHalfWidth * 2.4,
            height: radius * 0.5);
        canvas.drawArc(rect, 0, math.pi, true, openMouthPaint);
        // Add a small tongue? No, keep it simple with a circle segment
        break;
      case MoodType.neutral:
        // Straight horizontal line
        canvas.drawLine(
            Offset(center.dx - mouthHalfWidth, mouthY),
            Offset(center.dx + mouthHalfWidth, mouthY),
            mouthPaint);
        break;
      case MoodType.sad:
        // Downward frown arc
        final rect = Rect.fromCenter(
            center: Offset(center.dx, mouthY + radius * 0.22),
            width: mouthHalfWidth * 2.0,
            height: radius * 0.45);
        canvas.drawArc(rect, math.pi, math.pi, false, mouthPaint);
        break;
    }
  }

  void _drawCheeks(Canvas canvas, Offset center, double radius) {
    final cheekPaint = Paint()
      ..color = Colors.pink.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    final cheekY = center.dy + radius * 0.07;
    final cheekOffsetX = radius * 0.50;
    final cheekRadius = radius * 0.22;

    canvas.drawCircle(Offset(center.dx - cheekOffsetX, cheekY), cheekRadius, cheekPaint);
    canvas.drawCircle(Offset(center.dx + cheekOffsetX, cheekY), cheekRadius, cheekPaint);
  }

  @override
  bool shouldRepaint(MoodFacePainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.animationValue != animationValue ||
      oldDelegate.faceColor != faceColor;
}
