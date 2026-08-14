import 'package:cloud_firestore/cloud_firestore.dart';
class Option {
  final String optionId;
  final String optionText;

  Option({
    required this.optionId,
    required this.optionText,
  });
  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      optionId: map['option_id'],
      optionText: map['option_text'],
    );
  }
}