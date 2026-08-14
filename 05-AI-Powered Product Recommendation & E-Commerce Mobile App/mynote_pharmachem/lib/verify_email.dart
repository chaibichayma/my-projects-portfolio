import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/home_screen.dart';
import 'package:mynote_pharmachem/login.dart';
import 'package:mynote_pharmachem/navigation_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Future<void> sendEmailVerificationAndNavigateToWelcomePage() async {
    final user = FirebaseAuth.instance.currentUser!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool emailVerified = prefs.getBool('emailVerified') ?? false;

    if (!emailVerified) {
      try {
        await user.sendEmailVerification();
        // Enregistrez l'état de vérification dans SharedPreferences
        await prefs.setBool('emailVerified', true);

        // Une fois que la vérification par e-mail est terminée avec succès,
        // naviguez vers la page WelcomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );

        Get.snackbar('Link sent', 'A link has been sent to your email', margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM);
      } catch (error) {
        print("Error sending verification email: $error");
      }
    } else {
      // Si l'e-mail est déjà vérifié, naviguez simplement vers la page WelcomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification")),
      body: const Padding(
        padding: EdgeInsets.all(28.0),
        child: Center(
          child: Text('Open your email and click on the link provided to verify & reload this page'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendEmailVerificationAndNavigateToWelcomePage,
        child: const Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}