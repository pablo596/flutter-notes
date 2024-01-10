import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// The arrows usually looks better with rounded caps.
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;

    /// Adjusted
    {
      Path path = Path();
      path.moveTo(size.width * 0.59, size.height * .475);
      path.relativeCubicTo(200, -150, size.width * 0.25, 200, size.width * 0.3,
          size.height * .475);
      path = ArrowPath.addTip(path, isAdjusted: true);
      canvas.drawPath(path, paint..color = Colors.black);

      const TextSpan textSpan = TextSpan(
        text: 'No hay notas aún, \ncree alguna en el botón.',
        style: TextStyle(color: Colors.black, fontSize: 20),
      );
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width * .25, size.height * .5));
    }
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => false;
}
