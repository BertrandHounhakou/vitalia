// Import des packages Flutter et intl
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitalia/data/models/appointment_model.dart';

// Widget personnalisé pour afficher une carte de rendez-vous
class AppointmentCard extends StatelessWidget {
  // Données du rendez-vous à afficher (maintenant de type AppointmentModel)
  final AppointmentModel appointment;

  // Constructeur avec paramètre requis
  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  // Construction de l'interface de la carte
  @override
  Widget build(BuildContext context) {
    // Formatage de la date
    final date = DateFormat('dd/MM/yyyy').format(appointment.dateTime);
    final time = DateFormat('HH:mm').format(appointment.dateTime);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Marges de la carte
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // Padding interne
        leading: Icon(Icons.calendar_today, size: 40, color: Colors.blue), // Icône de calendrier
        title: Text(
          'Rendez-vous #${appointment.id}', // Titre avec ID
          style: TextStyle(fontWeight: FontWeight.bold), // Style en gras
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            SizedBox(height: 8), // Espacement
            Text('Patient ID: ${appointment.patientId}'), // ID patient
            SizedBox(height: 4), // Espacement
            Text('Date: $date à $time'), // Date et heure
            SizedBox(height: 4), // Espacement
            Text('Centre: ${appointment.centerId}'), // Centre de santé
            SizedBox(height: 8), // Espacement
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding du badge de statut
              decoration: BoxDecoration(
                color: _getStatusColor(appointment.status), // Couleur selon le statut
                borderRadius: BorderRadius.circular(4), // Coins arrondis
              ),
              child: Text(
                appointment.status.toUpperCase(), // Statut en majuscules
                style: TextStyle(color: Colors.white, fontSize: 12), // Style du texte
              ),
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 8), // Espacement
              Text('Notes: ${appointment.notes}'), // Notes si existantes
            ],
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios), // Icône de navigation
        onTap: () {
          // TODO: Implémenter la navigation vers les détails du rendez-vous
          print('Rendez-vous sélectionné: ${appointment.id}');
        },
      ),
    );
  }

  // Méthode pour obtenir la couleur selon le statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.green; // Vert pour programmé
      case 'confirmed':
        return Colors.blue; // Bleu pour confirmé
      case 'cancelled':
        return Colors.red; // Rouge pour annulé
      case 'completed':
        return Colors.grey; // Gris pour terminé
      default:
        return Colors.grey; // Gris par défaut
    }
  }
}