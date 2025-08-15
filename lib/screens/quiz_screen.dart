import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/latex_text.dart';
import '../widgets/answer_option.dart';
import '../widgets/progress_indicator.dart';
import '../utils/constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      provider.resetQuiz();
      provider.startTimer();
      _animationController.forward();
    });
  }

  void _nextQuestion(QuizProvider provider) {
    _animationController.reverse().then((_) {
      provider.nextQuestion();
      _animationController.forward();
      if (!provider.isQuizComplete) {
        provider.startTimer();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.isQuizComplete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, resultsRoute).then((_) {
              provider.resetQuiz();
            });
          });
          return const SizedBox.shrink();
        }

        final question = provider.questions[provider.currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Q${provider.currentIndex + 1}/${provider.questions.length}',
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      kToolbarHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LatexText(tex: question.question, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: question.options.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final optionAnimation = CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              0.2 + (index * 0.1),
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          );
                          return FadeTransition(
                            opacity: optionAnimation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(optionAnimation),
                              child: AnswerOption(
                                option: question.options[index],
                                index: index,
                                isSelected: provider
                                    .selectedAnswers[provider.currentIndex] ==
                                    index,
                                isLocked: false,
                                onTap: () => provider.selectAnswer(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomProgressIndicator(
                      current: provider.currentIndex + 1,
                      total: provider.questions.length,
                    ),
                    if (provider.timerSeconds > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Time left: ${provider.timerSeconds} seconds',
                        ),
                      ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ElevatedButton(
                          onPressed: provider.selectedAnswers[
                          provider.currentIndex] !=
                              null
                              ? () => _nextQuestion(provider)
                              : null,
                          child: const Text('Next'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}