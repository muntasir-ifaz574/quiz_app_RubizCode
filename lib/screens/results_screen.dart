// lib/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/score_model.dart';
import '../providers/quiz_provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final score = provider.calculateScore();
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score / ${provider.questions.length}'),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Enter your name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  final newScore = Score(
                    playerName: _nameController.text,
                    score: score,
                    timestamp: DateTime.now(),
                  );
                  await StorageService.saveScore(newScore);
                  if (mounted){
                    Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
                  }
                }
              },
              child: const Text('Save Score'),
            ),
          ],
        ),
      ),
    );
  }
}