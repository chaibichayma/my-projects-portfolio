import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
class CosmetiquesPage extends StatelessWidget {
  final String imagePath;

  const CosmetiquesPage({Key? key, required this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits Cosmétiques'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('categoryIds', arrayContains: 'cosmetiquesId')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Product> products = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Product(
              productId: data['productId'] ?? '',
              imageUrl: data['imageUrl'],
              nom: data['nom'],
             
              marque: data['marque'],
              quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
              enStock: data['en_stock'] ?? false,
              prix: data['prix'].toDouble(),
              salePrix: data['salePrix'].toDouble(),
              onSale: data['onSale'],
              remise: data['remise'] != null ? data['remise'].toDouble() : 0.0,
              productData: doc,
              saleStartTime: data['saleStartTime'] != null ? DateTime.parse(data['saleStartTime']) : DateTime.now(),
              saleEndTime: data['saleEndTime'] != null ? DateTime.parse(data['saleEndTime']) : DateTime.now(),
              categoryIds: List<String>.from(data['categoryIds'] ?? []),
            );
          }).toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.nom),
                subtitle: Text(product.marque),
                // Affichez d'autres informations sur le produit si nécessaire
              );
            },
          );
        },
      ),
    );
  }
}
