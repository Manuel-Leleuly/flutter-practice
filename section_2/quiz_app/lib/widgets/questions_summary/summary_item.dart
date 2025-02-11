import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/models/question_result.dart';
import 'package:quiz_app/widgets/questions_summary/question_identifier.dart';

class SummaryItem extends StatelessWidget {
  final QuestionResult itemData;

  const SummaryItem({
    super.key,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrectAnswer = itemData.userAnswer == itemData.correctAnswer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionIdentifier(
            questionIndex: itemData.questionIndex,
            isCorrectAnswer: isCorrectAnswer,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemData.question,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  itemData.userAnswer,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 181, 254, 246),
                  ),
                ),
                Text(
                  itemData.correctAnswer,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 181, 254, 246),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
