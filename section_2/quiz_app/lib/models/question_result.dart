class QuestionResult {
  final int questionIndex;
  final String question;
  final String correctAnswer;
  final String userAnswer;

  const QuestionResult({
    required this.questionIndex,
    required this.question,
    required this.correctAnswer,
    required this.userAnswer,
  });
}
