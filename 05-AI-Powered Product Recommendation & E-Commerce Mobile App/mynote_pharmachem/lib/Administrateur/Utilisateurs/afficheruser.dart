import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/Utilisateurs/adduserscreen.dart';
import 'package:mynote_pharmachem/Administrateur/Utilisateurs/edituserscreen.dart';
import 'package:mynote_pharmachem/user_model.dart';
class UserListScreen extends StatelessWidget {
  final String userId;
  
  UserListScreen({required this.userId, });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des utilisateurs',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFA32CC4),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFA32CC4),
          ),
          Positioned(
            top: kToolbarHeight,
            left: 15,
            right: 15,
            bottom: 40,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erreur de chargement des données'),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<DocumentSnapshot> users = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var user = users[index].data() as Map<String, dynamic>;

                            // Vérifier si le champ fullName et role existent
                            if (user.containsKey('fullName') && user.containsKey('role')) {
                              String fullName = user['fullName'];
                              String role = user['role'];

                              // Vérifier si le rôle de l'utilisateur n'est pas "admin"
                              if (role != 'admin') {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        fullName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        user['email'] ?? 'Email inconnu',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit), // Icône de modification
                                            onPressed: () {
                                              // Action à effectuer lors du clic sur le bouton Modifier
                                              navigateToEditUserScreen(context, users[index].id);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete), // Icône de suppression
                                            onPressed: () {
                                              // Action à effectuer lors du clic sur le bouton Supprimer
                                              deleteCurrentUser(users[index].id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              }
                            }
                            return SizedBox.shrink();
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, kToolbarHeight - 10, 15, 25),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFA32CC4), // Couleur d'arrière-plan du bouton
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddUserScreen()), // Remplacez AutrePage par le nom de votre page
                        );
                      },
                      child: Center(
                        child: Text(
                          'Ajouter un utilisateur',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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

  void navigateToEditUserScreen(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(userId: userId,),
      ),
    );
  }

  void deleteCurrentUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete().then((_) {
      print('Utilisateur supprimé avec succès');
    }).catchError((error) {
      print('Erreur lors de la suppression de l\'utilisateur : $error');
    });
  }
}