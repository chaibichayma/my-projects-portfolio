import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/classCalendrier.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mynote_pharmachem/notificationss.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with WidgetsBindingObserver {
  final TextEditingController _eventController = TextEditingController();
  List<WellnessEvent> events = [];
  final CollectionReference eventsRef = FirebaseFirestore.instance.collection('events');
  final Uuid uuid = Uuid();
  final String eventsKey = 'saved_events';
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    loadEventsFromSharedPreferences(); // Charger les événements localement lors de l'initialisation de l'écran
    scheduleNotifications();
    // Vérification de la permission de notification et demande si nécessaire
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  
  
  // Méthode pour charger les événements depuis Firestore
  
  Future<void> loadEventsFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? eventsJson = prefs.getStringList(eventsKey);

  if (eventsJson != null) {
    List<WellnessEvent> loadedEvents = eventsJson
        .map((json) => WellnessEvent.fromJson(jsonDecode(json)))
        .whereType<WellnessEvent>() // Filtrer les événements non nuls
        .toList();

    setState(() {
      events = loadedEvents;
    });
  } else {
    print('Aucun événement trouvé dans SharedPreferences.');
  }
  print('Events loaded from SharedPreferences: $events');
}

  Future<void> addEventLocally(WellnessEvent event) async {
  String? userId = getCurrentUserId();
  if (userId != null) {
    setState(() {
      events.add(event);
    });
    saveEvents(); // Sauvegarder les événements localement après l'ajout
    addEventToFirestore(event, userId);
  } else {
    print('Utilisateur non connecté');
    // Gérer le cas où l'utilisateur n'est pas connecté
  }
}


 Future<void> saveEvents() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> eventsJson = events.map((event) => jsonEncode(event.toJson())).toList();
  await prefs.setStringList(eventsKey, eventsJson);
}

  void scheduleNotifications() {
    print('Starting notification scheduling...');
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      print('Current time: $now');
      for (WellnessEvent event in events) {
        if (!event.validated && now.isAfter(event.dateTime)) {
          print('Triggering notification for event: ${event.title}');
          triggerNotification(event.title); // Appeler triggerNotification pour chaque événement non validé dont la date est passée
        }
      }
    });
  }

  triggerNotification(String eventTitle) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, 
      channelKey: 'basic_channel', // Spécifiez une valeur de channelKey valide
      title: '$eventTitle',
      body: 'Bonjour, Ne manquez pas votre événement.Nous sommes impatients de vous voir là-bas pour une journée inoubliable !',
      
      ),
  );
}




  // Méthode pour ajouter un événement à Firestore
  Future<void> addEventToFirestore(WellnessEvent event, String userId) async {
  try {
    Timestamp dateTimeStamp = Timestamp.fromDate(event.dateTime);
    await eventsRef.doc(event.idC).set({
      'title': event.title,
      'dateTime': dateTimeStamp,
      'idC': event.idC,
      'userId': userId,
    });
    print('Event added to Firestore successfully.');
  } catch (e) {
    print('Error adding event to Firestore: $e');
  }
}

  // Méthode pour récupérer l'ID de l'utilisateur actuel
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<void> deleteAllEvents() async {
  // Supprimer tous les événements localement
  setState(() {
    events.clear();
  });
  await saveEvents(); // Attendre la sauvegarde locale

  // Supprimer tous les événements de Firestore
  String? userId = getCurrentUserId();
  if (userId != null) {
    QuerySnapshot eventsSnapshot =
        await eventsRef.where('userId', isEqualTo: userId).get();
    for (DocumentSnapshot doc in eventsSnapshot.docs) {
      await doc.reference.delete();
    }
    print('Tous les événements ont été supprimés de Firestore.');
  }
}
  Future<void> updateEventValidationInFirestore(String eventId) async {
  try {
    DocumentReference eventRef = eventsRef.doc(eventId);
    await eventRef.update({'validated': true});
    print('Événement validé dans Firestore avec succès.');
  } catch (e) {
    print('Erreur lors de la validation de l\'événement dans Firestore : $e');
  }
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Color(0xFFA32CC4),
      title: Text(
        'Calendrier BIEN-ÊTRE',
        style: TextStyle(color: Colors.white),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      labelText: 'Entrez un événement',
                      labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Color(0xFFA32CC4),
                  child: IconButton(
                    onPressed: () async {
                      DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );

                      if (selectedDateTime != null) {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );

                        if (selectedTime != null) {
                          DateTime updatedDateTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          String? userId = getCurrentUserId();
                          if (userId != null) {
                            WellnessEvent newEvent = WellnessEvent(
                              title: _eventController.text,
                              idC: uuid.v4(),
                              dateTime: updatedDateTime,
                              validated: false,
                              userId: userId,
                            );
                            addEventLocally(newEvent);
                           
                            addEventToFirestore(newEvent, userId);

                            _eventController.clear();
                          } else {
                            print('Utilisateur non connecté');
                          }
                        }
                      }
                    },
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40,),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7, // Hauteur maximale de 70% de la taille de l'écran
            ),
            child: Expanded(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Événement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black,),), numeric: false),
                  DataColumn(label: Text('Date et heure', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,))),
                  DataColumn(label: Text('Validé', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black,))),
                ],
                rows: events.asMap().entries.map((entry) {
                  int index = entry.key;
                  WellnessEvent event = entry.value;

                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Text(
                              event.title,
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          event.dateTime != null ? '${DateFormat.yMd().add_jm().format(event.dateTime!)}' : '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(event.validated ? Icons.check_circle : Icons.circle_outlined),
                          onPressed: () async {
                            await updateEventValidationInFirestore(event.idC);
                            setState(() {
                              event.validated = true;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 200,),
          ElevatedButton(
            onPressed: () {            
              deleteAllEvents();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA32CC4), 
              minimumSize: Size(200, 60), 
              textStyle: TextStyle(fontSize: 18, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ), 
            ),
            child: Text(
              'Supprimer tous les événements',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ),
  );
}}