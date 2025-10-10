// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Menu latéral personnalisé pour les Administrateurs
/// Affiche uniquement les fonctionnalités d'administration
class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({Key? key}) : super(key: key);

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
          // EN-TÊTE avec dégradé (avatar + nom admin)
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
                // Avatar de l'admin
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Color(0xFFFF9800),
                    backgroundImage: currentUser?.profileImage != null
                        ? NetworkImage(currentUser!.profileImage!)
                        : null,
                    child: currentUser?.profileImage == null
                        ? Icon(Icons.admin_panel_settings, size: 35, color: Colors.white)
                        : null,
                  ),
                ),
                
                SizedBox(width: 15),
                
                // Informations admin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentUser?.name ?? 'Administrateur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ADMINISTRATEUR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Navigator.pushReplacementNamed(context, '/admin/home');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Gestion des utilisateurs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Gestion des utilisateurs',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Créer un centre de santé
                  _buildMenuItem(
                    context: context,
                    icon: Icons.add_business,
                    title: 'Créer un centre de santé',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/create-center');
                    },
                  ),

                  // Créer un patient
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_add,
                    title: 'Créer un patient',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/create-patient');
                    },
                  ),

                  // Liste des utilisateurs
                  _buildMenuItem(
                    context: context,
                    icon: Icons.people,
                    title: 'Liste des utilisateurs',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/users');
                    },
                  ),

                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Rapports
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Rapports & Statistiques',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Statistiques globales
                  _buildMenuItem(
                    context: context,
                    icon: Icons.analytics,
                    title: 'Statistiques globales',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fonctionnalité à venir')),
                      );
                    },
                  ),

                  // Rapports d'activité
                  _buildMenuItem(
                    context: context,
                    icon: Icons.assessment,
                    title: 'Rapports d\'activité',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fonctionnalité à venir')),
                      );
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

                  // Profil admin
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person,
                    title: 'Mon profil',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/profile');
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

