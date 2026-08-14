import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
class Compte extends StatefulWidget {
  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  late User? _user;
  late FirebaseFirestore _firestore;
  late TextEditingController _textFieldController;
  bool _isTextFieldValid = false;
  StreamController<DocumentSnapshot> _streamController =
      StreamController<DocumentSnapshot>();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _firestore = FirebaseFirestore.instance;
    _textFieldController = TextEditingController();
    _streamController
        .addStream(_firestore.collection('users').doc(_user!.uid).snapshots());
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _editField(BuildContext context, String label) async {
  _textFieldController.text = '';
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier $label'),
        content: TextField(
          controller: _textFieldController,
          onChanged: (value) {
            setState(() {
              _isTextFieldValid = value.isNotEmpty;
            });
          },
          decoration: InputDecoration(
            hintText: 'Entrez votre nouveau $label',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Valider'),
            onPressed: () async {
              if (_isTextFieldValid) {
                var newData = _textFieldController.text;

                if (label == 'Nom complet') {
                  _firestore
                      .collection('users')
                      .doc(_user!.uid)
                      .update({'fullName': newData});
                } else if (label == 'Email') {
                  _firestore
                      .collection('users')
                      .doc(_user!.uid)
                      .update({'email': newData});
                } else if (label == 'Téléphone') {
                  _firestore
                      .collection('users')
                      .doc(_user!.uid)
                      .update({'phone': newData});
                } else if (label == 'Mot de passe') {
                  String hashedPassword = hashPassword(newData);
                  DateTime now = DateTime.now(); // Obtenir la date actuelle
                  // Formater la date selon vos besoins
                  _firestore
                      .collection('users')
                      .doc(_user!.uid)
                      .update({
                        'password': hashedPassword,
                        'lastModifiedDate': now, // Mettre à jour la date de modification
                      });
                }

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Color(0xFFA32CC4),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 700.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Image.asset(
                        'images/removecompte.png',
                        height: 170,
                        width: 170,
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Erreur de chargement des données'));
                        } else {
                          var userData = snapshot.data!.data() as Map<String, dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    Divider(color: Colors.black),
                                    _buildUserInfoContainer('Nom complet', userData['fullName'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Email', userData['email'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Téléphone', userData['phone'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Mot de passe', '******', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoContainer(String label, String value, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  value,
                  style: TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFFA32CC4)),
            onPressed: () {
              _editField(context, label);
            },
          ),
        ],
      ),
    );
  }
}