// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

/// Widget réutilisable pour afficher une carte de service
/// Utilisé sur la page d'accueil pour afficher les différents services (Annuaire, Rendez-vous, etc.)
class ServiceCard extends StatelessWidget {
  // Titre du service affiché sous l'icône
  final String title;
  
  // Icône du service affichée dans le conteneur
  final IconData icon;
  
  // Route de navigation vers laquelle naviguer lors du clic
  final String route;

  // Constructeur du widget avec paramètres requis
  const ServiceCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Élévation de la carte pour l'effet d'ombre
      elevation: 2,
      
      // Forme de la carte avec bordures arrondies
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      
      child: InkWell(
        // Action au clic : navigation vers la route spécifiée
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        
        // Bordure arrondie pour l'effet de clic
        borderRadius: BorderRadius.circular(8),
        
        child: Container(
          // Padding interne de la carte (réduit)
          padding: EdgeInsets.all(4),
          
          child: Column(
            // Centrage vertical du contenu
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              // Conteneur pour l'icône avec fond coloré
              Container(
                // Dimensions du conteneur d'icône (réduites)
                width: 40,
                height: 40,
                
                // Décoration : fond gris clair avec bordures arrondies
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                
                child: Center(
                  // Icône du service
                  child: Icon(
                    icon,
                    size: 22, // Taille de l'icône réduite
                    color: Color(0xFF2A9D8F), // Couleur vert-bleu
                  ),
                ),
              ),
              
              // Espacement entre l'icône et le texte (réduit)
              SizedBox(height: 4),
              
              // Titre du service
              Text(
                title,
                textAlign: TextAlign.center, // Centrage du texte
                style: TextStyle(
                  fontSize: 10, // Taille de la police réduite
                  fontWeight: FontWeight.w500, // Épaisseur moyenne
                  color: Colors.black87, // Couleur du texte
                ),
                maxLines: 2, // Maximum 2 lignes
                overflow: TextOverflow.ellipsis, // Points de suspension si trop long
              ),
            ],
          ),
        ),
      ),
    );
  }
}

