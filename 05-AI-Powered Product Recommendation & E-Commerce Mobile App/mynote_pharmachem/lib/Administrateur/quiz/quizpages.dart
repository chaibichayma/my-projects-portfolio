import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/quiz/questionmodel.dart';

class QuizAdminScreen extends StatefulWidget {
  @override
  _QuizAdminScreenState createState() => _QuizAdminScreenState();
}

class _QuizAdminScreenState extends State<QuizAdminScreen> {
  Map<String, bool> _isExpandedMap = {}; // Map pour stocker l'état d'expansion de chaque question
  void editQuestion(DocumentSnapshot questionDoc) async {
  TextEditingController questionController =
      TextEditingController(text: questionDoc['question_text']);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Modifier la question"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Nouvelle question'),
              onChanged: (value) {
                // Vous pouvez stocker la valeur modifiée dans un StatefulWidget si nécessaire
              },
            ),
            // Ajoutez des champs pour modifier les options si nécessaire
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
  String newQuestionText = questionController.text.trim();
  if (newQuestionText.isNotEmpty) {
    try {
      await questionDoc.reference.update({
        'question_text': newQuestionText,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question mise à jour avec succès')),
      );
      setState(() {}); // Rebuild the widget to reflect changes
    } catch (e) {
      print('Erreur lors de la mise à jour de la question : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue lors de la mise à jour de la question')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez saisir une question valide')),
    );
  }
  Navigator.of(context).pop();
},
            child: Text("Enregistrer"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler"),
          ),
        ],
      );
    },
  );
}
void deleteOption(String quizId, String questionId, String optionId) async {
  try {
    // Référence au document de l'option dans la sous-collection 'options'
    DocumentReference optionRef = FirebaseFirestore.instance
        .collection('Quizes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId)
        .collection('options')
        .doc(optionId);

    // Suppression du document de l'option
    await optionRef.delete();

    // Affichage d'un message de succès
    print('Option supprimée avec succès');
  } catch (e) {
    // Gestion des erreurs
    print('Erreur lors de la suppression de l\'option : $e');
  }
}
void deleteQuestion(String quizId, String questionId) async {
  try {
    // Référence au document de la question dans la sous-collection 'questions'
    DocumentReference questionRef = FirebaseFirestore.instance
        .collection('Quizes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId);

    // Suppression de tous les documents de la sous-collection 'options' associée à cette question
    QuerySnapshot optionsSnapshot = await questionRef.collection('options').get();
    for (QueryDocumentSnapshot optionDoc in optionsSnapshot.docs) {
      await optionDoc.reference.delete();
    }

    // Suppression du document de la question
    await questionRef.delete();

    // Affichage d'un message de succès
    print('Question et ses options supprimées avec succès');
  } catch (e) {
    // Gestion des erreurs
    print('Erreur lors de la suppression de la question et de ses options : $e');
  }
}
void editOption(DocumentSnapshot optionDoc) async {
  TextEditingController optionController =
      TextEditingController(text: optionDoc['option_text']);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Modifier l'option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: optionController,
              decoration: InputDecoration(labelText: 'Nouvelle option'),
              onChanged: (value) {
                // Vous pouvez stocker la valeur modifiée dans un StatefulWidget si nécessaire
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              String newOptionText = optionController.text.trim();
              if (newOptionText.isNotEmpty) {
                try {
                  await optionDoc.reference.update({
                    'option_text': newOptionText,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Option mise à jour avec succès')),
                  );
                  setState(() {}); // Rebuild the widget to reflect changes
                } catch (e) {
                  print('Erreur lors de la mise à jour de l\'option : $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Une erreur est survenue lors de la mise à jour de l\'option')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez saisir une option valide')),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text("Enregistrer"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler"),
          ),
        ],
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Quizes').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final quizDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: quizDocs.length,
            itemBuilder: (ctx, index) {
              final quiz = quizDocs[index];
              return Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: Color(0xFFE5DBED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      title: Text(
                        quiz['quizName'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      
                    ),
                  ),
                  StreamBuilder(
                    stream: quiz.reference.collection('questions').snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> questionSnapshot) {
                      if (questionSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final questionDocs = questionSnapshot.data!.docs;
                      return Column(
                        children: questionDocs.map((questionDoc) {
                          final questionId = questionDoc.id;
                          final isExpanded = _isExpandedMap.containsKey(questionId) ? _isExpandedMap[questionId]! : false;
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8), // Espacement vertical entre les questions
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Couleur de fond gris clair
                                  borderRadius: BorderRadius.circular(12), // Bordure circulaire avec un rayon de 12 pixels
                                ),
                                child: ListTile(
                                  title: Text(
                                    questionDoc['question_text'],
                                    style: TextStyle(
                                      color: Colors.black, // Couleur du texte de la question
                                      fontWeight: FontWeight.bold, // Optionnel : si vous souhaitez que le texte soit en gras
                                      fontSize: 15, // Optionnel : taille de la police pour le texte de la question
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          editQuestion(questionDoc); 
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          deleteQuestion(quiz.id, questionDoc.id); 
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isExpandedMap[questionId] = !isExpanded;
                                    });
                                  },
                                ),
                              ),
                              if (isExpanded)
                                StreamBuilder(
                                  stream: questionDoc.reference.collection('options').snapshots(),
                                  builder: (ctx, AsyncSnapshot<QuerySnapshot> optionSnapshot) {
                                    if (optionSnapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    final optionDocs = optionSnapshot.data!.docs;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: optionDocs.length,
                                      itemBuilder: (ctx, index) {
                                        final option = optionDocs[index];
                                        final optionDoc = optionDocs[index]; 
                                        return Container(
                                          margin: EdgeInsets.symmetric(vertical: 4), // Espacement vertical entre les options
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Couleur de fond blanc
                                            borderRadius: BorderRadius.circular(8), // Bordure circulaire avec un rayon de 8 pixels
                                            border: Border.all(color: Colors.grey), // Bordure grise
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              option['option_text'],
                                              style: TextStyle(
                                                color: Colors.black, // Couleur du texte des options
                                                fontSize: 15, // Taille de la police pour le texte des options
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    editOption(optionDoc); // Appeler la fonction editOption avec le document de l'option
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    deleteOption(quiz.id, questionDoc.id, optionDoc.id); 
                                                },
                                              ),
                                            ],
                                          ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
