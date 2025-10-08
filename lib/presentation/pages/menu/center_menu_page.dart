// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Menu latéral personnalisé pour les Centres de santé
/// Affiche uniquement les fonctionnalités accessibles aux centres
class CenterMenuPage extends StatelessWidget {
  const CenterMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Drawer(
      // Largeur fixe à 78% pour ne jamais couvrir totalement la page
      width: MediaQuery.of(context).size.width * 0.78,
      
      child: Column(
        children: [
          // EN-TÊTE avec dégradé (avatar + nom du centre)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E88E5), // Bleu
                  Color(0xFF26A69A), // Vert-bleu
                ],
              ),
            ),
            child: Row(
              children: [
                // Avatar du centre
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Color(0xFF4CAF50),
                    backgroundImage: currentUser?.profileImage != null
                        ? NetworkImage(currentUser!.profileImage!)
                        : null,
                    child: currentUser?.profileImage == null
                        ? Icon(Icons.local_hospital, size: 35, color: Colors.white)
                        : null,
                  ),
                ),
                
                SizedBox(width: 15),
                
                // Informations du centre
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentUser?.name ?? 'Centre de santé',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        currentUser?.phone ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // RESTE DU MENU avec fond BLANC
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Élément de menu pour le tableau de bord
                  _buildMenuItem(
                    context: context,
                    icon: Icons.dashboard,
                    title: 'Tableau de bord',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/center/home');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Consultations
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Consultations',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Ajouter une consultation
                  _buildMenuItem(
                    context: context,
                    icon: Icons.add_circle_outline,
                    title: 'Nouvelle consultation',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/center/add-consultation');
                    },
                  ),

                  // Historique des consultations
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history,
                    title: 'Historique consultations',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/center/consultations');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Rendez-vous
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Rendez-vous',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Gérer les rendez-vous
                  _buildMenuItem(
                    context: context,
                    icon: Icons.event_available,
                    title: 'Gérer les rendez-vous',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/center/appointments');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Patients
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Patients',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Rechercher un patient
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_search,
                    title: 'Rechercher un patient',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/center/patients');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Compte
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Mon compte',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Profil du centre
                  _buildMenuItem(
                    context: context,
                    icon: Icons.business,
                    title: 'Profil du centre',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Élément de menu pour se déconnecter
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Se déconnecter',
                    onTap: () => _showLogoutConfirmation(context),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Méthode pour construire un élément de menu stylisé
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[700],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 20,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      onTap: onTap,
    );
  }

  /// Méthode pour afficher la confirmation de déconnexion
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('NON'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: Text('OUI'),
            ),
          ],
        );
      },
    );
  }

  /// Méthode pour effectuer la déconnexion
  void _performLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.logout();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
      );
    }
  }
}

