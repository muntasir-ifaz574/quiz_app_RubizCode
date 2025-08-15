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
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 100,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFF1573F1)
          )
        ),
        child: LatexText(tex: option, fontSize: 16),
      ),
    );
  }
}
