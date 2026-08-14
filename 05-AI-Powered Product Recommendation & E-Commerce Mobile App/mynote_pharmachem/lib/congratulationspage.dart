import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/rewardspage.dart';
class CongratulationsScreen extends StatelessWidget {
  final int newScore;
  final String userId;
  

  CongratulationsScreen({required this.newScore, required this.userId}) {
    updateScoreInFirestore(newScore);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user != null ? user.displayName ?? 'Utilisateur' : 'Utilisateur';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Arrière-plan A32CC4
          Positioned.fill(
            child: Container(
              color: Color(0xFFA32CC4),
            ),
          ),
          // Conteneur blanc avec bordure
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1, // Position ajustable selon vos besoins
            left: 20.0, // Marge à gauche
            right: 20.0, // Marge à droite
            child: Container(
              padding: EdgeInsets.all(20.0), // Espacement intérieur du conteneur
              height: MediaQuery.of(context).size.height * 0.7, // Ajustez la hauteur du conteneur blanc
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // Décalage de l'ombre
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/felici.png',
                    height: MediaQuery.of(context).size.height * 0.3, // Hauteur de l'image
                    fit: BoxFit.contain, // Ajuster l'image dans le conteneur
                  ),
                  SizedBox(height: 20), // Espacement entre l'image et le texte
                  Text(
                    'Félicitations, $userName!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10), // Espacement entre le texte et le score
                  Text(
                    'Vous avez terminé le quiz.',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 50), // Espacement entre le texte et le score
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE5DBED), // Couleur de fond E5DBED
                      borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Espacement intérieur du conteneur du score
                    child: Text(
                      'Votre Score: $newScore points',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 40), // Espacement entre le score et le bouton
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RewardsPage(userId: userId,)),
                      );
                    },
                    child: Container(
                      width: double.infinity, // Largeur maximale du conteneur
                      decoration: BoxDecoration(
                        color: Color(0xFFBB7EB2), // Couleur de fond CABFD3
                        borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                        // Enlever la bordure
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Voir Recompense',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), // Couleur du texte noire
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateScoreInFirestore(int newScore) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          int oldScore = (userSnapshot.data() as Map<String, dynamic>)['score'] ?? 0;

          int updatedScore = oldScore + newScore;

          await userRef.update({'score': updatedScore});

          print('Score updated successfully in Firestore.');
        } else {
          await userRef.set({'score': newScore});

          print('New user with score added to Firestore.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error updating score in Firestore: $e');
    }
  }
}