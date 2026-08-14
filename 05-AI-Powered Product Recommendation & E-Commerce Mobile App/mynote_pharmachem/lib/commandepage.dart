import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mynote_pharmachem/classCommade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommandeFormulaire extends StatefulWidget {
  const CommandeFormulaire({Key? key}) : super(key: key); 

  @override
  State<CommandeFormulaire> createState() => _CommandeFormulaireState();
}

class _CommandeFormulaireState extends State<CommandeFormulaire> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController codePostalController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  static const String nomKey = 'nomComplet';
  static const String adresseKey = 'adresse';
  static const String villeKey = 'ville';
  static const String codePostalKey = 'codePostal';
  static const String telephoneKey = 'telephone';
  static const String productPriceKey = 'productPrice';
  @override
  void initState() {
    super.initState();
    restoreFormData();
  }
  
  double calculateTotalPrice(List<DocumentSnapshot> documents) {
    double totalPrice = 0;
    for (var doc in documents) {
      double productPrice = (doc[productPriceKey] ?? 0).toDouble();
      int quantity = doc['quantity'];
      totalPrice += productPrice * quantity;
    }
    return totalPrice;
  }
  
  Future<void> restoreFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nomController.text =  '';
      adresseController.text =  '';
      villeController.text = '';
      codePostalController.text = '';
      telephoneController.text = '';
    });
  }
  Future<void> saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(nomKey, nomController.text);
    await prefs.setString(adresseKey, adresseController.text);
    await prefs.setString(villeKey, villeController.text);
    await prefs.setString(codePostalKey, codePostalController.text);
    await prefs.setString(telephoneKey, telephoneController.text);
  }
  Future<double> getTotalPrice() async {
    List<DocumentSnapshot> documents = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .get()
        .then((snapshot) => snapshot.docs);

    return calculateTotalPrice(documents);
  }

 
  Future<void> enregistrerCommande() async {
    if (nomController.text.isEmpty ||
      adresseController.text.isEmpty ||
      villeController.text.isEmpty ||
      codePostalController.text.isEmpty ||
      telephoneController.text.isEmpty) {
    // Affichez un message à l'utilisateur s'il y a des champs manquants
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Veuillez remplir tous les champs.'),
    ));
    return; // Arrêtez l'exécution de la méthode si des champs sont manquants
  }
  CollectionReference commandes =
      FirebaseFirestore.instance.collection('commandes');
  String numeroCommande = Commande.generateNumeroCommande();
  double totalCommandes = calculateTotalPrice(await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Cart')
      .get()
      .then((snapshot) => snapshot.docs));

  // Récupérer les produits du panier
  List<DocumentSnapshot> cartProducts = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Cart')
      .get()
      .then((snapshot) => snapshot.docs);

  // Mettre à jour la quantité des produits dans la collection products
  for (var product in cartProducts) {
    String productId = product['productId'];
    int quantity = product['quantity'];

    // Récupérer le document dans products correspondant au productId
    QuerySnapshot productQuery = await FirebaseFirestore.instance
        .collection('products')
        .where('productId', isEqualTo: productId)
        .get();

    if (productQuery.docs.isNotEmpty) {
      // Mettre à jour la quantitéP dans le document correspondant
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(productQuery.docs.first.id);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);
        if (productSnapshot.exists) {
          int currentQuantity = productSnapshot['quantityP'];
          int newQuantity = currentQuantity - quantity;
          transaction.update(productRef, {'quantityP': newQuantity});
        }
      });
    } else {
      print('Le produit avec l\'ID $productId n\'existe pas dans la collection products.');
    }
  }

  Commande nouvelleCommande = Commande(
    nomComplet: nomController.text,
    adresse: adresseController.text,
    ville: villeController.text,
    codePostal: codePostalController.text,
    telephone: telephoneController.text,
    totalCommandes: totalCommandes, // Ajouter le total à la commande
    numeroCommande: numeroCommande,
    dateCommande: DateTime.now(),
  );
  await commandes.add(nouvelleCommande.toJson());

  // Appel de la méthode _placeOrder après l'enregistrement de la commande
  _placeOrder(context);
}
  void _placeOrder(BuildContext context) async {
  // Vérifiez que tous les champs sont remplis avant de continuer
  if (nomController.text.isEmpty ||
      adresseController.text.isEmpty ||
      villeController.text.isEmpty ||
      codePostalController.text.isEmpty ||
      telephoneController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Veuillez remplir tous les champs avant de passer la commande.'),
    ));
    return; // Arrêtez l'exécution de la méthode si des champs sont vides
  }

  // Si tous les champs sont remplis, continuez avec le processus normal
  double totalCommandes = calculateTotalPrice(await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Cart')
      .get()
      .then((snapshot) => snapshot.docs));

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'total': FieldValue.increment(totalCommandes)});

    // Ajouter le total à chaque document de la collection 'commandes'
    CollectionReference commandesRef =
        FirebaseFirestore.instance.collection('commandes');
    QuerySnapshot commandeSnapshot = await commandesRef
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (commandeSnapshot.docs.isNotEmpty) {
      for (var doc in commandeSnapshot.docs) {
        await commandesRef.doc(doc.id).update({'total': totalCommandes});
      }
    }

    // Affichez le message de succès uniquement si aucun champ n'est vide
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Commande passée avec succès'),
    ));
  } catch (e) {
    print('Erreur lors de la mise à jour du total des commandes : $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Erreur lors de la commande. Veuillez réessayer.'),
    ));
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 45), // Hauteur de l'appbar augmentée de 20 pixels
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFA32CC4),
            title: Text(
              'Commande',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            centerTitle: true,
            elevation: 0, // Supprimer l'ombre sous l'appbar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             SizedBox(height: 20),            
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 18),
                    ),
                    FutureBuilder<double>(
                      future: getTotalPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '${snapshot.data} TND',
                            style: TextStyle(fontSize: 18),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height:45.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: nomController,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nom Complet",
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: Color.fromRGBO(34, 34, 34, 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: adresseController,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Adresse",
                      prefixIcon: const Icon(Icons.home, color: Color.fromRGBO(34, 34, 34, 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: villeController,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Ville",
                      prefixIcon: const Icon(Icons.home_filled, color: Color.fromRGBO(34, 34, 34, 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: codePostalController,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Code Postal",
                      prefixIcon: const Icon(Icons.password, color: Color.fromRGBO(34, 34, 34, 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: telephoneController,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Téléphone",
                      prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(34, 34, 34, 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60,),
              
              Container(
                  width: double.infinity, // Pour que le conteneur prenne toute la largeur disponible
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                  onPressed: () {
                    // Vérifiez que tous les champs sont remplis avant d'appeler enregistrerCommande()
                    if (nomController.text.isNotEmpty &&
                        adresseController.text.isNotEmpty &&
                        villeController.text.isNotEmpty &&
                        codePostalController.text.isNotEmpty &&
                        telephoneController.text.isNotEmpty) {
                      enregistrerCommande().then((value) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                title: Text('Commande enregistrée'),
                content: Text('Votre commande a été enregistrée avec succès.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Redirection ou autre action après confirmation
                    },
                    child: Text('OK'),
                  ),
                ],
                            );
                          },
                        );
                      }).catchError((error) {
                        print('Erreur lors de l\'enregistrement de la commande : $error');
                        // Afficher un message d'erreur à l'utilisateur si nécessaire
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Veuillez remplir tous les champs avant de passer la commande.'),
                      ));
                    }
                  },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.purple),
                    ),
                  ),
                  
                ),
                
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                      ),
                    ),
                  ),
                ),
                
          ],
        ),
      ),
    ),
  );
}}
