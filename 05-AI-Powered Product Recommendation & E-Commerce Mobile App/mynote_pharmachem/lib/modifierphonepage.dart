import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ModifierPhonePage extends StatefulWidget {
  @override
  _ModifierPhonePageState createState() => _ModifierPhonePageState();
}

class _ModifierPhonePageState extends State<ModifierPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  late User? _user;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _modifierNomComplet(String nouveauPhone) async {
    try {
      await _firestore.collection('users').doc(_user!.uid).update({'phone': nouveauPhone});
      Navigator.pop(context); // Retour à la page précédente après la modification réussie
    } catch (e) {
      // Gérer les erreurs ici, par exemple afficher un message d'erreur à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier Télephone',
          style: TextStyle(
            fontSize: 20.0, // Taille du texte
            fontWeight: FontWeight.bold, // Poids de la police
            color: Colors.white, // Couleur du texte
            letterSpacing: 1.2, // Espacement entre les lettres
          ),
        ),
        backgroundColor: Color(0xFFA32CC4),       
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text(
                'Nouveau Téléphone',
                style: TextStyle(
                  fontSize: 18.0, // Taille du texte
                  fontWeight: FontWeight.bold, // Poids de la police
                  color: Colors.black, // Couleur du texte
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Entrez le nouveau Téléphone',
                ),
              ),
              SizedBox(height: 300.0),
              ElevatedButton(
                onPressed: () {
                  String nouveauphone = _phoneController.text.trim();
                  if (nouveauphone.isNotEmpty) {
                    _modifierNomComplet(nouveauphone);
                  } else {
                    // Afficher un message d'erreur si le champ est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Veuillez entrer un nouveau téléphone.')),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA32CC4)), 
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 70)), 
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), 
                    ),
                  ),
                ),
                child: Text(
                  'Envoyer',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Fond blanc
                  side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey)), // Bordure grise
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 60)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}