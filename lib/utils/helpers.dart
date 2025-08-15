import '../models/question_model.dart';

int calculateScoreHelper(List<Question> questions, List<int?> selectedAnswers) {
  int score = 0;
  for (int i = 0; i < questions.length; i++) {
    if (selectedAnswers[i] == questions[i].answerIndex) {
      score++;
    }
  }
  return score;
}