
import 'package:cloud_firestore/cloud_firestore.dart';
class WellnessEvent {
  final String title;
  DateTime dateTime; 
  final String idC;
  final String userId; 
  bool validated;

  WellnessEvent({required this.title, required this.dateTime, required this.validated, required this.idC, required this.userId});
   Map<String, dynamic> toJson() {
    return {
      'id': idC,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'userId': userId,
      'validated': validated,
    };
  }
  static WellnessEvent fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WellnessEvent(
      idC: data['idC'] ?? '',
      title: data['title'] ?? '',
      dateTime: DateTime.parse(data['dateTime'] ?? ''),
      validated: data['validated'] ?? false,
      userId: data['userId'] ?? '',
    );
  }
  factory WellnessEvent.fromJson(Map<String, dynamic> json) {
  return WellnessEvent(
    title: json['title'] ?? '',
    dateTime: json['dateTime'] != null ? DateTime.parse(json['dateTime']) : DateTime.now(),
    idC: json['idC'] ?? '',
    userId: json['userId'] ?? '',
    validated: json['validated'] ?? false,
  );
}
}
