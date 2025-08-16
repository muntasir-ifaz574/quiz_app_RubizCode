import 'package:flutter/material.dart';
import 'latex_text.dart';

class AnswerOption extends StatelessWidget {
  final String option;
  final int index;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isSelected
        ? Colors.blue
        : isDarkMode
        ? Colors.black
        : Colors.white;
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 50,
          maxWidth: double.infinity,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF1573F1),
          ),
        ),
        child: LatexText(
          tex: option,
          fontSize: 16,
        ),
      ),
    );
  }
}