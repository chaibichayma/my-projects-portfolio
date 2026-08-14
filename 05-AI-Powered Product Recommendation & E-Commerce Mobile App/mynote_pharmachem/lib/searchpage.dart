import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
class SearchResultsPage extends StatelessWidget {
  final String searchQuery;

  SearchResultsPage({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de recherche'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          // Utilisez un ensemble pour stocker les produits de manière unique
          Set<Product> uniqueProducts = {};

          // Filtrer les produits localement
          snapshot.data!.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
            Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
            Product product = Product(
              productId: data['productId'] ?? '',
              imageUrl: data['imageUrl'],
              quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
              enStock: data['en_stock'] ?? false,
              saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
              saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
              nom: data['nom'],
              marque: data['marque'],
              prix: data['prix'].toDouble(),
              salePrix: data['salePrix'].toDouble(),
              onSale: data['onSale'],
              productData: doc,
              categoryIds: List<String>.from(data['categoryIds'] ?? []),
            );
            if (product.nom.toLowerCase().startsWith(searchQuery.toLowerCase()) ||
                product.nom.toLowerCase().contains(searchQuery.toLowerCase())) {
              uniqueProducts.add(product);
            }
          });

          List<Product> filteredProducts = uniqueProducts.toList();

          if (filteredProducts.isEmpty) {
            return Center(child: Text('Aucun résultat trouvé pour "$searchQuery"'));
          }

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ListTile(
                title: Text(product.nom),
                subtitle: Text('${product.prix} FCFA'), // Utilisez les champs pertinents
                leading: Image.network(product.imageUrl), // Affichez l'image du produit
                // Ajoutez d'autres informations du produit si nécessaire
                onTap: () {
                  
                },
              );
            },
          );
        },
      ),
    );
  }
}