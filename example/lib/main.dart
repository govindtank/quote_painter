import 'package:flutter/material.dart';
import 'package:quote_painter/quote_painter.dart';

void main() => runApp(const QuoteDemoApp());

class QuoteDemoApp extends StatelessWidget {
  const QuoteDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Painter Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const QuoteStudioScreen(),
    );
  }
}

class QuoteStudioScreen extends StatefulWidget {
  const QuoteStudioScreen({super.key});

  @override
  State<QuoteStudioScreen> createState() => _QuoteStudioScreenState();
}

class _QuoteStudioScreenState extends State<QuoteStudioScreen> {
  int _selectedThemeIndex = 1;

  final List<(String, QuoteStyle)> _themes = [
    ('Editorial', QuoteThemes.editorial),
    ('Cyberpunk', QuoteThemes.cyberpunkNeon),
    ('Minimalist', QuoteThemes.minimalistDark),
    ('Sunset Glow', QuoteThemes.sunsetGlow),
    ('Badge Pill', QuoteThemes.highlightedBadge),
  ];

  @override
  Widget build(BuildContext context) {
    final currentStyle = _themes[_selectedThemeIndex].$2;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Quote Painter Studio'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Theme selection selector chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_themes.length, (index) {
                  final isSelected = _selectedThemeIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_themes[index].$1),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedThemeIndex = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Live Quote Canvas Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: QuoteCanvas(
                  width: 350,
                  height: 260,
                  quoteStyle: currentStyle,
                  lines: const [
                    TextLine(
                      '“Simplicity is the soul',
                      style: LineStyle(
                        highlight: LineHighlight(
                          color: Color(0x2200E5FF),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                      ),
                    ),
                    TextLine('of efficiency and the'),
                    TextLine('heart of great design.”'),
                    TextLine(
                      '— Austin Freeman',
                      style: LineStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                  padding: const EdgeInsets.all(24),
                  backgroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E1E2E), Color(0xFF0F0F1A)],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Auto-Wrap section preview
            const Text(
              'Auto-Wrap Paragraph Layout (QuotePainter.fromText)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: CustomPaint(
                size: const Size(318, 110),
                painter: QuotePainter.fromText(
                  text:
                      'Creativity is thinking up new things. Innovation is doing new things.',
                  quoteStyle: QuoteThemes.sunsetGlow.copyWith(fontSize: 18),
                  maxWidth: 318,
                  maxHeight: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
