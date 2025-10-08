// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/data/models/consultation_model.dart';
import 'package:vitalia/core/services/consultation_service.dart';

/// Page affichant l'historique médical complet d'un patient
/// Accessible uniquement aux centres de santé
class PatientHistoryPage extends StatefulWidget {
  // Patient dont on affiche l'historique
  final UserModel patient;

  const PatientHistoryPage({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientHistoryPageState createState() => _PatientHistoryPageState();
}

class _PatientHistoryPageState extends State<PatientHistoryPage> {
  // Service de consultation
  final ConsultationService _consultationService = ConsultationService();
  
  // Liste des consultations
  List<ConsultationModel> _consultations = [];
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConsultations();
  }

  /// Charger les consultations du patient
  Future<void> _loadConsultations() async {
    try {
      final consultations = await _consultationService.getPatientConsultations(widget.patient.id);
      
      setState(() {
        _consultations = consultations;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement consultations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Dossier patient',
        showMenuButton: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte d'informations patient
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF2A9D8F),
                    backgroundImage: widget.patient.profileImage != null
                        ? NetworkImage(widget.patient.profileImage!)
                        : null,
                    child: widget.patient.profileImage == null
                        ? Text(
                            widget.patient.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),

                  SizedBox(height: 12),

                  Text(
                    widget.patient.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    widget.patient.phone,
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  SizedBox(height: 8),

                  // Informations médicales importantes
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      if (widget.patient.bloodType != null)
                        Chip(
                          label: Text(
                            'Groupe: ${widget.patient.bloodType}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      if (widget.patient.age != null)
                        Chip(
                          label: Text(
                            'Âge: ${widget.patient.age} ans',
                            style: TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      if (widget.patient.allergies != null && widget.patient.allergies!.isNotEmpty)
                        Chip(
                          label: Text(
                            'Allergies',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Constantes médicales
            if (widget.patient.medicalHistory != null &&
                widget.patient.medicalHistory!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Constantes médicales',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          widget.patient.medicalHistory!,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Allergies détaillées
            if (widget.patient.allergies != null &&
                widget.patient.allergies!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allergies et pathologies',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      color: Colors.orange[50],
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.patient.allergies!,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Contact d'urgence
            if (widget.patient.emergencyContact != null &&
                widget.patient.emergencyContact!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.red[50],
                  child: ListTile(
                    leading: Icon(Icons.emergency, color: Colors.red),
                    title: Text('Contact d\'urgence'),
                    subtitle: Text(widget.patient.emergencyContact!),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Divider
            Divider(thickness: 8, color: Colors.grey[200]),

            // Section historique des consultations
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: Color(0xFF2A9D8F)),
                      SizedBox(width: 8),
                      Text(
                        'Historique des consultations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Liste des consultations
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _consultations.isEmpty
                          ? _buildEmptyConsultations()
                          : Column(
                              children: _consultations.map((consultation) {
                                return _buildConsultationCard(consultation);
                              }).toList(),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour construire une carte de consultation
  Widget _buildConsultationCard(ConsultationModel consultation) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(consultation.dateTime);
    final formattedTime = DateFormat('HH:mm').format(consultation.dateTime);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF2A9D8F).withOpacity(0.1),
          child: Icon(Icons.medical_services, color: Color(0xFF2A9D8F)),
        ),

        title: Text(
          consultation.reason,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Dr. ${consultation.doctorName}'),
            SizedBox(height: 2),
            Text('$formattedDate à $formattedTime'),
          ],
        ),

        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Diagnostic', consultation.diagnosis),
                if (consultation.treatment != null)
                  _buildDetailRow('Traitement', consultation.treatment!),
                if (consultation.prescription != null)
                  _buildDetailRow('Ordonnance', consultation.prescription!),
                if (consultation.notes != null)
                  _buildDetailRow('Notes', consultation.notes!),
                if (consultation.vitalSigns != null &&
                    consultation.vitalSigns!.isNotEmpty) ...[
                  Divider(),
                  Text(
                    'Constantes vitales',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...consultation.vitalSigns!.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('${entry.key}: ${entry.value}'),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget pour afficher une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Widget pour l'état vide des consultations
  Widget _buildEmptyConsultations() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 12),
          Text(
            'Aucune consultation enregistrée',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

