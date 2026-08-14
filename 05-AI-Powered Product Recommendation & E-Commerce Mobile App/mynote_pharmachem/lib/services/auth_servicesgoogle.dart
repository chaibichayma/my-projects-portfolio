import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/navigation_menu.dart';
import 'package:mynote_pharmachem/navigationadmin.dart';
import 'package:mynote_pharmachem/signup.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      // Se déconnecter de Google Sign-In avant de commencer le processus de connexion
      await _googleSignIn.signOut();

      // Lancer le processus de connexion avec Google
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return true; // Indique que l'authentification avec Google a réussi
      } else {
        return false; // Indique que l'utilisateur a annulé la sélection du compte Google
      }
    } catch (error) {
      print('Erreur lors de la connexion avec Google : $error');
      return false; // Indique qu'une erreur s'est produite lors de l'authentification avec Google
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}