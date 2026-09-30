import 'package:flutter/material.dart';

/// Gradient direction for text fill.
enum GradientDirection {
  leftToRight,
  topToBottom,
  diagonalTopLeft,
  diagonalTopRight,
}

/// Placement for decorative quotation marks.
enum QuoteMarkPlacement {
  topLeft,
  topCenter,
  topRight,
  bothSides,
}

/// Configuration for decorative quotation marks embellishment.
class QuoteMarkStyle {
  /// Whether to render decorative quotation marks.
  final bool show;

  /// The character/glyph to use for opening quote (e.g. `“`, `«`, `„`).
  final String openingMark;

  /// The character/glyph to use for closing quote (e.g. `”`, `»`, `”`).
  final String closingMark;

  /// Placement of quotation marks.
  final QuoteMarkPlacement placement;

  /// Font size of the quotation marks.
  final double fontSize;

  /// Color of the quotation marks.
  final Color color;

  /// Font family for the quotation marks.
  final String? fontFamily;

  /// Offset adjustment for opening mark.
  final Offset openingOffset;

  /// Offset adjustment for closing mark.
  final Offset closingOffset;

  /// Opacity multiplier (0.0 to 1.0).
  final double opacity;

  const QuoteMarkStyle({
    this.show = false,
    this.openingMark = '“',
    this.closingMark = '”',
    this.placement = QuoteMarkPlacement.topLeft,
    this.fontSize = 48.0,
    this.color = const Color(0x66FFFFFF),
    this.fontFamily,
    this.openingOffset = Offset.zero,
    this.closingOffset = Offset.zero,
    this.opacity = 0.6,
  });

