import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databasesPath = await getDatabasesPath();
  final dbPath = path.join(databasesPath, 'quiz.db');
  await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  });
  runApp(const MyApp());
}

