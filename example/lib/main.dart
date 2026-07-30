import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

void main() => runApp(const QuoteDemoApp());

class QuoteDemoApp extends StatelessWidget {
  const QuoteDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Painter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const QuoteDemoScreen(),
    );
  }
}

class QuoteDemoScreen extends StatelessWidget {
  const QuoteDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const quoteStyle = QuoteStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      strokeColor: Colors.black,
      strokeWidth: 1.5,
      shadowColor: Color(0x80000000),
      shadowOffset: Offset(2, 2),
      shadowBlurRadius: 4,
      textAlign: TextAlign.center,
      lineHeight: 1.5,
      gradient: LinearGradient(
        colors: [Colors.amber, Colors.orangeAccent],
      ),
    );

    const lines = [
      TextLine('The only way to'),
      TextLine('do great work'),
      TextLine('is to love what you do.'),
      TextLine('— Steve Jobs',
          style: LineStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            textAlign: TextAlign.right,
          )),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quote Painter')),
      body: const Center(
        child: QuoteCanvas(
          lines: lines,
          quoteStyle: quoteStyle,
          width: 350,
          height: 300,
          padding: EdgeInsets.all(24),
          backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
          ),
        ),
      ),
    );
  }
}
