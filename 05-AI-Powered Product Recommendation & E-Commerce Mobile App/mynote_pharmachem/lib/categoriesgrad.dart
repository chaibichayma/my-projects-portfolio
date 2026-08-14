import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/categoriespage.dart';
import 'package:mynote_pharmachem/product_list.dart';
import 'package:mynote_pharmachem/produits.dart';

class CategoryGrid extends StatelessWidget {
  final String categoryId;
  final Product product;
  final User user;
  final String userId;
  CategoryGrid({required this.categoryId, required this.product, required this.user, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('sous-categories')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final subCategories = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3, // Ajustez ceci pour changer la hauteur des éléments
          ),
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final subCategory = subCategories[index];
            final subCategoryName = subCategory['nomP'];
            final subCategoryIcon = CategoriesPage(product: product, user: user, userId: userId).getIconDataFromString(subCategory['icon']);
            return InkWell(
              onTap: () {
                String sousCategorieId = subCategory.id; // Assurez-vous que l'ID de la sous-catégorie est correctement récupéré
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListPage(sousCategorieId: sousCategorieId, product: product, user: user, userId: userId),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE5DBED),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(subCategoryIcon, size: 24),
                    SizedBox(width: 8),
                    Text(subCategoryName),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}