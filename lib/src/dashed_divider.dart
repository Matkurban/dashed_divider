import 'package:flutter/material.dart';

/// A lightweight customizable dashed divider widget.
///
/// Features:
/// - Horizontal or vertical orientation
/// - Custom dash length, gap, thickness, color
/// - Optional fixed total length, otherwise expands to parent constraint
/// - Optional margin and rounded dash corners
///
/// Example:
/// ```dart
/// const DashedDivider();
/// const DashedDivider(color: Colors.red, dashLength: 6, dashGap: 3);
/// const DashedDivider(axis: Axis.vertical, length: 80);
/// ```
class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.dashLength = 4,
    this.dashGap = 2,
    this.thickness = 1,
    this.color = const Color(0xFFDDDDDD),
    this.length,
    this.margin,
    this.dashRadius,
  });

  /// Divider direction.
  final Axis axis;

  /// Length of an individual dash (logical pixels).
  final double dashLength;

  /// Gap between dashes (logical pixels).
  final double dashGap;

  /// Thickness (cross-axis size) of the divider.
  final double thickness;

  /// Dash color.
  final Color color;

  /// Optional fixed total length. If null, uses incoming constraints.
  final double? length;

  /// Optional outer padding.
  final EdgeInsetsGeometry? margin;

  /// Corner radius for each dash. If null, defaults to half the thickness for a pill look.
  final double? dashRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine total drawable length based on axis & constraints.
        double available =
            length ?? (axis == Axis.horizontal ? constraints.maxWidth : constraints.maxHeight);
        if (!available.isFinite) {
          // Fallback to screen dimension if unconstrained (rare edge case in scroll view without explicit size).
          final size = MediaQuery.maybeOf(context)?.size;
          if (size != null) {
            available = axis == Axis.horizontal ? size.width : size.height;
          } else {
            available = 0; // Nothing we can reliably paint.
          }
        }

        final sized = CustomPaint(
          size: axis == Axis.horizontal ? Size(available, thickness) : Size(thickness, available),
          painter: _DashedLinePainter(
            axis: axis,
            dashLength: dashLength,
            dashGap: dashGap,
            thickness: thickness,
            color: color,
            dashRadius: dashRadius,
          ),
        );

        final boxed = axis == Axis.horizontal
            ? SizedBox(width: available, height: thickness, child: sized)
            : SizedBox(width: thickness, height: available, child: sized);

        return margin != null ? Padding(padding: margin!, child: boxed) : boxed;
      },
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.axis,
    required this.dashLength,
    required this.dashGap,
    required this.thickness,
    required this.color,
    required this.dashRadius,
  });

  final Axis axis;
  final double dashLength;
  final double dashGap;
  final double thickness;
  final Color color;
  final double? dashRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (dashLength <= 0 || thickness <= 0 || size.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final totalMain = axis == Axis.horizontal ? size.width : size.height;
    final r = Radius.circular(dashRadius ?? thickness / 2);

    double drawn = 0;
    while (drawn < totalMain) {
      final currentDash = (drawn + dashLength) <= totalMain ? dashLength : (totalMain - drawn);
      if (currentDash <= 0) break;

      Rect rect;
      if (axis == Axis.horizontal) {
        rect = Rect.fromLTWH(drawn, 0, currentDash, thickness);
      } else {
        rect = Rect.fromLTWH(0, drawn, thickness, currentDash);
      }
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: r,
        topRight: r,
        bottomLeft: r,
        bottomRight: r,
      );
      canvas.drawRRect(rrect, paint);
      drawn += currentDash + dashGap;
      if (dashGap <= 0) {
        // Prevent infinite loop if gap is zero or negative.
        drawn += 0.0001; // minimal increment
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.axis != axis ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.thickness != thickness ||
        oldDelegate.color != color ||
        oldDelegate.dashRadius != dashRadius;
  }
}
