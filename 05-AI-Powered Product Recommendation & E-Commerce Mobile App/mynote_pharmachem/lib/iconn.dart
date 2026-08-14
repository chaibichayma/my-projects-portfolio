import 'package:flutter/material.dart';

IconData iconDataFromName(String iconName) {
  switch (iconName) {
    case 'Maquillage':
        return Icons.celebration; 
      case 'Soin des cheveux':
        return Icons.style; 
      case 'Soins du corps':
        return Icons.accessibility; 
      case 'Homme':
        return Icons.person; 
      case 'Soins des mains  ':
        return Icons.pan_tool; 
      case 'Soins de visage':
        return Icons.face; 
      case 'Compléments':
        return Icons.local_dining; 
      case 'Hygiène de bébé':
        return Icons.child_care; 
      case 'Base  de plantes':
        return Icons.eco; 
      case 'Propolis':
        return Icons.local_bar; 
      case 'Vitamines':
        return Icons.local_pharmacy; 
      case 'Alimentation':
        return Icons.grain; 
      case 'Boissons':
        return Icons.local_bar; 
      case 'HuilesEssentielles':
        return Icons.local_grocery_store; 
      case 'Phytothérapie':
        return Icons.local_florist; 
      case 'Thés et infusions':
        return Icons.emoji_food_beverage; 
      case 'Produits apicoles':
        return Icons.beach_access; 
    default:
      return Icons.error; // Icône par défaut en cas de nom d'icône invalide
  }
}