// Import du package Flutter
import 'package:flutter/material.dart';

// Widget personnalisé pour afficher une carte d'hôpital
class HospitalCard extends StatelessWidget {
  // Données de l'hôpital à afficher
  final Map<String, dynamic> hospital;

  // Constructeur avec paramètre requis
  const HospitalCard({Key? key, required this.hospital}) : super(key: key);

  // Construction de l'interface de la carte
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Marges de la carte
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // Padding interne
        leading: Icon(Icons.local_hospital, size: 40, color: Colors.red), // Icône d'hôpital
        title: Text(
          hospital['name'], // Nom de l'hôpital
          style: TextStyle(fontWeight: FontWeight.bold), // Style en gras
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            SizedBox(height: 8), // Espacement
            Text(hospital['address']), // Adresse de l'hôpital
            SizedBox(height: 8), // Espacement
            Text(
              '${hospital['distance']} km', // Distance en kilomètres
              style: TextStyle(color: Colors.green), // Style vert pour la distance
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios), // Icône de navigation
        onTap: () {
          // TODO: Implémenter la navigation vers les détails de l'hôpital
          print('Hôpital sélectionné: ${hospital['name']}');
        },
      ),
    );
  }
}