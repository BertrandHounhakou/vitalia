// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/menu/admin_menu_page.dart';
import 'package:vitalia/core/services/firebase_user_service.dart';
import 'package:vitalia/core/services/consultation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Page d'accueil pour l'Administrateur
/// Dashboard affichant les statistiques réelles depuis Firestore
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Services
  final FirebaseUserService _userService = FirebaseUserService();
  final ConsultationService _consultationService = ConsultationService();
  
  // Statistiques globales (chargées depuis Firestore)
  Map<String, int> _stats = {
    'totalPatients': 0,
    'totalCenters': 0,
    'totalConsultations': 0,
    'activeToday': 0,
  };
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  /// Charger les statistiques globales depuis Firestore
  Future<void> _loadStatistics() async {
    try {
      print('📊 Admin: Chargement des statistiques globales...');

      // Charger tous les utilisateurs
      final allUsers = await _userService.getUsers();

      // Compter par rôle
      final totalPatients = allUsers.where((u) => u.role == 'patient').length;
      final totalCenters = allUsers.where((u) => u.role == 'center').length;

      // Compter toutes les consultations
      final consultationsSnapshot = await FirebaseFirestore.instance
          .collection('consultations')
          .get();
      final totalConsultations = consultationsSnapshot.docs.length;

      // Compter les activités aujourd'hui (consultations + rendez-vous)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final todayConsultations = consultationsSnapshot.docs.where((doc) {
        final data = doc.data();
        final dateTime = (data['dateTime'] as Timestamp).toDate();
        final cDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        return cDate.isAtSameMomentAs(today);
      }).length;

      final appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .get();
      
      final todayAppointments = appointmentsSnapshot.docs.where((doc) {
        final data = doc.data();
        final dateTime = (data['dateTime'] as Timestamp).toDate();
        final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        return aDate.isAtSameMomentAs(today);
      }).length;

      final activeToday = todayConsultations + todayAppointments;

      setState(() {
        _stats = {
          'totalPatients': totalPatients,
          'totalCenters': totalCenters,
          'totalConsultations': totalConsultations,
          'activeToday': activeToday,
        };
        _isLoading = false;
      });

      print('✅ Admin: Statistiques chargées: $_stats');
    } catch (e) {
      print('❌ Admin: Erreur chargement statistiques: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de l'administrateur connecté
    final authProvider = Provider.of<AuthProvider>(context);
    final adminName = authProvider.currentUser?.name ?? 'Administrateur';

    return Scaffold(
      // AppBar personnalisée avec dégradé
      appBar: CustomAppBar(
        title: 'Administration Vitalia',
        showMenuButton: true,
      ),

      // Menu latéral personnalisé pour Administrateur
      drawer: AdminMenuPage(),

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
                                'Bienvenue, $adminName',
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

            // Grille des statistiques globales (2x2)
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                // Total patients (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Patients',
                  subtitle: 'Total inscrits',
                  value: _stats['totalPatients'].toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),

                // Total centres (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Centres',
                  subtitle: 'Centres de santé',
                  value: _stats['totalCenters'].toString(),
                  icon: Icons.local_hospital,
                  color: Colors.green,
                ),

                // Total consultations (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Consultations',
                  subtitle: 'Total',
                  value: _stats['totalConsultations'].toString(),
                  icon: Icons.medical_services,
                  color: Colors.orange,
                ),

                // Actifs aujourd'hui (DONNÉES RÉELLES)
                _buildStatCard(
                  title: 'Aujourd\'hui',
                  subtitle: 'Activités',
                  value: _stats['activeToday'].toString(),
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ],
            ),

            SizedBox(height: 24),

            // Actions administrateur
            Text(
              'Gestion des utilisateurs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12),

            // Bouton créer un centre de santé
            _buildActionButton(
              title: 'Créer un centre de santé',
              subtitle: 'Ajouter un nouveau centre médical',
              icon: Icons.add_business,
              color: Color(0xFF2A9D8F),
              onTap: () async {
                await Navigator.pushNamed(context, '/admin/create-center');
                // Recharger les statistiques après création
                _loadStatistics();
              },
            ),

            SizedBox(height: 12),

            // Bouton créer un patient
            _buildActionButton(
              title: 'Créer un compte patient',
              subtitle: 'Enregistrer un nouveau patient',
              icon: Icons.person_add,
              color: Color(0xFF1E88E5),
              onTap: () async {
                await Navigator.pushNamed(context, '/admin/create-patient');
                // Recharger les statistiques après création
                _loadStatistics();
              },
            ),

            SizedBox(height: 12),

            // Bouton liste des utilisateurs
            _buildActionButton(
              title: 'Liste des utilisateurs',
              subtitle: 'Voir et gérer tous les comptes',
              icon: Icons.list,
              color: Color(0xFF4CAF50),
              onTap: () async {
                await Navigator.pushNamed(context, '/admin/users');
                // Recharger les statistiques après gestion
                _loadStatistics();
              },
            ),

            SizedBox(height: 12),

            // Bouton statistiques
            _buildActionButton(
              title: 'Statistiques globales',
              subtitle: 'Rapports et analyses',
              icon: Icons.analytics,
              color: Color(0xFFFF9800),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
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
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
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
    required String subtitle,
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
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

