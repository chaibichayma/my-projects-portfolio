import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/WelcomeScreendeux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
import 'package:mynote_pharmachem/visiteur/homeviteur.dart';
class NavigationMenuVisiteur extends StatelessWidget {
  const NavigationMenuVisiteur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationControllerVisiteur());
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
            NavigationDestination(icon: Icon(Icons.category), label: 'Category'),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Compte')
          ],
        ),
      ),
      body: Obx(() {
        if (controller.selectedIndex.value == 3) {
          return WelcomeScreen(
          );
        } else if (controller.selectedIndex.value == 2) {
          return WelcomeScreen(); // Afficher ChatbotApp lorsque la destination Chat est sélectionnée
        } else {
          return controller.screens[controller.selectedIndex.value]();
        }
      }),
    );
  }
}
class NavigationControllerVisiteur extends GetxController {
  final Rx<int> selectedIndex = Rx<int>(0);
  late Future<DocumentSnapshot> productDataFuture;
  late Product product;
  late User user;
  late DocumentSnapshot productData;
  String userId = '';

  NavigationControllerVisiteur() {
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
      print('Error fetching product data: $e');
      throw e;
    }
  }

  List<Widget Function()> get screens => [
    () => buildHomeScreen(),
    () => WelcomeScreen(),
    () => WelcomeScreen(),
    () => WelcomeScreen(),// Remplacez Container par ComptePage pour afficher la page ComptePage
  ];

  Widget buildHomeScreen() {
    return FutureBuilder<DocumentSnapshot>(
      future: productDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return HomeVisiteur(
            productData: snapshot.data!,
            product: product,
            userId: FirebaseAuth.instance.currentUser!.uid,
            user: user,
          );
        }
      },
    );
  }
}