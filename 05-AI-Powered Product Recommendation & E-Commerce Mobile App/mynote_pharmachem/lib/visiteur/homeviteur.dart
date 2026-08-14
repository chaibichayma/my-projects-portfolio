import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/Administrateur/Utilisateurs/afficheruser.dart';
import 'package:mynote_pharmachem/Administrateur/dashbord.dart';
import 'package:mynote_pharmachem/AllProduitpage.dart';
import 'package:mynote_pharmachem/WelcomeScreendeux.dart';
import 'package:mynote_pharmachem/cherchepage.dart';
import 'package:mynote_pharmachem/components/horizantal_list.dart';
import 'package:mynote_pharmachem/offresSpecialespage.dart';
import 'package:mynote_pharmachem/panier.dart';
import 'package:mynote_pharmachem/productcard.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/user_model.dart';
import 'package:mynote_pharmachem/visiteur/allproduitvisite.dart';
import 'package:mynote_pharmachem/visiteur/offresspecialesvisiteur.dart';
class HomeVisiteur extends StatefulWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;
  final User user;

  HomeVisiteur({
    Key? key,
    required this.productData,
    required this.product,
    required this.userId,
    required this.user,
  }) : super(key: key);

  @override
  _HomeVisiteurState createState() => _HomeVisiteurState();
}

class _HomeVisiteurState extends State<HomeVisiteur> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isFavorite = false;
  final TextEditingController _searchController = TextEditingController();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
      final productRef = FirebaseFirestore.instance.collection('ListeEnvie').doc(widget.product.productId);

      if (isFavorite) {
        // Ajouter le produit à la liste d'envies
        await productRef.set({
          'productId': widget.product.productId,
          'productName': widget.productData['nom'],
          'productPrice': widget.productData['prix'],
          'imageProduct': widget.productData['imageUrl'],
          'marqueProduct': widget.productData['marque'],
          'salePrixProduct': widget.productData['salePrix'],
          'remiseProduct': widget.productData['remise'],
        });
      } else {
        // Supprimer le produit de la liste d'envies
        await productRef.delete();
      }

      print('Produit ajouté/supprimé de la liste d\'envies avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout/suppression du produit à la liste d\'envies : $e');
    }
  }

  final List<String> _imagePaths = [
    'images/promo3.jpg',
    'images/promos1.jpg',
    'images/promo4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(userId: widget.userId, product: widget.product, productData: widget.productData, user: widget.user),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.search,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search here....",
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _imagePaths.length,
                    itemBuilder: (context, index) {
                      return _buildImage(_imagePaths[index]);
                    },
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 10.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            HorizontalList(product: widget.product, userId: widget.userId, productData: widget.productData),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TousProduitsViteur(productData: widget.product.productData, product: widget.product, userId: widget.userId),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Recommandé pour vous',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                 
                    quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        },
                        child: ProductCard(product: product, userId: widget.userId, productData: widget.productData,),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  OffresSpecialesPageVisiteur(productData: widget.productData, userId: widget.userId, product: widget.product),
                        ),
                      );
                    },
                    child: Text(
                      'Offres Spéciales sélectionnées',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 63,),
                  GestureDetector(
                    /*onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NextPage()),
                      );
                    },*/
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
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
                    prix: data['prix'].toDouble(),
                    categoryIds: List<String>.from(data['categoryIds'] ?? []),
                    salePrix: data['salePrix'].toDouble(),
                    quantityP: data['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
                    enStock: data['en_stock'] ?? false,
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
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        },
                        child: ProductCard(
                          product: product,
                          userId: widget.userId,
                          productData: widget.productData,
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

  Widget _buildImage(String imagePath) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 300, 
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _imagePaths.length; i++) {
      indicators.add(_indicator(i == _currentPage));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}