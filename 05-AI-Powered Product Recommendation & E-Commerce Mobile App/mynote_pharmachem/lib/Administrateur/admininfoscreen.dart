import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:crypto/crypto.dart';
import 'dart:math';


class AdminInfoScreen extends StatefulWidget {
  final String userId;

  AdminInfoScreen({required this.userId});

  @override
  _AdminInfoScreenState createState() => _AdminInfoScreenState();
}

class _AdminInfoScreenState extends State<AdminInfoScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late Map<String, dynamic> userData; // Déclaration de la variable ici

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Row(
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(width: 25.0), // Espacement horizontal entre l'icône et le texte
          Text(
            'Informations Administrateur',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFA32CC4),
    ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur s\'est produite'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Aucune donnée trouvée'));
          }

          userData = snapshot.data!.data()! as Map<String, dynamic>; // Assignation ici

          var role = userData['role'];
          if (role != 'admin') {
            return Center(child: Text('Vous n\'êtes pas autorisé à accéder à cette page'));
          }

          fullNameController.text = userData['fullName'];
          emailController.text = userData['email'];
          passwordController.text = userData['password'];

          return Container(
            color: Color(0xFFA32CC4),
            child: Center(
              child: Container(
                width: double.infinity,
                height: 500.0,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditableInfoField('Nom Complet', fullNameController),
                    SizedBox(height: 20,),
                    _buildEditableInfoField('Email', emailController),
                    SizedBox(height: 20,),
                    _buildEditableInfoField('Mot de passe', passwordController),
                    SizedBox(height: 20,),
                    _buildInfoField('Rôle', userData['role']),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
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
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
  void _showFullNameDialog() async {
  TextEditingController fullNameController = TextEditingController(text: userData['fullName']);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier le Nom Complet'),
        content: TextField(
          controller: fullNameController,
          decoration: InputDecoration(hintText: 'Nouveau Nom Complet'),
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
              // Mettre à jour userData localement
              setState(() {
                userData['fullName'] = fullNameController.text;
              });

              try {
                // Mettre à jour les données dans Firestore
                await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
                  'fullName': fullNameController.text,
                });

                // Mettre à jour les contrôleurs de texte après la mise à jour Firestore
                fullNameController.text = fullNameController.text;

                Navigator.of(context).pop();
              } catch (e) {
                print('Erreur lors de la mise à jour des données: $e');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Erreur lors de la mise à jour des données'),
                ));
              }
            },
          ),
        ],
      );
    },
  );
}
void _showEmailDialog() async {
  TextEditingController emailController = TextEditingController(text: userData['email']);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier l\'Email'),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(hintText: 'Nouvel Email'),
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
              setState(() {
                userData['email'] = emailController.text;
              });

              try {
                await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
                  'email': emailController.text,
                });

                // Mise à jour des contrôleurs de texte après la mise à jour Firestore
                emailController.text = emailController.text;

                Navigator.of(context).pop();
              } catch (e) {
                print('Erreur lors de la mise à jour des données: $e');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Erreur lors de la mise à jour des données'),
                ));
              }
            },
          ),
        ],
      );
    },
  );
}
void _showPasswordDialog() async {
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier le Mot de Passe'),
        content: TextField(
          controller: passwordController,
          decoration: InputDecoration(hintText: 'Nouveau Mot de Passe'),
          obscureText: true,
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
              String newPassword = passwordController.text;

              // Générer un sel aléatoire
              String salt = _generateSalt();

              // Hacher le mot de passe avec le sel
              String hashedPassword = _hashPassword(newPassword, salt);

              setState(() {
                // Mettre à jour le mot de passe et lastModifiedDate dans userData
                userData['password'] = hashedPassword;
                userData['lastModifiedDate'] = Timestamp.now();
              });

              try {
                // Mettre à jour les données dans Firestore
                await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
                  'password': userData['password'],
                  'lastModifiedDate': userData['lastModifiedDate'],
                });

                Navigator.of(context).pop();
              } catch (e) {
                print('Erreur lors de la mise à jour des données: $e');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Erreur lors de la mise à jour des données'),
                ));
              }
            },
          ),
        ],
      );
    },
  );
}
String _generateSalt() {
  Random random = Random();
  List<int> saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64.encode(saltBytes);
}

String _hashPassword(String password, String salt) {
  String saltedPassword = password + salt;
  var bytes = utf8.encode(saltedPassword);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

  Widget _buildEditableInfoField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              obscureText: label == 'Password', // Pour masquer le texte du mot de passe
            ),
          ),
          IconButton(
  icon: Icon(Icons.edit),
  onPressed: () {
    if (label == 'Nom Complet') {
      _showFullNameDialog();
    } else if (label == 'Email') {
      _showEmailDialog();
    } else if (label == 'Mot de passe') {
      _showPasswordDialog();
    }
  },
),
        ],
      ),
    );
  }
}