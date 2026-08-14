/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/questionpage.dart';
class QuestionScreen extends StatelessWidget {
  final DocumentSnapshot questionSnapshot;

  QuestionScreen(this.questionSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Question')),
      body: Column(
        children: [
          Text(questionSnapshot['question_text']),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OptionListScreen(questionSnapshot),
                ),
              );
            },
            child: Text('Voir les options'),
          ),
        ],
      ),
    );
  }
}*/