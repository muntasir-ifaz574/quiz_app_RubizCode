import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/utils/helpers.dart';

void main() {
  test('Calculate score correctly', () {
    final questions = [
      Question(question: 'Q1', options: ['A', 'B'], answerIndex: 0),
      Question(question: 'Q2', options: ['A', 'B'], answerIndex: 1),
    ];
    final selected = [0, 1];
    expect(calculateScoreHelper(questions, selected), 2);

    final selectedWrong = [1, 0];
    expect(calculateScoreHelper(questions, selectedWrong), 0);
  });
}