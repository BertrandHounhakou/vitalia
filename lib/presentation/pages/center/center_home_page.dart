// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/menu/center_menu_page.dart';
import 'package:vitalia/core/services/consultation_service.dart';
import 'package:vitalia/core/services/appointment_service.dart';
import 'package:vitalia/data/models/consultation_model.dart';
import 'package:vitalia/data/models/appointment_model.dart';

/// Page d'accueil pour les Centres de santé
/// Dashboard affichant les statistiques réelles depuis Firestore
class CenterHomePage extends StatefulWidget {
  const CenterHomePage({Key? key}) : super(key: key);

  @override
  _CenterHomePageState createState() => _CenterHomePageState();
}

class _CenterHomePageState extends State<CenterHomePage> {
  // Services
  final ConsultationService _consultationService = ConsultationService();
  final AppointmentService _appointmentService = AppointmentService();
  
  // Statistiques du centre (chargées depuis Firestore)
  Map<String, int> _stats = {
    'consultationsToday': 0,
    'appointmentsToday': 0,
    'patientsTotal': 0,
    'pendingAppointments': 0,
  };
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  /// Charger les statistiques réelles depuis Firestore
  Future<void> _loadStatistics() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final centerId = authProvider.currentUser?.id;

      if (centerId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('📊 Chargement des statistiques du centre $centerId...');

      // Charger toutes les consultations du centre
      final consultations = await _consultationService.getCenterConsultations(centerId);
      
      // Charger tous les rendez-vous du centre
      final appointments = await _appointmentService.getCenterAppointments(centerId);

      // Calculer les statistiques
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(Duration(days: 1));

      // Consultations aujourd'hui
      final consultationsToday = consultations.where((c) {
        final cDate = DateTime(c.dateTime.year, c.dateTime.month, c.dateTime.day);
        return cDate.isAtSameMomentAs(today);
      }).length;

      // Rendez-vous aujourd'hui
      final appointmentsToday = appointments.where((a) {
        final aDate = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day);
        return aDate.isAtSameMomentAs(today);
      }).length;

      // Total patients uniques (depuis consultations ET rendez-vous)
      final patientsFromConsultations = consultations.map((c) => c.patientId).toSet();
      final patientsFromAppointments = appointments.map((a) => a.patientId).toSet();
      
      // Union des deux ensembles pour avoir tous les patients uniques
      final allUniquePatients = {...patientsFromConsultations, ...patientsFromAppointments};
      final uniquePatients = allUniquePatients.length;

      // Rendez-vous en attente (scheduled ou confirmed)
      final pendingAppointments = appointments.where((a) {
        return (a.status == 'scheduled' || a.status == 'confirmed') && 
               a.dateTime.isAfter(now);
      }).length;

      setState(() {
        _stats = {
          'consultationsToday': consultationsToday,
          'appointmentsToday': appointmentsToday,
          'patientsTotal': uniquePatients,
          'pendingAppointments': pendingAppointments,
        };
        _isLoading = false;
      });

      print('✅ Statistiques chargées: $_stats');
    } catch (e) {
      print('❌ Erreur chargement statistiques: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de l'utilisateur connecté
    final authProvider = Provider.of<AuthProvider>(context);
    final centerName = authProvider.currentUser?.name ?? 'Centre de santé';

    return Scaffold(
      // AppBar personnalisée avec dégradé
      appBar: CustomAppBar(
        title: centerName,
        showMenuButton: true,
      ),

      // Menu latéral personnalisé pour Centre de santé
      drawer: CenterMenuPage(),

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de bienvenue
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tableau de bord',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Statistiques en temps réel',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Color(0xFF26A69A)),
                          onPressed: _loadStatistics,
                          tooltip: 'Actualiser',
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Grille des statistiques (2x2)
                    GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                // Consultations du jour (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Consultations',
                  subtitle: "Aujourd'hui",
                  value: _stats['consultationsToday'].toString(),
                  icon: Icons.medical_services,
                  color: Colors.blue,
                ),

                // Rendez-vous du jour (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Rendez-vous',
                  subtitle: "Aujourd'hui",
                  value: _stats['appointmentsToday'].toString(),
                  icon: Icons.calendar_today,
                  color: Colors.green,
                ),

                // Total patients uniques (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Patients',
                  subtitle: 'Total',
                  value: _stats['patientsTotal'].toString(),
                  icon: Icons.people,
                  color: Colors.orange,
                ),

                // RDV en attente (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'En attente',
                  subtitle: 'Rendez-vous',
                  value: _stats['pendingAppointments'].toString(),
                  icon: Icons.pending_actions,
                  color: Colors.purple,
                ),
              ],
            ),

            SizedBox(height: 24),

            // Actions rapides
            Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12),

            // Boutons d'actions
            _buildActionButton(
              title: 'Ajouter une consultation',
              icon: Icons.add_circle,
              color: Color(0xFF2A9D8F),
              onTap: () async {
                await Navigator.pushNamed(context, '/center/add-consultation');
                // Recharger les statistiques après ajout
                _loadStatistics();
              },
            ),

            SizedBox(height: 12),

            _buildActionButton(
              title: 'Gérer les rendez-vous',
              icon: Icons.event_available,
              color: Color(0xFF1E88E5),
              onTap: () async {
                await Navigator.pushNamed(context, '/center/appointments');
                // Recharger les statistiques après gestion
                _loadStatistics();
              },
            ),

            SizedBox(height: 12),

            _buildActionButton(
              title: 'Rechercher un patient',
              icon: Icons.person_search,
              color: Color(0xFF4CAF50),
              onTap: () => Navigator.pushNamed(context, '/center/patients'),
            ),

            SizedBox(height: 12),

            _buildActionButton(
              title: 'Historique des consultations',
              icon: Icons.history,
              color: Color(0xFFFF9800),
              onTap: () => Navigator.pushNamed(context, '/center/consultations'),
            ),
          ],
                ),
              ),
            ),
    );
  }

  /// Widget pour construire une carte de statistique
  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône
            Icon(
              icon,
              size: 36,
              color: color,
            ),

            SizedBox(height: 8),

            // Valeur (nombre)
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 4),

            // Titre
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            // Sous-titre
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour construire un bouton d'action
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône avec fond coloré
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),

              SizedBox(width: 16),

              // Titre
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Flèche
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

