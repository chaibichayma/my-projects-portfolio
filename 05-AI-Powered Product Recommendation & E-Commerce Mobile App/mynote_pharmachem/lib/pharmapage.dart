import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/productCardCate.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'dart:async';
class PharmaceutiquesPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot productData;
  final Product product;

  PharmaceutiquesPage({required this.userId, required this.productData, required this.product});

  @override
  _PharmaceutiquesPageState createState() => _PharmaceutiquesPageState();
}

class _PharmaceutiquesPageState extends State<PharmaceutiquesPage> {
  late PageController _pageController;
  late StreamController<List<Product>> _productsStreamController;
  List<List<Product>> paginatedProducts = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _productsStreamController = StreamController<List<Product>>();
    paginateProducts();
  }

  void paginateProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryIds', arrayContains: 'pharmaceutiquesId')
        .get();
    List<Product> products = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
      Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
      return Product(
        productId: data['productId'] ?? '',
        imageUrl: data['imageUrl'],
        quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
      enStock: data['en_stock'] ?? false,
        saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
        saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
        nom: data['nom'],
        marque: data['marque'],
        prix: data['prix'].toDouble(),
        categoryIds: List<String>.from(data['categoryIds'] ?? []),
        salePrix: data['salePrix'].toDouble(),
        onSale: data['onSale'],
        remise: data['remise'] != null ? data['remise'].toDouble() : 0.0,
        productData: doc,
      );
    }).toList();
    for (int i = 0; i < products.length; i += 4) {
      final List<Product> page = products.skip(i).take(4).toList();
      paginatedProducts.add(page);
    }
    _productsStreamController.add(products); // Mettre à jour le Stream avec les produits
  }

  @override
  void dispose() {
    _pageController.dispose();
    _productsStreamController.close(); // Fermer le StreamController pour éviter les fuites de mémoire
    super.dispose();
  }

  double get discountPercentage {
    if (widget.product.onSale) {
      double discount = ((widget.product.prix - widget.product.salePrix) / widget.product.prix) * 100;
      // Ajoutez la remise supplémentaire si elle est définie
      discount -= widget.product.remise;
      return discount;
    } else {
      return 0.0;
    }
  }

 void navigateToProductDetails(Product product) {
  // Naviguer vers la page de détails du produit en utilisant la méthode Navigator
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailsPage(
        product: product,
        userId: widget.userId,
        productData: product.productData, // Utiliser les données du produit spécifique
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 45), 
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Text(
              'Pharmaceutiques',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            centerTitle: true,
            elevation: 0, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productsStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          List<Product> products = snapshot.data ?? [];
          return Column(
            children: [
              SizedBox(height: 60.0), 
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: paginatedProducts.length,
                  itemBuilder: (context, pageIndex) {
                    final List<Product> currentPage = paginatedProducts[pageIndex];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: currentPage.length,
                      itemBuilder: (context, index) {
                        final product = currentPage[index];
                        return GestureDetector(
                          onTap: () {
                            navigateToProductDetails(product);
                          },
                          child: ProductCardCat(
                            product: product,
                            userId: widget.userId,
                            productData: widget.productData,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}