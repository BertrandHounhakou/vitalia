// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/menu/admin_menu_page.dart';

/// Page d'accueil pour l'Administrateur
/// Dashboard affichant les statistiques et la gestion des utilisateurs
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Statistiques globales (simulées - à remplacer par des données Firebase)
  final Map<String, int> _stats = {
    'totalPatients': 1245,
    'totalCenters': 38,
    'totalConsultations': 5678,
    'activeToday': 142,
  };

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

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de bienvenue
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
              'Tableau de bord administrateur',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
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
                // Total patients
                _buildStatCard(
                  title: 'Patients',
                  subtitle: 'Total inscrits',
                  value: _stats['totalPatients'].toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),

                // Total centres
                _buildStatCard(
                  title: 'Centres',
                  subtitle: 'Centres de santé',
                  value: _stats['totalCenters'].toString(),
                  icon: Icons.local_hospital,
                  color: Colors.green,
                ),

                // Total consultations
                _buildStatCard(
                  title: 'Consultations',
                  subtitle: 'Total',
                  value: _stats['totalConsultations'].toString(),
                  icon: Icons.medical_services,
                  color: Colors.orange,
                ),

                // Actifs aujourd'hui
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
              onTap: () => Navigator.pushNamed(context, '/admin/create-center'),
            ),

            SizedBox(height: 12),

            // Bouton créer un patient
            _buildActionButton(
              title: 'Créer un compte patient',
              subtitle: 'Enregistrer un nouveau patient',
              icon: Icons.person_add,
              color: Color(0xFF1E88E5),
              onTap: () => Navigator.pushNamed(context, '/admin/create-patient'),
            ),

            SizedBox(height: 12),

            // Bouton liste des utilisateurs
            _buildActionButton(
              title: 'Liste des utilisateurs',
              subtitle: 'Voir et gérer tous les comptes',
              icon: Icons.list,
              color: Color(0xFF4CAF50),
              onTap: () => Navigator.pushNamed(context, '/admin/users'),
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

