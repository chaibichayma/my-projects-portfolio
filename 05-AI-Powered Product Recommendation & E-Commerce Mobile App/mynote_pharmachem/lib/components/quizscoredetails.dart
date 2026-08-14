/*import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/classQuestion.dart';
import 'package:mynote_pharmachem/classQuiz.dart';

class QuizDetailsScreen extends StatelessWidget {
  final Quiz quiz;

  QuizDetailsScreen({required this.quiz});

  
  int calculateScore() {
  int score = 0;
  for (Question question in quiz.questions) {
    if (question.selectedOption != null &&
        question.selectedOption!.optionId == question.correctAnswer) {
      score += question.points;
    }
  }
  return score;
}

  @override
  Widget build(BuildContext context) {
    int score = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Your Score: $score'),
          ElevatedButton(
            onPressed: () {
              // Mettez à jour le score dans Firestore ici, si nécessaire
            },
            child: Text('Finish Quiz'),
          ),
        ],
      ),
    );
  }
}*/