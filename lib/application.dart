import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/screens/category_screen.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/results_screen.dart';
import 'package:quiz_app/utils/constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        initialRoute: homeRoute,
        routes: {
          homeRoute: (_) => const HomeScreen(),
          categoryRoute: (_) => const CategoryScreen(),
          quizRoute: (_) => const QuizScreen(),
          resultsRoute: (_) => const ResultsScreen(),
          leaderboardRoute: (_) => const LeaderboardScreen(),
        },
      ),
    );
  }
}