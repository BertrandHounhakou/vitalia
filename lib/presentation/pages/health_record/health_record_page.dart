// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/profile/medical_constants_page.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/core/services/consultation_service.dart';
import 'package:vitalia/data/models/consultation_model.dart';

/// Page du carnet de santé affichant les constantes médicales et l'historique des consultations
/// LECTURE SEULE - Les patients ne peuvent PAS modifier ou ajouter des consultations
/// Seuls les centres de santé peuvent ajouter des consultations
class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({Key? key}) : super(key: key);

  @override
  _HealthRecordPageState createState() => _HealthRecordPageState();
}

/// État de la page du carnet de santé
class _HealthRecordPageState extends State<HealthRecordPage> {
  // Service de consultation
  final ConsultationService _consultationService = ConsultationService();
  
  // Liste des consultations chargées depuis Firestore
  List<ConsultationModel> _consultations = [];
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConsultations();
  }

  /// Charger les consultations du patient depuis Firestore
  Future<void> _loadConsultations() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser?.id;

      if (userId != null) {
        final consultations = await _consultationService.getPatientConsultations(userId);
        setState(() {
          _consultations = consultations;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des consultations: $e');
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
    // Récupération de l'utilisateur connecté et de ses constantes médicales
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Affichage de l'indicateur de chargement pendant le chargement des consultations
    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Mon carnet de santé',
          showMenuButton: true,
        ),
        drawer: MenuPage(),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
          ),
        ),
      );
    }

    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Mon carnet de santé',
        showMenuButton: true,
      ),
      
      // Menu latéral
      drawer: MenuPage(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section des constantes médicales
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre avec icône (sans bouton modifier)
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Color(0xFF2A9D8F),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Mes constantes médicales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Grille des constantes médicales (3 colonnes, cartes très compactes)
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3, // 3 colonnes
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.0,
                    children: [
                      // Carte Groupe sanguin
                      _buildCompactConstantCard(
                        icon: Icons.bloodtype,
                        iconColor: Colors.red,
                        title: 'B+',
                        subtitle: 'Groupe sanguin',
                        value: user?.bloodType ?? 'N/A',
                      ),

                      // Carte Taille
                      _buildCompactConstantCard(
                        icon: Icons.height,
                        iconColor: Colors.blue,
                        title: '162',
                        subtitle: 'Taille',
                        value: _extractHeight(user?.medicalHistory),
                      ),

                      // Carte Poids
                      _buildCompactConstantCard(
                        icon: Icons.monitor_weight,
                        iconColor: Colors.orange,
                        title: '65',
                        subtitle: 'Poids',
                        value: _extractWeight(user?.medicalHistory),
                      ),

                      // Carte Glycémie
                      _buildCompactConstantCard(
                        icon: Icons.monitor_heart,
                        iconColor: Colors.pink,
                        title: '1',
                        subtitle: 'Glycémie',
                        value: _extractGlycemia(user?.medicalHistory),
                      ),

                      // Carte Électrophorèse
                      _buildCompactConstantCard(
                        icon: Icons.science,
                        iconColor: Colors.purple,
                        title: 'AA',
                        subtitle: 'Electrophorèse',
                        value: _extractElectrophoresis(user?.medicalHistory),
                      ),

                      // Carte IMC
                      _buildCompactConstantCard(
                        icon: Icons.calculate,
                        iconColor: Colors.teal,
                        title: '24,8',
                        subtitle: 'Imc',
                        value: _extractBMI(user?.medicalHistory),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Divider(thickness: 8, color: Colors.grey[200]),

            // Section de l'historique des consultations
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Color(0xFF2A9D8F),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Historique des consultations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Liste des consultations ou message vide
                  _consultations.isEmpty
                      ? _buildEmptyConsultationsMessage()
                      : Column(
                          children: _consultations.map((consultation) {
                            return _buildConsultationCardFromModel(consultation);
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),

      // PAS DE BOUTON D'AJOUT - Lecture seule pour les patients
      // Seuls les centres de santé peuvent ajouter des consultations
    );
  }

  /// Widget pour construire une carte de constante compacte (comme sur la photo)
  Widget _buildCompactConstantCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône (très petite)
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),

            SizedBox(height: 3),

            // Valeur principale (plus petite)
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2),

            // Libellé (très petit)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour construire une carte de consultation depuis le modèle Firestore
  Widget _buildConsultationCardFromModel(ConsultationModel consultation) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(consultation.dateTime);
    final formattedTime = DateFormat('HH:mm').format(consultation.dateTime);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showConsultationDetails(consultation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône avec fond coloré
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF2A9D8F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: Color(0xFF2A9D8F),
                  size: 24,
                ),
              ),

              SizedBox(width: 12),

              // Informations de la consultation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom du docteur
                    Text(
                      consultation.doctorName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Date et heure
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),

                    // Raison de la consultation
                    Text(
                      consultation.reason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Diagnostic
                    Text(
                      'Diagnostic: ${consultation.diagnosis}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Badge "Voir détails"
                    SizedBox(height: 6),
                    Text(
                      'Appuyez pour voir les détails',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2A9D8F),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget pour le message quand il n'y a pas de consultations
  Widget _buildEmptyConsultationsMessage() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Vous n\'avez effectué aucune consultation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Vos consultations apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Afficher les détails complets d'une consultation (lecture seule)
  void _showConsultationDetails(ConsultationModel consultation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.medical_services, color: Color(0xFF2A9D8F)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Détails de la consultation',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Docteur', consultation.doctorName, Icons.person),
                Divider(),
                _buildDetailRow(
                  'Date',
                  DateFormat('dd/MM/yyyy à HH:mm').format(consultation.dateTime),
                  Icons.calendar_today,
                ),
                Divider(),
                _buildDetailRow('Motif', consultation.reason, Icons.notes),
                Divider(),
                _buildDetailRow('Diagnostic', consultation.diagnosis, Icons.medical_information),
                
                if (consultation.treatment != null) ...[
                  Divider(),
                  _buildDetailRow('Traitement', consultation.treatment!, Icons.medication),
                ],
                
                if (consultation.prescription != null) ...[
                  Divider(),
                  _buildDetailRow('Ordonnance', consultation.prescription!, Icons.description),
                ],
                
                if (consultation.notes != null) ...[
                  Divider(),
                  _buildDetailRow('Notes', consultation.notes!, Icons.note_alt),
                ],

                // Affichage des constantes vitales si disponibles
                if (consultation.vitalSigns != null && consultation.vitalSigns!.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    'Constantes vitales',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A9D8F),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...consultation.vitalSigns!.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  /// Widget helper pour afficher une ligne de détail
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
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
    );
  }

  // Méthodes pour extraire les données du medicalHistory
  String _extractHeight(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Taille: (\d+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractWeight(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Poids: (\d+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractGlycemia(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Glycémie: ([\d.]+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractElectrophoresis(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Électrophorèse: (\w+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractBMI(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'IMC: ([\d.]+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }
}
