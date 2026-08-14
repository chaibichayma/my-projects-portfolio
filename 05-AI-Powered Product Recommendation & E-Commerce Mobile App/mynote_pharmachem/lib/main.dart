import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynote_pharmachem/Administrateur/Utilisateurs/afficheruser.dart';
import 'package:mynote_pharmachem/chatChem.dart';
import 'package:mynote_pharmachem/chatbotscreens.dart';
import 'package:mynote_pharmachem/chatchat.dart';

import 'package:mynote_pharmachem/compte.dart';
import 'package:mynote_pharmachem/consts.dart';
import 'package:mynote_pharmachem/login.dart';
import 'package:mynote_pharmachem/mesrecompenses.dart';
import 'package:mynote_pharmachem/modifieradresselivraison.dart';
import 'package:mynote_pharmachem/modifieremailpage.dart';
import 'package:mynote_pharmachem/navigation_menu.dart';
import 'package:mynote_pharmachem/navigationadmin.dart';

import 'package:mynote_pharmachem/pageListeEnvie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel', 
        channelName: 'Basic_notifications',
        channelDescription: 'Notification channel for basics channel'
      ),
    ],
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor primarySwatch = Colors.purple;

    return MaterialApp(
      title: 'MyNote Pharmachem',
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/compte': (context) => Compte(),
        '/Envie': (context) {
          String userId = FirebaseAuth.instance.currentUser!.uid;
          return EnviePage(userId: userId);
        },
        '/livraison': (context) => AdresseLivraison(),
        '/navigationMenu': (context) => NavigationMenu(),
        '/chat': (context) => ChatbotInterface(),
        '/navigationMenuAdmin': (context) => NavigationMenuAdmin(),
        '/detail6': (context) => ModifierEmailPage(),
        '/recompenses': (context) {
          String userId = FirebaseAuth.instance.currentUser!.uid;
          return MesRecompenses(userId: userId);
        },
        /*'/detail6': (context) => DetailPage(),*/
      },
    );
  }
}