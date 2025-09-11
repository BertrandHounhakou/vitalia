// Import du package Flutter
import 'package:flutter/material.dart';

// Widget personnalisé pour afficher une carte de pharmacie
class PharmacyCard extends StatelessWidget {
  // Données de la pharmacie à afficher
  final Map<String, dynamic> pharmacy;

  // Constructeur avec paramètre requis
  const PharmacyCard({Key? key, required this.pharmacy}) : super(key: key);

  // Construction de l'interface de la carte
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Marges de la carte
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // Padding interne
        leading: Icon(Icons.local_pharmacy, size: 40, color: Colors.green), // Icône de pharmacie
        title: Text(
          pharmacy['name'], // Nom de la pharmacie
          style: TextStyle(fontWeight: FontWeight.bold), // Style en gras
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            SizedBox(height: 8), // Espacement
            Text(pharmacy['address']), // Adresse de la pharmacie
            SizedBox(height: 8), // Espacement
            Row(
              children: [
                Text(
                  '${pharmacy['distance']} km', // Distance en kilomètres
                  style: TextStyle(color: Colors.green), // Style vert pour la distance
                ),
                SizedBox(width: 16), // Espacement horizontal
                if (pharmacy['isOnDuty']) // Affichage conditionnel du badge "Garde"
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding du badge
                    decoration: BoxDecoration(
                      color: Colors.orange, // Couleur de fond orange
                      borderRadius: BorderRadius.circular(4), // Coins arrondis
                    ),
                    child: Text(
                      'Garde', // Texte du badge
                      style: TextStyle(color: Colors.white, fontSize: 12), // Style du texte
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios), // Icône de navigation
        onTap: () {
          // TODO: Implémenter la navigation vers les détails de la pharmacie
          print('Pharmacie sélectionnée: ${pharmacy['name']}');
        },
      ),
    );
  }
}