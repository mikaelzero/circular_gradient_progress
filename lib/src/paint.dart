import 'dart:math' show cos, min, pi, sin;

import 'package:flutter/material.dart';

extension NumToRadians on num {
  double toRadians() {
    return toDouble() * (pi / 180.0);
  }

  double toDegree() {
    return toDouble() * (180 / pi);
  }
}

class ProgressPainter extends CustomPainter {
  final double sweepAngle;
  final double strokeWidth;
  final List<List<Color>> progressColor;
  final Color backgroundColor;
  final bool reverse;

  ProgressPainter({
    this.sweepAngle = 360,
    this.strokeWidth = 20,
    this.reverse = false,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double wh = min(size.width, size.height);
    var centerX = wh / 2;
    var centerY = wh / 2;
    var radius = wh / 2 - strokeWidth / 2;

    double startAngle = 0;
    var rect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: wh - strokeWidth,
      height: wh - strokeWidth,
    );
    int colorRangeIndex = (sweepAngle / 360).ceil() - 1;
    if (colorRangeIndex > progressColor.length - 1) {
      colorRangeIndex = progressColor.length - 1;
    }
    if (colorRangeIndex < 0) {
      colorRangeIndex = 0;
    }

    var shader = SweepGradient(
      startAngle: startAngle.toRadians(),
      endAngle: 360.toRadians(),
      colors: reverse ? progressColor[colorRangeIndex].reversed.toList() : progressColor[colorRangeIndex],
    ).createShader(rect);

    var paint = Paint()
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    var backgroundPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    var startCapPosition = Offset(
      centerX + radius * cos(startAngle.toRadians()),
      centerY + radius * sin(startAngle.toRadians()),
    );

    canvas.drawArc(
      rect,
      0.toRadians(),
      360.toRadians(),
      false,
      backgroundPaint,
    );
    if (sweepAngle >= 0) {
      canvas.save();
      // Move the canvas origin to the center
      canvas.translate(centerX, centerY);
      double rotationAngle = 0;

      if (sweepAngle > 360) {
        rotationAngle = 360 - sweepAngle;
      }
      double rotationRadians = reverse ? -rotationAngle.toRadians() : rotationAngle.toRadians();
      // Rotate the canvas
      canvas.rotate((-90).toRadians() - rotationRadians);
      // Move the canvas origin back
      canvas.translate(-centerX, -centerY);

      if (sweepAngle < 360) {
        canvas.drawArc(
          Rect.fromCenter(
            center: startCapPosition,
            width: strokeWidth,
            height: strokeWidth,
          ),
          0,
          reverse ? 180.toRadians() : -180.toRadians(),
          true,
          Paint()..color = progressColor[0].first,
        );
      }
      canvas.drawArc(
        rect,
        0.toRadians(),
        reverse ? -(startAngle + sweepAngle).toRadians() : (startAngle + sweepAngle).toRadians(),
        false,
        paint,
      );
      if (sweepAngle < 360) {
        canvas.drawRect(
          Rect.fromCenter(
            center: startCapPosition,
            width: strokeWidth,
            height: 1,
          ),
          Paint()..color = progressColor[0].first,
        );
      }

      canvas.translate(centerX, centerY);
      if (sweepAngle < 360) {
        final endCapRotate = 360 - sweepAngle;
        canvas.rotate(reverse ? endCapRotate.toRadians() : -endCapRotate.toRadians());
      }
      //0.1 is because the angle calculation is not accurate enough, so we need to go back a little bit.
      var endCapPosition = Offset(
        centerX + radius * cos((startAngle).toRadians()),
        centerY + radius * sin((startAngle).toRadians()),
      );

      canvas.translate(-centerX, -centerY);
      final endColor = getColorAtAngle(sweepAngle, progressColor[colorRangeIndex]);
      if (sweepAngle > 355) {
        //Draw arc shadow
        var shadowPosition = Offset(
          centerX + radius * cos((startAngle).toRadians()),
          centerY + (reverse ? -5 : 5) + radius * sin((startAngle).toRadians()),
        );
        final Paint shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth / 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        final Path path = Path()
          ..addArc(
            Rect.fromCenter(
              center: shadowPosition,
              width: strokeWidth / 2,
              height: strokeWidth / 2,
            ),
            0,
            reverse ? -pi : pi,
          );
        canvas.drawPath(path, shadowPaint);
      }

      //Draw the ending arc
      canvas.drawArc(
        Rect.fromCenter(
          center: endCapPosition,
          width: strokeWidth,
          height: strokeWidth,
        ),
        0,
        reverse ? -180.toRadians() : 180.toRadians(),
        true,
        Paint()..color = endColor,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: endCapPosition,
          width: strokeWidth,
          height: 1,
        ),
        Paint()..color = endColor,
      );

      // // Restore the canvas to the saved state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ProgressPainter oldDelegate) {
    return sweepAngle != oldDelegate.sweepAngle;
  }

  Color getColorAtAngle(double angle, List<Color> colors) {
    double totalAngle = sweepAngle > 360 ? sweepAngle : 360;
    double fraction = angle / totalAngle;
    int segments = colors.length - 1;
    double segmentFraction = fraction * segments;
    int segmentIndex = segmentFraction.floor();
    double segmentInnerFraction = segmentFraction - segmentIndex;
    Color startColor = colors[segmentIndex];
    Color endColor = colors[(segmentIndex + 1) % colors.length];
    return Color.lerp(startColor, endColor, segmentInnerFraction)!;
  }
}
