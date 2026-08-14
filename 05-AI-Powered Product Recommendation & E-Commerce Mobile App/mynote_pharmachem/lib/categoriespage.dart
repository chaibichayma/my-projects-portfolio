import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynote_pharmachem/categoriesgrad.dart';
import 'package:mynote_pharmachem/produits.dart';

class CategoriesPage extends StatelessWidget {
  final Product product;
  final User user;
  final String userId;
  const CategoriesPage({Key? key, required this.product, required this.user, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCategorySection('Cosmétiques', 'cosmetiquesId'),
        buildCategorySection('Pharmaceutiques', 'pharmaceutiquesId'),
        buildCategorySection('Biologiques', 'biologiquesId'),
      ],
    );
  }

  Widget buildCategorySection(String title, String categoryId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CategoryGrid(categoryId: categoryId, product: product, user: user, userId: userId),
        ],
      ),
    );
  }
  IconData? getIconDataFromString(String iconName) {
    switch(iconName) {
      case 'cut':
        return Icons.cut;
      case 'accessibility':
        return Icons.accessibility;
      case 'person':
        return Icons.person;
      case 'pan_tool':
        return Icons.pan_tool;
      case 'brush':
        return Icons.brush;
      case 'face':
        return Icons.face;
      case 'medical_services_sharp':
        return Icons.medical_services_sharp;
      case 'medication_outlined':
        return Icons.medication_outlined;
      case 'child_care':
        return Icons.child_care;
      case 'eco':
        return Icons.eco;
      case 'local_bar':
        return Icons.local_bar;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      case 'grain':
        return Icons.grain;
      case 'remove':
        return Icons.remove;
      case 'local_drink':
        return Icons.local_drink;
      case 'local_florist':
        return Icons.local_florist;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      default:
        return null;
    }
  }
  
}
