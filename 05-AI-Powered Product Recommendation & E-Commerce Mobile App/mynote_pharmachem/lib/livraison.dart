/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModifierLivraisonPage extends StatefulWidget {
   final String commandeId;
   const ModifierLivraisonPage({Key? key, required this.commandeId}) : super(key: key);
  @override
  _ModifierLivraisonPageState createState() => _ModifierLivraisonPageState();
}

class _ModifierLivraisonPageState extends State<ModifierLivraisonPage> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController();
  }

  void _editField(BuildContext context, String label, String currentValue) async {
    _textFieldController.text = currentValue;
    bool isTextFieldValid = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier $label'),
          content: TextField(
            controller: _textFieldController,
            onChanged: (value) {
              setState(() {
                isTextFieldValid = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'Entrez votre nouveau $label',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Valider'),
              onPressed: () async {
                if (isTextFieldValid) {
                  var newData = _textFieldController.text;
                  await FirebaseFirestore.instance.collection('commandes').doc(widget.commandeId).update({
                    label: newData,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA32CC4),
        title: Text('Modifier Livraison'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Color(0xFFA32CC4),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 700.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Image.asset(
                        'images/removecompte.png',
                        height: 170,
                        width: 170,
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('commandes').doc(widget.commandeId).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Erreur de chargement des données'));
                        } else {
                          var userData = snapshot.data!.data() as Map<String, dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    Divider(color: Colors.black),
                                    _buildUserInfoContainer('Nom complet', userData['nomComplet'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Email', userData['email'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Téléphone', userData['telephone'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Adresse', userData['adresse'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Code Postal', userData['codePostal'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    _buildUserInfoContainer('Ville', userData['ville'] ?? 'N/A', context),
                                    Divider(color: Colors.black),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 Widget _buildUserInfoContainer(String label, String value, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  value,
                  style: TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFFA32CC4)),
            onPressed: () {
              _editField(context, label, value);
            },
          ),
        ],
      ),
    );
 }}   */