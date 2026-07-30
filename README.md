# quote_painter

Flutter package for rendering styled text on image/video canvas.

## Features

- **Gradient fill** — solid color or `LinearGradient`/`RadialGradient`
- **Stroke (outline)** — configurable width and color per text
- **Shadow** — offset + blur radius
- **Per-line alignment** — left, center, right per `TextLine`
- **Emoji + mixed script** — full Unicode support via Flutter's `TextPainter`
- **Exact positioning** — set `(x, y, width, height)` bounding rect
- **PNG export** — capture to `Uint8List` via `exportToPng`

## Usage

```dart
import 'package:quote_painter/quote_painter.dart';

final style = QuoteStyle(
  fontSize: 28,
  gradient: LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
  strokeColor: Colors.black,
  strokeWidth: 1.5,
  shadowBlurRadius: 4,
);

final lines = [
  TextLine('The only way to'),
  TextLine('do great work'),
  TextLine('is to love what you do.'),
  TextLine('— Steve Jobs',
      style: LineStyle(fontSize: 18, fontStyle: FontStyle.italic, textAlign: TextAlign.right)),
];

// In your widget tree:
QuoteCanvas(
  lines: lines,
  quoteStyle: style,
  width: 350,
  height: 300,
  backgroundDecoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
    ),
  ),
);
```

## Export to PNG

```dart
final key = GlobalKey(); // from QuoteCanvas
final bytes = await exportToPng(key, pixelRatio: 3);
// bytes is Uint8List — save to file or share
```

## API

| Class | Purpose |
|---|---|
| `QuoteStyle` | Global text config: font, gradient, stroke, shadow, alignment |
| `LineStyle` | Per-line overrides for any `QuoteStyle` property |
| `TextLine` | A single text string with optional `LineStyle` |
| `QuotePainter` | `CustomPainter` — low-level canvas rendering |
| `QuoteCanvas` | Widget wrapping `QuotePainter` with background |
| `exportToPng` | Capture widget to PNG `Uint8List` |
