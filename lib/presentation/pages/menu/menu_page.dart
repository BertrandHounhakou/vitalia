// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

// Classe pour la page du menu latéral (sans état)
class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  // Construction de l'interface du menu latéral
  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Drawer( // Drawer (menu latéral)
      child: ListView( // Liste d'éléments du menu
        padding: EdgeInsets.zero, // Pas de padding
        children: [
          // En-tête du menu avec informations utilisateur
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Couleur d'arrière-plan
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
              children: [
                // Avatar de l'utilisateur
                CircleAvatar(
                  radius: 30, // Taille de l'avatar
                  backgroundImage: currentUser?.profileImage != null 
                      ? NetworkImage(currentUser!.profileImage!) // Image de profil
                      : AssetImage('assets/images/profile.png') as ImageProvider, // Image par défaut
                  child: currentUser?.profileImage == null 
                      ? Icon(Icons.person, size: 30, color: Colors.white) // Icône si pas d'image
                      : null,
                ),
                SizedBox(height: 10), // Espacement
                // Nom de l'utilisateur
                Text(
                  currentUser?.name ?? 'Utilisateur', // Nom ou valeur par défaut
                  style: TextStyle(
                    color: Colors.white, // Couleur blanche
                    fontSize: 18, // Taille de police
                    fontWeight: FontWeight.bold, // Gras
                  ),
                ),
                // Email de l'utilisateur
                Text(
                  currentUser?.phone ?? '', // Téléphone ou vide
                  style: TextStyle(
                    color: Colors.white70, // Blanc transparent
                  ),
                ),
              ],
            ),
          ),
          
          // Élément de menu pour la page d'accueil
          ListTile(
            leading: Icon(Icons.home), // Icône d'accueil
            title: Text('Accueil'), // Texte du menu
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home'); // Navigation vers l'accueil
            },
          ),
          
          // Élément de menu pour l'annuaire
          ListTile(
            leading: Icon(Icons.contacts), // Icône de contacts
            title: Text('Annuaire'), // Texte du menu
            onTap: () {
              // TODO: Implémenter la page annuaire
              Navigator.pop(context); // Fermeture du menu
            },
          ),
          
          // Élément de menu pour les rendez-vous
          ListTile(
            leading: Icon(Icons.calendar_today), // Icône de calendrier
            title: Text('Mes rendez-vous'), // Texte du menu
            onTap: () {
              Navigator.pushNamed(context, '/appointments'); // Navigation vers les RDV
            },
          ),
          
          // Élément de menu pour le carnet de santé
          ListTile(
            leading: Icon(Icons.medical_services), // Icône médicale
            title: Text('Mon carnet de santé'), // Texte du menu
            onTap: () {
              // TODO: Implémenter la page carnet de santé
              Navigator.pushNamed(context, '/health-record'); // Fermeture du menu
            },
          ),
          
          // Élément de menu pour les pharmacies
          ListTile(
            leading: Icon(Icons.local_pharmacy), // Icône de pharmacie
            title: Text('Les pharmacies'), // Texte du menu
            onTap: () {
              Navigator.pushNamed(context, '/pharmacies'); // Navigation vers les pharmacies
            },
          ),
          
          // Élément de menu pour les hôpitaux
          ListTile(
            leading: Icon(Icons.local_hospital), // Icône d'hôpital
            title: Text('Les hôpitaux'), // Texte du menu
            onTap: () {
              Navigator.pushNamed(context, '/hospitals'); // Navigation vers les hôpitaux
            },
          ),
          
          // Élément de menu pour les assurances
          ListTile(
            leading: Icon(Icons.verified_user), // Icône d'assurance
            title: Text('Les assurances'), // Texte du menu
            onTap: () {
              // TODO: Implémenter la page assurances
              Navigator.pop(context); // Fermeture du menu
            },
          ),
          
          Divider(), // Séparateur
          
          // Élément de menu pour le profil
          ListTile(
            leading: Icon(Icons.person), // Icône de profil
            title: Text('Mon profil'), // Texte du menu
            onTap: () {
              Navigator.pushNamed(context, '/profile'); // Navigation vers le profil
            },
          ),
          
          // Élément de menu pour nous contacter
          ListTile(
            leading: Icon(Icons.phone), // Icône de téléphone
            title: Text('Nous contacter'), // Texte du menu
            onTap: () {
              // TODO: Implémenter la page de contact
              Navigator.pop(context); // Fermeture du menu
            },
          ),
          
          // Élément de menu pour à propos
          ListTile(
            leading: Icon(Icons.info), // Icône d'information
            title: Text('À propos'), // Texte du menu
            onTap: () {
              // TODO: Implémenter la page à propos
              Navigator.pop(context); // Fermeture du menu
            },
          ),
          
          // Élément de menu pour mentions légales
          ListTile(
            leading: Icon(Icons.description), // Icône de document
            title: Text('Mentions légales'), // Texte du menu
            onTap: () {
              // TODO: Implémenter les mentions légales
              Navigator.pop(context); // Fermeture du menu
            },
          ),
          
          Divider(), // Séparateur
          
          // Élément de menu pour se déconnecter
          ListTile(
            leading: Icon(Icons.logout), // Icône de déconnexion
            title: Text('Se déconnecter'), // Texte du menu
            onTap: () {
              _showLogoutConfirmation(context); // Confirmation de déconnexion
            },
          ),
        ],
      ),
    );
  }

  // Méthode pour afficher la confirmation de déconnexion
  void _showLogoutConfirmation(BuildContext context) {
    showDialog( // Affichage d'une dialog
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'), // Titre de la dialog
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'), // Message de confirmation
          actions: [
            // Bouton NON
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermeture de la dialog
              },
              child: Text('NON'), // Texte du bouton
            ),
            // Bouton OUI
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermeture de la dialog
                _performLogout(context); // Déconnexion effective
              },
              child: Text('OUI'), // Texte du bouton
            ),
          ],
        );
      },
    );
  }

  // Méthode pour effectuer la déconnexion
  void _performLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.logout(); // Appel de la déconnexion
      Navigator.pushReplacementNamed(context, '/login'); // Redirection vers login
    } catch (e) {
      // Gestion d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
      );
    }
  }
}