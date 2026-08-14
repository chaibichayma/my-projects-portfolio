import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DetailCommandePage extends StatefulWidget {
  final DocumentSnapshot commandSnapshot;

  DetailCommandePage(this.commandSnapshot);

  @override
  _DetailCommandePageState createState() => _DetailCommandePageState();
}

class _DetailCommandePageState extends State<DetailCommandePage> {
  late String statut;

  @override
  void initState() {
    super.initState();
    // Initialiser la variable statut avec la valeur actuelle de la commande
    Map<String, dynamic>? commandData = widget.commandSnapshot.data() as Map<String, dynamic>?;

    if (commandData != null) {
      setState(() {
        statut = commandData['statut'] ?? 'Statut non défini';
      });
    } else {
      // Gérer le cas où les données sont nulles
    }
  }

  void _changerStatut() {
    // Mettre à jour le statut dans Firestore
    FirebaseFirestore.instance.collection('commandes').doc(widget.commandSnapshot.id).update({
      'statut': statut,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Statut mis à jour avec succès.'),
        ),
      );
    }).catchError((error) {
      print('Erreur lors de la mise à jour du statut: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour du statut.'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.commandSnapshot.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de commande',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFA32CC4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoContainer('Commande #${widget.commandSnapshot.id}'),
                _buildInfoContainer('Nom complet: ${data['nomComplet']}'),
                _buildInfoContainer('Adresse: ${data['adresse']}'),
                _buildInfoContainer('Code postal: ${data['codePostal']}'),
                _buildInfoContainer('Ville: ${data['ville']}'),
                _buildInfoContainer('Téléphone: ${data['telephone']}'),
                _buildInfoContainer('Statut: $statut', isEditable: true, onTap: () {
                  // Lorsque l'utilisateur clique sur le statut, ouvrir un dialogue pour modifier le statut
                  _showEditStatutDialog();
                }),
                _buildInfoContainer('Numéro de commande: ${data['numeroCommande']}'),
                _buildInfoContainer('Total: ${data['total']}'),
                _buildInfoContainer('Date de commande: ${data['dateCommande'].toDate()}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String text, {bool isEditable = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
            ),
            if (isEditable) Icon(Icons.edit, color: Colors.purple),
          ],
        ),
      ),
    );
  }

  void _showEditStatutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le statut'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                statut = value;
              });
            },
            decoration: InputDecoration(hintText: 'Nouveau statut'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _changerStatut();
                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}