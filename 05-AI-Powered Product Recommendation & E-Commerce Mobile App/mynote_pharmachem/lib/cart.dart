/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/itemcard.dart';
class Cart {
  List<CartItem> _items = [];

  void addToCart(String productId, int quantity) {
    // Recherchez si le produit est déjà dans le panier
    int index = _items.indexWhere((item) => item.productId == productId);
    
    if (index != -1) {
      // Si le produit est déjà dans le panier, mettez à jour la quantité
      _items[index].quantity += quantity;
    } else {
      // Sinon, ajoutez un nouvel élément au panier
      _items.add(CartItem(
        productId: productId,
        quantity: quantity,
      ));
    }
  }
  Future<void> addToFirestore() async {
    // Convertir les éléments du panier en List<Map<String, dynamic>>
    List<Map<String, dynamic>> cartData = _items.map((item) => item.toMap()).toList();
    
    // Ajouter les données du panier à Firestore
    try {
      await FirebaseFirestore.instance.collection('users').doc('userID').set({'cart': cartData});
      print('Le panier a été ajouté à Firestore avec succès.');
    } catch (error) {
      print('Erreur lors de l\'ajout du panier à Firestore: $error');
    }
  }
}*/