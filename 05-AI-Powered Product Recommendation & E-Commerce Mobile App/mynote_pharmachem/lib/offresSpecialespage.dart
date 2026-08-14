import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/productCardCate.dart';
import 'package:mynote_pharmachem/productcard.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart'; 
class OffresSpecialesPage extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;

  OffresSpecialesPage({
    required this.productData,
    required this.product,
    required this.userId,
  });

  double get discountPercentage {
    if (product.onSale) {
      double discount = ((product.prix - product.salePrix) / product.prix) * 100;
      // Ajoutez la remise supplémentaire si elle est définie
      discount -= product.remise;
      return discount;
    } else {
      return 0.0;
    }
  }

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
              'Offres Spéciales',
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
        child: Column(
          children: [
            SizedBox(height: 40,),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                List<Product> products = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
                  Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
                  return Product(
                    productId: data['productId'] ?? '',
                    imageUrl: data['imageUrl'],
                 
                    saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
                    saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
                    nom: data['nom'],
                    marque: data['marque'],
                    quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
                    enStock: data['en_stock'] ?? false,
                    prix: data['prix'].toDouble(),
                    categoryIds: List<String>.from(data['categoryIds'] ?? []),
                    salePrix: data['salePrix'].toDouble(),
                    onSale: data['onSale'],
                    remise: data['remise'] != null ? data['remise'].toDouble() : 0.0,
                    productData: doc,
                  );
                }).toList();

                // Filtrer les produits pour exclure ceux dont la date de fin de vente est atteinte
                DateTime currentDate = DateTime.now();
                List<Product> productsOnSale = products.where((product) {
                  return product.onSale &&
                      currentDate.isAfter(product.saleStartTime) &&
                      currentDate.isBefore(product.saleEndTime);
                }).toList();

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
                    itemCount: productsOnSale.length,
                    itemBuilder: (context, index) {
                      final product = productsOnSale[index];
                      return GestureDetector(
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
                        child: ProductCard(
                          product: product,
                          userId: userId,
                          productData: productData,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}