import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote_pharmachem/login.dart';
import 'package:flutter/gestures.dart';
import 'package:mynote_pharmachem/user_model.dart' as Myuser;
import 'package:mynote_pharmachem/verify_email.dart';
import 'package:mynote_pharmachem/classhachage.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key); 

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("Erreur lors de l'envoi de la vérification par e-mail: $e");
    }
  }

  Future<void> signUp(BuildContext context) async {
  try {
    String hashedPassword = hashPassword(passwordController.text);

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: hashedPassword, 
    );
    await sendEmailVerification(userCredential.user!);
      DateTime currentDate = DateTime.now();
      String userId = userCredential.user!.uid;
      double total = 0.0;
      String role = "user";
      await Myuser.Userr(
        id: userId,
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: hashedPassword, 
        lastModifiedDate: currentDate,
        total: total,
        role: role,
      ).addUserToFirestore();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Verify()),
      );
    } catch (e) {
    print("Erreur lors de l'inscription: $e");
  }
}
  
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 80.0, right: 20.0, top: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'images/remove2.png',
                    width: 200.0, 
                    height: 180.0, 
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 8.0),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            const SizedBox(height: 5.0,),
             const Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 8.0),
                  child: Text(
                    'Créez votre profil pour démarrer Journey!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            const SizedBox(height: 0.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: fullNameController,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(    
                    hintText: "Nom Complet",  
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: Color.fromRGBO(34, 34, 34, 1.0)),               
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:  const BorderSide(
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
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: emailController,
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
                      return 'Veuillez entrer votre adresse e-mail';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: phoneController,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Téléphone",
                    prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(34, 34, 34, 1.0)),
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
                      return 'Veuillez entrer votre numéro de téléphone';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: passwordController,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
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
                      return 's\'il vous plait entrez votre mot de passe';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 108),
                child: ElevatedButton(
                  onPressed: () => signUp(context), 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple), 
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), 
                        side: BorderSide(color: Colors.purple), 
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18.0), // Ajoutez le padding ici
                    child: Text(
                      'S\'inscrire',
                        style: TextStyle(
                          color: Colors.white, // Couleur du texte blanche
                          fontSize: 16, // Taille de police
                          fontWeight: FontWeight.bold, // Gras
                      ),
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 12),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Vous avez déjà un compte?',
                        style: TextStyle(
                          color: Colors.black, // Couleur du texte
                          fontSize: 16, // Taille de police
                      ),
                    ),
                    TextSpan(
                      text: 'Se connecter',
                      style: const TextStyle(
                        color: Colors.purple, // Couleur du texte
                        fontSize: 16, // Taille de police
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
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