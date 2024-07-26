import 'dart:math';

import 'package:flutter/material.dart';

import 'paint.dart';

/// CircularGradientProgressWidget
class CircularGradientProgressWidget extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final double sweepAngle;
  final double initAngle;

  ///The colors need to go from light to dark, otherwise the effect is weird.
  ///Receive multiple color arrays so that more colors are needed when reaching a certain angle.
  final List<Color> gradientColors;
  final Color backgroundColor;
  final bool animate;

  /// If true, a smoother intermediate color will be automatically inserted between the two gradient colors.
  final bool interpolatedColor;

  /// Set the percentage of the gradient color based on the two colors when inserting the intermediate gradient color
  final double interpolatedColorRatio;

  /// When the change reaches a certain percentage, the color will be the same as the last color,
  //so it needs to be limited, otherwise a circular_gradient_progress with the same color will appear instead of a gradient color.
  final double maxInterpolatedColorRatio;

  /// base duration
  final int duration;

  /// This value represents how much animation time needs to be increased for each 360 degrees after exceeding 360 degrees.
  final int plusDuration;
  /// max duration
  final int maxDration;

  /// animation behavier
  final Curve curve;

  /// if true,be reverse
  final bool reverse;

  ///
  const CircularGradientProgressWidget({
    super.key,
    required this.gradientColors,
    required this.backgroundColor,
    required this.size,
    this.sweepAngle = 0,
    required this.strokeWidth,
    this.animate = false,
    this.interpolatedColor = true,
    this.interpolatedColorRatio = 0.1,
    this.maxInterpolatedColorRatio = 0.7,
    this.duration = 1500,
    this.plusDuration = 500,
    this.curve = Curves.easeInOutQuad,
    this.initAngle = 0,
    this.reverse = false,
    this.maxDration = 0,
  });

  @override
  State<CircularGradientProgressWidget> createState() => _CircularGradientProgressWidgetState();
}

class _CircularGradientProgressWidgetState extends State<CircularGradientProgressWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double sweepAngle = 0;
  double initAngle = 0;

  @override
  void initState() {
    super.initState();
    initAngle = widget.initAngle;
    if (widget.sweepAngle < 0) {
      initAngle = -1;
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    _updateAnimation(widget.sweepAngle, initAngle);
  }

  @override
  void didUpdateWidget(CircularGradientProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sweepAngle != oldWidget.sweepAngle) {
      _updateAnimation(widget.sweepAngle, sweepAngle);
    }
  }

  void _updateAnimation(double newSweepAngle, double oldSweepAngle) {
    if (widget.sweepAngle < 0 || newSweepAngle < 0) {
      setState(() {
        sweepAngle = -1;
      });
      return;
    }
    final double angleDifference = (newSweepAngle - oldSweepAngle).abs();
    int baseDurationMillis = widget.duration;

    int totalDuration = 0;
    if (angleDifference <= 360 && oldSweepAngle != 0) {
      totalDuration = ((angleDifference / 360) * baseDurationMillis).toInt();
    } else {
      totalDuration = baseDurationMillis;
      int full360Intervals = (angleDifference / 360).floor();
      totalDuration += full360Intervals * widget.plusDuration;
    }
    if (widget.animate) {
      if (widget.maxDration != 0 && totalDuration > widget.maxDration) {
        _controller.duration = Duration(milliseconds: widget.maxDration);
      } else {
        _controller.duration = Duration(milliseconds: totalDuration);
      }
    } else {
      _controller.duration = Duration.zero;
    }

    _animation = Tween<double>(begin: oldSweepAngle, end: newSweepAngle).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    )..addListener(() {
        setState(() {
          sweepAngle = _animation.value;
        });
      });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<List<Color>> generateColorArray(List<Color> colorList, double totalAngle) {
    final baseColorStart = colorList[0];
    final baseColorEnd = colorList[1];
    List<List<Color>> colors = [];
    int fullRotations = (totalAngle / 360).floor();
    colors.add([baseColorStart, baseColorEnd]);
    for (int i = 1; i <= fullRotations; i++) {
      double t = min(i * widget.interpolatedColorRatio, widget.maxInterpolatedColorRatio);
      colors.add([Color.lerp(baseColorStart, baseColorEnd, t)!, baseColorEnd]);
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final progressColors = generateColorArray(widget.gradientColors, widget.interpolatedColor ? sweepAngle : 0);
    return CustomPaint(
      painter: ProgressPainter(
        sweepAngle: sweepAngle,
        progressColor: progressColors,
        strokeWidth: widget.strokeWidth,
        backgroundColor: widget.backgroundColor,
        reverse: widget.reverse,
      ),
      size: Size(
        widget.size,
        widget.size,
      ),
    );
  }
}
