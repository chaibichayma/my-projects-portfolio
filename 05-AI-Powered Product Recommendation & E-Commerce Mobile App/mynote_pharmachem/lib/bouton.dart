import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getQuizzes() async {
  try {
    // Votre logique pour récupérer les quizzes depuis Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Quizes')
        .get();
    List<DocumentSnapshot<Map<String, dynamic>>> quizSnapshots = querySnapshot.docs;
    return quizSnapshots;
  } catch (e) {
    throw Exception('Erreur lors de la récupération des quiz: $e');
  }
}
}
