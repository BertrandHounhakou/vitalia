// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

// Classe pour un écran individuel d'onboarding (sans état)
class OnboardingScreen extends StatelessWidget {
  // Propriétés de l'écran d'onboarding
  final String title; // Titre de l'écran
  final String description; // Description de l'écran
  final String imagePath; // Chemin de l'image

  // Constructeur avec paramètres requis
  const OnboardingScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  // Construction de l'interface de l'écran d'onboarding
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0), // Padding interne
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
        crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
        children: [
          // Image de l'écran d'onboarding
          Image.asset(
            imagePath, // Chemin de l'image
            height: 250, // Hauteur fixe
            width: 250, // Largeur fixe
            fit: BoxFit.contain, // Adaptation de l'image
          ),
          SizedBox(height: 20), // Espacement entre l'image et le titre
          
          // Titre de l'écran d'onboarding
          Text(
            title, // Texte du titre
            style: TextStyle(
              fontSize: 24, // Taille de police
              fontWeight: FontWeight.bold, // Gras
              color: Color(0xFF26A69A), // Couleur du thème
            ),
            textAlign: TextAlign.center, // Centrage du texte
          ),
          SizedBox(height: 20), // Espacement entre le titre et la description
          
          // Description de l'écran d'onboarding
          Text(
            description, // Texte de la description
            style: TextStyle(
              fontSize: 16, // Taille de police
              color: Colors.grey[600], // Couleur grise
              height: 1.5, // Hauteur de ligne
            ),
            textAlign: TextAlign.center, // Centrage du texte
          ),
        ],
      ),
    );
  }
}