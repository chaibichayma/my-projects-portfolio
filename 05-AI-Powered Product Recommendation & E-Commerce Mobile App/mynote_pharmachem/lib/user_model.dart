import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mynote_pharmachem/itemproduct.dart';
class Userr {
  String id;
  String fullName;
  String email;
  String phone;
  String password;
  DateTime lastModifiedDate;
  double total;
  double score;
  double newScore;
  String role;
  List<CartItem> ?cartItems;

  Userr({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.lastModifiedDate,
    this.total = 0.0,
    this.score = 0.0,
    this.newScore = 0.0,
    required this.role,
    this.cartItems,
  });

 
  static Userr empty() {
    return Userr(
      id: '',
      fullName: '',
      email: '',
      phone: '',
      password: '',
      lastModifiedDate: DateTime.now(),
      total: 0.0,
      score: 0.0,
      newScore: 0.0,
      role: '',
    );
  }

  
  factory Userr.fromMap(Map<String, dynamic> map) {
    return Userr(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      lastModifiedDate: map['lastModifiedDate'] ?? DateTime.now(),
      total: map['total'] ?? 0.0,
      score: 0.0,
      newScore: 0.0,
      role: map['role'] ?? '',

    );
  }

  static Userr fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data() ?? {};
    Timestamp timestamp = data['lastModifiedDate'] ?? Timestamp.now();
    DateTime dateTime = timestamp.toDate(); // Convertir le Timestamp en DateTime
    return Userr(
      id: snapshot.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      lastModifiedDate: dateTime, // Utiliser le DateTime converti ici
      total: data['total'] ?? 0.0,
      score: 0.0,
      newScore: 0.0,
      role: data['role'] ?? '',
    );
  }

 
  String get lastModifiedDateFormatted {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(lastModifiedDate);
  }

  // Méthode pour ajouter un produit au panier
  Future<void> addToCart(String productId, String productName, double productPrice) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).collection('Cart').doc(productId).set({
        'nom': productName,
        'prix': productPrice,
      });
      print('Produit ajouté au panier avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout du produit au panier: $e');
    }
  }

 
  Future<void> addUserToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'lastModifiedDate': lastModifiedDate,
        'role': role,
      });
      print('Utilisateur ajouté à Firestore avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout d\'un utilisateur à Firestore: $e');
    }
  }

  Userr toUser() {
    return Userr(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      role: this.role,
      phone: this.phone,
      password: this.password,
      lastModifiedDate: this.lastModifiedDate,
      total: this.total,
      score: this.score,
      newScore: this.newScore,
    );
  }

 
  static Future<Userr?> getCurrentUser() async {
    firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() ?? {};
        return Userr(
          id: currentUser.uid,
          fullName: userData['fullName'] ?? '',
          email: userData['email'] ?? '',
          role: userData['role'] ?? '',
          phone: userData['phone'] ?? '',
          password: userData['password'] ?? '',
          lastModifiedDate: userData['lastModifiedDate'] ?? DateTime.now(),
          total: userData['total'] ?? 0.0,
          score: 0.0,
          newScore: 0.0,
        );
      }
    }
    return null; 
  }
}