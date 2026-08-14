import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/classListeEnvie.dart';
class EnviePage extends StatelessWidget {
  final String userId;

  EnviePage({required this.userId});

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
              'Ma liste d\'Envie',
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ListeEnvie').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur s\'est produite'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final isEmpty = snapshot.data!.docs.isEmpty;

          return Column(
            children: [
              SizedBox(height: 30), // Espacement entre l'appbar et les produits
              Expanded(
                child: SingleChildScrollView(
                  child: isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/removeheart.png', 
                                width: 400,
                                height: 400,
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: Text(
                                  'Aucun produit dans votre',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text(
                                  'liste d\'Envie!',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: snapshot.data!.docs.map((doc) {
                            var product = ProductInWishlist(
                              productId: doc['productId'],
                              productName: doc['productName'],
                              productPrice: (doc['productPrice'] ?? 0).toDouble(),
                              imageProduct: doc['imageProduct'],
                              marqueProduct: doc['marqueProduct'],
                              salePrixProduct: (doc['salePrixProduct'] ?? 0).toDouble(),
                              remiseProduct: (doc['remiseProduct'] ?? 0).toDouble(),
                            );

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image à gauche
                                    Image.network(
                                      product.imageProduct,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 16), // Espacement entre l'image et les autres champs
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Prix:  ${product.productPrice}  TND',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Color(0xFFA32CC4),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('ListeEnvie')
                                                      .doc(doc.id)
                                                      .delete();
                                                },
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
                          }).toList(),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}