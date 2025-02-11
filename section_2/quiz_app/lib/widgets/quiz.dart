import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/widgets/questions_screen.dart';
import 'package:quiz_app/widgets/results_screen.dart';
import 'package:quiz_app/widgets/start_screen.dart';

enum QuizScreen {
  start,
  questions,
  result,
}

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  QuizScreen activeScreen = QuizScreen.start;

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = QuizScreen.result;
      });
    }
  }

  void switchScreen() {
    setState(() {
      activeScreen = QuizScreen.questions;
    });
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = QuizScreen.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartScreen(onQuizStart: switchScreen);

    switch (activeScreen) {
      case QuizScreen.start:
        screenWidget = StartScreen(onQuizStart: switchScreen);
        break;
      case QuizScreen.questions:
        screenWidget = QuestionsScreen(onSelectAnswer: chooseAnswer);
        break;
      case QuizScreen.result:
        screenWidget = ResultsScreen(
          chosenAnswers: selectedAnswers,
          onRestart: restartQuiz,
        );
        break;
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
