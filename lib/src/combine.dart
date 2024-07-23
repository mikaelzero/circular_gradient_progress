import 'package:flutter/material.dart';
import 'widget.dart';

class CircularGradientCombineWidget extends StatefulWidget {
  final double size;
  final List<double> sweepAngles;
  final bool animate;
  final List<List<Color>> gradientColors;
  final List<Color> backgroundColors;
  final double centerCircleSizeRatio;
  final double gapRatio;
  // If true, a smoother intermediate color will be automatically inserted between the two gradient colors.
  final bool interpolatedColor;
  // Set the percentage of the gradient color based on the two colors when inserting the intermediate gradient color
  final double interpolatedColorRatio;
  //When the change reaches a certain percentage, the color will be the same as the last color,
  //so it needs to be limited, otherwise a circular_gradient_progress with the same color will appear instead of a gradient color.
  final double maxInterpolatedColorRatio;
  final int duration;
  // This value represents how much animation time needs to be increased for each 360 degrees after exceeding 360 degrees.
  final int plusDuration;
  final Curve curve;
  final double initAngle;

  const CircularGradientCombineWidget({
    super.key,
    required this.size,
    required this.sweepAngles,
    required this.backgroundColors,
    required this.gradientColors,
    this.animate = true,
    this.centerCircleSizeRatio = 0.15,
    this.gapRatio = 0.05,
    this.interpolatedColor = true,
    this.interpolatedColorRatio = 0.1,
    this.maxInterpolatedColorRatio = 0.7,
    this.duration = 1500,
    this.plusDuration = 500,
    this.curve = Curves.easeInOutQuad,
    this.initAngle = 0,
  });

  @override
  State<CircularGradientCombineWidget> createState() => _CircularGradientCombineWidgetState();
}

class _CircularGradientCombineWidgetState extends State<CircularGradientCombineWidget> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final centerCircleSize = widget.size * widget.centerCircleSizeRatio;
    final gap = widget.size * widget.gapRatio;
    var strokeWidth = (widget.size - (widget.sweepAngles.length - 1) * gap - centerCircleSize) / widget.sweepAngles.length;
    if (strokeWidth > widget.size / 3) {
      strokeWidth = widget.size / 3;
    }
    return Stack(
      alignment: Alignment.center,
      children: List.generate(widget.sweepAngles.length, (index) {
        return CircularGradientProgressWidget(
          animate: widget.animate,
          interpolatedColorRatio: widget.interpolatedColorRatio,
          maxInterpolatedColorRatio: widget.maxInterpolatedColorRatio,
          duration: widget.duration,
          plusDuration: widget.plusDuration,
          curve: widget.curve,
          initAngle: widget.initAngle,
          interpolatedColor: widget.interpolatedColor,
          gradientColors: widget.gradientColors[index],
          sweepAngle: widget.sweepAngles[index],
          size: widget.size - strokeWidth * index - gap * index,
          strokeWidth: strokeWidth / 2,
          backgroundColor: index > widget.backgroundColors.length - 1 ? widget.backgroundColors.last : widget.backgroundColors[index],
        );
      }),
    );
  }
}
