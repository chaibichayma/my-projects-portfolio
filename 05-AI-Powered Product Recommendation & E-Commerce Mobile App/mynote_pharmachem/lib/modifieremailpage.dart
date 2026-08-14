import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ModifierEmailPage extends StatefulWidget {
  @override
  _ModifierEmailPageState createState() => _ModifierEmailPageState();
}

class _ModifierEmailPageState extends State<ModifierEmailPage> {
  final TextEditingController _emailController = TextEditingController();
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
    _emailController.dispose();
    super.dispose();
  }

  void _modifierEmail(String nouveauEmail) async {
    try {
      await _firestore.collection('users').doc(_user!.uid).update({'email': nouveauEmail});
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
          'Modifier Email',
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
                'Nouveau Email',
                style: TextStyle(
                  fontSize: 18.0, // Taille du texte
                  fontWeight: FontWeight.bold, // Poids de la police
                  color: Colors.black, // Couleur du texte
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(                     
                    hintText: 'Entrez le nouveau Email',
                    border: InputBorder.none, 
                  ),
                ),
              ),
              SizedBox(height: 300.0),
              ElevatedButton(
                onPressed: () {
                  String nouveauEmail = _emailController.text.trim();
                  if (nouveauEmail.isNotEmpty) {
                    _modifierEmail(nouveauEmail);
                  } else {
                    // Afficher un message d'erreur si le champ est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Veuillez entrer un nouveau Email.')),
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