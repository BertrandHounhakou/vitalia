// Import du package Flutter
import 'package:flutter/material.dart';

// Widget personnalisé pour afficher une carte d'assurance
class InsuranceCard extends StatelessWidget {
  // Données de l'assurance à afficher
  final Map<String, dynamic> insurance;

  // Constructeur avec paramètre requis
  const InsuranceCard({Key? key, required this.insurance}) : super(key: key);

  // Construction de l'interface de la carte
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Marges de la carte
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // Padding interne
        leading: Icon(Icons.verified_user, size: 40, color: Colors.purple), // Icône d'assurance
        title: Text(
          insurance['name'], // Nom de l'assurance
          style: TextStyle(fontWeight: FontWeight.bold), // Style en gras
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            SizedBox(height: 8), // Espacement
            if (insurance['startDate'] != null && insurance['endDate'] != null)
              Text('Valide du ${insurance['startDate']} au ${insurance['endDate']}'), // Période de validité
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios), // Icône de navigation
        onTap: () {
          // TODO: Implémenter la navigation vers les détails de l'assurance
          print('Assurance sélectionnée: ${insurance['name']}');
        },
      ),
    );
  }
}