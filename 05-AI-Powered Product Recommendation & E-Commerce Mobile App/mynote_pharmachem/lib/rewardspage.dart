import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote_pharmachem/classgagne.dart';
import 'package:mynote_pharmachem/rewardsclass.dart';

class RewardsPage extends StatelessWidget {
  final String userId;

  RewardsPage({required this.userId});

  Stream<int> fetchTotalUserPointsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => (doc.data() as Map<String, dynamic>?)?['score'] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA32CC4), // Couleur de fond de la page
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retourner à la page précédente
          },
        ),
        toolbarHeight: 30,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20), // Marge autour du conteneur blanc
        padding: EdgeInsets.all(20), // Padding à l'intérieur du conteneur blanc
        decoration: BoxDecoration(
          color: Colors.white, // Couleur de fond du conteneur blanc
          borderRadius: BorderRadius.circular(20), // Bordure circulaire du conteneur
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centrage des éléments dans la ligne
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Alignement des éléments au centre
                children: [
                  Container(
                    alignment: Alignment.center, // Centrage de l'image à l'intérieur du conteneur
                    child: Image.asset(
                      'images/giftt.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 40),
                  StreamBuilder<int>(
                    stream: fetchTotalUserPointsStream(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error fetching user points: ${snapshot.error}'));
                      } else {
                        int totalUserPoints = snapshot.data ?? 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // Alignement des éléments au centre
                          children: [
                            Text(
                              'Les points totales sont:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFE5DBED), // Arrière-plan du conteneur pour les points
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$totalUserPoints points',
                                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<Reward>>(
                      future: fetchRewardsFromFirestore(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error fetching rewards: ${snapshot.error}'));
                        } else {
                          List<Reward> rewards = snapshot.data ?? [];

                          return ListView.builder(
                            itemCount: rewards.length,
                            itemBuilder: (context, index) {
                              Reward reward = rewards[index];

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
  title: Text(reward.name_recompense),
  subtitle: Text(reward.description_recompense),
  trailing: Container(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: Color(0xFFE5DBED),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      '${reward.pointsRequired} points',
      style: TextStyle(fontSize: 14, color: Colors.black),
    ),
  ),
  onTap: () async {
    int currentPoints = await fetchTotalUserPointsFromFirestore(userId);

    if (currentPoints >= reward.pointsRequired) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmer l\'échange'),
          content: Text('Etes-vous sûr de vouloir échanger ${reward.pointsRequired} points pour ${reward.name_recompense}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                exchangePointsForReward(reward);
                Navigator.pop(context);
                showCongratulationsAlert(context, reward.name_recompense);
              },
              child: Text('Confirmer'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Points insuffisants'),
          content: Text('Vous n\'avez pas suffisamment de points pour échanger cette récompense.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  },
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
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> fetchTotalUserPointsFromFirestore(String userId) async {
  int totalPoints = 0;

  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      totalPoints = (userSnapshot.data() as Map<String, dynamic>?)?['score'] ?? 0;
    } else {
      print('Document utilisateur introuvable.');
    }

    return totalPoints;
  } catch (e) {
    print('Erreur lors de la récupération du total des points utilisateur: $e');
    return 0;
  }
}
  Future<List<Reward>> fetchRewardsFromFirestore() async {
    List<Reward> rewards = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('recompenses').get();

      querySnapshot.docs.forEach((doc) {
        Reward reward = Reward(
          id_recompense: doc.id,
          name_recompense: doc['name_recompense'],
          description_recompense: doc['description_recompense'],
          pointsRequired: doc['pointsRequired'],
          imageUrl: doc['imageUrl'],
        );
        rewards.add(reward);
      });
    } catch (e) {
      print('Erreur lors de la récupération des récompenses depuis Firestore: $e');
    }

    return rewards;
  }

  void exchangePointsForReward(Reward reward) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Vérifiez que les informations de l'utilisateur sont disponibles
      if (user.uid != null && user.displayName != null) {
        // Obtenez le document de l'utilisateur dans Firestore
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          int currentPoints = (userSnapshot.data() as Map<String, dynamic>)['score'] ?? 0;

          if (currentPoints >= reward.pointsRequired) {
            int newPoints = currentPoints - reward.pointsRequired;

            // Soustrayez les points requis pour la récompense du score actuel de l'utilisateur
            await userRef.update({'score': newPoints});

            // Créez un objet Gagne avec les informations nécessaires
            Gagne gagne = Gagne(
              userId: user.uid,
              userName: user.displayName!,
              rewardName: reward.name_recompense,
              rewardDescription: reward.description_recompense,
            );

            // Enregistrez le gagné dans Firestore
            await gagne.saveToFirestore();

            print('Récompense échangée avec succès.');
          } else {
            print('Points insuffisants à échanger contre cette récompense.');
          }
        } else {
          print('Document utilisateur introuvable.');
        }
      } else {
        print('Informations utilisateur manquantes.');
      }
    } catch (e) {
      print('Erreur lors de l\'échange de récompense: $e');
    }
  } else {
    print('Aucun utilisateur n\'est actuellement connecté.');
  }
}
void showCongratulationsAlert(BuildContext context, String rewardName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Félicitations!'),
        content: Text('Vous avez réussi à échanger des points contre $rewardName.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK'),
          ),
        ],
      ),
    );
}