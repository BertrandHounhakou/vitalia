// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

/// Widget réutilisable pour l'AppBar personnalisée de l'application
/// Utilisé sur toutes les pages pour avoir une en-tête unifiée
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Titre affiché dans l'AppBar
  final String title;
  
  // Afficher ou non le bouton MENU à gauche (par défaut true)
  final bool showMenuButton;
  
  // Actions personnalisées à droite (optionnel)
  final List<Widget>? actions;
  
  // Callback personnalisé pour le bouton retour (optionnel)
  final VoidCallback? onBackPressed;

  /// Constructeur du widget CustomAppBar
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showMenuButton = true,
    this.actions,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Titre de l'AppBar
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Bouton à gauche (MENU ou flèche retour)
      leading: showMenuButton
          ? Builder(
              builder: (context) => Container(
                margin: EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: onBackPressed ?? () {
                    Scaffold.of(context).openDrawer();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            ),
      
      // Actions à droite (optionnel)
      actions: actions,
      
      // Décoration avec dégradé bleu-vert en arrière-plan
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF1E88E5), // Bleu
              Color(0xFF26A69A), // Vert-bleu
            ],
          ),
        ),
      ),
      
      // Pas d'ombre sous l'AppBar
      elevation: 0,
      
      // Couleur des icônes
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  /// Taille préférée de l'AppBar (standard 56px)
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

