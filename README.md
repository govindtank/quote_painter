# quote_painter

[![Pub Version](https://img.shields.io/pub/v/quote_painter.svg?style=flat-square&color=blue)](https://pub.dev/packages/quote_painter)
[![Pub Points](https://img.shields.io/pub/points/quote_painter?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/quote_painter/score)
[![Pub Likes](https://img.shields.io/pub/likes/quote_painter?style=flat-square)](https://pub.dev/packages/quote_painter)
[![CI](https://github.com/govindtank/quote_painter/actions/workflows/ci.yml/badge.svg)](https://github.com/govindtank/quote_painter/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square)](https://pub.dev/packages/quote_painter)

A high-performance Flutter package for rendering beautifully styled text, inspirational quotes, titles, and captions over image/video canvas surfaces with gradients, outlines, multi-layer shadows, per-line overrides, and PNG export.

Now available on **[pub.dev/packages/quote_painter](https://pub.dev/packages/quote_painter)**.

---

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/quote_painter/main/screenshot.svg" width="450" alt="quote_painter screenshot" />
</p>

---

## ✨ Features

- 🌈 **Gradient Fills** — Full support for Linear and Radial gradients across text characters or solid colors.
- 🖋️ **Strokes & Outlines** — Configurable stroke widths, outline colors, and join styles to make text readable against any backdrop.
- 🌑 **Multi-Layer Shadows** — Customizable blur radius, shadow color, and 2D offset for crisp depth.
- 📏 **Per-Line Customization** — Override font size, color, gradient, stroke, and text alignment (`left`, `center`, `right`) per individual line.
- 🌐 **Unicode & Mixed Scripts** — Full emoji, multilingual, and complex script support via Flutter's `TextPainter`.
- 📐 **Precise Canvas Layout** — Automatic wrapping, custom padding, background decorations, and bounding constraints.
- 🖼️ **High-Resolution PNG Export** — Convert canvas designs directly to `Uint8List` bytes at custom pixel ratios (2x, 3x, 4x for 4K exports).

---

## 📦 Installation

Add `quote_painter` to your Flutter project:

```bash
flutter pub add quote_painter
```

Or add it to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  quote_painter: ^0.1.0
```

Then run `flutter pub get` and import:

```dart
import 'package:quote_painter/quote_painter.dart';
```

---

## 🚀 Usage

### 1. Basic Quote Canvas

Display a multi-line styled quote with gradient text and a dark background:

```dart
import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

class QuoteCardDemo extends StatelessWidget {
  const QuoteCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Define global style
    final quoteStyle = QuoteStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      gradient: const LinearGradient(
        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      ),
      strokeColor: Colors.black26,
      strokeWidth: 1.5,
      shadowColor: Colors.black54,
      shadowBlurRadius: 6,
      shadowOffset: const Offset(2, 2),
      textAlign: TextAlign.center,
      lineHeight: 1.35,
    );

    // 2. Define text lines with optional individual overrides
    final lines = [
      TextLine('“The greatest glory in living'),
      TextLine('lies not in never falling,'),
      TextLine('but in rising every time we fall.”'),
      TextLine(
        '— Nelson Mandela',
        style: LineStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
          textAlign: TextAlign.right,
        ),
      ),
    ];

    // 3. Render widget
    return Center(
      child: QuoteCanvas(
        lines: lines,
        quoteStyle: quoteStyle,
        width: 360,
        height: 240,
        backgroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
      ),
    );
  }
}
```

---

### 2. Exporting Canvas to PNG

Easily capture the painted canvas as a PNG image for sharing, saving to gallery, or video frame generation:

```dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

final GlobalKey canvasKey = GlobalKey();

// Render QuoteCanvas with the key:
QuoteCanvas(
  key: canvasKey,
  lines: lines,
  quoteStyle: style,
  width: 1080,
  height: 1080,
);

// Capture as high-res PNG bytes:
Future<Uint8List?> exportCard() async {
  final Uint8List? pngBytes = await exportToPng(
    canvasKey,
    pixelRatio: 3.0, // Crisp 3x resolution for social media export
  );
  return pngBytes;
}
```

---

## 🎨 API Reference

### `QuoteStyle`
Defines the default styling for all lines in the canvas:

| Property | Type | Default | Description |
|---|---|---|---|
| `fontSize` | `double` | `24.0` | Default text size in logical pixels. |
| `fontWeight` | `FontWeight` | `FontWeight.w600` | Font weight. |
| `fontStyle` | `FontStyle` | `FontStyle.normal` | Normal or italic. |
| `fontFamily` | `String?` | `null` | Custom font family. |
| `color` | `Color` | `Colors.white` | Solid text color (when no gradient is set). |
| `gradient` | `Gradient?` | `null` | Gradient fill applied across text. |
| `gradientDirection` | `GradientDirection` | `leftToRight` | Gradient axis direction (`leftToRight`, `topToBottom`, `topLeftToBottomRight`). |
| `strokeColor` | `Color` | `Colors.black` | Outline / stroke color. |
| `strokeWidth` | `double` | `0.0` | Outline width (`0` disables outline). |
| `shadowColor` | `Color` | `Colors.black54` | Drop shadow color. |
| `shadowOffset` | `Offset` | `Offset(1.0, 1.0)` | Drop shadow 2D offset. |
| `shadowBlurRadius` | `double` | `2.0` | Drop shadow blur radius. |
| `textAlign` | `TextAlign` | `TextAlign.center` | Alignment of text within container. |
| `lineHeight` | `double` | `1.4` | Line height multiplier. |
| `letterSpacing` | `double` | `0.0` | Spacing between characters. |

---

### `LineStyle`
Allows overriding properties for specific `TextLine` entries:

| Property | Type | Description |
|---|---|---|
| `fontSize` | `double?` | Line-specific font size. |
| `fontWeight` | `FontWeight?` | Line-specific font weight. |
| `color` | `Color?` | Line-specific color. |
| `gradient` | `Gradient?` | Line-specific gradient. |
| `strokeColor` | `Color?` | Line-specific outline color. |
| `strokeWidth` | `double?` | Line-specific outline width. |
| `shadowColor` | `Color?` | Line-specific shadow color. |
| `textAlign` | `TextAlign?` | Line-specific alignment (`left`, `center`, `right`). |

---

### `QuoteCanvas`
The Flutter widget that wraps the custom painter:

| Parameter | Type | Default | Description |
|---|---|---|---|
| `lines` | `List<TextLine>` | **required** | Ordered list of `TextLine` objects to paint. |
| `quoteStyle` | `QuoteStyle` | **required** | Base typography and styling configuration. |
| `width` | `double` | **required** | Canvas width in logical pixels. |
| `height` | `double` | **required** | Canvas height in logical pixels. |
| `backgroundColor` | `Color?` | `null` | Solid background color. |
| `backgroundDecoration` | `BoxDecoration?` | `null` | Full background decoration with gradients, borders, shadows. |
| `padding` | `EdgeInsetsGeometry` | `EdgeInsets.zero` | Inner padding around text lines. |

---

## 🧪 Testing

```bash
flutter test
flutter analyze
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
