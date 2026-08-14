import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/bouton.dart';
import 'package:mynote_pharmachem/detailsQuiz.dart';
import 'package:mynote_pharmachem/quizscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class QuizListScreen extends StatelessWidget {
  final QuizService _quizService = QuizService();
  final String userId;
  QuizListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 45), // Hauteur de l'appbar augmentée de 20 pixels
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Text(
              'Quiz',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            centerTitle: true,
            elevation: 0, // Supprimer l'ombre sous l'appbar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: 160,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/quiz.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
              future: _quizService.getQuizzes(),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<DocumentSnapshot<Map<String, dynamic>>> quizzes = snapshot.data!;
                  return ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      String quizName = quizzes[index]['quizName'];
                      String imageUrl = quizzes[index]['imageUrl'];
                      return GestureDetector(
                        onTap: () async {
                          QuerySnapshot<Map<String, dynamic>> questionSnapshot = await FirebaseFirestore.instance
                              .collection('Quizes')
                              .doc(quizzes[index].id)
                              .collection('questions')
                              .get();

                          // Vérifiez s'il y a des questions dans le quiz
                          if (questionSnapshot.docs.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionListScreen(
                                  quizSnapshot: quizzes[index], // Passer la valeur correcte
                                  questionsList: questionSnapshot.docs,
                                  userId: userId,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Pas de questions'),
                                  content: Text('Ce quiz n\'a pas de questions.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                imageUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                quizName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}