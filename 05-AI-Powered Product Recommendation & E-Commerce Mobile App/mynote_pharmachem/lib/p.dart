import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ProductItemm extends StatelessWidget {
  final String productName;

  const ProductItemm({required this.productName});
   Future<String> getImageUrlForProduct(String productName) async {
    String imageUrl = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('nom', isEqualTo: productName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      imageUrl = querySnapshot.docs.first.get('imageUrl').toString();
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrlForProduct(productName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading image'));
        } else {
          String imageUrl = snapshot.data ?? '';
          return Card(
            elevation: 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      // Autres détails du produit à ajouter ici
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}