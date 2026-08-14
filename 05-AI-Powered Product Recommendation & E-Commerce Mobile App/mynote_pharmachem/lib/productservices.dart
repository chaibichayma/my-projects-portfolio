import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> searchProducts(String keyword) async {
    List<Product> products = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('nom', isEqualTo: keyword)
          .get();

      querySnapshot.docs.forEach((doc) {
        products.add(Product.fromFirestore(doc));
      });
    } catch (e) {
      print('Error searching products: $e');
    }

    return products;
  }
}