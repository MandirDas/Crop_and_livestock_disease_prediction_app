import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final double confidence;

  PieChartPainter({required this.confidence});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3; // Smaller radius

    // Gradient for confidence
    final confidencePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.greenAccent, Colors.green],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Gradient for remaining
    final remainingPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.redAccent, Colors.red],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw arcs
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      2 * 3.14159 * confidence,
      true,
      confidencePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + 2 * 3.14159 * confidence,
      2 * 3.14159 * (1 - confidence),
      true,
      remainingPaint,
    );

    // Add a white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
