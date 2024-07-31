import 'package:flutter/material.dart';
import 'widget.dart';

///CircularGradientCombineWidget multi CircularGradientProgressWidget
class CircularGradientCombineWidget extends StatefulWidget {
  ///widget size
  final double size;

  ///list of each sweep angle
  final List<double> sweepAngles;

  ///List<Color> of each circular
  final List<List<Color>> gradientColors;

  ///Background Color of each circular
  final List<Color> backgroundColors;

  ///empty center circle size ratio by size
  final double centerCircleSizeRatio;

  ///each gap of circular ratio by size
  final double gapRatio;

  /// default begin angle
  final double initAngle;

  ///open animate
  final bool animate;

  /// If true, a smoother intermediate color will be automatically inserted between the two gradient colors.
  final bool interpolatedColor;

  /// Set the percentage of the gradient color based on the two colors when inserting the intermediate gradient color
  final double interpolatedColorRatio;

  /// When the change reaches a certain percentage, the color will be the same as the last color,
  //so it needs to be limited, otherwise a circular_gradient_progress with the same color will appear instead of a gradient color.
  final double maxInterpolatedColorRatio;

  /// base duration
  final Duration duration;

  /// This value represents how much animation time needs to be increased for each 360 degrees after exceeding 360 degrees.
  final Duration plusDuration;

  /// max duration
  final Duration maxDuration;

  /// animation behavier
  final Curve curve;

  /// if true,be reverse
  final bool reverse;

  ///
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
    this.duration = const Duration(milliseconds: 1500),
    this.plusDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutQuad,
    this.initAngle = 0,
    this.reverse = false,
    this.maxDuration = Duration.zero,
  });

  @override
  State<CircularGradientCombineWidget> createState() => _CircularGradientCombineWidgetState();
}

class _CircularGradientCombineWidgetState extends State<CircularGradientCombineWidget> with SingleTickerProviderStateMixin {
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
          gradientColors: index >= widget.gradientColors.length ? widget.gradientColors.last : widget.gradientColors[index],
          sweepAngle: index >= widget.sweepAngles.length ? widget.sweepAngles.last : widget.sweepAngles[index],
          size: widget.size - strokeWidth * index - gap * index,
          strokeWidth: strokeWidth / 2,
          backgroundColor: index > widget.backgroundColors.length - 1 ? widget.backgroundColors.last : widget.backgroundColors[index],
          reverse: widget.reverse,
          maxDuration: widget.maxDuration,
        );
      }),
    );
  }
}
