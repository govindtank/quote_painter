import 'package:flutter/material.dart';
import 'quote_painter.dart';
import 'style.dart';

/// Widget that renders styled quote text on a background.
class QuoteCanvas extends StatefulWidget {
  final List<TextLine> lines;
  final QuoteStyle quoteStyle;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BoxDecoration? backgroundDecoration;
  final EdgeInsetsGeometry padding;

  const QuoteCanvas({
    super.key,
    required this.lines,
    required this.quoteStyle,
    required this.width,
    required this.height,
    this.backgroundColor,
    this.backgroundDecoration,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<QuoteCanvas> createState() => _QuoteCanvasState();
}

class _QuoteCanvasState extends State<QuoteCanvas> {
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return RepaintBoundary(
      key: _repaintKey,
      child: Container(
        width: w.width,
        height: w.height,
        decoration: w.backgroundDecoration ??
            BoxDecoration(color: w.backgroundColor ?? Colors.black),
        padding: w.padding,
        child: CustomPaint(
          size: Size(w.width, w.height),
          painter: QuotePainter(
            lines: w.lines,
            quoteStyle: w.quoteStyle,
            offsetX: 0,
            offsetY: 0,
            width: w.width,
            height: w.height,
          ),
        ),
      ),
    );
  }
}
