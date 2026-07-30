import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'style.dart';

/// A single line of text with optional per-line style.
class TextLine {
  final String text;
  final LineStyle? style;

  const TextLine(this.text, {this.style});
}

/// [CustomPainter] that renders styled text lines with gradient, stroke, shadow.
///
/// Each line can have its own [LineStyle] override. Renders within the
/// bounding rect [offsetX], [offsetY], [width], [height].
class QuotePainter extends CustomPainter {
  final List<TextLine> lines;
  final QuoteStyle quoteStyle;
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;

  QuotePainter({
    required this.lines,
    required this.quoteStyle,
    this.offsetX = 0,
    this.offsetY = 0,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(offsetX, offsetY, width, height);
    canvas.save();
    canvas.clipRect(rect);

    double y = offsetY;

    for (final line in lines) {
      if (line.text.isEmpty) {
        y += quoteStyle.fontSize * quoteStyle.lineHeight;
        continue;
      }

      final ls = line.style;
      final textAlign = quoteStyle.resolveAlign(lineOverride: ls);
      final ts = _buildTextStyle(quoteStyle, ls, forFill: false);
      final textSpan = TextSpan(text: line.text, style: ts);
      final tp = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
        textAlign: textAlign,
      );
      tp.layout(maxWidth: width);

      final x = _alignX(tp.width, textAlign);
      final pos = Offset(x, y);

      // 1) Shadow
      _paintShadow(canvas, line, tp, pos);

      // 2) Stroke
      _paintStroke(canvas, line, tp, pos);

      // 3) Fill (solid or gradient)
      _paintFill(canvas, line, tp, pos, quoteStyle);

      y += tp.height + (quoteStyle.fontSize * (quoteStyle.lineHeight - 1.0));
    }

    canvas.restore();
  }

  TextStyle _buildTextStyle(QuoteStyle s, LineStyle? ls,
      {required bool forFill}) {
    Color color;
    if (forFill) {
      color = ls?.color ?? s.color;
    } else {
      // Base style: use fill color so layout metrics match
      color = ls?.color ?? s.color;
    }
    return TextStyle(
      color: color,
      fontSize: ls?.fontSize ?? s.fontSize,
      fontWeight: ls?.fontWeight ?? s.fontWeight,
      fontStyle: ls?.fontStyle ?? s.fontStyle,
      fontFamily: ls?.fontFamily ?? s.fontFamily,
      height: s.lineHeight,
    );
  }

  double _alignX(double textWidth, TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return offsetX + (width - textWidth) / 2;
      case TextAlign.right:
      case TextAlign.end:
        return offsetX + width - textWidth;
      default:
        return offsetX;
    }
  }

  void _paintShadow(Canvas canvas, TextLine line, TextPainter tp, Offset pos) {
    final ls = line.style;
    final sc = ls?.shadowColor ?? quoteStyle.shadowColor;
    if (sc.opacity <= 0) return;
    final so = ls?.shadowOffset ?? quoteStyle.shadowOffset;
    final sb = ls?.shadowBlurRadius ?? quoteStyle.shadowBlurRadius;
    final maxW = width;

    if (sb > 0) {
      canvas.save();
      final paint = Paint()
        ..color = sc
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sb);
      canvas.translate(so.dx, so.dy);
      canvas.saveLayer(null, paint);
      tp.paint(canvas, pos);
      canvas.restore();
      canvas.restore();
    } else {
      final span = TextSpan(
        text: line.text,
        style: TextStyle(
          color: sc,
          fontSize: ls?.fontSize ?? quoteStyle.fontSize,
          fontWeight: ls?.fontWeight ?? quoteStyle.fontWeight,
          fontFamily: ls?.fontFamily ?? quoteStyle.fontFamily,
          height: quoteStyle.lineHeight,
        ),
      );
      final shadowTp = TextPainter(
        text: span,
        textDirection: ui.TextDirection.ltr,
        textAlign: tp.textAlign,
      );
      shadowTp.layout(maxWidth: maxW);
      shadowTp.paint(canvas, pos + so);
    }
  }

  void _paintStroke(Canvas canvas, TextLine line, TextPainter tp, Offset pos) {
    final ls = line.style;
    final strokeColor = ls?.strokeColor ?? quoteStyle.strokeColor;
    final strokeWidth = ls?.strokeWidth ?? quoteStyle.strokeWidth;
    if (strokeColor.opacity <= 0 || strokeWidth <= 0) return;

    final span = TextSpan(
      text: line.text,
      style: TextStyle(
        color: strokeColor,
        fontSize: ls?.fontSize ?? quoteStyle.fontSize,
        fontWeight: ls?.fontWeight ?? quoteStyle.fontWeight,
        fontFamily: ls?.fontFamily ?? quoteStyle.fontFamily,
        height: quoteStyle.lineHeight,
      ),
    );
    final strokeTp = TextPainter(
      text: span,
      textDirection: ui.TextDirection.ltr,
      textAlign: tp.textAlign,
    );
    strokeTp.layout(maxWidth: width);

    // Draw stroke by painting multiple times offset
    final sw = strokeWidth;
    for (final dx in [-sw, 0.0, sw]) {
      for (final dy in [-sw, 0.0, sw]) {
        if (dx == 0 && dy == 0) continue;
        strokeTp.paint(canvas, pos + Offset(dx, dy));
      }
    }
  }

  void _paintFill(Canvas canvas, TextLine line, TextPainter tp, Offset pos,
      QuoteStyle style) {
    final ls = line.style;
    final gradient = style.resolveGradient(
      Rect.fromLTWH(pos.dx, pos.dy, tp.width, tp.height),
      lineOverride: ls,
    );

    if (gradient != null) {
      final fillPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(pos.dx, pos.dy, tp.width, tp.height),
        );
      final span = TextSpan(
        text: line.text,
        style: TextStyle(
          foreground: fillPaint,
          fontSize: ls?.fontSize ?? style.fontSize,
          fontWeight: ls?.fontWeight ?? style.fontWeight,
          fontFamily: ls?.fontFamily ?? style.fontFamily,
          height: style.lineHeight,
        ),
      );
      final fillTp = TextPainter(
        text: span,
        textDirection: ui.TextDirection.ltr,
        textAlign: tp.textAlign,
      );
      fillTp.layout(maxWidth: width);
      fillTp.paint(canvas, pos);
    } else {
      tp.paint(canvas, pos);
    }
  }

  @override
  bool shouldRepaint(covariant QuotePainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.quoteStyle != quoteStyle ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
