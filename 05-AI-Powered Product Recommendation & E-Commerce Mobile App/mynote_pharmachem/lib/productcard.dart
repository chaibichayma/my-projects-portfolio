import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
class ProductCard extends StatefulWidget {
  final Product product;
  final String userId;
  final DocumentSnapshot productData;

  const ProductCard({
    Key? key,
    required this.product,
    required this.userId,
    required this.productData,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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

  double discountPercentage = isOnSale
      ? ((widget.product.prix - widget.product.salePrix) / widget.product.prix) * 100
      : 0.0;

  String stockStatus = widget.product.quantityP > 0 ? 'En stock' : 'Bientôt en stock';

  return Card(
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              height: 65.0,
              child: Center(
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (isOnSale) // Affichez la remise uniquement si le produit est en promotion et dans la période définie
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  color: Color(0xFFCABFD3),
                  child: Text(
                    '${discountPercentage.toStringAsFixed(2)} %',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.from([
              Text(
                widget.product.nom,
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Marque: ' + widget.product.marque,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
              ),
              Text(
                stockStatus, // Affiche "En stock" ou "Bientôt en stock"
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: widget.product.quantityP > 0 ? Colors.green : Colors.orange),
              ),
            ])
              ..addAll([
                isOnSale
                    ? Row(
                        children: [
                          Text(
                            'Prix: ',
                            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.product.prix.toStringAsFixed(2)} TND',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${widget.product.salePrix.toStringAsFixed(2)} TND',
                            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      )
                    : Text(
                        'Prix: ${widget.product.prix.toStringAsFixed(2)} TND',
                        style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                      ),
              ]),
          ),
        ),
      ],
    ),
  );
}}