
class Commande {
  final String nomComplet;
  final String adresse;
  final String ville;
  final String codePostal;
  final String telephone;
  final String numeroCommande;
  final DateTime dateCommande;
  double totalCommandes;
  final String? statut;

  Commande({
    required this.nomComplet,
    required this.adresse,
    required this.ville,
    required this.codePostal,
    required this.telephone,
    required this.numeroCommande,
    required this.dateCommande,
    this.totalCommandes = 0.0,
    this.statut,
  });
  Map<String, dynamic> toJson() {
    return {
      'nomComplet': nomComplet,
      'adresse': adresse,
      'ville': ville,
      'codePostal': codePostal,
      'telephone': telephone,
      'numeroCommande': numeroCommande,
      'dateCommande': dateCommande,
      'total': totalCommandes,
    };
  }
  static String generateNumeroCommande() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
}