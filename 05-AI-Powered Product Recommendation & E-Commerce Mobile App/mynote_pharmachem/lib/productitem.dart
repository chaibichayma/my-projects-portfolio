import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';


class ProductItem extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final User user;
  final String userId;
  final int quantity;

  ProductItem({
    required this.productData,
    this.quantity = 1,
    required this.product,
    required this.user,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = productData['imageUrl'];
    final nomProduit = productData['nom'];
    final marque = productData['marque'];
    final prix = productData['prix'];
    final salePrix = productData['salePrix'];
    final onSale = productData['onSale'];
    DateTime saleEndTime = productData['saleEndTime']?.toDate() ?? DateTime.now();
    double discount = ((prix - salePrix) / prix) * 100;

    String stockStatus = quantity > 0 ? 'En stock' : 'Bientôt en stock';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(productData: productData, product: product, userId: userId)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: imageUrl != null
                  ? SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Placeholder(),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomProduit,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$marque',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${prix.toStringAsFixed(2)} TND',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: onSale && DateTime.now().isBefore(saleEndTime)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none, // Ajout de la décoration de prix barré
                    ),
                  ),
                  if (onSale && DateTime.now().isBefore(saleEndTime)) ...[
                    SizedBox(height: 8),
                    Text(
                      '${salePrix.toStringAsFixed(2)} TND',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Remise: ${discount.toStringAsFixed(2)} %',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                  
                  SizedBox(height: 8),
                  Text(
                    stockStatus,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: quantity > 0 ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}