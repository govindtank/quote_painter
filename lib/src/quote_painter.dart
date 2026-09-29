import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'style.dart';

/// A single line of text with optional per-line style.
class TextLine {
  final String text;
  final LineStyle? style;

  const TextLine(this.text, {this.style});
}

/// [CustomPainter] that renders styled text lines with gradient, stroke, shadow,
/// line highlights/badges, and decorative quotation marks.
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

  /// Automatically creates a [QuotePainter] from a continuous text string,
  /// breaking lines automatically to fit within [maxWidth].
  factory QuotePainter.fromText({
    required String text,
    required QuoteStyle quoteStyle,
    required double maxWidth,
    required double maxHeight,
    double offsetX = 0,
    double offsetY = 0,
    LineStyle? defaultLineStyle,
  }) {
    final words = text.split(RegExp(r'\s+'));
    final lines = <TextLine>[];

    String currentLine = '';
    for (final word in words) {
      if (word.isEmpty) continue;
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';
      final tp = TextPainter(
        text: TextSpan(
          text: testLine,
          style: quoteStyle.toTextStyle(lineOverride: defaultLineStyle),
        ),
        textDirection: ui.TextDirection.ltr,
        textAlign: quoteStyle.resolveAlign(lineOverride: defaultLineStyle),
      )..layout(maxWidth: double.infinity);

      if (tp.width <= maxWidth || currentLine.isEmpty) {
        currentLine = testLine;
      } else {
        lines.add(TextLine(currentLine, style: defaultLineStyle));
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(TextLine(currentLine, style: defaultLineStyle));
    }

    return QuotePainter(
      lines: lines,
      quoteStyle: quoteStyle,
      offsetX: offsetX,
      offsetY: offsetY,
      width: maxWidth,
      height: maxHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(offsetX, offsetY, width, height);
    canvas.save();
    canvas.clipRect(rect);

    // 0) Paint decorative background quote marks if enabled
    if (quoteStyle.quoteMarkStyle.show) {
      _paintQuoteMarks(canvas);
    }

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

      // 1) Highlight / badge background
      final highlight = quoteStyle.resolveHighlight(lineOverride: ls);
      if (highlight != null) {
        _paintHighlight(canvas, highlight, pos, tp.size);
      }

      // 2) Shadow
      _paintShadow(canvas, line, tp, pos);

      // 3) Stroke
      _paintStroke(canvas, line, tp, pos);

      // 4) Fill (solid or gradient)
      _paintFill(canvas, line, tp, pos, quoteStyle);

      y += tp.height + (quoteStyle.fontSize * (quoteStyle.lineHeight - 1.0));
    }

    canvas.restore();
  }

  void _paintQuoteMarks(Canvas canvas) {
    final markStyle = quoteStyle.quoteMarkStyle;
    final markPaint = Paint()
      ..color = markStyle.color.withValues(
        alpha: markStyle.color.a * markStyle.opacity,
      );

    final openingSpan = TextSpan(
      text: markStyle.openingMark,
      style: TextStyle(
        fontSize: markStyle.fontSize,
        fontFamily: markStyle.fontFamily,
        foreground: markPaint,
        fontWeight: FontWeight.w900,
        height: 1.0,
      ),
    );
    final openingTp = TextPainter(
      text: openingSpan,
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final closingSpan = TextSpan(
      text: markStyle.closingMark,
      style: TextStyle(
        fontSize: markStyle.fontSize,
        fontFamily: markStyle.fontFamily,
        foreground: markPaint,
        fontWeight: FontWeight.w900,
        height: 1.0,
      ),
    );
    final closingTp = TextPainter(
      text: closingSpan,
      textDirection: ui.TextDirection.ltr,
    )..layout();

    switch (markStyle.placement) {
      case QuoteMarkPlacement.topLeft:
        openingTp.paint(
          canvas,
          Offset(offsetX, offsetY) + markStyle.openingOffset,
        );
        break;
      case QuoteMarkPlacement.topCenter:
        openingTp.paint(
          canvas,
          Offset(offsetX + (width - openingTp.width) / 2, offsetY) +
              markStyle.openingOffset,
        );
        break;
      case QuoteMarkPlacement.topRight:
        openingTp.paint(
          canvas,
          Offset(offsetX + width - openingTp.width, offsetY) +
              markStyle.openingOffset,
        );
        break;
      case QuoteMarkPlacement.bothSides:
        openingTp.paint(
          canvas,
          Offset(offsetX, offsetY) + markStyle.openingOffset,
        );
        closingTp.paint(
          canvas,
          Offset(
                offsetX + width - closingTp.width,
                offsetY + height - closingTp.height,
              ) +
              markStyle.closingOffset,
        );
        break;
    }
  }

  void _paintHighlight(
    Canvas canvas,
    LineHighlight highlight,
    Offset pos,
    Size textSize,
  ) {
    final rect = Rect.fromLTWH(
      pos.dx - highlight.padding.left,
      pos.dy - highlight.padding.top,
      textSize.width + highlight.padding.horizontal,
      textSize.height + highlight.padding.vertical,
    );

    final rrect = highlight.borderRadius.toRRect(rect);
    final paint = Paint()..isAntiAlias = true;

    if (highlight.gradient != null) {
      paint.shader = highlight.gradient!.createShader(rect);
    } else {
      paint.color = highlight.color;
    }

    canvas.drawRRect(rrect, paint);

    if (highlight.border != null &&
        highlight.border!.style != BorderStyle.none &&
        highlight.border!.width > 0) {
      final borderPaint = Paint()
        ..color = highlight.border!.color
        ..strokeWidth = highlight.border!.width
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;
      canvas.drawRRect(rrect, borderPaint);
    }
  }

  TextStyle _buildTextStyle(
    QuoteStyle s,
    LineStyle? ls, {
    required bool forFill,
  }) {
    final color = ls?.color ?? s.color;
    return TextStyle(
      color: color,
      fontSize: ls?.fontSize ?? s.fontSize,
      fontWeight: ls?.fontWeight ?? s.fontWeight,
      fontStyle: ls?.fontStyle ?? s.fontStyle,
      fontFamily: ls?.fontFamily ?? s.fontFamily,
      letterSpacing: ls?.letterSpacing ?? s.letterSpacing,
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
    if (sc.a <= 0) return;
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
          letterSpacing: ls?.letterSpacing ?? quoteStyle.letterSpacing,
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
    if (strokeColor.a <= 0 || strokeWidth <= 0) return;

    final span = TextSpan(
      text: line.text,
      style: TextStyle(
        color: strokeColor,
        fontSize: ls?.fontSize ?? quoteStyle.fontSize,
        fontWeight: ls?.fontWeight ?? quoteStyle.fontWeight,
        fontFamily: ls?.fontFamily ?? quoteStyle.fontFamily,
        letterSpacing: ls?.letterSpacing ?? quoteStyle.letterSpacing,
        height: quoteStyle.lineHeight,
      ),
    );
    final strokeTp = TextPainter(
      text: span,
      textDirection: ui.TextDirection.ltr,
      textAlign: tp.textAlign,
    );
    strokeTp.layout(maxWidth: width);

    final sw = strokeWidth;
    for (final dx in [-sw, 0.0, sw]) {
      for (final dy in [-sw, 0.0, sw]) {
        if (dx == 0 && dy == 0) continue;
        strokeTp.paint(canvas, pos + Offset(dx, dy));
      }
    }
  }

  void _paintFill(
    Canvas canvas,
    TextLine line,
    TextPainter tp,
    Offset pos,
    QuoteStyle style,
  ) {
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
          letterSpacing: ls?.letterSpacing ?? style.letterSpacing,
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
