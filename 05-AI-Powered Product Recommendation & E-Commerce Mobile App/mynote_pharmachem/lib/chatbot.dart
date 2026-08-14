import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/chatChem.dart';
class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatbotInterface(),
    );
  }
}