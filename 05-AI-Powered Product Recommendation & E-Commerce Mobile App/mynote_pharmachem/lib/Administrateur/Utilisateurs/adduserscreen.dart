import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
class AddUserScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 140, // Hauteur de l'image
              child: Image.asset('images/profile2.jpg'), // Remplacez 'your_image.png' par le nom de votre image
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildTextFieldWithIcon(Icons.email, 'Email', emailController),
                  buildTextFieldWithIcon(Icons.person, 'Nom complet', fullNameController),
                  buildTextFieldWithIcon(Icons.lock, 'Mot de passe', passwordController, isPassword: true),
                  buildTextFieldWithIcon(Icons.account_circle, 'Rôle', roleController),
                  buildTextFieldWithIcon(Icons.phone, 'Téléphone', phoneController),
                  SizedBox(height: 42.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA32CC4), // Couleur de fond du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bordures arrondies
                        ),
                        minimumSize: Size(double.infinity, 60), // Taille minimale du bouton
                      ),
                      onPressed: () {
                        addUserToFirestore(context);
                      },
                      child: Text(
                        'Ajouter',
                        style: TextStyle(
                          color: Colors.white, // Couleur du texte en blanc
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                   )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithIcon(IconData iconData, String label, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        ),
      ),
    );
  }

  void addUserToFirestore(BuildContext context) {
  // Vérifier si un champ est vide
  if (emailController.text.isEmpty ||
      fullNameController.text.isEmpty ||
      passwordController.text.isEmpty ||
      roleController.text.isEmpty ||
      phoneController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remplir tous les champs')),
    );
    return; // Arrêter l'exécution de la fonction
  }

  // Si tous les champs sont remplis, continuer avec l'ajout de l'utilisateur
  String hashedPassword = _hashPassword(passwordController.text);
  
  DateTime now = DateTime.now(); // Obtenez la date et l'heure actuelles

  FirebaseFirestore.instance.collection('users').add({
    'email': emailController.text,
    'fullName': fullNameController.text,
    'password': hashedPassword, // Utilisation du mot de passe haché
    'role': roleController.text,
    'phone': phoneController.text,
    'lastModifiedDate': now, // Ajoutez la date de dernière modification
  }).then((_) {
    // Réinitialiser les contrôleurs après l'ajout
    emailController.clear();
    fullNameController.clear();
    passwordController.clear();
    roleController.clear();
    phoneController.clear();

    // Fermer l'écran d'ajout d'utilisateur
    Navigator.of(context).pop();

    // Afficher un message de succès ou naviguer vers une autre page si nécessaire
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utilisateur ajouté avec succès')),
    );
  }).catchError((error) {
    // Afficher un message d'erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'ajout de l\'utilisateur : $error')),
    );
  });
}
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convertir le mot de passe en bytes
    var hash = sha256.convert(bytes); // Appliquer le hachage SHA-256
    return hash.toString();
  }
}