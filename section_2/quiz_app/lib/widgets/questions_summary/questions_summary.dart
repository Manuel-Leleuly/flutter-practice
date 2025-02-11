import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_result.dart';
import 'package:quiz_app/widgets/questions_summary/summary_item.dart';

class QuestionsSummary extends StatelessWidget {
  final List<QuestionResult> summaryData;

  const QuestionsSummary({
    super.key,
    required this.summaryData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map(
            (data) {
              return SummaryItem(itemData: data);
            },
          ).toList(),
        ),
      ),
    );
  }
}
