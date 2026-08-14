import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Forgot extends StatefulWidget {
  const Forgot({Key? key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailController = TextEditingController();
  bool isResettingPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Please enter your email.'),
          );
        },
      );
      return;
    }

    setState(() {
      isResettingPassword = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset email sent. Check your email.'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print('Error sending password reset email: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Error sending password reset email. Please try again.'),
          );
        },
      );
    } finally {
      setState(() {
        isResettingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Forgot Password'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Your Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isResettingPassword ? null : passwordReset,
            child: Text('Reset'),
          ),
          if (isResettingPassword) CircularProgressIndicator(), // Indicateur de chargement
        ],
      ),
    );
  }
}