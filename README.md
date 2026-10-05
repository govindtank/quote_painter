# quote_painter

[![Pub Version](https://img.shields.io/pub/v/quote_painter.svg?style=flat-square&color=blue)](https://pub.dev/packages/quote_painter)
[![Pub Points](https://img.shields.io/pub/points/quote_painter?style=flat-square&color=2E8B57&label=pub%20points)](https://pub.dev/packages/quote_painter/score)
[![Pub Likes](https://img.shields.io/pub/likes/quote_painter?style=flat-square)](https://pub.dev/packages/quote_painter)
[![CI](https://github.com/govindtank/quote_painter/actions/workflows/ci.yml/badge.svg)](https://github.com/govindtank/quote_painter/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square)](https://pub.dev/packages/quote_painter)

A high-performance Flutter package for rendering beautifully styled text, inspirational quotes, titles, and captions over image/video canvas surfaces with gradients, outlines, multi-layer shadows, background highlight badges, decorative quote glyphs, ready-to-use themes, per-line overrides, and PNG export.

Now available on **[pub.dev/packages/quote_painter](https://pub.dev/packages/quote_painter)**.

---

<p align="center">
  <img src="https://raw.githubusercontent.com/govindtank/quote_painter/v0.2.1/screenshot.svg" width="450" alt="quote_painter screenshot" />
</p>

---

## ✨ Features

- 🌈 **Gradient Fills** — Full support for Linear and Radial gradients across text characters or solid colors.
- 🖋️ **Strokes & Outlines** — Configurable stroke widths, outline colors, and join styles to make text readable against any backdrop.
- 🌑 **Multi-Layer Shadows** — Customizable blur radius, shadow color, and 2D offset for crisp depth.
- 🏷️ **Line Badges & Highlights** — Add colored or gradient background pills/badges behind text lines (`LineHighlight`).
- ❝ **Decorative Quotation Marks** — Typographic quote mark embellishments (`QuoteMarkStyle`) with smart placement (`QuoteMarkPlacement`).
- 🎨 **Pre-built Typography Themes** — Quick start with `QuoteThemes.editorial`, `QuoteThemes.cyberpunkNeon`, `QuoteThemes.minimalistDark`, `QuoteThemes.sunsetGlow`, and `QuoteThemes.highlightedBadge`.
- 🔄 **Auto-Wrapping Helper** — Split continuous text into properly constrained lines using `QuotePainter.fromText(...)`.
- 📏 **Per-Line Customization** — Override font size, color, gradient, stroke, and text alignment (`left`, `center`, `right`) per individual line.
- 🌐 **Unicode & Mixed Scripts** — Full emoji, multilingual, and complex script support via Flutter's `TextPainter`.
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
  quote_painter: ^0.2.4
```

Then run `flutter pub get` and import:

```dart
import 'package:quote_painter/quote_painter.dart';
```

---

## 🚀 Usage

### 1. Basic Quote Canvas with Presets

Display a styled quote using built-in theme presets:

```dart
import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

class QuoteCardDemo extends StatelessWidget {
  const QuoteCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QuoteCanvas(
        lines: const [
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
        ],
        quoteStyle: QuoteThemes.cyberpunkNeon,
        width: 360,
        height: 260,
        backgroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF0F172A),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 16,
              offset: Offset(0, 8),
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

### 2. Auto-Wrapping Long Quotes (`fromText`)

Generate canvas lines automatically for continuous text:

```dart
final painter = QuotePainter.fromText(
  text: 'Creativity is intelligence having fun.',
  quoteStyle: QuoteThemes.editorial,
  maxWidth: 320,
  maxHeight: 200,
);
```

---

### 3. Decorative Quotation Marks & Line Badges

```dart
final customStyle = QuoteStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  defaultHighlight: const LineHighlight(
    color: Color(0x3300E5FF),
    borderRadius: BorderRadius.all(Radius.circular(6)),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  ),
  quoteMarkStyle: const QuoteMarkStyle(
    show: true,
    color: Color(0x4400E5FF),
    fontSize: 50,
    placement: QuoteMarkPlacement.topLeft,
  ),
);
```

---

### 4. Exporting Canvas to PNG

Easily capture the painted canvas as a PNG image for sharing or video composition:

```dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

final GlobalKey canvasKey = GlobalKey();

// In widget tree:
QuoteCanvas(
  key: canvasKey,
  lines: lines,
  quoteStyle: style,
  width: 1080,
  height: 1920,
)

// In export button callback:
Future<void> saveQuoteImage() async {
  final Uint8List pngBytes = await exportToPng(canvasKey, pixelRatio: 3.0);
  // Save or share pngBytes
}
```

---

## 🛠️ Architecture & API Reference

| Class | Description |
| :--- | :--- |
| `QuoteCanvas` | Interactive/static Flutter widget managing layout, bounding constraints, and export boundary. |
| `QuotePainter` | Core `CustomPainter` rendering lines, gradients, strokes, shadows, and quote marks. |
| `QuotePainter.fromText` | Factory constructing `QuotePainter` with automatic word-wrap layout. |
| `QuoteStyle` | Styling configuration (font, gradients, drop shadows, highlights, quote marks). |
| `QuoteThemes` | Out-of-the-box typography presets (`editorial`, `cyberpunkNeon`, `minimalistDark`, `sunsetGlow`, etc.). |
| `LineHighlight` | Background badge / pill styling per text line. |
| `QuoteMarkStyle` | Typographic quotation marks configuration and placement. |
| `exportToPng` | Headless rasterizer converting a `QuoteCanvas` into PNG bytes. |

---

## 🧪 Testing

```bash
flutter test
```

---

## 🌐 Ecosystem & Related Packages

Explore complementary production-grade libraries built for high-performance Flutter & Dart development:

| Package | Description | Version |
| :--- | :--- | :--- |
| **[`ambient_backdrop_glow`](https://pub.dev/packages/ambient_backdrop_glow)** | Dynamic ambient background glow and fluid animated mesh gradients from image artwork with OKLab color blending for Flutter. | `^1.1.2` |
| **[`country_mobile_validator`](https://pub.dev/packages/country_mobile_validator)** | Validate mobile numbers per country using real length ranges (8-10, 10-11 digits), mobile-only detection, and a country_code_picker-friendly API. | `^0.2.1` |
| **[`cron_schedule`](https://pub.dev/packages/cron_schedule)** | Lightweight, pure-Dart cron parser, next-occurrence predictor, human-readable translator, and fluent schedule builder for Dart and Flutter. | `^1.1.1` |
| **[`currency_field_formatter`](https://pub.dev/packages/currency_field_formatter)** | Bulletproof Flutter currency TextInputFormatter with exact cursor tracking, backspace handling, Indian Lakhs/Crores, and ISO 4217 presets. | `^1.1.1` |
| **[`flutter_whisper`](https://pub.dev/packages/flutter_whisper)** | On-device speech-to-text transcription using whisper.cpp. Automatic model download, streaming segment results, Android support. | `^0.2.1` |
| **[`offline_outbox`](https://pub.dev/packages/offline_outbox)** | Resilient offline-first outbox and retry queue for Dart and Flutter with disk persistence, exponential backoff, priority scheduling, and deduplication. | `^1.1.1` |
| **[`scratch_reveal`](https://pub.dev/packages/scratch_reveal)** | High-performance GPU-accelerated scratch card and scratch-to-reveal canvas widget for Flutter with sub-millisecond bitmask progress tracking. | `^1.1.1` |
| **[`segmented_ring_painter`](https://pub.dev/packages/segmented_ring_painter)** | High-performance segmented circular progress and concentric activity ring widget for Flutter with gradient arcs, rounded caps, gap math, and tap hit-testing. | `^1.1.2` |
| **[`waveform_pro`](https://pub.dev/packages/waveform_pro)** | Production-quality Flutter waveform widget with GPU-accelerated rendering, discrete bars, curved splines, dual-color progress, zoom, markers, and audio peak extraction. | `^1.1.4` |

---

## 💖 Support the Project

If you find this project useful, consider supporting its active maintenance and future development:

<p align="left">
  <a href="https://buymeacoffee.com/govindtanko"><img src="https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
  <a href="https://github.com/sponsors/govindtank"><img src="https://img.shields.io/badge/GitHub%20Sponsors-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors" /></a>
  <a href="https://www.patreon.com/govindtank"><img src="https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon" /></a>
</p>

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Maintained with ❤️ by [Govind Tank](https://github.com/govindtank).*
