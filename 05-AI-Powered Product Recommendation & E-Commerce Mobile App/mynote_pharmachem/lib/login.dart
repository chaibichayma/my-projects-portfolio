import 'package:mynote_pharmachem/forgot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:mynote_pharmachem/home_screen.dart';
import 'package:mynote_pharmachem/navigation_menu.dart';
import 'package:mynote_pharmachem/navigationadmin.dart';
import 'package:mynote_pharmachem/phonesign.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:mynote_pharmachem/services/auth_servicesgoogle.dart';
import 'package:mynote_pharmachem/signup.dart';
import 'package:mynote_pharmachem/components/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/classhachage.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  bool isloading =false;
  void signIN() {
  setState(() {
    isloading = true;
  });
  String hashedPassword = hashPassword(password.text);
  FirebaseAuth.instance
      .signInWithEmailAndPassword(
    email: email.text,
    password: password.text,
  )
      .then((userCredential) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((userData) {
      if (userData.exists) {
        Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
        String role = userDataMap['role']; // Supposons que le champ de rôle soit 'role'
        if (role == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationMenu()),
          );
        } else if (role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationMenuAdmin()),
          );
        } else {
          // Gérer les autres rôles ou aucune correspondance trouvée
          print('Role not recognized or handled');
        }
      } else {
        print('User data not found');
      }
    }).catchError((error) {
      print("Error getting user data: $error");
    }).whenComplete(() {
      setState(() {
        isloading = false;
      });
    });
  }).catchError((error) {
    print("Authentication error: $error");
    setState(() {
      isloading = false;
    });
  });
}
String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  @override
  Widget build(BuildContext context) {
    return isloading?Center(child: CircularProgressIndicator(),): Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 74.0, right: 18.0, top: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'images/remove2.png',
                  width: 220.0, // largeur de l'image
                  height: 220.0, // hauteur de l'image
                ),
              ),
            ),
            SizedBox(height: 10.0),
            const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 8.0, top: 0),
                  child: Text(
                    'Hello',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            const SizedBox(height: 7,),
            const Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 8.0),
                  child: Text(
                    'Sign into your account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            const SizedBox(height: 23.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-Mail",
                    prefixIcon: const Icon(Icons.email, color: Color.fromRGBO(34, 34, 34, 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 14,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: password,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.fingerprint, color: Color.fromRGBO(34, 34, 34, 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 4,),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot()));
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
          
                  ),
              ),
            const SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 108),
              child: ElevatedButton(
                onPressed: () => signIN(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(163, 44, 196, 1.0)), // Couleur de fond bleue
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bordure arrondie
                      side: BorderSide(color: Color.fromRGBO(163, 44, 196, 1.0)), // Bordure bleue
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18.0), // Ajoutez le padding ici
                  child: Text(
                    'Sign IN',
                    style: TextStyle(
                      color: Colors.white, // Couleur du texte blanche
                      fontSize: 16, // Taille de police
                      fontWeight: FontWeight.bold, // Gras
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            const Padding(
                  padding: EdgeInsets.only(left: 100.0, right: 8.0, top: 0),
                  child: Text(
                    'Or Sign In with',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ), 
            ),          
            const SizedBox(height: 6,),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(
                  onTap: () async {
                    bool signInSuccessful = await AuthService().signInWithGoogle();
                      if (signInSuccessful) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => NavigationMenu()),
                        );
                      }},
                      imagePath: 'images/googlel.png',
                    ),
                    const SizedBox(width: 40,),
                    SquareTile(
                      onTap: () {
                        Navigator.push(                      
                          context,
                          MaterialPageRoute(builder: (context) => PhonePage()),
                        );
                      },
                      imagePath: 'images/phone.png',
                    ),
                  ],
                ),
              const SizedBox(height: 15,),
              Center(
               child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Don \'t have an account? ',
                        style: TextStyle(
                          color: Colors.black, // Couleur du texte
                          fontSize: 16, // Taille de police
                      ),
                    ),
                    TextSpan(
                      text: 'Create',
                      style: const TextStyle(
                        color: Colors.purple, // Couleur du texte
                        fontSize: 16, // Taille de police
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
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
}