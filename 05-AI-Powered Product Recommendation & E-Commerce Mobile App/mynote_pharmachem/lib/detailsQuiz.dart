import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/congratulationspage.dart';
import 'dart:async';
class QuestionListScreen extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> quizSnapshot;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> questionsList;
  final String userId;


  QuestionListScreen({
    required this.quizSnapshot,
    required this.questionsList,
    required this.userId,
  });

  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  int currentQuestionIndex = 0;
  List<bool> hasAnsweredQuestionList = [];
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    hasAnsweredQuestionList = List.filled(widget.questionsList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          widget.quizSnapshot.data()!['quizName'],
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Image.asset('images/quizpage.png'),
            SizedBox(height: 15),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE5DBED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.questionsList[currentQuestionIndex].data()!['question_text'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    FutureBuilder<QuerySnapshot>(
                      future: widget.questionsList[currentQuestionIndex].reference.collection('options').get(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Erreur: ${snapshot.error}'),
                          );
                        } else {
                          List<QueryDocumentSnapshot> options = snapshot.data!.docs;
                          if (options.isEmpty) {
                            return Center(
                              child: Text('Aucune option disponible pour cette question.'),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...options.map((optionSnapshot) {
                                String optionText = optionSnapshot['option_text'];
                                String optionId = optionSnapshot['option_id'];
                                bool isOptionSelected = hasAnsweredQuestionList[currentQuestionIndex];
                                bool isCorrectAnswer = optionId == widget.questionsList[currentQuestionIndex]['correct_answer'];
                                Color optionColor = Colors.white; // Couleur de l'option par défaut

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: isOptionSelected
                                          ? null
                                          : () async {
                                              if (isCorrectAnswer) {
                                                setState(() {
                                                  userScore += 10;
                                                });
                                              }

                                              setState(() {
                                                hasAnsweredQuestionList[currentQuestionIndex] = true;
                                                currentQuestionIndex = (currentQuestionIndex + 1) % widget.questionsList.length;
                                              });

                                              bool allQuestionsAnswered = hasAnsweredQuestionList.every((answered) => answered);
                                              if (allQuestionsAnswered) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CongratulationsScreen(newScore: userScore, userId: widget.userId,),
                                                  ),
                                                );
                                              }
                                            },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: optionColor,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: Text(optionText),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 11), // SizedBox entre les options
                                  ],
                                );
                              }).toList(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}