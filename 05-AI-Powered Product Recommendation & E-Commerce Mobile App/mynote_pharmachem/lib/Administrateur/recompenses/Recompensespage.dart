import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/recompenses/nouvellerecompense.dart';
import 'package:mynote_pharmachem/rewardsclass.dart';
class RecompensesPage extends StatelessWidget {
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
              'Récompenses',
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
          SizedBox(height: 10), 
         Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('recompenses').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Une erreur est survenue'),
                );
              }
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          
              final rewards = snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Reward(
                  id_recompense: document.id,
                  description_recompense: data['description_recompense'],
                  imageUrl: data['imageUrl'],
                  pointsRequired: data['pointsRequired'],
                  name_recompense: data['name_recompense'],
                );
              }).toList();
          
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux éléments par ligne
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.7, // Aspect ratio pour ajuster la taille des éléments
                ),
                itemCount: rewards.length,
                itemBuilder: (BuildContext context, int index) {
                  final reward = rewards[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        _editReward(context, reward); // Ouvrir l'écran de modification
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  reward.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.purple,),
                                    onPressed: () {
                                      // Logique pour supprimer la récompense
                                      FirebaseFirestore.instance.collection('recompenses').doc(reward.id_recompense).delete();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nom : ${reward.name_recompense}',
                                  style: TextStyle(
                                    fontSize: 14, // Taille de la police
                                    fontWeight: FontWeight.bold, // Police en gras
                                    color: Colors.black, // Couleur du texte
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Points requis : ${reward.pointsRequired}',
                                  style: TextStyle(
                                    fontSize: 14, // Taille de la police
                                    fontWeight: FontWeight.normal, // Police en gras
                                    color: Colors.black, // Couleur du texte
                                  ),
                                ),
                             ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10), // Ajouter un espace de 20 pixels entre la liste et le bouton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NouvelleRecompensePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5DBED), // Couleur de fond du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                ),
                minimumSize: Size(400, 50), // Largeur et hauteur du bouton
              ),
              child: Text(
                'Ajouter récompense',
                style: TextStyle(
                  fontSize: 20, // Taille de la police
                  fontWeight: FontWeight.bold, // Police en gras
                  color: Colors.black, // Couleur du texte
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editReward(BuildContext context, Reward reward) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: reward.name_recompense);
        TextEditingController pointsController = TextEditingController(text: reward.pointsRequired.toString());

        return AlertDialog(
          title: Text(
            'Modifier la récompense',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:InputDecoration(
                  labelText: 'Nom de la récompense',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // Couleur du texte de l'étiquette
                    fontWeight: FontWeight.bold, // Poids de la police de l'étiquette
                  ),
                ),
              ),
              TextField(
                controller: pointsController,
                decoration: InputDecoration(labelText: 'Points requis', labelStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Logique pour sauvegarder les modifications
                String newName = nameController.text.trim();
                int newPoints = int.tryParse(pointsController.text.trim()) ?? 0;
                _saveChanges(reward.id_recompense, newName, newPoints);
                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges(String id, String newName, int newPoints) {
    FirebaseFirestore.instance.collection('recompenses').doc(id).update({
      'name_recompense': newName,
      'pointsRequired': newPoints,
    }).then((value) {
      // Logique de réussite de la mise à jour
    }).catchError((error) {
      // Logique en cas d'erreur
    });
  }
}