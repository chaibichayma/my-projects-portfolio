/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';


class Productt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final product = Product.fromSnapshot(snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>);
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(product.nom),
                      Text(product.marque),
                      Text('\$${product.prix.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              },
            );
          }

          return Center(
            child: Text('Aucune donnée disponible.'),
          );
        },
      ),
    );
  }
}*/