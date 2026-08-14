import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:intl/intl.dart';
class DetailsProduct extends StatefulWidget {
  final DocumentSnapshot productData;
  final String userId;
  DetailsProduct({required this.productData, required this.userId});

  @override
  _DetailsProductState createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _marqueController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController _salePrixController = TextEditingController();
  TextEditingController _applicationController = TextEditingController();
  TextEditingController _compositionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _precautionsController = TextEditingController();
  TextEditingController _productIdController = TextEditingController();
  TextEditingController _proprietesController = TextEditingController();
  TextEditingController _avantagesController = TextEditingController();
  TextEditingController _categoryIds = TextEditingController();
  TextEditingController _descriptionController  = TextEditingController();
  TextEditingController _onSaleController = TextEditingController();
  TextEditingController _onStockController = TextEditingController();
  
  late CollectionReference _productsCollection;
 


  @override
  void initState() {
    super.initState();
    _nomController.text = widget.productData['nom'];
    _marqueController.text = widget.productData['marque'];
    _prixController.text = widget.productData['prix'].toString();
    _salePrixController.text = widget.productData['salePrix'].toString();
    _applicationController.text = widget.productData['application'];
    _compositionController.text = widget.productData['composition'];
    _imageUrlController.text =  widget.productData['imageUrl'];
    _precautionsController.text =  widget.productData['precautions'];
    _productIdController.text =  widget.productData['productId'];
    _proprietesController.text =  widget.productData['proprietes'];
    _avantagesController.text = widget.productData['avantages'];
    _categoryIds.text = widget.productData['categoryIds'].join(', ');
    _descriptionController.text = widget.productData['description'];
    _onSaleController.text = widget.productData['onSale'].toString();
    _onStockController.text = widget.productData['en_stock'].toString();
    
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _productIdController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ProductId',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _productIdController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'ProductId': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _nomController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _nomController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'nom': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _marqueController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Marque',
                ),
                onTap: () {
                  _marqueController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _marqueController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'marque': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _prixController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prix',
                ),
                onTap: () {
                  _prixController.selection = TextSelection(
                      baseOffset: 0, extentOffset:  _prixController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'prix': double.parse(value)}); // Mettre à jour Firestore
                },
              ),
            ),
             Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _salePrixController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'salePrix',
                ),
                onTap: () {
                  _prixController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _salePrixController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'salePrix': double.parse(value)}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _applicationController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'application',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _applicationController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'application': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _compositionController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'composition',
                ),
                onTap: () {
                  _marqueController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _compositionController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'composition': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _imageUrlController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'imageUrl',
                ),
                onTap: () {
                  _marqueController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _imageUrlController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'imageUrl': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _precautionsController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'precautions',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _precautionsController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'precautions': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _proprietesController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'proprietes',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _proprietesController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'proprietes': value}); // Mettre à jour Firestore
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _avantagesController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'avantages',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _avantagesController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'avantages': value}); // Mettre à jour Firestore
                },
              ),
            ),
          Padding(
  padding: EdgeInsets.only(bottom: 10),
  child: TextFormField(
    controller: _categoryIds,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'categoryIds',
    ),
    onChanged: (value) {
      // Divisez les avantages en une liste en utilisant la virgule comme séparateur
      List<String> categoryIdsList = value.split(',');

      // Supprimez les espaces autour de chaque élément de la liste
      categoryIdsList = categoryIdsList.map((e) => e.trim()).toList();

      // Mettez à jour le contrôleur avec la liste mise à jour des avantages
      _categoryIds.text = categoryIdsList.join(', ');

      // Mettez à jour les données dans Firestore
      _updateFirestoreData({'categoryIds': categoryIdsList});
    },
  ),
),
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _descriptionController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'description',
                ),
                onTap: () {
                  _nomController.selection = TextSelection(
                      baseOffset: 0, extentOffset: _descriptionController.text.length);
                },
                onChanged: (value) {
                  _updateFirestoreData({'description': value}); // Mettre à jour Firestore
                },
              ),
            ),
Padding(
  padding: EdgeInsets.only(bottom: 10),
  child: TextFormField(
    controller: _onSaleController,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'En vente',
    ),
    onChanged: (value) {
      // Mettez à jour les données dans Firestore lorsque la valeur change
      _updateFirestoreData({'onSale': value.toLowerCase() == 'true'});
    },
  ),
),
Padding(
  padding: EdgeInsets.only(bottom: 10),
  child: TextFormField(
    controller: _onStockController,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'En Stock',
    ),
    onChanged: (value) {
      // Mettez à jour les données dans Firestore lorsque la valeur change
      _updateFirestoreData({'En stock': value.toLowerCase() == 'true'});
    },
  ),
),


          ],
          
        ),
      ),
    );
  }

  Future<void> _updateFirestoreData(Map<String, dynamic> data) async {
    data['avantages'] = _avantagesController.text.split(',').map((e) => e.trim()).toList();
     data['categoryIds'] = _categoryIds.text.split(',').map((e) => e.trim()).toList();
    data['description'] = _descriptionController.text.split(',').map((e) => e.trim()).toList();
    data['onSale'] = _onSaleController.text.toLowerCase() == 'true'; 
    data['en_stock'] = _onStockController.text.toLowerCase() == 'true';
    await _productsCollection.doc(widget.productData.id).update(data);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _marqueController.dispose();
    _prixController.dispose();
    _salePrixController.dispose();
    _applicationController.dispose();
    _compositionController.dispose();
    _imageUrlController.dispose();
    _precautionsController.dispose();
    _productIdController.dispose();
    _proprietesController.dispose();
    _avantagesController.dispose();
    _categoryIds.dispose();
    _descriptionController.dispose();
    _onSaleController.dispose();
    _onStockController.dispose();
    super.dispose();
  }
}