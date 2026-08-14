import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController imageProductController = TextEditingController();
  TextEditingController marqueProductController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController remiseProductController = TextEditingController();
  TextEditingController salePrixProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          'Ajouter au panier',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFieldContainer(
                child: TextField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Nom du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: productPriceController,
                  decoration: InputDecoration(labelText: 'Prix du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantité'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: imageProductController,
                  decoration: InputDecoration(labelText: 'Image du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: marqueProductController,
                  decoration: InputDecoration(labelText: 'Marque du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: productIdController,
                  decoration: InputDecoration(labelText: 'ID du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: remiseProductController,
                  decoration: InputDecoration(labelText: 'Remise du produit'),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: salePrixProductController,
                  decoration: InputDecoration(labelText: 'Prix de vente du produit'),
                ),
              ),
              SizedBox(height: 35),
              ElevatedButton(
  onPressed: () {
    _addToCart();
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFB686DB)), // Couleur d'arrière-plan
    fixedSize: MaterialStateProperty.all<Size>(Size(400, 50)), // Taille fixe du bouton (hauteur et largeur)
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rayon de bordure pour rendre le bouton légèrement circulaire
      ),
    ),
  ),
  child: Text(
    'Ajouter au Panier',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  ),
),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: child,
      ),
    );
  }

  Future<void> _addToCart() async {
    try {
      // Récupérer l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Ajouter un nouveau document à la sous-collection 'Cart' de l'utilisateur
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Cart')
            .add({
          'productName': productNameController.text,
          'productPrice': double.parse(productPriceController.text),
          'quantity': int.parse(quantityController.text),
          'imageProduct': imageProductController.text,
          'marqueProduct': marqueProductController.text,
          'productId': productIdController.text,
          'remiseProduct': double.parse(remiseProductController.text),
          'salePrixProduct': double.parse(salePrixProductController.text),
        });

        // Effacer les champs après l'ajout
        productNameController.clear();
        productPriceController.clear();
        quantityController.clear();
        imageProductController.clear();
        marqueProductController.clear();
        productIdController.clear();
        remiseProductController.clear();
        salePrixProductController.clear();

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produit ajouté au panier avec succès.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Aucun utilisateur connecté.');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout au panier: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite lors de l\'ajout au panier.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    quantityController.dispose();
    imageProductController.dispose();
    marqueProductController.dispose();
    productIdController.dispose();
    remiseProductController.dispose();
    salePrixProductController.dispose();
    super.dispose();
  }
}