import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/calendrierpage.dart';
import 'package:mynote_pharmachem/categoriespage.dart';
import 'package:mynote_pharmachem/cherchepage.dart';
import 'package:mynote_pharmachem/panier.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/rewardspage.dart';
import 'package:mynote_pharmachem/quizlistscreen.dart';
class Category extends StatefulWidget {
  final Product product;
  final User user;
  final String userId;
  final DocumentSnapshot productData;


  Category({Key? key, required this.product,  required this.user, required this.userId, required this.productData,}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
    final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
               height: 150, 
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [                      
                       GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                               builder: (context) => CartPage(userId: widget.userId, product: widget.product, productData: widget.productData, user: widget.user,),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cherche(productData: widget.productData, product: widget.product, userId: widget.userId,),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10), // Ajoutez un espace entre l'icône et le champ de texte
                          Icon(
                            Icons.search,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          SizedBox(width: 10), // Ajoutez un espace entre l'icône et le champ de texte
                          Expanded(
                            child: TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Cherche ici ....",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 20,
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
            ),
            const SizedBox(height: 20,),
            CategoriesPage(product: widget.product, user: widget.user, userId: widget.userId),
            const SizedBox(height: 10,),
            Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.0), // Ajoute des marges de 8.0 pixels à gauche et à droite
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizListScreen(userId: widget.userId,),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordure circulaire avec rayon de 20.0
      ),
      side: BorderSide(
        width: 1.0, // Largeur de la bordure
        color: Colors.grey, // Couleur de la bordure
      ),
      backgroundColor: Color(0xFFE5DBED),
    ),
    child: Container(
      constraints: BoxConstraints(maxWidth: 150.0), // Limite la largeur du Container à 150.0 pixels
      height: 50.0, // Hauteur du bouton
      alignment: Alignment.center, // Alignement du contenu au centre du bouton
      child: Text(
        'Quiz',
        style: TextStyle(
          fontSize: 16.0, // Taille de la police du texte
          fontWeight: FontWeight.bold, // Gras
          color: Colors.black, // Couleur du texte
        ),
      ),
    ),
  ),
),
            SizedBox(height: 10,),
            Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.0), // Ajoute des marges de 8.0 pixels à gauche et à droite
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RewardsPage(userId: widget.userId,),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordure circulaire avec rayon de 20.0
      ),
      side: BorderSide(
        width: 1.0, // Largeur de la bordure
        color: Colors.grey, // Couleur de la bordure
      ),
      backgroundColor: Color(0xFFE5DBED),
    ),
    child: Container(
      constraints: BoxConstraints(maxWidth: 150.0), // Limite la largeur du Container à 150.0 pixels
      height: 50.0, // Hauteur du bouton
      alignment: Alignment.center, // Alignement du contenu au centre du bouton
      child: Text(
        'Rewards',
        style: TextStyle(
          fontSize: 16.0, // Taille de la police du texte
          fontWeight: FontWeight.bold, // Gras
          color: Colors.black, // Couleur du texte
        ),
      ),
    ),
  ),
),
          SizedBox(height: 10,),
          Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.0), // Ajoute des marges de 8.0 pixels à gauche et à droite
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarScreen(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordure circulaire avec rayon de 20.0
      ),
      side: BorderSide(
        width: 1.0, // Largeur de la bordure
        color: Colors.grey, // Couleur de la bordure
      ),
      backgroundColor: Color(0xFFE5DBED),
    ),
    child: Container(
      constraints: BoxConstraints(maxWidth: 150.0), // Limite la largeur du Container à 150.0 pixels
      height: 50.0, // Hauteur du bouton
      alignment: Alignment.center, // Alignement du contenu au centre du bouton
      child: Text(
        'Calendrier',
        style: TextStyle(
          fontSize: 16.0, // Taille de la police du texte
          fontWeight: FontWeight.bold, // Gras
          color: Colors.black, // Couleur du texte
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}