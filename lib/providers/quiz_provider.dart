import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../services/qustion_service.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> questions = [];
  int currentIndex = 0;
  List<int?> selectedAnswers = [];
  int timerSeconds = 15;
  Timer? _timer;
  bool isQuizComplete = false;

  Future<void> loadQuestions() async {
    questions = await QuestionService.loadQuestions();
    selectedAnswers = List<int?>.filled(questions.length, null);
    currentIndex = 0;
    isQuizComplete = false;
    timerSeconds = 15;
    _timer?.cancel();
    notifyListeners();
  }

  Future<void> loadQuestionsForCategory(String category) async {
    final allQuestions = await QuestionService.loadQuestions();
    questions = allQuestions.where((q) => q.category == category).toList();
    selectedAnswers = List<int?>.filled(questions.length, null);
    currentIndex = 0;
    isQuizComplete = false;
    timerSeconds = 15;
    _timer?.cancel();
    notifyListeners();
  }

  void selectAnswer(int index) {
    selectedAnswers[currentIndex] = index;
    notifyListeners();
  }

  void nextQuestion() {
    _timer?.cancel();
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      timerSeconds = 15;
      startTimer();
    } else {
      isQuizComplete = true;
    }
    notifyListeners();
  }

  void startTimer() {
    timerSeconds = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        timerSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }
  int calculateScore() {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selectedAnswer = selectedAnswers[i];
      final correctAnswer = question.answerIndex;

      if (selectedAnswer != null && selectedAnswer == correctAnswer) {
        score++;
      }
    }
    return score;
  }

  void resetQuiz() {
    currentIndex = 0;
    selectedAnswers = List<int?>.filled(questions.length, null);
    isQuizComplete = false;
    timerSeconds = 15;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
