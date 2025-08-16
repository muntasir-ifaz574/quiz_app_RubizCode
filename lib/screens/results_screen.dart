import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/score_model.dart';
import '../providers/quiz_provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/latex_text.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScoreAndNavigate(BuildContext context) async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
      return;
    }

    final provider = Provider.of<QuizProvider>(context, listen: false);
    final score = provider.calculateScore();

    final newScore = Score(
      playerName: _nameController.text.trim(),
      score: score,
      timestamp: DateTime.now(),
    );

    try {
      await StorageService.saveScore(newScore);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        homeRoute,
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save score: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final score = provider.calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LatexText(
              tex: 'Your Score: $score',
              fontSize: 24,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveScoreAndNavigate(context),
              child: const Text('Save Score & Return Home'),
            ),
          ],
        ),
      ),
    );
  }
}