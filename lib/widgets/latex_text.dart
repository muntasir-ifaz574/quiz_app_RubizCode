import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LatexText extends StatelessWidget {
  final String tex;
  final double fontSize;
  final Color? textColor;

  const LatexText({
    super.key,
    required this.tex,
    this.fontSize = 16,
    this.textColor,
  });

  bool _containsLatex(String text) {
    return text.contains(r'$$') ||
        text.contains(r'\frac') ||
        text.contains(r'\int') ||
        text.contains(r'\sqrt') ||
        text.contains(r'\pi') ||
        text.contains(r'\^') ||
        text.contains(r'\alpha') ||
        text.contains(r'\beta') ||
        text.contains(r'\gamma') ||
        text.contains(r'\sum');
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
        style: TextStyle(
          fontSize: fontSize,
          color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      );
    }

    if (!tex.contains(r'$$') && _containsLatex(tex)) {
      debugPrint('[LatexText] Rendering full LaTeX: "$tex"');
      return Baseline(
        baseline: fontSize * 0.8,
        baselineType: TextBaseline.alphabetic,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Math.tex(
            tex.trim(),
            textStyle: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            mathStyle: MathStyle.text,
            textScaleFactor: 1.0,
            onErrorFallback: (error) {
              debugPrint('[LatexText] ❌ Error rendering LaTeX: $error');
              return Text(
                'Error rendering LaTeX: $error\nContent: $tex',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            },
          ),
        ),
      );
    }

    final latexPattern = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final parts = <Widget>[];
    int lastEnd = 0;

    for (final match in latexPattern.allMatches(tex)) {
      final start = match.start;
      final end = match.end;
      final latexContent = match.group(1)!.trim();

      if (start > lastEnd) {
        final plainText = tex.substring(lastEnd, start).trim();
        if (plainText.isNotEmpty) {
          parts.add(
            Text(
              plainText,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
              ),
            ),
          );
          parts.add(const SizedBox(width: 4.0));
        }
      }

      if (latexContent.isNotEmpty) {
        debugPrint('[LatexText] Rendering LaTeX: "$latexContent"');
        parts.add(
          Baseline(
            baseline: fontSize * 0.8,
            baselineType: TextBaseline.alphabetic,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Math.tex(
                latexContent,
                textStyle: TextStyle(
                  fontSize: fontSize,
                  color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                ),
                mathStyle: MathStyle.text,
                textScaleFactor: 1.0,
                onErrorFallback: (error) {
                  debugPrint('[LatexText] ❌ Error rendering LaTeX: $error');
                  return Text(
                    'Error rendering LaTeX: $error\nContent: $latexContent',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                },
              ),
            ),
          ),
        );
        parts.add(const SizedBox(width: 4.0));
      }

      lastEnd = end;
    }

    if (lastEnd < tex.length) {
      final plainText = tex.substring(lastEnd).trim();
      if (plainText.isNotEmpty) {
        parts.add(
          Text(
            plainText,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
          ),
        );
      }
    }

    if (parts.isEmpty) {
      final cleanedTex = tex.replaceAll(RegExp(r'\$\$'), '').trim();
      debugPrint('[LatexText] Rendering only LaTeX: "$cleanedTex"');
      return Baseline(
        baseline: fontSize * 0.8,
        baselineType: TextBaseline.alphabetic,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Math.tex(
            cleanedTex,
            textStyle: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
            mathStyle: MathStyle.text,
            textScaleFactor: 1.0,
            onErrorFallback: (error) {
              debugPrint('[LatexText] ❌ Error rendering LaTeX: $error');
              return Text(
                'Error rendering LaTeX: $error\nContent: $cleanedTex',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            },
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: parts,
    );
  }
}