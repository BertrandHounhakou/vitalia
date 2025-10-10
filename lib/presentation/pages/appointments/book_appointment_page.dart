// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/appointment_provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/data/models/appointment_model.dart';
import 'package:vitalia/data/models/doctor_model.dart';
import 'package:intl/intl.dart';

// Classe pour la page de prise de rendez-vous avec état
class BookAppointmentPage extends StatefulWidget {
  // Médecin sélectionné depuis l'annuaire (optionnel)
  final DoctorModel? selectedDoctor;
  
  const BookAppointmentPage({Key? key, this.selectedDoctor}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs si un médecin a été sélectionné
    if (widget.selectedDoctor != null) {
      _doctorController.text = widget.selectedDoctor!.name;
      _specialtyController.text = widget.selectedDoctor!.specialty;
      // Pré-remplir le lieu avec le premier hôpital
      if (widget.selectedDoctor!.hospitals.isNotEmpty) {
        _locationController.text = widget.selectedDoctor!.hospitals.first;
      }
    }
  }

  @override
  void dispose() {
    // Libérer les contrôleurs
    _doctorController.dispose();
    _specialtyController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
        backgroundColor: Color(0xFF26A69A),
      ),
      body: SingleChildScrollView( // Permet le défilement
        padding: EdgeInsets.all(16), // Padding interne
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
          children: [
            // Bannière d'information si un médecin a été sélectionné
            if (widget.selectedDoctor != null)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF26A69A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF26A69A).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF26A69A),
                      child: Text(
                        widget.selectedDoctor!.name.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedDoctor!.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services,
                                size: 14,
                                color: Color(0xFF26A69A),
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.selectedDoctor!.specialty,
                                style: TextStyle(
                                  color: Color(0xFF26A69A),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF26A69A),
                      size: 28,
                    ),
                  ],
                ),
              ),
            
            // Champ pour le nom du docteur
            TextFormField(
              controller: _doctorController,
              readOnly: widget.selectedDoctor != null, // Lecture seule si pré-rempli
              decoration: InputDecoration(
                labelText: 'Médecin', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                filled: widget.selectedDoctor != null,
                fillColor: widget.selectedDoctor != null 
                    ? Colors.grey[100] 
                    : null,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la spécialité
            TextFormField(
              controller: _specialtyController,
              readOnly: widget.selectedDoctor != null, // Lecture seule si pré-rempli
              decoration: InputDecoration(
                labelText: 'Spécialité', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                filled: widget.selectedDoctor != null,
                fillColor: widget.selectedDoctor != null 
                    ? Colors.grey[100] 
                    : null,
                prefixIcon: Icon(Icons.medical_services),
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la date avec sélecteur
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: IconButton( // Icône de calendrier
                  icon: Icon(Icons.edit_calendar),
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
                prefixIcon: Icon(Icons.access_time),
                suffixIcon: IconButton( // Icône d'horloge
                  icon: Icon(Icons.edit),
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
                prefixIcon: Icon(Icons.location_on),
                filled: widget.selectedDoctor != null && widget.selectedDoctor!.hospitals.isNotEmpty,
                fillColor: widget.selectedDoctor != null && widget.selectedDoctor!.hospitals.isNotEmpty
                    ? Colors.grey[100] 
                    : null,
              ),
              readOnly: widget.selectedDoctor != null && widget.selectedDoctor!.hospitals.isNotEmpty,
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour les notes (optionnel)
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optionnel)', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                prefixIcon: Icon(Icons.note_alt),
              ),
              maxLines: 3, // Multi-lignes pour les notes
            ),
            SizedBox(height: 24), // Espacement
            
            // Bouton de confirmation
            ElevatedButton(
              onPressed: _confirmAppointment, // Confirmation du rendez-vous
              child: Text(
                'Confirmer le rendez-vous',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), // Texte du bouton
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF26A69A), // Couleur moderne
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16), // Padding vertical
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour confirmer le rendez-vous
  Future<void> _confirmAppointment() async {
    // Validation des champs
    if (_doctorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer le nom du médecin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner une date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner une heure'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer le lieu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Récupération de l'ID du patient connecté
      final patientId = authProvider.currentUser?.id;
      if (patientId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Conversion de la date et de l'heure
      final dateParts = _dateController.text.split('/');
      if (dateParts.length != 3) {
        throw Exception('Format de date invalide');
      }

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      // Parse de l'heure
      final timeParts = _timeController.text.split(':');
      int hour = 0;
      int minute = 0;
      
      if (timeParts.length >= 2) {
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1].replaceAll(RegExp(r'[^0-9]'), ''));
      }

      final appointmentDateTime = DateTime(year, month, day, hour, minute);

      // Vérification que la date est dans le futur
      if (appointmentDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La date du rendez-vous doit être dans le futur'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Création d'un nouveau rendez-vous avec les vraies données
      final newAppointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unique
        patientId: patientId, // ID réel du patient
        centerId: _locationController.text, // On utilise le lieu comme centerId pour l'instant
        dateTime: appointmentDateTime, // Date et heure réelles sélectionnées
        status: 'scheduled', // Statut programmé
        notes: 'Médecin: ${_doctorController.text}, Spécialité: ${_specialtyController.text}${_notesController.text.isNotEmpty ? '\nNotes: ${_notesController.text}' : ''}',
      );

      // Affichage d'un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Ajout du rendez-vous dans Firestore
      await appointmentProvider.addAppointment(newAppointment);

      // Fermeture de l'indicateur de chargement
      Navigator.pop(context);

      // Message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rendez-vous confirmé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      // Retour à la page précédente
      Navigator.pop(context);
    } catch (e) {
      // Fermeture de l'indicateur de chargement si ouvert
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}