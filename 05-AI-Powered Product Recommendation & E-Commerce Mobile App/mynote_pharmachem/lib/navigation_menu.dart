import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mynote_pharmachem/chatbot.dart';
import 'package:mynote_pharmachem/comptePage.dart';
import 'package:mynote_pharmachem/constants.dart';
import 'package:mynote_pharmachem/home_screen.dart';
import 'package:mynote_pharmachem/categories.dart' as Categories;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynote_pharmachem/produits.dart';
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
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
            NavigationDestination(icon: Icon(Icons.category), label: 'Catégories'),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Compte')
          ],
        ),
      ),
      body: Obx(() {
        if (controller.selectedIndex.value == 3) {
          return ComptePage(
            userName: controller.user.displayName ?? 'Utilisateur',
            productData: controller.productData, // Ajoutez cette ligne avec le productData du contrôleur
            product: controller.product, // Ajoutez cette ligne avec le produit du contrôleur
            userId: controller.userId, // Ajoutez cette ligne avec l'ID de l'utilisateur du contrôleur
          );
        } else if (controller.selectedIndex.value == 2) {
          return ChatbotApp(); // Afficher ChatbotApp lorsque la destination Chat est sélectionnée
        } else {
          return controller.screens[controller.selectedIndex.value]();
        }
      }),
    );
  }
}
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = Rx<int>(0);
  late Future<DocumentSnapshot> productDataFuture;
  late Product product;
  late User user;
  late DocumentSnapshot productData;
  String userId = '';

  NavigationController() {
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
    () => Categories.Category(product: product, user: user, userId: userId, productData: productData,),
    () => Container(color: Colors.blue),
    () => ComptePage(userName: fullName, userId: userId, productData: productData, product: product,), // Remplacez Container par ComptePage pour afficher la page ComptePage
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
          return HomeScreen(
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