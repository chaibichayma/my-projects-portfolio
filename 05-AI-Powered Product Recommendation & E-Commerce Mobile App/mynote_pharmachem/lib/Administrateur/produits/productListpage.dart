import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/produits/detailsrodui.dart';
import 'package:mynote_pharmachem/productCardCate.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart'; 
import 'dart:async';
class ProductListWidget extends StatefulWidget {
  final String userId;
  ProductListWidget({required this.userId});
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  List<Product> products = []; // Liste de produits à afficher
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialiser la liste de produits depuis Firestore
    _fetchProducts();
    _pageController = PageController();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      List<Product> fetchedProducts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
        Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
        return Product(
          productId: data['productId'] ?? '',
          quantityP: data['quantityP'] ?? 0,
          enStock: data['en_stock'] ?? false,
          imageUrl: data['imageUrl'],
          nom: data['nom'],
          marque: data['marque'],
          prix: data['prix'].toDouble(),
          salePrix: data['salePrix'].toDouble(),
          saleStartTime: saleStartTimeTimestamp != null
              ? saleStartTimeTimestamp.toDate()
              : DateTime.now(),
          saleEndTime: saleEndTimeTimestamp != null
              ? saleEndTimeTimestamp.toDate()
              : DateTime.now(),
          categoryIds: List<String>.from(data['categoryIds'] ?? []),
          onSale: data['onSale'],
          remise: data['remise'] != null ? data['remise'].toDouble() : 0.0,
          productData: doc,
        );
      }).toList();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
    }
  }

  Future<void> _deleteProduct(String productName) async {
    try {
      // Vérifiez que le nom du produit n'est pas vide
      if (productName.isEmpty) {
        print('Le nom du produit est vide.');
        return;
      }

      // Recherchez le produit dans la liste locale
      Product productToDelete = products.firstWhere(
        (product) => product.nom == productName,
        orElse: () => throw Exception('Produit non trouvé dans la liste locale.'),
      );

      // Supprimez le produit de Firestore en utilisant l'identifiant du document
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productToDelete.productData.id)
          .delete();

      // Supprimez le produit de la liste locale
      setState(() {
        products.removeWhere((product) => product.nom == productName);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Produit supprimé avec succès.'),
      ));
    } catch (e) {
      print('Erreur lors de la suppression du produit: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la suppression du produit.'),
      ));
    }
  }

  @override
Widget build(BuildContext context) {
  return PageView.builder(
    controller: _pageController,
    scrollDirection: Axis.horizontal,
    itemCount: (products.length / 4).ceil(),
    itemBuilder: (context, pageIndex) {
      int startIndex = pageIndex * 4;
      int endIndex = startIndex + 4; // Utilisez startIndex + 4 pour afficher 4 produits par page

      // Assurez-vous que endIndex ne dépasse pas la taille de la liste de produits
      if (endIndex > products.length) {
        endIndex = products.length;
      }

      // Liste des produits à afficher sur la page actuelle
      List<Product> productsToShow = products.sublist(startIndex, endIndex);

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: productsToShow.length,
        itemBuilder: (context, index) {
          final product = productsToShow[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsProduct(
                    productData: product.productData,
                    userId: widget.userId,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nom,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text('Marque: ${product.marque}'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.purple),
                    onPressed: () {
                      _deleteProduct(product.nom);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}}