import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/Administrateur/panier/addproductpanier.dart';
class CartDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> itemDetails;

  CartDetailsPage({required this.itemDetails});

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          'Details de panier',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
  itemCount: widget.itemDetails.length,
  itemBuilder: (context, index) {
    Map<String, dynamic> currentItem = widget.itemDetails[index];
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 _buildCartItemDetail(
                              label: 'Marque:',
                              value: currentItem['marqueProduct'] ?? '',
                              
                            ),
                            SizedBox(height: 4),
                            _buildCartItemDetail(
                              label: 'Image:',
                              value: currentItem['imageProduct'] ?? '',
                              
                            ),
                            SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Product ID:',
                        value: currentItem['productId'] ?? '',
                        
                      ),
                      SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Product Name:',
                        value: currentItem['productName'] ?? '',
                        
                      ),
                      SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Product Price:',
                        value: currentItem['productPrice']?.toString() ?? '',
                        
                      ),
                      SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Quantity:',
                        value: currentItem['quantity']?.toString() ?? '',
                        
                      ),
                      SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Remise:',
                        value: currentItem['remiseProduct']?.toString() ?? '',
                        
                      ),
                      SizedBox(height: 4),
                      _buildCartItemDetail(
                        label: 'Sale Price:',
                        value: currentItem['salePrixProduct']?.toString() ?? '',
                       
                      ),
                      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeItemFromCart(currentItem),
            color: Colors.purple,
          ),
        ],
      ),

              ],
            ),
          ),
          
        ],
      ),
    );
  },
),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddToCartPage()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5DBED), // Couleur de fond du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                ),
                minimumSize: Size(400, 50), // Largeur et hauteur du bouton
              ),
              child: Text(
                'Ajouter',
                style: TextStyle(
                  fontSize: 22, // Taille de la police
                  fontWeight: FontWeight.bold, // Police en gras
                  color: Colors.black, // Couleur du texte
                ),
              ),
            ),
          ),
        
SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _clearCart;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA32CC4), // Couleur de fond du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                ),
                minimumSize: Size(400, 50), // Largeur et hauteur du bouton
              ),
              child: Text(
                'Vider le panier',
                style: TextStyle(
                  fontSize: 20, // Taille de la police
                  fontWeight: FontWeight.bold, // Police en gras
                  color: Colors.white, // Couleur du texte
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }


 Widget _buildCartItemDetail({required String label, required String value}) {
    return Text(
      '$label $value',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
  void _removeItemFromCart(Map<String, dynamic> currentItem) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Récupérer la référence à la sous-collection 'Cart' de l'utilisateur actuel
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Cart');

      // Effectuer une requête pour trouver le document correspondant au nom du produit
      QuerySnapshot querySnapshot = await cartRef
          .where('productName', isEqualTo: currentItem['productName'])
          .get();

      // Supprimer le document trouvé de la sous-collection 'Cart'
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();

        // Mettre à jour l'interface en supprimant également l'élément de la liste des détails du panier
        setState(() {
          widget.itemDetails.remove(currentItem);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le produit a été supprimé du panier avec succès.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le produit n\'a pas été trouvé dans le panier.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aucun utilisateur connecté.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print('Erreur lors de la suppression du produit du panier: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Une erreur s\'est produite lors de la suppression du produit du panier.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
  void _clearCart() async {
  try {
    // Vérifier si l'utilisateur est connecté
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Récupérer la référence à la sous-collection 'Cart' de l'utilisateur actuel
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Cart');

      // Obtenir tous les documents dans la sous-collection 'Cart'
      QuerySnapshot cartSnapshot = await cartRef.get();

      // Supprimer chaque document dans la sous-collection 'Cart'
      for (QueryDocumentSnapshot cartDoc in cartSnapshot.docs) {
        await cartDoc.reference.delete();
      }

      // Mettre à jour l'interface en vidant également la liste des détails du panier
      setState(() {
        widget.itemDetails.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le panier a été vidé avec succès.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aucun utilisateur connecté.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print('Erreur lors de la suppression des éléments du panier: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Une erreur s\'est produite lors de la suppression des éléments du panier.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
}