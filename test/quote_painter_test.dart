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
    expect(style.quoteMarkStyle.show, false);
    expect(style.defaultHighlight, isNull);
  });

  test('QuoteStyle copyWith', () {
    const style = QuoteStyle(fontSize: 24, color: Colors.white);
    final modified = style.copyWith(
      fontSize: 32,
      color: Colors.red,
      defaultHighlight: const LineHighlight(color: Colors.black),
      quoteMarkStyle: const QuoteMarkStyle(show: true),
    );
    expect(modified.fontSize, 32.0);
    expect(modified.color, Colors.red);
    expect(modified.strokeWidth, 0.0);
    expect(modified.defaultHighlight?.color, Colors.black);
    expect(modified.quoteMarkStyle.show, true);
  });

  test('LineStyle merge and LineHighlight', () {
    const highlight1 = LineHighlight(color: Colors.yellow);
    const highlight2 = LineHighlight(color: Colors.green);
    const base =
        LineStyle(fontSize: 20, color: Colors.blue, highlight: highlight1);
    const override = LineStyle(fontSize: 30, highlight: highlight2);
    final merged = base.merge(override);
    expect(merged.fontSize, 30.0);
    expect(merged.color, Colors.blue);
    expect(merged.highlight?.color, Colors.green);
  });

  test('TextLine creation', () {
    const line = TextLine('Hello', style: LineStyle(fontSize: 18));
    expect(line.text, 'Hello');
    expect(line.style!.fontSize, 18.0);
  });

  test('QuoteStyle resolveAlign and resolveHighlight', () {
    const style = QuoteStyle(
      textAlign: TextAlign.right,
      defaultHighlight: LineHighlight(color: Colors.amber),
    );
    expect(style.resolveAlign(), TextAlign.right);
    expect(
        style.resolveAlign(
            lineOverride: const LineStyle(textAlign: TextAlign.left)),
        TextAlign.left);

    expect(style.resolveHighlight()?.color, Colors.amber);
    expect(
        style
            .resolveHighlight(
                lineOverride: const LineStyle(
                    highlight: LineHighlight(color: Colors.purple)))
            ?.color,
        Colors.purple);
  });

  test('QuoteThemes presets are configured properly', () {
    final editorial = QuoteThemes.editorial;
    expect(editorial.quoteMarkStyle.show, true);
    expect(editorial.fontSize, 28.0);

    final cyberpunk = QuoteThemes.cyberpunkNeon;
    expect(cyberpunk.gradient, isNotNull);
    expect(cyberpunk.strokeWidth, 1.0);
    expect(cyberpunk.quoteMarkStyle.show, true);

    final dark = QuoteThemes.minimalistDark;
    expect(dark.fontSize, 24.0);

    final sunset = QuoteThemes.sunsetGlow;
    expect(sunset.gradient, isNotNull);

    final badge = QuoteThemes.highlightedBadge;
    expect(badge.defaultHighlight, isNotNull);
  });

  test('QuotePainter.fromText splits continuous text into multiple lines', () {
    final painter = QuotePainter.fromText(
      text:
          'Simplicity is the soul of efficiency and the heart of great design.',
      quoteStyle: const QuoteStyle(fontSize: 20.0),
      maxWidth: 150.0,
      maxHeight: 400.0,
    );

    expect(painter.lines.length, greaterThan(1));
    expect(painter.width, 150.0);
    expect(painter.height, 400.0);
  });

  testWidgets('QuoteCanvas and QuotePainter render without errors',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuoteCanvas(
            width: 300,
            height: 300,
            quoteStyle: QuoteThemes.cyberpunkNeon,
            lines: const [
              TextLine('Cyberpunk Dreams',
                  style: LineStyle(
                      highlight: LineHighlight(color: Colors.black54))),
              TextLine('Built for the future'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(QuoteCanvas), findsOneWidget);
    await tester.pumpAndSettle();
  });

  test('Export function type is callable', () {
    expect(exportToPng, isA<Function>());
  });
}
