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
  late final int _score;
  late final int _totalQuestions;
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);
    _score = provider.calculateScore();
    _totalQuestions = provider.questions.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Score: $_score / $_totalQuestions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () async {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your name'),
                        ),
                      );
                      return;
                    }

                    final newScore = Score(
                      playerName: _nameController.text.trim(),
                      score: _score,
                      timestamp: DateTime.now(),
                    );

                    await StorageService.saveScore(newScore);

                    // if (mounted) {
                    if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        homeRoute,
                            (route) => false,
                      );
                    // }
                  },
                  child: const Text(
                    'Save Score',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
