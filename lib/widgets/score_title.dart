import 'package:flutter/material.dart';
import '../models/score_model.dart';

class ScoreTile extends StatelessWidget {
  final Score score;
  final int rank;

  const ScoreTile({super.key, required this.score, required this.rank});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$rank.'),
      title: Text(score.playerName),
      trailing: Text('${score.score}'),
    );
  }
}