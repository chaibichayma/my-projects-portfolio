import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DateTimeDisplay extends StatelessWidget {
  final DateTime? dateTime;

  const DateTimeDisplay({Key? key, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dateTime != null
        ? Text(
            '${dateTime!.day}/${dateTime!.month}/${dateTime!.year} ${dateTime!.hour}:${dateTime!.minute}',
          )
        : Icon(Icons.calendar_today); // Remplace 'Choisir la date et l\'heure' par une icône
  }
}