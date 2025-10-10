// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/menu/center_menu_page.dart';
import 'package:vitalia/presentation/pages/menu/admin_menu_page.dart';

/// Classe pour la page du menu latéral (sans état)
/// Affiche le menu avec en-tête dégradé et fond blanc pour les éléments
class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    
    // Redirection vers le bon menu selon le rôle
    if (currentUser?.role == 'center') {
      return CenterMenuPage();
    }
    
    if (currentUser?.role == 'admin') {
      return AdminMenuPage();
    }

    return Drawer(
      // Largeur fixe à 78% pour ne jamais couvrir totalement la page
      width: MediaQuery.of(context).size.width * 0.78,
      
      child: Column(
        children: [
          // EN-TÊTE avec dégradé (avatar + nom utilisateur sur la même ligne)
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
                // Avatar de l'utilisateur
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Color(0xFF87CEEB),
                    backgroundImage: currentUser?.profileImage != null
                        ? NetworkImage(currentUser!.profileImage!)
                        : null,
                    child: currentUser?.profileImage == null
                        ? Icon(Icons.person, size: 35, color: Colors.white)
                        : null,
                  ),
                ),
                
                SizedBox(width: 15),
                
                // Informations utilisateur (nom + téléphone)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nom de l'utilisateur
                      Text(
                        currentUser?.name ?? 'Utilisateur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      
                      // Téléphone de l'utilisateur
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
                  // Élément de menu pour la page d'accueil
                  _buildMenuItem(
                    context: context,
                    icon: Icons.home,
                    title: 'Accueil',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/patient-home');
                    },
                  ),

                  // Élément de menu pour l'annuaire
                  _buildMenuItem(
                    context: context,
                    icon: Icons.contacts,
                    title: 'Annuaire',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/directory');
                    },
                  ),

                  // Élément de menu pour les rendez-vous
                  _buildMenuItem(
                    context: context,
                    icon: Icons.calendar_today,
                    title: 'Mes rendez-vous',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/appointments');
                    },
                  ),

                  // Élément de menu pour le carnet de santé
                  _buildMenuItem(
                    context: context,
                    icon: Icons.medical_services,
                    title: 'Mon carnet de santé',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/health-record');
                    },
                  ),

                  // Élément de menu pour les pharmacies
                  _buildMenuItem(
                    context: context,
                    icon: Icons.local_pharmacy,
                    title: 'Les pharmacies',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pharmacies');
                    },
                  ),

                  // Élément de menu pour les hôpitaux
                  _buildMenuItem(
                    context: context,
                    icon: Icons.local_hospital,
                    title: 'Les hôpitaux',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/hospitals');
                    },
                  ),

                  // Élément de menu pour les assurances
                  _buildMenuItem(
                    context: context,
                    icon: Icons.verified_user,
                    title: 'Les assurances',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/insurances');
                    },
                  ),

                  // Divider entre sections
                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Mon compte
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

                  // Élément de menu pour le profil
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person,
                    title: 'Mon profil',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),

                  // Élément de menu pour nous contacter
                  _buildMenuItem(
                    context: context,
                    icon: Icons.phone,
                    title: 'Nous contacter',
                    onTap: () => Navigator.pop(context),
                  ),

                  // Élément de menu pour à propos
                  _buildMenuItem(
                    context: context,
                    icon: Icons.info,
                    title: 'À propos',
                    onTap: () => Navigator.pop(context),
                  ),

                  // Élément de menu pour mentions légales
                  _buildMenuItem(
                    context: context,
                    icon: Icons.description,
                    title: 'Mentions légales',
                    onTap: () => Navigator.pop(context),
                  ),

                  // Divider avant déconnexion
                  Divider(color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),

                  // Section Plus
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Plus',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  // Élément de menu pour se déconnecter
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Se déconnecter',
                    onTap: () => _showLogoutConfirmation(context),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Méthode pour construire un élément de menu stylisé
  /// Maintenant avec texte et icônes GRIS (pas blanc) pour fond blanc
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[700], // Icône grise pour fond blanc
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87, // Texte noir pour fond blanc
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400], // Chevron gris clair
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
