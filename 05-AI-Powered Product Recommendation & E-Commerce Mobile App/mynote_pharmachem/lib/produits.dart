import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId;
  String imageUrl;
  String nom;
  String marque;
  double prix;
  double salePrix;
  bool onSale;
  double remise;
  bool isFavorite;
  final List<String> categoryIds;
  DateTime saleStartTime;
  DateTime saleEndTime;
  int quantityP; 
  bool enStock;
  final DocumentSnapshot  productData;
  Product({
    required this.productId,
    required this.imageUrl,
    required this.nom,
    required this.marque,
    required this.prix,
    required this.salePrix,
    required this.onSale,
    this.remise = 0.0,
    this.isFavorite = false,
    required this.categoryIds,
    required this.saleStartTime,
    required this.saleEndTime,
    required this.productData,
    required this.quantityP, 
    required this.enStock, 
  });

  

  factory Product.fromJson(Map<String, dynamic> json) {
    Timestamp? saleStartTimeTimestamp = json['saleStartTime'];
    Timestamp? saleEndTimeTimestamp = json['saleEndTime'];

    return Product(
      productId: json['productId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      nom: json['nom'] ?? '',
      marque: json['marque'] ?? '',
      prix: json['prix'],
      salePrix: json['salePrix'],
      onSale: json['onSale'],
      remise: json['remise'] ?? 0.0,
      quantityP: json['quantityP'] ?? 0, 
      enStock: json['en_stock'] ?? false,
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
      saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
      productData: json['productData'] ?? '',
    );
  }
  factory Product.fromDocument(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  return Product(
    productId: doc.id,
    imageUrl: data['imageUrl'],
    nom: data['nom'],
    marque: data['marque'],
    prix: (data['prix'] as num).toDouble(), // Convertir le champ prix en double
    salePrix: data['salePrix'] ?? 0.0, // Utiliser 0.0 par défaut si salePrix est null
    onSale: data['onSale'] ?? false, // Utiliser false par défaut si onSale est null
    remise: data['remise'] ?? 0.0, // Utiliser 0.0 par défaut si remise est null
    isFavorite: data['isFavorite'] ?? false, // Utiliser false par défaut si isFavorite est null
    categoryIds: List<String>.from(data['categoryIds']),
    saleStartTime: data['saleStartTime'].toDate(),
    saleEndTime: data['saleEndTime'].toDate(),
    quantityP: data['quantityP'] ?? 0, // Utiliser 0 par défaut si quantityP est null
    enStock: data['enStock'] ?? false, // Utiliser false par défaut si enStock est null
    productData: doc,
  );
}


  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp? saleStartTimeTimestamp = data['saleStartTime'];
    Timestamp? saleEndTimeTimestamp = data['saleEndTime'];

    return Product(
      productId: data['productId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      nom: data['nom'] ?? '',
      marque: data['marque'] ?? '',
      prix: (data['prix'] ?? 0.0).toDouble(),
      salePrix: (data['salePrix'] ?? 0.0).toDouble(),
      onSale: data['onSale'] ?? false,
      quantityP: data['quantityP'] ?? 0, 
      enStock: data['en_stock'] ?? false,
      remise: (data['remise'] ?? 0.0).toDouble(),
      categoryIds: List<String>.from(data['categoryIds'] ?? []),
      saleStartTime: saleStartTimeTimestamp != null ? saleStartTimeTimestamp.toDate() : DateTime.now(),
      saleEndTime: saleEndTimeTimestamp != null ? saleEndTimeTimestamp.toDate() : DateTime.now(),
      productData: doc,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'imageUrl': imageUrl,
      'nom': nom,
      'marque': marque,
      'prix': prix,
      'salePrix': salePrix,
      'onSale': onSale,
      'remise': remise,
      'isFavorite': isFavorite,
      'categoryIds': categoryIds,
      'saleStartTime': saleStartTime.toIso8601String(),
      'saleEndTime': saleEndTime.toIso8601String(),
      'productData': productData,
    };
  }
 

  double get discountPercentage {
    if (onSale) {
      double discount = ((prix - salePrix) / prix) * 100;
      discount -= remise;
      return discount;
    } else {
      return 0.0;
    }
  }
}