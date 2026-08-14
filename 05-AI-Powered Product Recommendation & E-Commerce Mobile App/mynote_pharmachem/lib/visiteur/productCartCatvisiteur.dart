import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/WelcomeScreendeux.dart';
import 'package:mynote_pharmachem/productdetailspage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
class ProductCardCatVisiteur extends StatefulWidget {
  final Product product;
  final String userId;
  final DocumentSnapshot productData;

  const ProductCardCatVisiteur({
    Key? key,
    required this.product,
    required this.userId,
    required this.productData,
  }) : super(key: key);

  @override
  _ProductCardCatVisiteurState createState() => _ProductCardCatVisiteurState();
}

class _ProductCardCatVisiteurState extends State<ProductCardCatVisiteur> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Vérifier périodiquement si la date de début de la promotion est atteinte
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {}); // Redessiner le widget à chaque tick du timer
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Arrêter le timer lors de la suppression du widget
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  DateTime? saleStartTime = widget.product.saleStartTime;
  DateTime? saleEndTime = widget.product.saleEndTime;
  bool isOnSale = false;

  if (saleStartTime != null && saleEndTime != null) {
    DateTime currentTime = DateTime.now();
    if (currentTime.isAfter(saleStartTime) && currentTime.isBefore(saleEndTime)) {
      isOnSale = true;
    }
  }

  String stockStatus = widget.product.quantityP > 0 ? 'En stock' : 'Bientôt en stock';

  double discountPercentage = isOnSale
      ? ((widget.product.prix - widget.product.salePrix) / widget.product.prix) * 100
      : 0.0;

  return Card(
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.product.imageUrl,
                  width: double.infinity,
                  height: 130.0,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.nom,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        widget.product.marque,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        stockStatus, // Affiche "En stock" ou "Bientôt en stock"
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: widget.product.quantityP > 0 ? Colors.green : Colors.orange,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${widget.product.prix} TND',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: isOnSale ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: '\n',
                              style: TextStyle(height: 10),
                            ),
                            if (isOnSale)
                              TextSpan(
                                text: '${widget.product.salePrix} TND',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isOnSale)
              Positioned(
                left: 2.0,
                top: 8.0,
                child: Container(
                  color: Color(0xFFCABFD3),
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    '${discountPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}}