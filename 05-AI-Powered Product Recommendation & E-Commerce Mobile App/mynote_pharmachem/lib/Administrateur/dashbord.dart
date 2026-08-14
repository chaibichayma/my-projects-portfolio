import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/Utilisateurs/afficheruser.dart';
import 'package:mynote_pharmachem/Administrateur/admininfoscreen.dart';
import 'package:mynote_pharmachem/Administrateur/categories/touscategories.dart';
import 'package:mynote_pharmachem/Administrateur/commandepage.dart';
import 'package:mynote_pharmachem/Administrateur/panier/userwithcart.dart';
import 'package:mynote_pharmachem/Administrateur/produits/liste_produit.dart';
import 'package:mynote_pharmachem/Administrateur/quiz/quizpages.dart';
import 'package:mynote_pharmachem/Administrateur/recompenses/Recompensespage.dart';
import 'package:mynote_pharmachem/productcard.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:firebase_auth/firebase_auth.dart';
enum MenuOptions { utilisateurs, produits, panier, commandes , recompenses, categories, quizes}
class DashboardScreen extends StatelessWidget {
  final String userId;
  final DocumentSnapshot productData;
  final Product product;

  DashboardScreen({required this.userId, required this.product, required this.productData,});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFA32CC4),
      toolbarHeight: 140,
      leading: Padding(
  padding: EdgeInsets.only(left: 10, top: 10),
  child: IconButton(
    icon: Icon(Icons.logout, color: Colors.white), // Icône de déconnexion
    iconSize: 40,
    onPressed: () async {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Déconnexion'),
            content: Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); 
                },
                child: Text('Annuler', style: TextStyle(fontSize: 16),),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Oui', style: TextStyle(fontSize: 16),),
              ),
            ],
          );
        },
      );

      if (confirmed) {
        // L'utilisateur a confirmé la déconnexion
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        } catch (e) {
          print('Erreur lors de la déconnexion: $e');
        }
      }
    },
  ),
),
      title: Text(
        'Tableau de bord',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,   
      actions: [
  PopupMenuButton<MenuOptions>(
    icon: Icon(Icons.menu, color: Colors.white,size: 40,),
    itemBuilder: (BuildContext context) => menuItems(context),
    onSelected: (MenuOptions result) {
      switch (result) {
        case MenuOptions.utilisateurs:
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserListScreen(userId: userId)));
          break;
        case MenuOptions.produits:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(productData: productData, product: product, userId: userId)));
          break;
        case MenuOptions.commandes:
          Navigator.push(context, MaterialPageRoute(builder: (context) => CommandesPage()));
          break;
        case MenuOptions.panier:
          Navigator.push(context, MaterialPageRoute(builder: (context) => UsersWithCartPage()));
          break;
        case MenuOptions.recompenses:
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecompensesPage()));
          break;
        case MenuOptions.categories:
          Navigator.push(context, MaterialPageRoute(builder: (context) => TousCategoriesPage()));
          break;
        case MenuOptions.quizes:
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizAdminScreen()));
          break;
      }
    },
  ),
],
    ),
    backgroundColor: Color(0xFFA32CC4),
      body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
    ),
    margin: EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        SizedBox(
          height: 180,
          width: 180,
          child: Image.asset(
            'images/admine.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 50),
        Container(
          height: 100,
          alignment: Alignment.center,
          child: Text(
            'Bienvenue admin!',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5), // Espacement entre le texte et le fullName
        Container(
          alignment: Alignment.center, // Centrer la liste des noms complets
          child: Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<String> adminFullNames = [];
                snapshot.data!.docs.forEach((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String fullName = data['fullName'];
                  adminFullNames.add(fullName);
                });

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: adminFullNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        adminFullNames[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35, // Taille de la police
                          fontWeight: FontWeight.normal, // Poids de la police (gras)
                          color: Colors.black, // Couleur du texte
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    ),
  ),
),
  
  );
}

 Widget buildContainer(String text, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFFE5DBED),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      
        CircleAvatar(
          backgroundColor: Color(0xFFA32CC4), // Couleur de fond du cercle
          radius: 30, // Taille du cercle
          child: Icon(
            iconData,
            color: Colors.white, // Couleur de l'icône
            size: 25, // Taille de l'icône
          ),
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}}
  

List<PopupMenuItem<MenuOptions>> menuItems(BuildContext context) {
  return [
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.utilisateurs,
      child: Row(
        children: [
          Icon(Icons.person, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Utilisateurs',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.produits,
      child: Row(
        children: [
          Icon(Icons.production_quantity_limits_outlined, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Produits',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.commandes,
      child: Row(
        children: [
          Icon(Icons.shop, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Commandes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.panier,
      child: Row(
        children: [
          Icon(Icons.shop_2, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Panier',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.recompenses,
      child: Row(
        children: [
          Icon(Icons.star, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Récompenses',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.categories,
      child: Row(
        children: [
          Icon(Icons.category, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Catégories',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem<MenuOptions>(
      value: MenuOptions.quizes,
      child: Row(
        children: [
          Icon(Icons.quiz, color: Color(0xFFA32CC4)),
          SizedBox(width: 10),
          Text(
            'Quizes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ];
}