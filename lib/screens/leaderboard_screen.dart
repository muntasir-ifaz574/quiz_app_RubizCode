import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../services/storage_service.dart';
import '../widgets/score_title.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Score> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await StorageService.getLeaderboard();
    setState(() {
      _scores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: _scores.isEmpty
          ? const Center(child: Text('No scores yet'))
          : ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          return ScoreTile(score: _scores[index], rank: index + 1);
        },
      ),
    );
  }
}