import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Captures a [RepaintBoundary] as PNG bytes.
Future<Uint8List> exportToPng(GlobalKey boundaryKey,
    {double pixelRatio = 3.0}) async {
  final boundary = boundaryKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
