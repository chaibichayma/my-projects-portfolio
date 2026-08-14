import 'package:mynote_pharmachem/classOptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Question {
  final String questionId;
  final String questionText;
  final int points;
  final String correctAnswer;
  final List<Option> options;

  Question({
    required this.questionId,
    required this.questionText,
    required this.points,
    required this.correctAnswer,
    required this.options,
  });
  factory Question.fromMap(Map<String, dynamic> map) {
    List<dynamic> optionsData = map['options'];
    List<Option> options = optionsData.map((optionData) => Option.fromMap(optionData)).toList();

    return Question(
      questionId: map['question_id'],
      questionText: map['question_text'],
      correctAnswer: map['correct_answer'],
      points: map['points'],
      options: options,
    );
  }
}