import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/classQuestion.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Question>> getQuestions() async {
    List<Question> questions = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('questions').get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (var doc in docs) {
        Question question = Question.fromMap(doc.data() as Map<String, dynamic>);
        questions.add(question);
      }
    } catch (e) {
      print('Erreur lors de la récupération des questions: $e');
    }

    return questions;
  }
}