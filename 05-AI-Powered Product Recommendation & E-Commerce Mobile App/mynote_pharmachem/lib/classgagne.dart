import 'package:cloud_firestore/cloud_firestore.dart';

class Gagne {
  final String userId;
  final String userName;
  final String rewardName;
  final String rewardDescription;
  

  Gagne({
    required this.userId,
    required this.userName,
    required this.rewardName,
    required this.rewardDescription,
  });

  Future<void> saveToFirestore() async {
    try {
      // Ajoutez un document à la collection gagne_recompenses
      await FirebaseFirestore.instance.collection('gagne_recompenses').add({
        'userId': userId,
        'userName': userName,
        'rewardName': rewardName,
        'rewardDescription': rewardDescription,
        'timestamp': Timestamp.now(),
      });

      print('Gagné ajouté avec succès à Firestore.');
    } catch (e) {
      print('Erreur lors de l\'ajout du gagné dans Firestore: $e');
    }
  }
}