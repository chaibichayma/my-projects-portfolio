import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mynote_pharmachem/categories.dart';
class TousCategoriesPage extends StatelessWidget {
  List<Category> categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 45),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Text(
              'Catégories',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            centerTitle: true,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCategoriesList(context),
          ),
          SizedBox(height: 10), // Ajouter un espace de 20 pixels entre la liste et le bouton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _addNewCategory(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5DBED), // Couleur de fond du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure circulaire
                ),
                minimumSize: Size(400, 50), // Largeur et hauteur du bouton
              ),
              child: Text(
                'Ajouter Catégorie',
                style: TextStyle(
                  fontSize: 20, // Taille de la police
                  fontWeight: FontWeight.bold, // Police en gras
                  color: Colors.black, // Couleur du texte
                ),
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> categories = snapshot.data!.docs;

        return ListView.builder(
  itemCount: categories.length,
  itemBuilder: (context, index) {
    DocumentSnapshot category = categories[index];
    String categoryName = category['nomC'] ?? '';
    String categoryId = category['categorieId'] ?? '';
    IconData categoryIcon = _getCategoryIcon(categoryId);

    return Dismissible(
  key: Key(categoryId),
  direction: DismissDirection.endToStart,
  
  child: SizedBox(
    height: 110, // Hauteur du conteneur ajustée
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFE5DBED),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 10, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categoryIcon, size: 30), // Taille de l'icône définie sur 30
                SizedBox(width: 15), // Espacement entre l'icône et le nom de la catégorie
                Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.black, // Couleur du texte
                    fontSize: 15, // Taille de la police
                    fontWeight: FontWeight.bold, // Style de la police
                    // Autres propriétés de style de texte si nécessaire
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 10, 40),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editCategory(context, categoryId, categoryName);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 40),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteCategory(context, categoryName);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  },
);

      },
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'bio':
        return Icons.biotech;
      case 'cos':
        return Icons.favorite;
      case 'phar':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
  void _addNewCategory(BuildContext context) {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Ajouter une catégorie',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style du texte du bouton
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Nom de la nouvelle catégorie',
              hintStyle: TextStyle(
                color: Colors.black, // Couleur du texte d'indication
                fontSize: 14, // Taille de la police du texte d'indication
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextField(
            controller: idController,
            decoration: InputDecoration(
              hintText: 'ID de la nouvelle catégorie',
              hintStyle: TextStyle(
                color: Colors.black, // Couleur du texte d'indication
                fontSize: 14, // Taille de la police du texte d'indication
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            String categoryName = nameController.text.trim();
            String categoryId = idController.text.trim();
            if (categoryName.isNotEmpty && categoryId.isNotEmpty) {
              try {
                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
                    .set({
                      'nomC': categoryName,
                      'categorieId': categoryId,
                    });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Catégorie ajoutée avec succès')),
                );
                Navigator.of(context).pop(); // Fermer le dialogue après l'ajout
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de l\'ajout de la catégorie')),
                );
                print(e.toString());
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Veuillez saisir un nom et un ID de catégorie valide')),
              );
            }
          },
          child: Text('Ajouter'),
        ),
      ],
    ),
  );
}

 void _deleteCategory(BuildContext context, String categoryName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('nomC', isEqualTo: categoryName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String categoryId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catégorie supprimée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La catégorie n\'a pas été trouvée')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression de la catégorie')),
    );
    print(e.toString());
  }
}
void _editCategory(BuildContext context, String categoryId, String currentName) async {
  TextEditingController textEditingController = TextEditingController(text: currentName);

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('categories')
      .where('categorieId', isEqualTo: categoryId)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot categoryDoc = querySnapshot.docs.first;
    String existingCategoryId = categoryDoc['categorieId'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier la catégorie'),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Nouveau nom de la catégorie',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              String newName = textEditingController.text.trim();
              if (newName.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryDoc.id) // Utilisation de l'ID du document trouvé
                      .update({'nomC': newName});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Catégorie mise à jour avec succès')),
                  );
                  Navigator.of(context).pop(); // Fermer le dialogue après la mise à jour
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la mise à jour de la catégorie')),
                  );
                  print(e.toString());
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez saisir un nom valide')),
                );
              }
            },
            child: Text('Valider'),
          ),
        ],
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('La catégorie n\'a pas été trouvée')),
    );
  }
}
}