import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/navigation_menu.dart';
import 'package:pinput/pinput.dart';
class OtpPage extends StatefulWidget {
  final String vid;
  const OtpPage({super.key, required this.vid});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code= '';
  signIn()async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
        Get.offAll(NavigationMenu()),
      });
    }on FirebaseAuthException catch(e) {
      Get.snackbar('Error Occured', e.code);
    }catch(e) {
      Get.snackbar('Error Occured', e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(child: Text("OTP Verification", style: TextStyle(fontSize: 30))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              child: Text("Enter OTP sent to +216 51268178"),
            ),
            const SizedBox(height: 20,),
            textcode(),
            const SizedBox(height: 80,),
            button()
          ],
        )
      )
    );
  }
  Widget textcode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Pinput(
          length: 6,
          onChanged: (value) {
            setState(() {
              code=value;
            });
          },
        ),
      ),
    );
  }
  Widget button() {
      return Center(
      child: ElevatedButton(
        onPressed: (){
          signIn();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 90,),
          child: Text(
            "Verify & Procceed",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    );

  }
}