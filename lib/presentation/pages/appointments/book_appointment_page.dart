// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/appointment_provider.dart';
import 'package:vitalia/data/models/appointment_model.dart';

// Classe pour la page de prise de rendez-vous avec état
class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

// État de la page de prise de rendez-vous
class _BookAppointmentPageState extends State<BookAppointmentPage> {
  // Contrôleurs pour les champs du formulaire
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Méthode pour sélectionner une date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Date initiale (aujourd'hui)
      firstDate: DateTime.now(), // Date minimale (aujourd'hui)
      lastDate: DateTime.now().add(const Duration(days: 365)), // Date maximale (1 an)
    );
    
    if (picked != null) { // Si une date a été sélectionnée
      setState(() {
        // Formatage de la date en JJ/MM/AAAA
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Méthode pour sélectionner une heure
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Heure initiale (maintenant)
    );
    
    if (picked != null) { // Si une heure a été sélectionnée
      setState(() {
        _timeController.text = picked.format(context); // Formatage de l'heure
      });
    }
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prendre un rendez-vous'), // Titre de la page
      ),
      body: SingleChildScrollView( // Permet le défilement
        padding: EdgeInsets.all(16), // Padding interne
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
          children: [
            // Champ pour le nom du docteur
            TextFormField(
              controller: _doctorController,
              decoration: InputDecoration(
                labelText: 'Médecin', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la spécialité
            TextFormField(
              controller: _specialtyController,
              decoration: InputDecoration(
                labelText: 'Spécialité', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la date avec sélecteur
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                suffixIcon: IconButton( // Icône de calendrier
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDate, // Sélection de date
                ),
              ),
              readOnly: true, // Lecture seule pour ouvrir le sélecteur
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour l'heure avec sélecteur
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Heure', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                suffixIcon: IconButton( // Icône d'horloge
                  icon: Icon(Icons.access_time),
                  onPressed: _selectTime, // Sélection d'heure
                ),
              ),
              readOnly: true, // Lecture seule pour ouvrir le sélecteur
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour le lieu
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Lieu', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour les notes (optionnel)
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optionnel)', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              maxLines: 3, // Multi-lignes pour les notes
            ),
            SizedBox(height: 24), // Espacement
            
            // Bouton de confirmation
            ElevatedButton(
              onPressed: _confirmAppointment, // Confirmation du rendez-vous
              child: Text('Confirmer le rendez-vous'), // Texte du bouton
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16), // Padding vertical
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour confirmer le rendez-vous
  void _confirmAppointment() {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    
    // Création d'un nouveau rendez-vous
    final newAppointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unique
      patientId: 'current_patient_id', // À remplacer par l'ID réel
      centerId: 'selected_center_id', // À remplacer par l'ID réel
      dateTime: DateTime.now().add(Duration(days: 3)), // Date de simulation
      status: 'scheduled', // Statut programmé
      notes: _notesController.text, // Notes
    );

    // Ajout du rendez-vous
    appointmentProvider.addAppointment(newAppointment);
    
    // Message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rendez-vous confirmé avec succès')),
    );
    
    // Retour à la page précédente
    Navigator.pop(context);
  }
}