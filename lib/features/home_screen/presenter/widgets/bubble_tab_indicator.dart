import 'package:flutter/material.dart';

class BubbleTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double height;
  final EdgeInsetsGeometry padding;

  const BubbleTabIndicator({
    required this.color,
    this.radius = 20.0,
    this.height = 30.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(
      color: color,
      radius: radius,
      height: height,
      padding: padding,
    );
  }
}

class _BubblePainter extends BoxPainter {
  final Color color;
  final double radius;
  final double height;
  final EdgeInsetsGeometry padding;

  _BubblePainter({
    required this.color,
    required this.radius,
    required this.height,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final double width = configuration.size?.width ?? 0;
    final horizontalInset = padding.horizontal / 2;
    final Rect rect = Rect.fromLTWH(
      offset.dx + horizontalInset,
      offset.dy + (configuration.size!.height - height) / 2,
      width - (horizontalInset * 2),
      height,
    );

    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rrect, paint);
  }
}