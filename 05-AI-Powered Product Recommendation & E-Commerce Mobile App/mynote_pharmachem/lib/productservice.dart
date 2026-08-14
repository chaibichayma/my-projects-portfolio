import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mynote_pharmachem/produits.dart';
class ProductService {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  // Récupérer tous les produits
  Stream<List<Product>> getProducts() {
    return productCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product(
            productId: doc['productId'] ?? '',
            imageUrl: doc['imageUrl'],
            nom: doc['nom'],
            quantityP: doc['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
            enStock: doc['en_stock'] ?? false,
            onSale: doc['onSale'],
            salePrix: doc['salePrix'],
            categoryIds: List<String>.from(doc['categoryIds'] ?? []),
            productData: doc['productData'],
            saleStartTime: doc['saleStartTime'] != null ? DateTime.parse(doc['saleStartTime']) : DateTime.now(),
            saleEndTime: doc['saleEndTime'] != null ? DateTime.parse(doc['saleEndTime']) : DateTime.now(),
            prix: doc['prix'].toDouble(),
            marque: doc['marque'])).toList());
            

            
  }
}