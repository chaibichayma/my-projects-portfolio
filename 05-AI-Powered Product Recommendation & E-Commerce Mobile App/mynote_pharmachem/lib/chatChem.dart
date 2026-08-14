import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/chatbotscreens.dart';
import 'package:mynote_pharmachem/chatt.dart';
class ChatbotInterface extends StatefulWidget {
  @override
  _ChatbotInterfaceState createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Color(0xFFA32CC4), // Arrière-plan de la page en couleur A32CC4
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 40.0, // Hauteur de l'AppBar
                  child: AppBar(
                    backgroundColor: Colors.transparent, // Couleur transparente pour l'AppBar
                    elevation: 0, // Supprimer l'ombre de l'AppBar
                  ),
                ),
                Container(
                  height: 450, // Hauteur de l'image
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/chatbot.png'), // Chemin vers votre image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Couleur transparente pour le reste de la page
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Bienvenue!',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Couleur du texte en blanc pour contraster avec l'arrière-plan
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Espacement entre les textes
                      Center(
                        child: Text(
                          'Atteignons vos objectifs',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                            color: Colors.white, // Couleur du texte en blanc pour contraster avec l'arrière-plan
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'ensemble avec nous!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.white, // Couleur du texte en blanc pour contraster avec l'arrière-plan
                          ),
                        ),
                      ),
                      SizedBox(height: 50), // Espacement entre le texte et le bouton
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatsMe()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding pour ajuster la taille
                            minimumSize: Size(380, 60), // Taille minimale du bouton (largeur: 380, hauteur: 60)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rendre le bouton légèrement circulaire avec un rayon de 30
                            ),
                            elevation: 0, // Enlever l'ombre
                              side: BorderSide.none, // Enlever la bordure
                            ),
                            child: Text(
                              'Commencer',
                              style: TextStyle(
                                fontSize: 25, 
                               
                              ),
                            ),
                          ),
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}