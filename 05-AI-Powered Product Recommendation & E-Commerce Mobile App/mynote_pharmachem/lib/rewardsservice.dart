import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/rewardsclass.dart';

class RewardService {
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
      print('Error fetching rewards from Firestore: $e');
    }

    return rewards;
  }
}