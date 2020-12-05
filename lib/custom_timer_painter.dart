import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter(
      {this.animation,
      this.fillColor,
      this.color,
      this.strokeWidth,
      this.strokeCap,
      this.backgroundColor})
      : super(repaint: animation);

  final Animation<double> animation;
  final Color fillColor, color, backgroundColor;
  final double strokeWidth;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth ?? 5.0
      ..strokeCap = strokeCap ?? StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    double progress = (animation.value) * 2 * math.pi;
    paint.color = fillColor;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);

    if (backgroundColor != null) {
      final backgroundPaint = Paint();
      backgroundPaint.color = backgroundColor;
      canvas.drawCircle(
          size.center(Offset.zero), size.width / 2.2, backgroundPaint);
    }
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        fillColor != old.fillColor;
  }
}
