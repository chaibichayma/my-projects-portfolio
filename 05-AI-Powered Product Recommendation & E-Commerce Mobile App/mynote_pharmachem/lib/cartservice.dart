import 'package:cloud_firestore/cloud_firestore.dart';
class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour ajouter un produit au panier
  Future<void> addToCart(String userId, String productId, String productName, double productPrice, int quantity) async {
  try {
    // Vérifie si le produit existe déjà dans le panier de l'utilisateur
    final existingProduct = await _firestore.collection('users').doc(userId).collection('Cart').where('productId', isEqualTo: productId).get();
    if (existingProduct.docs.isNotEmpty) {
      // Si le produit existe déjà, mettez à jour la quantité du produit existant
      final cartItemId = existingProduct.docs.first.id;
      final currentQuantity = existingProduct.docs.first['quantity'] as int;
      await _firestore.collection('users').doc(userId).collection('Cart').doc(cartItemId).update({
        'quantity': currentQuantity + quantity,
      });
      print('Quantité du produit mise à jour avec succès');
    } else {
      // Si le produit n'existe pas, ajoutez-le au panier
      await _firestore.collection('users').doc(userId).collection('Cart').add({
        'productId': productId,
        'nom': productName,
        'prix': productPrice,
        'quantity': quantity,
      });
      print('Produit ajouté au panier avec succès');
    }
  } catch (e) {
    print('Erreur lors de l\'ajout du produit au panier : $e');
  }
}

  // Méthode pour récupérer le contenu du panier d'un utilisateur
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      final cartSnapshot = await _firestore.collection('users').doc(userId).collection('Cart').get();
      return cartSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Erreur lors de la récupération du contenu du panier : $e');
      return [];
    }
  }

  // Méthode pour supprimer un produit du panier
  Future<void> removeFromCart(String userId, String cartItemId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('Cart').doc(cartItemId).delete();
      print('Produit supprimé du panier avec succès');
    } catch (e) {
      print('Erreur lors de la suppression du produit du panier : $e');
    }
  }

  // Méthode pour mettre à jour la quantité d'un produit dans le panier
  Future<void> updateCartItemQuantity(String userId, String cartItemId, int newQuantity) async {
    try {
      await _firestore.collection('users').doc(userId).collection('Cart').doc(cartItemId).update({
        'quantity': newQuantity,
      });
      print('Quantité du produit mise à jour avec succès');
    } catch (e) {
      print('Erreur lors de la mise à jour de la quantité du produit : $e');
    }
  }
}
