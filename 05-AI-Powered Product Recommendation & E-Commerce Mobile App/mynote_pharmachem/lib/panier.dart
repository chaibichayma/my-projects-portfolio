import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/AllProduitpage.dart';
import 'package:mynote_pharmachem/itemcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/productcard.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';

class CartPage extends StatelessWidget {
  final String userId;
  final DocumentSnapshot productData;
  final Product product;
  final User user;

  CartPage({required this.productData, required this.product, required this.userId, required this.user});

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
              'Panier',
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: CartItemList(productData: productData, product: product, userId: userId, user: user, ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => TousProduits(productData: productData, product: product, userId: userId,), 
                        ),
                      );
                    },
                    child: Text(
                      'Recommandé pour vous',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline, 
                      ),
                    ),
                  ),
                ),
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<Product> products = snapshot.data!.docs
                    .map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
                  Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
                  return Product(
                    productId: data['productId'] ?? '',
                    imageUrl: data['imageUrl'],        
                    quantityP: data['quantityP'] ?? 0, 
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
                })
                    .where((product) => !product.onSale)
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount:  products.length > 2 ? 2 : products.length, 
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                productData: product.productData,
                                product: product,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                        child: ProductCard(product: product, userId: userId, productData: productData,),
                      );
                    },
                  ),
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}