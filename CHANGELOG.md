## 0.2.1

* Updated preview screenshot and UI alignment in documentation.

## 0.2.0

* Added `QuotePainter.fromText(...)` for automatic word-wrapping and line calculations to fit bounding constraints.
* Added `QuoteMarkStyle` and `QuoteMarkPlacement` for customizable typographic quotation mark embellishments (`“`, `”`, `«`, `»`).
* Added `LineHighlight` for background highlight pill badges, gradient badges, and borders per line.
* Added pre-built typography and visual presets in `QuoteThemes` (`editorial`, `cyberpunkNeon`, `minimalistDark`, `sunsetGlow`, `highlightedBadge`).
* Added unit & widget tests covering automated wrapping, decorators, and themes.

## 0.1.1

* Added `platforms` declaration (android, ios, linux, macos, windows, web).

## 0.1.0

* Initial release: Flutter package for rendering styled text on image/video canvas.
* Gradient fill, stroke, shadow, and per-line alignment.
* Headless `QuotePainter` for exporting quotes as PNG images.
* `QuoteStyle` with full text styling control (font size, weight, colors, spacing).
