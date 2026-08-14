import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/biopage.dart';
import 'package:mynote_pharmachem/cosmeticpage.dart';
import 'package:mynote_pharmachem/pharmapage.dart';
import 'package:mynote_pharmachem/produits.dart';

class HorizontalList extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;
  HorizontalList({required this.productData, required this.product, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // Première catégorie sans espace à gauche
          Padding(
            padding: EdgeInsets.only(left: 1.0),
            child: Category(
              image_location: 'images/p1.png',
              image_caption: 'Cosmétique',
              
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CosmetiquesPage(
                    product: product,
                    userId: userId,
                    productData: productData,
                  ),
                ),
              );
              },
            ),
          ),
          const SizedBox(width: 25,),
          Padding(
            padding: EdgeInsets.only(left: 8.0), // Espacement à gauche
            child: Category(
              image_location: 'images/p2.png',
              image_caption: 'Biologique',
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BiologiquesPage(
                    product: product,
                    userId: userId,
                    productData: productData,
                  ),
                ),
              );
             
              },
            ),
          ),
          const SizedBox(width: 45,),
          Padding(
            padding: EdgeInsets.only(left: 8.0), // Espacement à gauche
            child: Category(
              image_location: 'images/p3.png',
              image_caption: 'Pharma',
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PharmaceutiquesPage(
                    product: product,
                    userId: userId,
                    productData: productData,
                  ),
                ),
              );          
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final VoidCallback? onTap; // Fonction de rappel pour gérer l'appui

  Category({
    required this.image_location,
    required this.image_caption,
    this.onTap, // Ajoutez cet argument optionnel
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Utilisez onTap directement ici
      child: Container(
        width: 100.0,
        child: ListTile(
          title: Image.asset(
            image_location,
            fit: BoxFit.fitWidth,
          ),
          subtitle: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 14), // Espace vertical de 5 pixels
                Text(
                  image_caption,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}