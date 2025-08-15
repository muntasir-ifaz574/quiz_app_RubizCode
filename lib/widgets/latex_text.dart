import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LatexText extends StatelessWidget {
  final String tex;
  final double fontSize;

  const LatexText({super.key, required this.tex, this.fontSize = 16});

  bool _containsLatex(String text) {
    return text.contains(r'$$') || text.contains(r'\frac') || text.contains(r'\int') || text.contains(r'\sqrt');
  }

  @override
  Widget build(BuildContext context) {
    if (tex.trim().isEmpty) {
      debugPrint('[LatexText] Empty or invalid string.');
      return const Text(
        'Invalid content',
        style: TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    if (!_containsLatex(tex)) {
      debugPrint('[LatexText] Rendering plain text: "$tex"');
      return Text(
        tex,
        style: TextStyle(fontSize: fontSize),
      );
    }

    final latexPattern = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final match = latexPattern.firstMatch(tex);
    final cleanedTex = match != null ? match.group(1)!.trim() : tex.trim();

    debugPrint('[LatexText] Rendering LaTeX: "$cleanedTex"');

    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        minHeight: 50,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Math.tex(
            cleanedTex,
            textStyle: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            mathStyle: MathStyle.text,
            textScaleFactor: fontSize / 18,
            onErrorFallback: (error) {
              debugPrint('[LatexText] ❌ Error rendering LaTeX: $error');
              return Text(
                'Error rendering LaTeX: $error\nContent: $cleanedTex',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            },
          ),
        ),
      ),
    );
  }
}
