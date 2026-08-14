import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote_pharmachem/produits.dart';
class ProductDetailsPage extends StatefulWidget {
  final DocumentSnapshot productData;
  final Product product;
  final String userId;
  ProductDetailsPage({required this.productData, required this.product, required this.userId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isFavorite = false;
  int quantity = 1;
   bool showDetails = false;

  void toggleFavorite() async {
  setState(() {
    isFavorite = !isFavorite;
  });

  try {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId);
    
    final productRef = FirebaseFirestore.instance
        .collection('ListeEnvie')
        .doc(widget.product.productId);

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
  Future<void> _updateTotal() async {
  try {
    var userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var cartDocs = await userRef.collection('Cart').get();

    double total = 0;
    for (var doc in cartDocs.docs) {
      double productPrice = (doc['productPrice'] ?? 0).toDouble();
      int quantity = doc['quantity'];
      total += productPrice * quantity;
    }

    // Utilisez une clé de type String pour le champ 'total'
    await userRef.update({'total': total.toString()});
  } catch (e) {
    print('Erreur lors de la mise à jour du total : $e');
  }
}
void toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }
  Future<void> addToCart() async {
  try {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('Cart');

    // Vérifier si le produit existe déjà dans le panier
    final existingProduct = await cartRef
        .where('productId', isEqualTo: widget.product.productId)
        .get();

    if (existingProduct.docs.isNotEmpty) {
      // Le produit existe déjà, mettre à jour la quantité
      final docId = existingProduct.docs.first.id;
      final currentQuantity = existingProduct.docs.first['quantity'];
      final updatedQuantity = currentQuantity + quantity;

      await cartRef.doc(docId).update({'quantity': updatedQuantity});
    } else {
      // Le produit n'existe pas, l'ajouter au panier
      await cartRef.add({
        'productId': widget.product.productId,
        'productName': widget.productData['nom'],
        'productPrice': widget.productData['prix'],
        'imageProduct': widget.productData['imageUrl'],
        'marqueProduct': widget.productData['marque'],
        'salePrixProduct': widget.productData['salePrix'],
        'remiseProduct': widget.productData['remise'],
        'quantity': quantity,
      });
    }

    print('Produit ajouté au panier avec succès');

    // Mettre à jour le total après avoir ajouté le produit au panier
    _updateTotal();
  } catch (e) {
    print('Erreur lors de l\'ajout du produit au panier : $e');
  }
}

  
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData['nom'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFA32CC4),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                '${widget.productData['nom']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.productData['imageUrl'] != null)
              Stack(
                children: [
                  InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 3.0,
                    child: Image.network(
                      widget.productData['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: toggleFavorite,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Marque: ${widget.productData['marque']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Prix: ${widget.productData['prix']} TND',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: SizedBox(
                height: 200,
                child: Container(
                  padding: EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      
                      ElevatedButton( 
                        onPressed: addToCart,
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordures circulaires
                        ),
                          textStyle: TextStyle(fontSize: 18, color: Colors.white),
                          minimumSize: Size(100, 50),
                        ),
                        child: Text(
                          'Ajouter au panier',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA32CC4),
                          shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Bordures circulaires
    ),
                          textStyle: TextStyle(fontSize: 18, color: Colors.white),
                          minimumSize: Size(100, 50),
                        ),
                        child: Text(
                          'Passer une commande',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,),
            ElevatedButton(
              onPressed: () {
                toggleDetails(); // Basculer la visibilité des détails
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5DBED), // Changer la couleur de fond  
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                ),
                minimumSize: Size(double.infinity, 50), // Centrer le bouton
              ),
              child: Text(
                showDetails ? 'Cacher les détails' : 'Afficher les détails',
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            if (showDetails)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            if (widget.productData['description'] != null && widget.productData['description'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['description']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6),
            if (widget.productData['composition'] != null && widget.productData['composition'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Composition:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['composition']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6),
            if (widget.productData['proprietes'] != null && widget.productData['proprietes'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Propriétés:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['proprietes']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6),
            if (widget.productData['precautions'] != null && widget.productData['precautions'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Précautions:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['precautions']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6),
            if (widget.productData['avantages'] != null && widget.productData['avantages'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Avantages:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['avantages']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 6),
            if (widget.productData['application'] != null && widget.productData['application'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Mode d\'application:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${widget.productData['application']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),],
              ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}