  QuoteMarkStyle copyWith({
    bool? show,
    String? openingMark,
    String? closingMark,
    QuoteMarkPlacement? placement,
    double? fontSize,
    Color? color,
    String? fontFamily,
    Offset? openingOffset,
    Offset? closingOffset,
    double? opacity,
  }) {
    return QuoteMarkStyle(
      show: show ?? this.show,
      openingMark: openingMark ?? this.openingMark,
      closingMark: closingMark ?? this.closingMark,
      placement: placement ?? this.placement,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      openingOffset: openingOffset ?? this.openingOffset,
      closingOffset: closingOffset ?? this.closingOffset,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Background highlight / pill badge style for a text line.
class LineHighlight {
  /// Background color for the line highlight.
  final Color color;

  /// Optional gradient for the highlight box.
  final Gradient? gradient;

  /// Corner radius for the highlight rectangle.
  final BorderRadius borderRadius;

  /// Padding around the line of text.
  final EdgeInsets padding;

  /// Border outline for the highlight box.
  final BorderSide? border;

  const LineHighlight({
    this.color = const Color(0x33FFFFFF),
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    this.border,
  });

  LineHighlight copyWith({
    Color? color,
    Gradient? gradient,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    BorderSide? border,
  }) {
    return LineHighlight(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      border: border ?? this.border,
    );
  }
}

/// Per-line style overrides.
class LineStyle {
  final Color? color;
  final Gradient? gradient;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final Color? strokeColor;
  final double? strokeWidth;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final double? letterSpacing;
  final TextAlign? textAlign;

  /// Optional highlight badge / background pill for this specific line.
  final LineHighlight? highlight;

  const LineStyle({
    this.color,
    this.gradient,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.strokeColor,
    this.strokeWidth,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.letterSpacing,
    this.textAlign,
    this.highlight,
  });

  LineStyle merge(LineStyle? other) {
    if (other == null) return this;
    return LineStyle(
      color: other.color ?? color,
      gradient: other.gradient ?? gradient,
      fontSize: other.fontSize ?? fontSize,
      fontWeight: other.fontWeight ?? fontWeight,
      fontStyle: other.fontStyle ?? fontStyle,
      fontFamily: other.fontFamily ?? fontFamily,
      strokeColor: other.strokeColor ?? strokeColor,
      strokeWidth: other.strokeWidth ?? strokeWidth,
      shadowColor: other.shadowColor ?? shadowColor,
      shadowOffset: other.shadowOffset ?? shadowOffset,
      shadowBlurRadius: other.shadowBlurRadius ?? shadowBlurRadius,
      letterSpacing: other.letterSpacing ?? letterSpacing,
      textAlign: other.textAlign ?? textAlign,
      highlight: other.highlight ?? highlight,
    );
  }
}

/// Configuration for quote text rendering.
class QuoteStyle {
  final Color color;
  final Gradient? gradient;
  final GradientDirection gradientDirection;
  final Color strokeColor;
  final double strokeWidth;
  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String? fontFamily;
  final TextAlign textAlign;
  final double lineHeight;
  final double letterSpacing;

  /// Default line highlight style for all lines (can be overridden per line).
  final LineHighlight? defaultHighlight;

  /// Decorative quote mark style.
  final QuoteMarkStyle quoteMarkStyle;

  const QuoteStyle({
    this.color = Colors.white,
    this.gradient,
    this.gradientDirection = GradientDirection.leftToRight,
    this.strokeColor = Colors.black,
    this.strokeWidth = 0.0,
    this.shadowColor = Colors.black54,
    this.shadowOffset = const Offset(1.0, 1.0),
    this.shadowBlurRadius = 2.0,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.w600,
    this.fontStyle = FontStyle.normal,
    this.fontFamily,
    this.textAlign = TextAlign.center,
    this.lineHeight = 1.4,
    this.letterSpacing = 0.0,
    this.defaultHighlight,
    this.quoteMarkStyle = const QuoteMarkStyle(),
  });

  QuoteStyle copyWith({
    Color? color,
    Gradient? gradient,
    GradientDirection? gradientDirection,
    Color? strokeColor,
    double? strokeWidth,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
    TextAlign? textAlign,
    double? lineHeight,
    double? letterSpacing,
    LineHighlight? defaultHighlight,
    QuoteMarkStyle? quoteMarkStyle,
  }) {
    return QuoteStyle(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      gradientDirection: gradientDirection ?? this.gradientDirection,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      defaultHighlight: defaultHighlight ?? this.defaultHighlight,
      quoteMarkStyle: quoteMarkStyle ?? this.quoteMarkStyle,
    );
  }

  /// Build a [TextStyle] from this config.
  TextStyle toTextStyle({LineStyle? lineOverride}) {
    final ls = lineOverride;
    return TextStyle(
      color: ls?.color ?? color,
      fontSize: ls?.fontSize ?? fontSize,
      fontWeight: ls?.fontWeight ?? fontWeight,
      fontStyle: ls?.fontStyle ?? fontStyle,
      fontFamily: ls?.fontFamily ?? fontFamily,
      letterSpacing: ls?.letterSpacing ?? letterSpacing,
      height: lineHeight,
    );
  }

  /// Resolve effective text alignment for a line.
  TextAlign resolveAlign({LineStyle? lineOverride}) {
    return lineOverride?.textAlign ?? textAlign;
  }

  /// Resolve effective highlight style for a line.
  LineHighlight? resolveHighlight({LineStyle? lineOverride}) {
    return lineOverride?.highlight ?? defaultHighlight;
  }

  /// Resolve the gradient for a given [Rect], applying direction.
  Gradient? resolveGradient(Rect rect, {LineStyle? lineOverride}) {
    final g = lineOverride?.gradient ?? gradient;
    if (g != null) return g;
    return null;
  }
}

/// Curated typography themes ready to use out of the box.
class QuoteThemes {
  const QuoteThemes._();

  /// Elegant editorial serif theme with warm accents.
  static QuoteStyle get editorial => const QuoteStyle(
        color: Color(0xFF1E293B),
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        lineHeight: 1.5,
        letterSpacing: 0.2,
        textAlign: TextAlign.center,
        shadowColor: Colors.transparent,
        quoteMarkStyle: QuoteMarkStyle(
          show: true,
          color: Color(0x331E293B),
          fontSize: 54.0,
          placement: QuoteMarkPlacement.topLeft,
        ),
      );

  /// Futuristic cyberpunk neon theme with vibrant gradient & glowing shadow.
  static QuoteStyle get cyberpunkNeon => const QuoteStyle(
        color: Color(0xFF00F0FF),
        gradient: LinearGradient(
          colors: [Color(0xFF00F0FF), Color(0xFFFF007F)],
        ),
        fontSize: 26.0,
        fontWeight: FontWeight.w800,
        lineHeight: 1.35,
        letterSpacing: 1.2,
        textAlign: TextAlign.center,
        strokeColor: Color(0xFF0D0221),
        strokeWidth: 1.0,
        shadowColor: Color(0xAA00F0FF),
        shadowBlurRadius: 12.0,
        shadowOffset: Offset(0, 0),
        quoteMarkStyle: QuoteMarkStyle(
          show: true,
          color: Color(0x88FF007F),
          fontSize: 48.0,
          placement: QuoteMarkPlacement.bothSides,
        ),
      );

  /// Sleek minimalist dark theme with clean sans-serif typography.
  static QuoteStyle get minimalistDark => const QuoteStyle(
        color: Color(0xFFF8FAFC),
        fontSize: 24.0,
        fontWeight: FontWeight.w500,
        lineHeight: 1.6,
        letterSpacing: 0.5,
        textAlign: TextAlign.center,
        shadowColor: Color(0x40000000),
        shadowBlurRadius: 4.0,
        shadowOffset: Offset(0, 2),
      );

  /// Warm sunset theme with orange/gold gradient text and subtle highlight.
  static QuoteStyle get sunsetGlow => const QuoteStyle(
        color: Color(0xFFFF7E5F),
        gradient: LinearGradient(
          colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
        ),
        fontSize: 26.0,
        fontWeight: FontWeight.w700,
        lineHeight: 1.4,
        letterSpacing: 0.3,
        textAlign: TextAlign.center,
        shadowColor: Color(0x66000000),
        shadowBlurRadius: 6.0,
        shadowOffset: Offset(1, 2),
      );

  /// Modern highlighted badge theme with pill background per line.
  static QuoteStyle get highlightedBadge => const QuoteStyle(
        color: Colors.white,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        lineHeight: 1.5,
        textAlign: TextAlign.center,
        shadowColor: Colors.transparent,
        defaultHighlight: LineHighlight(
          color: Color(0xDD1E1E2E),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
      );
}

/// Watermark placement options for canvas exports.
enum WatermarkPosition {
  /// Bottom right corner of image canvas.
  bottomRight,

  /// Bottom left corner of image canvas.
  bottomLeft,

  /// Top right corner.
  topRight,
}
