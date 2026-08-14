import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  final String userId;

  AddProductScreen({required this.userId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController nomController = TextEditingController();
  TextEditingController marqueController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController applicationController = TextEditingController();
  TextEditingController compositionController = TextEditingController();
  TextEditingController precautionsController = TextEditingController();
  TextEditingController proprietesController = TextEditingController();
  TextEditingController avantagesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryIdsController = TextEditingController();
  TextEditingController subCategoryIdsController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController salePrixController = TextEditingController();
  TextEditingController quantityPController = TextEditingController();
   TextEditingController remiseController = TextEditingController();
  DateTime? saleStartTime;
  DateTime? saleEndTime;
 
  bool onSale = false;
  bool en_stock = false;
  Future<void> _selectSaleStartTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          saleStartTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
  Future<void> _selectSaleEndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          saleEndTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  

  Widget _buildTextFieldWithBorder({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
          color: Colors.black, // Couleur du texte du label
          fontSize: 16.0, // Taille de la police du label
          fontWeight: FontWeight.bold, // Gras pour le label
        ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text(
          'Ajouter un produit',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFieldWithBorder(
                controller: productIdController,
                labelText: 'ProductId',
              ),
              _buildTextFieldWithBorder(
                controller: nomController,
                labelText: 'Nom du produit',
              ),
              _buildTextFieldWithBorder(
                controller: marqueController,
                labelText: 'Marque du produit',
              ),
              _buildTextFieldWithBorder(
                controller: imageUrlController,
                labelText: 'URL de l\'image du produit',
              ),
              _buildTextFieldWithBorder(
                controller: applicationController,
                labelText: 'Application',
              ),
              _buildTextFieldWithBorder(
                controller: compositionController,
                labelText: 'Composition',
              ),
              _buildTextFieldWithBorder(
                controller: precautionsController,
                labelText: 'Précautions',
              ),
              _buildTextFieldWithBorder(
                controller: proprietesController,
                labelText: 'Propriétés',
              ),
              _buildTextFieldWithBorder(
                controller: avantagesController,
                labelText: 'Avantages',
              ),
              _buildTextFieldWithBorder(
                controller: descriptionController,
                labelText: 'Description',
              ),
             
              _buildTextFieldWithBorder(
                controller: categoryIdsController,
                labelText: 'CategoryIds',
              ),
              _buildTextFieldWithBorder(
                controller: subCategoryIdsController,
                labelText: 'SubCategoryIds',
              ),
              _buildTextFieldWithBorder(
                controller: prixController,
                labelText: 'Prix',
              ),
              _buildTextFieldWithBorder(
                controller: remiseController,
                labelText: 'Remise',
              ),
              _buildTextFieldWithBorder(
                controller: quantityPController,
                labelText: 'Quantité',
              ),
              _buildTextFieldWithBorder(
                controller: salePrixController,
                labelText: 'Sale Prix',
              ),
              Row(
  children: [
    Text(
      'Date de début de vente: ',
      style: TextStyle(
        fontSize: 16.0, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
        color: Colors.black, // Couleur du texte
      ),
    ),
    IconButton(
      onPressed: _selectSaleStartTime,
      icon: Icon(Icons.access_time), // Icône d'horloge pour la date de début
      tooltip: 'Sélectionner l\'heure de début de vente',
    ),
  ],
),
Row(
  children: [
    Text(
      'Date de fin de vente: ',
      style: TextStyle(
        fontSize: 16.0, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
        color: Colors.black, // Couleur du texte
      ),
    ),
    IconButton(
      onPressed: _selectSaleEndTime,
      icon: Icon(Icons.access_alarm), // Icône de réveil pour la date de fin
      tooltip: 'Sélectionner l\'heure de fin de vente',
    ),
  ],
),
               
              CheckboxListTile(
                title: Text(
      'En vente: ',
      style: TextStyle(
        fontSize: 16.0, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
        color: Colors.black, // Couleur du texte
      ),
    ),
                value: onSale,
                onChanged: (value) {
                  setState(() {
                    onSale = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text(
      'En stock: ',
      style: TextStyle(
        fontSize: 16.0, // Taille de la police
        fontWeight: FontWeight.bold, // Gras
        color: Colors.black, // Couleur du texte
      ),
    ),
                value: en_stock,
                onChanged: (value) {
                  setState(() {
                    en_stock = value!;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFA32CC4),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _addProductToFirestore();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _addProductToFirestore() async {
    try {
      String nom = nomController.text.trim();
      String marque = marqueController.text.trim();
      String imageUrl = imageUrlController.text.trim();
      String productId = productIdController.text.trim();
      String application = applicationController.text.trim();
      String composition  = compositionController.text.trim();
      String precautions = precautionsController.text.trim();
      String proprietes = proprietesController.text.trim();
      String avantages = avantagesController.text.trim();
      String description = descriptionController.text.trim();
      String categoryIds = categoryIdsController.text.trim();
      String subCategoryIds = subCategoryIdsController.text.trim();
      String prix = prixController.text.trim();
      String salePrix = salePrixController.text.trim();
      String quantityP = quantityPController.text.trim();
      String remise = remiseController.text.trim();

       if (salePrix.isEmpty || double.tryParse(salePrix) == null) {
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Veuillez saisir un salePrix valide.'),
    ),
  );
  return;
}
 if (remise.isEmpty || double.tryParse(remise) == null) {
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Veuillez saisir une remise valide.'),
    ),
  );
  return;
}
 if (quantityP.isEmpty || int.tryParse(quantityP) == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Veuillez saisir une quantité valide.'),
    ),
  );
  return;
}
int quantityPInt = int.parse(quantityP);
if (quantityPInt is! int) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Une erreur est survenue lors de la conversion de la quantité.'),
    ),
  );
  return;
}
      if (prix.isEmpty || double.tryParse(prix) == null) {
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Veuillez saisir un prix valide.'),
    ),
  );
  return;
}

      // Vérifiez que les champs ne sont pas vides
      if (nom.isEmpty || marque.isEmpty || imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Veuillez remplir tous les champs.'),
        ));
        return;
      }

      // Ajoutez le nouveau produit à la collection Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'nom': nom,
        'marque': marque,
        'imageUrl': imageUrl,
        'productId': productId,
        'application': application,
        'composition': composition,
        'precautions': precautions,
        'proprietes': proprietes,
        'avantages': avantages,
        'description': description,
        'categoryIds': categoryIds.split(','),
        'subCategoryIds': subCategoryIds.split(','),
        'prix': double.parse(prix),
        'remise': double.parse(remise),
        'salePrix': double.parse(salePrix),
        'onSale': onSale,
        'en_stock': en_stock,
        'quantityP': quantityPInt,
        'saleStartTime': saleStartTime, 
        'saleEndTime': saleEndTime,
        // Ajoutez d'autres champs si nécessaire
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Produit ajouté avec succès.'),
      ));

      // Effacez les champs après l'ajout du produit
      nomController.clear();
      marqueController.clear();
      imageUrlController.clear();
      productIdController.clear();
      applicationController.clear();
      compositionController.clear();
      precautionsController.clear();
      proprietesController.clear();
      avantagesController.clear();
      descriptionController.clear();
      categoryIdsController.clear();
      subCategoryIdsController.clear();
      prixController.clear();
      salePrixController.clear();
      quantityPController.clear();
      remiseController.clear();

    } catch (e) {
      print('Erreur lors de l\'ajout du produit: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'ajout du produit.'),
      ));
    }
  }

    

  }