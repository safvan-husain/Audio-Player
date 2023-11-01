import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final bool isDark;

  const OutlinedText(this.text, this.isDark, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: CustomPaint(
        painter: TextOutlinePainter(text, isDark),
      ),
    );
  }
}

class TextOutlinePainter extends CustomPainter {
  final String text;
  final bool isDark;

  TextOutlinePainter(this.text, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = GoogleFonts.russoOne(
      fontSize: 40,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = !isDark ? Colors.white : Colors.black,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 2,
      maxWidth: size.width,
    );
    const offset = Offset(0, 0);
    textPainter.paint(canvas, offset);

    final textStyleFill = GoogleFonts.russoOne(
      fontSize: 40,
      color: isDark ? Colors.white : Colors.black,
    );
    final textSpanFill = TextSpan(
      text: text,
      style: textStyleFill,
    );
    final textPainterFill = TextPainter(
      text: textSpanFill,
      textDirection: TextDirection.ltr,
    );
    textPainterFill.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainterFill.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
