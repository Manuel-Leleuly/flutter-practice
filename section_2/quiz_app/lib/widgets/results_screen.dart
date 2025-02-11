import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/models/question_result.dart';
import 'package:quiz_app/widgets/questions_summary/questions_summary.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> chosenAnswers;
  final VoidCallback onRestart;

  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
  });

  List<QuestionResult> get summaryData {
    final List<QuestionResult> summary = [];

    chosenAnswers.asMap().forEach((index, answer) {
      summary.add(QuestionResult(
        questionIndex: index,
        question: questions[index].text,
        correctAnswer: questions[index].answers[0],
        userAnswer: chosenAnswers[index],
      ));
    });

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final int numTotalQuestions = questions.length;
    final int numCorrectQuestions = summaryData.fold(
      0,
      (previousValue, data) {
        if (data.userAnswer == data.correctAnswer) {
          return previousValue + 1;
        }
        return previousValue;
      },
    );

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 230, 200, 253),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            QuestionsSummary(summaryData: summaryData),
            SizedBox(height: 30),
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: Text('Restart Quiz'),
            )
          ],
        ),
      ),
    );
  }
}
