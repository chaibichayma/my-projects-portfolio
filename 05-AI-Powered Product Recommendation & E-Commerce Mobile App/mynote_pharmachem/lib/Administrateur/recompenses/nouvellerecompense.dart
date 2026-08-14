import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NouvelleRecompensePage extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Container(
                height: 200, // Hauteur de votre image
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/recompense.png'), // Image locale
                    fit: BoxFit.contain, // Ajustement de la taille de l'image
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
          
                _buildTextFieldWithIcon(
                  controller: descriptionController,
                  labelText: 'Description de la récompense',
                  icon: Icons.description,
                ),
                _buildTextFieldWithIcon(
                  controller: idController,
                  labelText: 'ID de la récompense',
                  icon: Icons.person,
                ),
                _buildTextFieldWithIcon(
                  controller: imageUrlController,
                  labelText: 'URL de l\'image',
                  icon: Icons.image,
                ),
                _buildTextFieldWithIcon(
                  controller: nameController,
                  labelText: 'Nom de la récompense',
                  icon: Icons.article,
                ),
                _buildTextFieldWithIcon(
                  controller: pointsController,
                  labelText: 'Points requis',
                  icon: Icons.star,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                     _validateFields(context);;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5DBED), // Couleur de fond du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                    ),
                    minimumSize: Size(400, 60), // Largeur et hauteur personnalisées
                    padding: EdgeInsets.all(10), // Marge interne personnalisée
                  ),
                  child: Text(
                    'Ajouter récompense',
                    style: TextStyle(
                      fontSize: 20, // Taille de police personnalisée
                      color: Colors.black, // Couleur du texte personnalisée
                      fontWeight: FontWeight.bold, // Style de police en gras
                    ),
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
              ),
              keyboardType: keyboardType,
            ),
          ),
        ],
      ),
    );
  }

  void _ajouterRecompense(BuildContext context) async {
    // Récupérer les valeurs saisies dans les champs de texte
    String description = descriptionController.text.trim();
    String id = idController.text.trim();
    String imageUrl = imageUrlController.text.trim();
    String name = nameController.text.trim();
    int points = int.tryParse(pointsController.text.trim()) ?? 0;

    try {
      // Initialiser Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Ajouter un document à la collection "recompenses"
      await firestore.collection('recompenses').add({
        'description_recompense': description,
        'id_recompense': id,
        'imageUrl': imageUrl,
        'name_recompense': name,
        'pointsRequired': points,
      });

      // Navigation ou autres actions après avoir ajouté le document
      Navigator.pop(context); // Retour à l'écran précédent
    } catch (e) {
      print('Erreur lors de l\'ajout de la récompense: $e');
      // Gérer l'erreur selon vos besoins
    }
  }
  void _validateFields(BuildContext context) {
  String description = descriptionController.text.trim();
  String id = idController.text.trim();
  String imageUrl = imageUrlController.text.trim();
  String name = nameController.text.trim();
  String pointsText = pointsController.text.trim();

  if (description.isEmpty ||
      id.isEmpty ||
      imageUrl.isEmpty ||
      name.isEmpty ||
      pointsText.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
  } else {
    _ajouterRecompense(context);
  }
}
} 

