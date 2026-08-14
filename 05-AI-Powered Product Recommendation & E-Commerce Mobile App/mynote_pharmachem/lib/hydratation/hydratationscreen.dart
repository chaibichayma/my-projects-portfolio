import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HydrationPage extends StatefulWidget {
  @override
  _HydrationPageState createState() => _HydrationPageState();
}

class _HydrationPageState extends State<HydrationPage> {
  double waterConsumption = 0.0;
  double sunExposure = 0.0;
  bool usedMoisturizer = false;
  bool adviceShown = false;
  String adviceDocumentId = '';
  List<String> conseilsAffiches = [];
  String adviceText = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 45), // Hauteur de l'appbar augmentée de 20 pixels
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Text(
              'Hydratation Cutanée',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            centerTitle: true,
            elevation: 0, // Supprimer l'ombre sous l'appbar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_drink, color: Colors.black),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Consommation d\'eau (en litres)',
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {
                              waterConsumption = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Slider(
                  value: sunExposure,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: sunExposure.toString(),
                  onChanged: (value) {
                    setState(() {
                      sunExposure = value;
                    });
                  },
                ),
                Text(
                  'Exposition au soleil : $sunExposure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Utilisation de produits hydratants : ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                    Checkbox(
                      value: usedMoisturizer,
                      onChanged: (value) {
                        setState(() {
                          usedMoisturizer = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Enregistrer les données dans Firestore ici
                    saveDataToFirestore();
                    fetchHydrationData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA32CC4),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 20.0),
                Visibility(
                  visible: adviceShown,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      adviceText,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
  Future<void> fetchHydrationData() async {
  try {
    // Récupérer l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Récupérer les documents de la collection "hydratation" pour l'utilisateur actuel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hydratation')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        String documentId = doc.id;

        if (documentId != adviceDocumentId && !conseilsAffiches.contains(documentId)) {
          String advice = getHydrationAdvice();
          setState(() {
            adviceShown = true;
            adviceText = advice;
            conseilsAffiches.add(documentId);
          });
        }
      });
      } else {
        print('Aucun document hydratation trouvé pour votre profil.');
      }
    } else {
      print('Utilisateur non connecté. Impossible de récupérer les données.');
    }
  } catch (error) {
    print('Erreur lors de la récupération des données d\'hydratation : $error');
  }
}
String getHydrationAdvice() {
  // Logique pour générer les conseils en fonction des données d'hydratation
  String advice = '';

  if (waterConsumption < 2.0) {
    advice += '• Augmentez votre consommation d\'eau pour rester hydraté.\n';
  }

  if (sunExposure > 5.0) {
    advice += '• Limitez votre exposition au soleil pour éviter les coups de soleil.\n';
  }

  if (!usedMoisturizer) {
    advice += '• Utilisez des produits hydratants pour prendre soin de votre peau.\n';
  }

  // Exemples de conseils supplémentaires
  if (sunExposure > 8.0) {
    advice += '• Évitez de sortir pendant les heures de forte exposition au soleil.\n';
  }

  if (waterConsumption > 3.0 && usedMoisturizer) {
    advice += '• Félicitations ! Continuez à bien vous hydrater et à utiliser des produits hydratants.\n';
  }

  // Autres conseils
  if (waterConsumption < 1.0) {
    advice += '• Votre consommation d\'eau est très faible. Essayez de boire au moins 1 litre par jour.\n';
  }

  if (sunExposure < 2.0) {
    advice += '• Vous avez une faible exposition au soleil. Pensez à sortir un peu plus pour profiter de la vitamine D.\n';
  }

  if (waterConsumption > 3.0 && usedMoisturizer && sunExposure < 5.0) {
    advice += '• Vous avez une bonne routine d\'hydratation et d\'exposition au soleil. Continuez ainsi !\n';
  }

  // Autres conseils ajoutés
  if (waterConsumption > 2.0 && waterConsumption < 4.0) {
    advice += '• Votre consommation d\'eau est dans la plage recommandée. Continuez ainsi !\n';
  }

  if (sunExposure < 4.0) {
    advice += '• Essayez de passer un peu plus de temps dehors pour profiter des bienfaits du soleil.\n';
  }

  if (sunExposure > 7.0) {
    advice += '• Protégez-vous avec un chapeau et des vêtements légers si vous sortez pendant les heures ensoleillées.\n';
  }

  if (usedMoisturizer && sunExposure < 3.0) {
    advice += '• Utilisez un écran solaire même pour une exposition légère au soleil pour protéger votre peau.\n';
  }

  if (waterConsumption > 3.5) {
    advice += '• Boire plus de 3,5 litres d\'eau par jour peut être trop. Essayez de maintenir une consommation équilibrée.\n';
  }

  if (waterConsumption < 1.5) {
    advice += '• Une consommation trop faible d\'eau peut entraîner une déshydratation. Assurez-vous de boire plus d\'eau.\n';
  }

  if (sunExposure < 5.0 && !usedMoisturizer) {
    advice += '• Protégez votre peau avec un écran solaire et utilisez des produits hydratants pour maintenir une peau saine.\n';
  }

  if (waterConsumption > 3.0 && sunExposure < 5.0) {
    advice += '• Vous avez une bonne consommation d\'eau et une exposition modérée au soleil. Continuez ainsi !\n';
  }

  if (waterConsumption > 4.0 && sunExposure < 4.0) {
    advice += '• Assurez-vous de rester hydraté mais évitez une exposition prolongée au soleil.\n';
  }

  if (sunExposure > 6.0 && usedMoisturizer) {
    advice += '• Protégez-vous du soleil avec des vêtements et un écran solaire, même avec une utilisation de produits hydratants.\n';
  }

  if (waterConsumption > 2.5 && waterConsumption < 3.5) {
    advice += '• Vous êtes dans une plage de consommation d\'eau recommandée. Continuez à maintenir cet équilibre.\n';
  }

  if (sunExposure > 5.0 && !usedMoisturizer) {
    advice += '• Une exposition prolongée sans protection peut endommager votre peau. Utilisez des produits hydratants.\n';
  }

  if (waterConsumption > 3.5 && sunExposure > 7.0) {
    advice += '• Évitez une consommation excessive d\'eau et protégez-vous du soleil avec des vêtements et un écran solaire.\n';
  }

  if (waterConsumption < 2.0 && sunExposure < 3.0 && !usedMoisturizer) {
    advice += '• Assurez-vous de boire plus d\'eau, de rester à l\'ombre et d\'utiliser des produits hydratants pour une peau saine.\n';
  }

  return advice.isNotEmpty ? advice : 'Aucun conseil pour le moment.';
}

  void saveDataToFirestore() {
  // Récupérer l'utilisateur actuellement connecté
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid; // Obtenez l'ID de l'utilisateur connecté

    // Créer une référence à la collection "hydratation" dans Firestore
    CollectionReference hydrationCollection = FirebaseFirestore.instance.collection('hydratation');

    // Ajouter un nouveau document à la collection avec les données d'hydratation et l'ID de l'utilisateur
    hydrationCollection.add({
      'userId': userId, // Champ userId pour l'utilisateur connecté
      'consommation_eau': waterConsumption,
      'exposition_soleil': sunExposure,
      'utilisation_produits': usedMoisturizer,
      'timestamp': DateTime.now(), // Ajouter un champ timestamp pour suivre quand les données ont été enregistrées
    }).then((value) {
      // Succès de l'enregistrement
      print('Données d\'hydratation enregistrées avec succès!');
    }).catchError((error) {
      // Erreur lors de l'enregistrement
      print('Erreur lors de l\'enregistrement des données : $error');
    });
  } else {
    print('Utilisateur non connecté. Impossible d\'enregistrer les données.');
  }
}
}
