// import 'package:flutter/material.dart';

// class SelectionPainter extends CustomPainter {
//   final Offset start;
//   final Offset end;

//   SelectionPainter(this.start, this.end);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromPoints(start, end);

//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     const dashWidth = 6;
//     const dashSpace = 4;

//     final path = Path()..addRect(rect);
//     final dashedPath = Path();

//     for (final metric in path.computeMetrics()) {
//       double distance = 0;
//       while (distance < metric.length) {
//         dashedPath.addPath(
//           metric.extractPath(distance, distance + dashWidth),
//           Offset.zero,
//         );
//         distance += dashWidth + dashSpace;
//       }
//     }

//     canvas.drawPath(dashedPath, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }


















import 'package:flutter/material.dart';

class SelectionPainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  SelectionPainter(this.startPoint, this.endPoint);

  @override
  void paint(Canvas canvas, Size size) {
    // Create the rectangle from start and end points
    final rect = Rect.fromPoints(startPoint, endPoint);

    // Draw semi-transparent fill
    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Draw border with gradient effect
    final borderPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(rect, borderPaint);

    // Draw corner handles
    _drawCornerHandles(canvas, rect);

    // Draw dashed border animation effect
    _drawDashedBorder(canvas, rect);
  }

  void _drawCornerHandles(Canvas canvas, Rect rect) {
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final handleBorderPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final handleSize = 12.0;
    final handleRadius = handleSize / 2;

    // Define corner positions
    final corners = [
      Offset(rect.left, rect.top),     // Top-left
      Offset(rect.right, rect.top),    // Top-right
      Offset(rect.left, rect.bottom),  // Bottom-left
      Offset(rect.right, rect.bottom), // Bottom-right
    ];

    // Draw circular handles at each corner
    for (final corner in corners) {
      canvas.drawCircle(corner, handleRadius, handlePaint);
      canvas.drawCircle(corner, handleRadius, handleBorderPaint);
    }
  }

  void _drawDashedBorder(Canvas canvas, Rect rect) {
    final dashedPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const dashWidth = 8.0;
    const dashSpace = 4.0;

    // Draw top dashed line
    _drawDashedLine(
      canvas,
      dashedPaint,
      rect.topLeft,
      rect.topRight,
      dashWidth,
      dashSpace,
    );

    // Draw right dashed line
    _drawDashedLine(
      canvas,
      dashedPaint,
      rect.topRight,
      rect.bottomRight,
      dashWidth,
      dashSpace,
    );

    // Draw bottom dashed line
    _drawDashedLine(
      canvas,
      dashedPaint,
      rect.bottomRight,
      rect.bottomLeft,
      dashWidth,
      dashSpace,
    );

    // Draw left dashed line
    _drawDashedLine(
      canvas,
      dashedPaint,
      rect.bottomLeft,
      rect.topLeft,
      dashWidth,
      dashSpace,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end,
    double dashWidth,
    double dashSpace,
  ) {
    final path = Path();
    final distance = (end - start).distance;
    final normalizedVector = Offset(
      (end.dx - start.dx) / distance,
      (end.dy - start.dy) / distance,
    );

    var currentDistance = 0.0;
    while (currentDistance < distance) {
      final dashEnd = currentDistance + dashWidth > distance
          ? distance
          : currentDistance + dashWidth;

      final dashStart = Offset(
        start.dx + normalizedVector.dx * currentDistance,
        start.dy + normalizedVector.dy * currentDistance,
      );

      final dashEndPoint = Offset(
        start.dx + normalizedVector.dx * dashEnd,
        start.dy + normalizedVector.dy * dashEnd,
      );

      path.moveTo(dashStart.dx, dashStart.dy);
      path.lineTo(dashEndPoint.dx, dashEndPoint.dy);

      currentDistance += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) {
    return oldDelegate.startPoint != startPoint ||
        oldDelegate.endPoint != endPoint;
  }
}