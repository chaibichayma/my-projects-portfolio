import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/otp.dart';
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController phonenumber =TextEditingController();
  sendcode()async{
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+216' + phonenumber.text,
        verificationCompleted: (PhoneAuthCredential credential){},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error Occured', e.code);
        },
        codeSent: (String vid,int? token) {
          Get.to(OtpPage(vid: vid,),);
        },
        codeAutoRetrievalTimeout: (vid) {}
      );
    }on FirebaseAuthException catch(e) {
      Get.snackbar('Error occured', e.code);
    } catch(e) {
      Get.snackbar('Error occured', e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const Center(child: Text("Your Phone !", style: TextStyle(fontSize: 30))),
          const Padding(
            padding:   EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            child: Text("we will send you an one time password on this mobile number"),
          ),
          const SizedBox(height: 20,),
          phonetext(),
          const SizedBox(height: 50,),
          button(),
        ],
      )
    );
  }
  Widget phonetext() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: phonenumber,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefix: Text("+216"),
          prefixIcon: Icon(Icons.phone),
          labelText: 'Enter Phone number',
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
  Widget button (){
    return Center(
      child: ElevatedButton(
        onPressed: (){
          sendcode();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 90,),
          child: Text(
            "Receive OTP",
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
