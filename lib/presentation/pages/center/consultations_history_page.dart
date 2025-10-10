// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/consultation_model.dart';
import 'package:vitalia/core/services/consultation_service.dart';

/// Page affichant l'historique de toutes les consultations du centre
class ConsultationsHistoryPage extends StatefulWidget {
  const ConsultationsHistoryPage({Key? key}) : super(key: key);

  @override
  _ConsultationsHistoryPageState createState() => _ConsultationsHistoryPageState();
}

class _ConsultationsHistoryPageState extends State<ConsultationsHistoryPage> {
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

  /// Charger toutes les consultations du centre
  Future<void> _loadConsultations() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final centerId = authProvider.currentUser?.id;

      if (centerId != null) {
        final consultations = await _consultationService.getCenterConsultations(centerId);
        
        setState(() {
          _consultations = consultations;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur chargement consultations: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des consultations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Historique des consultations',
        showMenuButton: false,
      ),

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
              ),
            )
          : _consultations.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadConsultations,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _consultations.length,
                    itemBuilder: (context, index) {
                      final consultation = _consultations[index];
                      return _buildConsultationCard(consultation);
                    },
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
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF26A69A).withOpacity(0.1),
          child: Icon(Icons.medical_services, color: Color(0xFF26A69A)),
        ),

        title: Text(
          consultation.reason,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'Dr. ${consultation.doctorName}',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '$formattedDate à $formattedTime',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),

        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient ID (temporaire, en attendant de lier avec les données patient)
                _buildDetailRow(
                  Icons.badge,
                  'ID Patient',
                  consultation.patientId,
                  Colors.blue,
                ),

                Divider(height: 24),

                // Diagnostic
                _buildDetailRow(
                  Icons.medical_information,
                  'Diagnostic',
                  consultation.diagnosis,
                  Colors.red,
                ),

                // Traitement
                if (consultation.treatment != null && consultation.treatment!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.medication,
                    'Traitement',
                    consultation.treatment!,
                    Colors.green,
                  ),
                ],

                // Ordonnance
                if (consultation.prescription != null && consultation.prescription!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.description,
                    'Ordonnance',
                    consultation.prescription!,
                    Colors.orange,
                  ),
                ],

                // Notes
                if (consultation.notes != null && consultation.notes!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.note_alt,
                    'Notes',
                    consultation.notes!,
                    Colors.purple,
                  ),
                ],

                // Constantes vitales
                if (consultation.vitalSigns != null && consultation.vitalSigns!.isNotEmpty) ...[
                  Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Constantes vitales',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      children: consultation.vitalSigns!.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Text(
                                '• ${entry.key}:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${entry.value}',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget pour afficher une ligne de détail
  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget pour l'état vide des consultations
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            'Aucune consultation enregistrée',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Les consultations que vous ajouterez\napparaîtront ici',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/center/add-consultation');
            },
            icon: Icon(Icons.add),
            label: Text('Ajouter une consultation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF26A69A),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

