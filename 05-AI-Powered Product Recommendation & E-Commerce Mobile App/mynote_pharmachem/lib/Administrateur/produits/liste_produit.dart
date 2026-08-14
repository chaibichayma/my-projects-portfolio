import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/produits/ajouterproduit.dart';
import 'package:mynote_pharmachem/Administrateur/produits/detailsrodui.dart';
import 'package:mynote_pharmachem/Administrateur/produits/productListpage.dart';
import 'package:mynote_pharmachem/productCardCate.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart'; 
import 'dart:async';
class ProductListScreen extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;

  ProductListScreen({
    required this.productData,
    required this.product,
    required this.userId,
  });
  
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
              'Liste des produits',
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
        SizedBox(height: 60.0),
        Expanded(
          child: ProductListWidget(userId: userId),
        ),
      
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen(userId: userId)),
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
                'Ajouter un produit',
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
}