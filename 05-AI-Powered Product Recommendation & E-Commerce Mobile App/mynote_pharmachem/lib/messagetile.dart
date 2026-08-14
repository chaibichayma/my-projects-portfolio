import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final bool sendByMe;
  final String message;

  const MessageTile({required this.sendByMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}