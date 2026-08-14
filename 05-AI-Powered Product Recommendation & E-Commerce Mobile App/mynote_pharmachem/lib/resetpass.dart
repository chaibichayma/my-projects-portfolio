import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isResetting = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Please enter both new password and confirm password.'),
          );
        },
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Passwords do not match.'),
          );
        },
      );
      return;
    }

    setState(() {
      isResetting = true;
    });

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.email, // Utilisation du paramètre correct "code"
        newPassword: newPassword,
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset successful.'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print('Error resetting password: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Error resetting password. Please try again.'),
          );
        },
      );
    } finally {
      setState(() {
        isResetting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Reset Password'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(hintText: 'New Password'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(hintText: 'Confirm Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isResetting ? null : resetPassword,
            child: Text('Reset'),
          ),
          if (isResetting) CircularProgressIndicator(), // Loading indicator
        ],
      ),
    );
  }
}