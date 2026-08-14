import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/detailscommande.dart';

class CommandesPage extends StatefulWidget {
  @override
  _CommandesPageState createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste de commandes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFA32CC4),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA32CC4), // Couleur de l'arrière-plan
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Couleur du conteneur blanc
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('commandes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucune commande trouvée.'));
                }
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.black), // Divider noir
                  itemBuilder: (context, index) {
                    DocumentSnapshot commandSnapshot = snapshot.data!.docs[index];
                    Map<String, dynamic> data = commandSnapshot.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        'Commande #${commandSnapshot.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      subtitle: Text(
                        'Total: ${data['total']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      trailing: IconButton( // Bouton d'icône "Supprimer"
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteCommande(commandSnapshot.id);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailCommandePage(commandSnapshot)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Fonction pour supprimer une commande
  void _deleteCommande(String commandeId) {
    FirebaseFirestore.instance.collection('commandes').doc(commandeId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande supprimée avec succès')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression de la commande: $error')),
      );
    });
  }
}