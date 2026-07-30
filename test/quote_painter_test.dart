import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quote_painter/quote_painter.dart';

void main() {
  test('QuoteStyle default values', () {
    const style = QuoteStyle();
    expect(style.color, Colors.white);
    expect(style.fontSize, 24.0);
    expect(style.strokeWidth, 0.0);
    expect(style.textAlign, TextAlign.center);
  });

  test('QuoteStyle copyWith', () {
    const style = QuoteStyle(fontSize: 24, color: Colors.white);
    final modified = style.copyWith(fontSize: 32, color: Colors.red);
    expect(modified.fontSize, 32.0);
    expect(modified.color, Colors.red);
    expect(modified.strokeWidth, 0.0);
  });

  test('LineStyle merge', () {
    const base = LineStyle(fontSize: 20, color: Colors.blue);
    const override = LineStyle(fontSize: 30);
    final merged = base.merge(override);
    expect(merged.fontSize, 30.0);
    expect(merged.color, Colors.blue);
  });

  test('TextLine creation', () {
    const line = TextLine('Hello', style: LineStyle(fontSize: 18));
    expect(line.text, 'Hello');
    expect(line.style!.fontSize, 18.0);
  });

  test('QuoteStyle resolveAlign defaults to base', () {
    const style = QuoteStyle(textAlign: TextAlign.right);
    expect(style.resolveAlign(), TextAlign.right);
    expect(
        style.resolveAlign(lineOverride: const LineStyle(textAlign: TextAlign.left)),
        TextAlign.left);
  });

  test('GradientDirection enum values', () {
    expect(GradientDirection.values.length, 4);
    expect(GradientDirection.leftToRight, isA<GradientDirection>());
    expect(GradientDirection.topToBottom, isA<GradientDirection>());
  });

  test('QuotePainter accepts empty lines', () {
    final painter = QuotePainter(
      lines: [],
      quoteStyle: const QuoteStyle(),
      width: 300,
      height: 200,
    );
    expect(painter.lines, isEmpty);
  });

  test('Export function type is callable', () {
    expect(exportToPng, isA<Function>());
  });
}
