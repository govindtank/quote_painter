import 'package:flutter/material.dart';

/// Gradient direction for text fill.
enum GradientDirection {
  leftToRight,
  topToBottom,
  diagonalTopLeft,
  diagonalTopRight,
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

  /// Resolve the gradient for a given [Rect], applying direction.
  Gradient? resolveGradient(Rect rect, {LineStyle? lineOverride}) {
    final g = lineOverride?.gradient ?? gradient;
    if (g != null) return g;
    // No gradient configured -> null (use solid color)
    return null;
  }
}
