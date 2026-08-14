import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AdresseLivraison extends StatefulWidget {
  @override
  _AdresseLivraisonState createState() => _AdresseLivraisonState();
}

class _AdresseLivraisonState extends State<AdresseLivraison> {
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _nomCompletController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAdresseLivraison();
  }

  Future<void> modifierCommande() async {
    CollectionReference commandes = FirebaseFirestore.instance.collection('commandes');
    QuerySnapshot commandeSnapshot = await commandes.get();

    if (commandeSnapshot.docs.isNotEmpty) {
      String documentId = commandeSnapshot.docs[0].id;
      await commandes.doc(documentId).update({
        'nomComplet': _nomCompletController.text,
        'adresse': _adresseController.text,
        'ville': _villeController.text,
        'codePostal': _codePostalController.text,
        'telephone': _telephoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adresse modifiée avec succès!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucune commande trouvée pour mettre à jour.')),
      );
    }
  }

  void fetchAdresseLivraison() async {
    try {
      QuerySnapshot commandeSnapshot = await FirebaseFirestore.instance.collection('commandes').get();

      if (commandeSnapshot.docs.isNotEmpty) {
        DocumentSnapshot firstCommande = commandeSnapshot.docs.first;
        Map<String, dynamic>? data = firstCommande.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _adresseController.text = data['adresse'] ?? '';
            _codePostalController.text = data['codePostal'] ?? '';
            _nomCompletController.text = data['nomComplet'] ?? '';
            _telephoneController.text = data['telephone'] ?? '';
            _villeController.text = data['ville'] ?? '';
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune commande trouvée')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des données')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFA32CC4),
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        'images/adresses.png',
                        height: 150,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _adresseController, 
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18, 
                    ),              
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      labelStyle: TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _codePostalController,
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18, 
                    ),  
                    decoration: InputDecoration(
                      labelText: 'Code Postal',
                      labelStyle: TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nomCompletController,
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18, 
                    ),  
                    decoration: InputDecoration(
                      labelText: 'Nom Complet',
                      labelStyle: TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _telephoneController,
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18, 
                    ),  
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      labelStyle: TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _villeController,
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18, 
                    ),  
                    decoration: InputDecoration(
                      labelText: 'Ville',
                      labelStyle: TextStyle(
                        color: Colors.black, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    width: double.infinity, 
                    height: 60, 
                    child: ElevatedButton.icon(
                      onPressed: modifierCommande,
                      icon: Icon(Icons.edit),
                      label: Text(
                        'Modifier Adresse',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, 
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA32CC4), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Modifier le rayon pour obtenir un bouton plus circulaire
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}