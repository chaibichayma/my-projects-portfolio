import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mynote_pharmachem/user_model.dart';
import 'package:intl/intl.dart'; 
class EditUserScreen extends StatefulWidget {
  final String userId;

  EditUserScreen({required this.userId});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late Userr user  = Userr.empty();
  


  @override
  void initState() {
    super.initState();
    // Chargez les données de l'utilisateur à partir de Firestore dans initState
    loadUserData();
  }

  void loadUserData() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    if (userSnapshot.exists) {
      // Extract the timestamp field from the snapshot
      Timestamp timestamp = userSnapshot.data()?['lastModifiedDate'] ?? Timestamp.now();

      // Convert the Timestamp to DateTime
      DateTime dateTime = timestamp.toDate();

      // Use the fromFirestore constructor to convert Firestore data to Userr object
      user = Userr.fromFirestore(userSnapshot); // Remove dateTime argument

      setState(() {}); // Update the UI after loading the data
    } else {
      print('User not found in Firestore');
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier un utilisateur'),
      ),
      body: SingleChildScrollView( // Ajouter SingleChildScrollView ici
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                child: Image.asset('images/modifier.png'),
              ),
              SizedBox(height: 17),
              buildTextField('Nom complet', user.fullName, Icons.person, onChanged: (value) => user.fullName = value),
              buildTextField('Email', user.email, Icons.email, onChanged: (value) => user.email = value),
              buildTextField('Téléphone', user.phone, Icons.phone, onChanged: (value) => user.phone = value),
              buildTextField('Mot de passe', user.password, Icons.lock, onChanged: (value) => user.password = value, isPassword: true),
              buildTextField('Rôle', user.role, Icons.account_circle, onChanged: (value) => user.role = value),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () => saveUserChanges(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA32CC4),
                  minimumSize: Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Enregistrer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, IconData prefixIcon, {bool isPassword = false, void Function(String)? onChanged}) {
    TextEditingController controller = TextEditingController(text: value);
    controller..selection = TextSelection.collapsed(offset: controller.text.length);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          prefixIcon: Icon(prefixIcon),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
   void saveUserChanges() async {
  try {


    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'fullName': user.fullName,
      'email': user.email,
      'phone': user.phone,
      'role': user.role,
    });
    print('User updated successfully');
    Navigator.pop(context); // Return to the user list after update
  } catch (e) {
    print('Error updating user: $e');
  }
}

  
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}