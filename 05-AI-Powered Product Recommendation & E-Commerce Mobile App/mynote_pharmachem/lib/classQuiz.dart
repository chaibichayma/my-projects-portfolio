import 'package:mynote_pharmachem/classQuestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Quiz {
  final String quizId;
  final String quizName;
  final String imageUrl;
  final List<Question> questions;
  int totalScore;

  Quiz({
    required this.quizId,
    required this.quizName,
    required this.questions,
    required this.imageUrl,
    this.totalScore = 0,
  });
  factory Quiz.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  List<Question> questions = [];

  if (data['questions'] != null) {
    // Convertir chaque élément de la liste 'questions' en une instance de Question
    List<dynamic> questionsList = data['questions'];
    questionsList.forEach((questionData) {
      Question question = Question.fromMap(questionData);
      questions.add(question);
    });
  }

  return Quiz(
    quizId: snapshot.id,
    quizName: data['quizName'],
    imageUrl: data['imageUrl'],
    questions: questions,
  );
}
}