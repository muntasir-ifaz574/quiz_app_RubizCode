class Score {
  final int? id;
  final String playerName;
  final int score;
  final DateTime timestamp;

  Score({
    this.id,
    required this.playerName,
    required this.score,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player_name': playerName,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      playerName: map['player_name'],
      score: map['score'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}