import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/score_model.dart';

class StorageService {
  static Future<Database> _getDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'quiz.db');
    return openDatabase(dbPath);
  }

  static Future<void> saveScore(Score score) async {
    final db = await _getDatabase();
    await db.insert('scores', score.toMap().without('id'));
  }

  static Future<List<Score>> getLeaderboard() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      orderBy: 'score DESC, timestamp DESC',
    );
    return maps.map((map) => Score.fromMap(map)).toList();
  }
}

extension MapWithout on Map<String, dynamic> {
  Map<String, dynamic> without(String key) {
    return Map.from(this)..remove(key);
  }
}