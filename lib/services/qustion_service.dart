import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';
import '../utils/constants.dart';

class QuestionService {
  static Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString(questionsJsonPath);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }
}