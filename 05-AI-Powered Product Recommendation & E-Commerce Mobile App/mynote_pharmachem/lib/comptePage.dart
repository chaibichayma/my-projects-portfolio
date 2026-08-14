import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/offresSpecialespage.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/quizlistscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ComptePage extends StatelessWidget {
  final String userName;
  final DocumentSnapshot productData;
  final Product product;
  final String userId;
  const ComptePage({Key? key, required this.userName, required this.productData, required this.product, required this.userId}) : super(key: key);
  void disconnectUser(BuildContext context) async {
  bool confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Ferme la boîte de dialogue et renvoie false
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Ferme la boîte de dialogue et renvoie true
            },
            child: Text('Oui'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    try {
      await FirebaseAuth.instance.signOut();
      // Naviguer vers la page de connexion
      Navigator.pushReplacementNamed(context, '/login'); // Assure le remplacement de la page actuelle
    } catch (e) {
      // En cas d'erreur lors de la déconnexion, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
      );
    }
  }
}  

  @override
  Widget build(BuildContext context) {
    // Liste d'icônes pour les éléments de la première liste
    List<IconData> icons = [
      Icons.person,
      Icons.favorite,
      Icons.location_on,
      Icons.chat_bubble_outline,
      Icons.card_giftcard,
    ];

    // Liste des noms pour les éléments de la première liste
    List<String> names = [
      'Compte',
      'Ma liste d\'envie',
      'Adresse de livraison',
      'Service Client',
      'Mes récompenses',
    ];

    // Liste d'icônes pour les éléments de la deuxième liste
    List<IconData> otherIcons = [
      Icons.local_offer,
      Icons.live_help,
    ];

    // Liste des noms pour les éléments de la deuxième liste
    List<String> otherNames = [
      'Offres et promotions',
      'Quiz bien-etre',
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color(0xFFA32CC4),
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mon Compte',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10), // Espacement vertical
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenue ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[400],
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Mon Compte PharmaChem',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(icons[index]),
                        title: Text(names[index]),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          _navigateToDetailPage(context, index);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Information',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OffresSpecialesPage(product: product, productData: productData, userId: userId,),
                            ),
                          );
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Offres et promotions',
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                Divider(height: 0),
              ElevatedButton(
                onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizListScreen(userId: userId),
                            ),
                          );
                        },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quiz bien-etre',
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(height: 20.0),
          ],
           ),
              ),
                SizedBox(height: 50.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      disconnectUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 60), // Largeur et hauteur personnalisées du bouton
                      backgroundColor: Colors.white70, // Couleur de fond du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Bordures circulaires du bouton
                      ),
                    ),
                    child: Text(
                      'Se déconnecter',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushNamed(context, '/compte');
  } else {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/Envie');
        break;
      case 2:
        Navigator.pushNamed(context, '/livraison');
        break;
        case 3:
        Navigator.pushNamed(context, '/chat');
        break;
      case 4:
        Navigator.pushNamed(context, '/recompenses');
        break;
      
      default:
        break;
    }
  }
  }}