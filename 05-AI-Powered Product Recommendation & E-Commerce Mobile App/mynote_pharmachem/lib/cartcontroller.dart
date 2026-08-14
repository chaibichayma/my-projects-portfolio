import 'package:mynote_pharmachem/produits.dart';

class CartController {
  List<Product> cartItems = [];

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }
}