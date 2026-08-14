import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/Administrateur/admininfoscreen.dart';
import 'package:mynote_pharmachem/Administrateur/dashbord.dart';
import 'package:mynote_pharmachem/categories.dart' as Categories;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
class NavigationMenuAdmin extends StatelessWidget {
  const NavigationMenuAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationControllerAdmin());
    final darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? Colors.black : Colors.white,
          indicatorColor: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Compte')
          ], // Supprimer les destinations pour 'Category' et 'Chat'
        ),
      ),
      body: Obx(() {
        if (controller.selectedIndex.value == 1) { // Vérifier si 'Compte' est sélectionné
          return AdminInfoScreen(
            userId: controller.userId, // Ajoutez cette ligne avec l'ID de l'utilisateur du contrôleur
          );
        } else {
          return controller.screens[controller.selectedIndex.value]();
        }
      }),
    );
  }
}
class NavigationControllerAdmin extends GetxController {
  final Rx<int> selectedIndex = Rx<int>(0);
  late Future<DocumentSnapshot> productDataFuture;
  late Product product;
  late User user;
  late DocumentSnapshot productData;
  String userId = '';

  NavigationControllerAdmin() {
    productDataFuture = fetchProductData();
    initializeProductData();
  }

  void initializeProductData() async {
    productData = await productDataFuture;
  }

  @override
  void onInit() {
    super.onInit();
    user = FirebaseAuth.instance.currentUser!; // Initialize the user
  }

  Future<DocumentSnapshot> fetchProductData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      DocumentSnapshot productData = querySnapshot.docs.first;
      Timestamp? saleStartTimeTimestamp = productData['saleStartTime'];
        Timestamp? saleEndTimeTimestamp = productData['saleEndTime'];
      product = Product(
        productId: productData['productId'] ?? '',
        imageUrl: productData['imageUrl'],
        nom: productData['nom'],
      
        marque: productData['marque'],
        prix: productData['prix'].toDouble(),
        quantityP: productData['quantityP'] ?? 0, // Initialiser le champ "quantity" depuis Firestore
        enStock: productData['en_stock'] ?? false,
        salePrix: productData['salePrix'].toDouble(),
        saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
        saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
        onSale: productData['onSale'],
        productData: productData, 
        categoryIds: List<String>.from(productData['categoryIds'] ?? []),
      );
      userId = FirebaseAuth.instance.currentUser!.uid; // Initialize userId
      return productData;
    } catch (e) {
      print('Erreur lors de la récupération des données produit: $e');
      throw e;
    }
  }

  List<Widget Function()> get screens => [
    () => buildHomeScreen(),
    () => Categories.Category(product: product, user: user, userId: userId, productData: productData,),
    () => Container(color: Colors.blue),
    () => AdminInfoScreen(userId: userId), // Remplacez Container par ComptePage pour afficher la page ComptePage
  ];

  Widget buildHomeScreen() {
  if (productData != null) {
    return DashboardScreen(
      userId: userId,
      product: product,
      productData: productData,
    );
  } else {
    return Center(child: CircularProgressIndicator());
  }
}
}