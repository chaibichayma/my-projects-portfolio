import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/panier/cartitem.dart';
class UsersWithCartPage extends StatefulWidget {
  @override
  _UsersWithCartPageState createState() => _UsersWithCartPageState();
}

class _UsersWithCartPageState extends State<UsersWithCartPage> {
  List<String> usersWithCart = [];
  String? selectedUserId;
  List<Map<String, dynamic>> cartItemsDetails = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          'Utilisateurs avec Cart',
          style: TextStyle(
            fontSize: 25, // Taille de la police
            fontWeight: FontWeight.bold, // Gras
            color: Colors.white, // Couleur du texte
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA32CC4), // Couleur "A32CC4"
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Liste des utilisateurs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: fetchUsersWithCart(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}'),
                        );
                      }

                      usersWithCart = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: usersWithCart.length * 2 - 1, // Nombre d'éléments et diviseurs
                        itemBuilder: (context, index) {
                          if (index.isOdd) {
                            // Diviseur
                            return Divider(color: Colors.black);
                          }

                          // Élément de la liste
                          final userIndex = index ~/ 2;
                          String userId = usersWithCart[userIndex];
                          return ListTile(
                            title: Text(userId),
                            onTap: () {
                              setState(() {
                                selectedUserId = userId;
                              });
                              fetchCartItemsForUser(userId);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchUsersWithCart() async {
    List<String> usersWithCart = [];

    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        QuerySnapshot<Map<String, dynamic>> cartSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart').get();

        if (cartSnapshot.docs.isNotEmpty) {
          usersWithCart.add(userId);
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs avec Cart: $e');
    }

    return usersWithCart;
  }

  Future<void> fetchCartItemsForUser(String userId) async {
    cartItemsDetails.clear(); // Clear existing cart items details
    try {
      QuerySnapshot<Map<String, dynamic>> cartSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).collection('Cart').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> cartItemDoc in cartSnapshot.docs) {
        cartItemsDetails.add(cartItemDoc.data());
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartDetailsPage(itemDetails: cartItemsDetails, ),
        ),
      );
    } catch (e) {
      print('Erreur lors de la récupération des éléments de Cart pour l\'utilisateur: $e');
    }
  }
}