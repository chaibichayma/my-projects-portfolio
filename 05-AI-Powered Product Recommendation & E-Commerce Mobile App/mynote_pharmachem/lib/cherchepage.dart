import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
class Cherche extends StatefulWidget {
  final DocumentSnapshot<Object?> productData;
  final Product product;
  final String userId;
  Cherche({required this.productData, required this.product, required this.userId});
  @override
  _ChercheState createState() => _ChercheState();
}

class _ChercheState extends State<Cherche> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _allProductNames = [];
  List<String> _suggestions = [];
  List<String> _searchResults = [];
  List<List<Product>> paginatedProducts = [];
  String _selectedSearchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchProductNames();
  }

  Future<void> _fetchProductNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _allProductNames =
          querySnapshot.docs.map((doc) => doc['nom'].toString()).toList();
      _searchResults = List.from(_allProductNames); // Initialiser avec tous les produits
    });
  }

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

  void _performSearchLocally(String query) {
    String searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      setState(() {
        _suggestions.clear();
        _searchResults = List.from(_allProductNames); // Réinitialiser avec tous les produits
      });
    } else {
      setState(() {
        _suggestions.clear();
        _searchResults.clear();

        _allProductNames.forEach((productName) {
          List<String> words = productName.toLowerCase().split(' ');
          _suggestions.addAll(
              words.where((word) => word.startsWith(searchQuery)));
        });
        _suggestions = _suggestions.toSet().toList();

        _searchResults = _allProductNames
            .where((name) => name.toLowerCase().contains(searchQuery))
            .toList();
      });
    }
  }

  
 Widget _buildSuggestions() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_suggestions[index]),
            onTap: () {
              _searchController.text = _suggestions[index];
              _performSearchLocally(_suggestions[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
  bool showSuggestions = _searchController.text.isNotEmpty;

  return SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Le plus populaire',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Erreur de chargement des données'));
            }
            List<Product> allProducts = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
              Timestamp? saleEndTimeTimestamp = data['saleEndTime'];
              return Product(
                productId: data['productId'] ?? '',
                quantityP: data['quantityP'] ?? 0,
                enStock: data['en_stock'] ?? false,
                imageUrl: data['imageUrl'],
              
                nom: data['nom'],
                marque: data['marque'],
                prix: (data['prix'] as num).toDouble(),
                salePrix: (data['salePrix'] as num).toDouble(),
                saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
                saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
                categoryIds: List<String>.from(data['categoryIds'] ?? []),
                onSale: data['onSale'],
                remise: (data['remise'] as num?)?.toDouble() ?? 0.0,
                productData: doc,
              );
            }).toList();

            List<Product> filteredProducts = _searchResults.isNotEmpty
                ? allProducts.where((product) => _searchResults.contains(product.nom)).toList()
                : allProducts;

            List<Widget> productWidgets = [];
            for (int i = 0; i < filteredProducts.length; i += 4) {
              int endIndex = i + 4;
              if (endIndex > filteredProducts.length) endIndex = filteredProducts.length;
              List<Product> pageProducts = filteredProducts.sublist(i, endIndex);
              productWidgets.add(
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                            builder: (context) => ProductDetailsPage(
                              productData: product.productData,
                              product: product,
                              userId: widget.userId,
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


            return Column(
              children: productWidgets,
            );
          },
        ),
      ],
    ),
  );
}
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 25),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Chercher...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: _performSearchLocally,
              ),
            ),
            centerTitle: true,
               
          ),
        ),
      ),
      body: Column(
        children: [
          if (_searchController.text.isNotEmpty)
            Expanded(
              child: _buildSuggestions(),
            ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}