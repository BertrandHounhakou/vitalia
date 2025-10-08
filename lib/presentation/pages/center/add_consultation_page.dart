// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/consultation_model.dart';
import 'package:vitalia/core/services/consultation_service.dart';

/// Page pour ajouter une nouvelle consultation médicale
/// Accessible uniquement aux centres de santé
class AddConsultationPage extends StatefulWidget {
  const AddConsultationPage({Key? key}) : super(key: key);

  @override
  _AddConsultationPageState createState() => _AddConsultationPageState();
}

class _AddConsultationPageState extends State<AddConsultationPage> {
  // Clé du formulaire pour validation
  final _formKey = GlobalKey<FormState>();
  
  // Service de consultation
  final ConsultationService _consultationService = ConsultationService();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Contrôleurs pour les constantes vitales
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Indicateur de chargement
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Nouvelle consultation',
        showMenuButton: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête informatif
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Enregistrez une nouvelle consultation médicale',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Section Patient
              Text(
                'Informations Patient',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // ID du patient
              TextFormField(
                controller: _patientIdController,
                decoration: InputDecoration(
                  labelText: 'ID Patient *',
                  hintText: 'Entrez l\'ID Vitalia du patient',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'ID patient est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Nom du docteur
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(
                  labelText: 'Nom du médecin *',
                  hintText: 'Dr. Nom Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom du médecin est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Section Consultation
              Text(
                'Détails de la consultation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Motif de consultation
              TextFormField(
                controller: _reasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Motif de consultation *',
                  hintText: 'Ex: Douleurs abdominales, fièvre...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_information),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le motif est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Diagnostic
              TextFormField(
                controller: _diagnosisController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Diagnostic *',
                  hintText: 'Diagnostic médical détaillé',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le diagnostic est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Traitement
              TextFormField(
                controller: _treatmentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Traitement prescrit',
                  hintText: 'Médicaments et posologie',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
              ),

              SizedBox(height: 16),

              // Ordonnance
              TextFormField(
                controller: _prescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Ordonnance',
                  hintText: 'Détails de l\'ordonnance',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),

              SizedBox(height: 24),

              // Section Constantes vitales
              Text(
                'Constantes vitales (optionnel)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Grille des constantes vitales (2 colonnes)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _temperatureController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Température (°C)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.thermostat),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _heartRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pouls (bpm)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.favorite),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bloodPressureController,
                      decoration: InputDecoration(
                        labelText: 'Tension (mmHg)',
                        hintText: '120/80',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monitor_heart),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Poids (kg)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monitor_weight),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Notes additionnelles
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes additionnelles',
                  hintText: 'Remarques, observations...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),

              SizedBox(height: 32),

              // Bouton d'enregistrement
              ElevatedButton(
                onPressed: _isLoading ? null : _saveConsultation,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('ENREGISTRER LA CONSULTATION'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A9D8F),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Méthode pour sauvegarder la consultation
  Future<void> _saveConsultation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final centerId = authProvider.currentUser?.id ?? '';

        // Construction des constantes vitales
        final vitalSigns = <String, dynamic>{};
        if (_temperatureController.text.isNotEmpty) {
          vitalSigns['temperature'] = _temperatureController.text;
        }
        if (_bloodPressureController.text.isNotEmpty) {
          vitalSigns['bloodPressure'] = _bloodPressureController.text;
        }
        if (_heartRateController.text.isNotEmpty) {
          vitalSigns['heartRate'] = _heartRateController.text;
        }
        if (_weightController.text.isNotEmpty) {
          vitalSigns['weight'] = _weightController.text;
        }

        // Création de la consultation
        final consultation = ConsultationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: _patientIdController.text,
          centerId: centerId,
          doctorName: _doctorNameController.text,
          dateTime: DateTime.now(),
          reason: _reasonController.text,
          diagnosis: _diagnosisController.text,
          treatment: _treatmentController.text.isNotEmpty ? _treatmentController.text : null,
          prescription: _prescriptionController.text.isNotEmpty ? _prescriptionController.text : null,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          vitalSigns: vitalSigns.isNotEmpty ? vitalSigns : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Sauvegarde dans Firestore
        await _consultationService.createConsultation(consultation);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Consultation enregistrée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        // Retour à la page précédente
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _doctorNameController.dispose();
    _reasonController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _prescriptionController.dispose();
    _notesController.dispose();
    _temperatureController.dispose();
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

