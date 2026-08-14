import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/WelcomeScreendeux.dart';
import 'package:mynote_pharmachem/productCardCate.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart'; 
import 'dart:async';
class TousProduitsViteur extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;

  TousProduitsViteur ({
    required this.productData,
    required this.product,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          'Tous les produits',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 60.0), // Espacement de 20 pixels entre l'appbar et les produits
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Erreur: ${snapshot.error}')),
                  );
                }
                List<Product> products = snapshot.data!.docs.map((doc) {
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
                    saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
                    saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
                    categoryIds: List<String>.from(data['categoryIds'] ?? []),
                    onSale: data['onSale'],
                    remise: data['remise'] != null ? data['remise'].toDouble() : 0.0,
                    productData: doc,
                  );
                }).toList();

                List<Widget> pages = [];
                for (int i = 0; i < products.length; i += 4) {
                  int endIndex = i + 4;
                  if (endIndex > products.length) endIndex = products.length;
                  List<Product> pageProducts = products.sublist(i, endIndex);
                  pages.add(
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: pageProducts.length,
                      itemBuilder: (context, index) {
                        final product = pageProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(
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
                                      if (product.onSale &&
                                          DateTime.now().isBefore(product.saleEndTime))
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Prix: ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: '${product.prix}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text('Sale Prix: ${product.salePrix}'),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE5DBED),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'Remise: ${product.remise}%',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75, // 75% of screen height
                    child: PageView(
                      children: pages,
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