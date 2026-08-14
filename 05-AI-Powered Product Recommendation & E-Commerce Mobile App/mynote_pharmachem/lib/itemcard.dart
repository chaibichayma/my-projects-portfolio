import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:mynote_pharmachem/commandepage.dart';
import 'package:mynote_pharmachem/home_screen.dart';
import 'package:mynote_pharmachem/produits.dart';



class CartItemList extends StatelessWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;
  final User user;
  CartItemList({
    required this.productData,
    required this.product,
    required this.userId,
    required this.user,
  });

  static const String productPriceKey = 'productPrice';
  static const String salePrixProductKey = 'salePrixProduct';
  static const String remiseProductKey = 'remiseProduct';
  void _checkAndAddTotalField() async {
  try {
    var userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var userData = await userDocRef.get();
    if (!userData.exists || userData.data()!['total'] == null) {
      // Vérifiez si le panier est vide
      var cartSnapshot = await userDocRef.collection('Cart').get();
      if (cartSnapshot.docs.isNotEmpty) {
        double totalPrice = calculateTotalPrice(cartSnapshot.docs);
        await userDocRef.set({'total': totalPrice}, SetOptions(merge: true));
      } else {
        // Si le panier est vide, définissez le total par défaut à 0.0
        await userDocRef.set({'total': 0.0}, SetOptions(merge: true));
      }
    }
  } catch (e) {
    print('Erreur lors de la vérification et de l\'ajout du champ total : $e');
  }
}
  @override
  Widget build(BuildContext context) {
    _checkAndAddTotalField();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          if (snapshot.data!.docs.isEmpty) {
            return buildEmptyCartWidget(context);
          } else {
            return buildCartItemsWidget(context, snapshot.data!.docs);
          }
        }
      },
    );
  }

  Widget buildEmptyCartWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/panier.png', width: 120, height: 120),
        SizedBox(height: 20),
        Text('Votre panier est vide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Parcourez nos catégories \ndécouvrez nos meilleures ', style: TextStyle(fontSize: 20)),
        Center(child: Text('offres', style: TextStyle(fontSize: 18))),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(productData: productData, product: product, userId: userId, user: user, ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'Commencez Vos achats',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE5DBED),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: Size(200, 50), // Width and height customization
          ),
        ),
      ],
    );
  }

  Widget buildCartItemsWidget(BuildContext context, List<DocumentSnapshot> cartItems) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                calculateTotalPrice(cartItems).toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            var doc = cartItems[index];
            int quantity = doc['quantity'];
            double productPrice = (doc[productPriceKey] ?? 0).toDouble();
            double salePrixProduct = (doc[salePrixProductKey] ?? 0).toDouble();
            double remise = (doc[remiseProductKey] ?? 0).toDouble();
            bool onSale = salePrixProduct < productPrice;

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        doc['imageProduct'],
                        fit: BoxFit.contain,
                        width: 80,
                        height: 100,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['productName']),
                            Text('${doc['marqueProduct']}'),
                            Text('${doc['productPrice'].toStringAsFixed(2)}'),
                            if (onSale) ...[
                              Text('${(salePrixProduct - remise).toStringAsFixed(2)}'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                margin: EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE5DBED),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${remise.toStringAsFixed(2)} %',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Cart')
                              .doc(doc.id)
                              .delete();
                        },
                        child: Text('Supprimer', style: TextStyle(color: Colors.purple)),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                        ),
                      ),
                      SizedBox(width: 20),
                      Transform.translate(
                        offset: Offset(-15, -5),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  if (quantity > 1) {
                                    _updateQuantity(doc.id, quantity - 1);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('$quantity', style: TextStyle(color: Colors.purple)),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  _updateQuantity(doc.id, quantity + 1);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _clearCart(context);
          },
          child: Text(
            'Vider le panier',
            style: TextStyle(
              fontSize: 19,
              color: Colors.black, // Couleur du texte
              fontWeight: FontWeight.bold, // Gras
            ),),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 55), 
            backgroundColor: Color(0xFFE5DBED),
            shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Bordures circulaires
    ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _placeOrder(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommandeFormulaire()),
            );
          },
          child: Text(
            'Commander',
            style: TextStyle(
              fontSize: 19,
              color: Colors.white, // Couleur du texte
              fontWeight: FontWeight.bold, // Gras
            ),),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(220, 50), 
            backgroundColor: Color(0xFFBB7EB2),
            shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Bordures circulaires
    ),
          ),
        ),
      ],
    );
  }

  double calculateTotalPrice(List<DocumentSnapshot> documents) {
    double totalPrice = 0;
    for (var doc in documents) {
      double productPrice = (doc[productPriceKey] ?? 0).toDouble();
      int quantity = doc['quantity'];
      totalPrice += productPrice * quantity;
    }
    return totalPrice;
  }

  Future<void> _updateQuantity(String docId, int quantity) async {
  try {
    var docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .doc(docId);

    await docRef.update({'quantity': quantity});
    print('Mise à jour de la quantité réussie');

    // Mettre à jour le montant total après avoir modifié la quantité
    double totalPrice = calculateTotalPrice(await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .get()
        .then((snapshot) => snapshot.docs));
    await _updateTotalField(totalPrice);
  } catch (e) {
    print('Erreur lors de la mise à jour de la quantité : $e');
  }
}


  void _clearCart(BuildContext context) async {
  try {
    var cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart');

    await cartRef.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // Mettre à jour le champ "total" à 0.0 après avoir vidé le panier
    await _updateTotalField(0.0);

    print('Panier vidé avec succès');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Panier vidé avec succès')),
    );
  } catch (e) {
    print('Erreur lors de la suppression du panier : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression du panier. Veuillez réessayer.')),
    );
  }
}
  void _placeOrder(BuildContext context) async {
    try {
      double totalPrice = calculateTotalPrice(await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .get()
          .then((snapshot) => snapshot.docs));

      await _updateTotalField(totalPrice);

      
    } catch (e) {
      print('Erreur lors de la commande : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la commande. Veuillez réessayer.')),
      );
    }
  }

  Future<void> _updateTotalField(double total) async {
  try {
    var userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var userData = await userDocRef.get();
    if (userData.exists) {
      await userDocRef.update({'total': total});
    } else {
      await userDocRef.set({'total': total});
    }
  } catch (e) {
    print('Erreur lors de la mise à jour du total : $e');
  }
}

}