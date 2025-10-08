// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/menu/center_menu_page.dart';

/// Page d'accueil pour les Centres de santé
/// Dashboard affichant les statistiques et les actions rapides
class CenterHomePage extends StatefulWidget {
  const CenterHomePage({Key? key}) : super(key: key);

  @override
  _CenterHomePageState createState() => _CenterHomePageState();
}

class _CenterHomePageState extends State<CenterHomePage> {
  // Statistiques du centre (simulées - à remplacer par des données Firebase)
  final Map<String, int> _stats = {
    'consultationsToday': 12,
    'appointmentsToday': 8,
    'patientsTotal': 245,
    'pendingAppointments': 5,
  };

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

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de bienvenue
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
              'Gestion des consultations et rendez-vous',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
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
                // Consultations du jour
                _buildStatCard(
                  title: 'Consultations',
                  subtitle: "Aujourd'hui",
                  value: _stats['consultationsToday'].toString(),
                  icon: Icons.medical_services,
                  color: Colors.blue,
                ),

                // Rendez-vous du jour
                _buildStatCard(
                  title: 'Rendez-vous',
                  subtitle: "Aujourd'hui",
                  value: _stats['appointmentsToday'].toString(),
                  icon: Icons.calendar_today,
                  color: Colors.green,
                ),

                // Total patients
                _buildStatCard(
                  title: 'Patients',
                  subtitle: 'Total',
                  value: _stats['patientsTotal'].toString(),
                  icon: Icons.people,
                  color: Colors.orange,
                ),

                // RDV en attente
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
              onTap: () => Navigator.pushNamed(context, '/center/add-consultation'),
            ),

            SizedBox(height: 12),

            _buildActionButton(
              title: 'Gérer les rendez-vous',
              icon: Icons.event_available,
              color: Color(0xFF1E88E5),
              onTap: () => Navigator.pushNamed(context, '/center/appointments'),
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

