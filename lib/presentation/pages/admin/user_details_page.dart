// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/core/services/consultation_service.dart';
import 'package:vitalia/core/services/appointment_service.dart';

/// Page de détails d'un utilisateur pour l'administrateur
/// Affiche toutes les informations selon le type d'utilisateur (patient, centre, admin)
class UserDetailsPage extends StatefulWidget {
  final UserModel user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ConsultationService _consultationService = ConsultationService();
  final AppointmentService _appointmentService = AppointmentService();
  
  int _totalConsultations = 0;
  int _totalAppointments = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  /// Charger les statistiques de l'utilisateur
  Future<void> _loadUserStats() async {
    try {
      if (widget.user.role == 'patient') {
        final consultations = await _consultationService.getPatientConsultations(widget.user.id);
        final appointments = await _appointmentService.getPatientAppointments(widget.user.id);
        
        setState(() {
          _totalConsultations = consultations.length;
          _totalAppointments = appointments.length;
          _isLoadingStats = false;
        });
      } else if (widget.user.role == 'center') {
        final consultations = await _consultationService.getCenterConsultations(widget.user.id);
        final appointments = await _appointmentService.getCenterAppointments(widget.user.id);
        
        setState(() {
          _totalConsultations = consultations.length;
          _totalAppointments = appointments.length;
          _isLoadingStats = false;
        });
      } else {
        setState(() {
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      print('Erreur chargement stats: $e');
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Détails utilisateur',
        showMenuButton: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête avec avatar et infos principales
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: widget.user.profileImage != null
                        ? NetworkImage(widget.user.profileImage!)
                        : null,
                    child: widget.user.profileImage == null
                        ? Icon(
                            _getUserIcon(),
                            size: 50,
                            color: _getGradientColors()[0],
                          )
                        : null,
                  ),

                  SizedBox(height: 16),

                  // Nom
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  // Badge de rôle
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      _getRoleLabel(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Statistiques rapides
                  if (!_isLoadingStats && widget.user.role != 'admin')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuickStat(
                          Icons.medical_services,
                          _totalConsultations.toString(),
                          'Consultations',
                        ),
                        SizedBox(width: 24),
                        _buildQuickStat(
                          Icons.calendar_today,
                          _totalAppointments.toString(),
                          'Rendez-vous',
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Informations détaillées
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Informations générales
                  _buildSectionTitle('Informations générales'),
                  
                  _buildInfoCard([
                    _buildInfoRow(Icons.email, 'Email', widget.user.email, canCopy: true),
                    _buildInfoRow(Icons.phone, 'Téléphone', widget.user.phone, canCopy: true),
                    _buildInfoRow(Icons.badge, 'ID Utilisateur', widget.user.id, canCopy: true),
                    if (widget.user.address != null)
                      _buildInfoRow(Icons.location_on, 'Adresse', widget.user.address!),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Créé le',
                      DateFormat('dd/MM/yyyy à HH:mm').format(widget.user.createdAt),
                    ),
                    _buildInfoRow(
                      Icons.update,
                      'Dernière mise à jour',
                      DateFormat('dd/MM/yyyy à HH:mm').format(widget.user.updatedAt),
                    ),
                  ]),

                  SizedBox(height: 24),

                  // Informations spécifiques au PATIENT
                  if (widget.user.role == 'patient') ...[
                    _buildSectionTitle('Informations médicales'),
                    
                    _buildInfoCard([
                      if (widget.user.firstName != null || widget.user.lastName != null)
                        _buildInfoRow(
                          Icons.person,
                          'Nom complet',
                          '${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}'.trim(),
                        ),
                      if (widget.user.dateOfBirth != null)
                        _buildInfoRow(
                          Icons.cake,
                          'Date de naissance',
                          '${DateFormat('dd/MM/yyyy').format(widget.user.dateOfBirth!)} (${widget.user.age} ans)',
                        ),
                      if (widget.user.gender != null)
                        _buildInfoRow(Icons.person_outline, 'Genre', widget.user.gender!),
                      if (widget.user.bloodType != null)
                        _buildInfoRow(
                          Icons.bloodtype,
                          'Groupe sanguin',
                          widget.user.bloodType!,
                          color: Colors.red,
                        ),
                      if (widget.user.allergies != null)
                        _buildInfoRow(
                          Icons.warning,
                          'Allergies',
                          widget.user.allergies!,
                          color: Colors.orange,
                        ),
                      if (widget.user.profession != null)
                        _buildInfoRow(Icons.work, 'Profession', widget.user.profession!),
                      if (widget.user.emergencyContact != null)
                        _buildInfoRow(
                          Icons.emergency,
                          'Contact d\'urgence',
                          widget.user.emergencyContact!,
                          color: Colors.red,
                          canCopy: true,
                        ),
                    ]),

                    SizedBox(height: 24),
                  ],

                  // Informations spécifiques au CENTRE
                  if (widget.user.role == 'center') ...[
                    _buildSectionTitle('Informations du centre'),
                    
                    _buildInfoCard([
                      if (widget.user.description != null)
                        _buildInfoRow(Icons.description, 'Description', widget.user.description!),
                      if (widget.user.openingHours != null)
                        _buildInfoRow(Icons.schedule, 'Horaires', widget.user.openingHours!),
                    ]),

                    SizedBox(height: 24),

                    // Spécialités
                    if (widget.user.specialties != null && widget.user.specialties!.isNotEmpty) ...[
                      _buildSectionTitle('Spécialités disponibles'),
                      
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.user.specialties!.map((specialty) {
                              return Chip(
                                avatar: Icon(
                                  Icons.medical_services,
                                  size: 16,
                                  color: Color(0xFF26A69A),
                                ),
                                label: Text(
                                  specialty,
                                  style: TextStyle(fontSize: 13),
                                ),
                                backgroundColor: Color(0xFF26A69A).withOpacity(0.1),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ],

                  // Statut du compte
                  _buildSectionTitle('Statut du compte'),
                  
                  _buildInfoCard([
                    _buildInfoRow(
                      widget.user.emailVerified ? Icons.verified : Icons.warning,
                      'Email vérifié',
                      widget.user.emailVerified ? 'Oui' : 'Non',
                      color: widget.user.emailVerified ? Colors.green : Colors.orange,
                    ),
                  ]),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Obtenir les couleurs du dégradé selon le rôle
  List<Color> _getGradientColors() {
    switch (widget.user.role) {
      case 'patient':
        return [Color(0xFF2A7FDE), Color(0xFF4CAF50)];
      case 'center':
        return [Color(0xFF26A69A), Color(0xFF1E88E5)];
      case 'admin':
        return [Color(0xFFFF9800), Color(0xFFF44336)];
      default:
        return [Colors.grey, Colors.grey[700]!];
    }
  }

  /// Obtenir l'icône selon le rôle
  IconData _getUserIcon() {
    switch (widget.user.role) {
      case 'patient':
        return Icons.person;
      case 'center':
        return Icons.local_hospital;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.account_circle;
    }
  }

  /// Obtenir le label du rôle
  String _getRoleLabel() {
    switch (widget.user.role) {
      case 'patient':
        return 'PATIENT';
      case 'center':
        return 'CENTRE DE SANTÉ';
      case 'admin':
        return 'ADMINISTRATEUR';
      default:
        return widget.user.role.toUpperCase();
    }
  }

  /// Widget pour une statistique rapide dans l'en-tête
  Widget _buildQuickStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Widget pour un titre de section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFF26A69A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget pour une carte d'informations
  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  /// Widget pour une ligne d'information
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
    bool canCopy = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? Colors.grey[600],
          ),
          SizedBox(width: 12),
          Expanded(
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              icon: Icon(Icons.copy, size: 18),
              color: Color(0xFF26A69A),
              tooltip: 'Copier',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copié !'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

