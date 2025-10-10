// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

// Import du widget d'écran d'onboarding
import 'onboarding_screen.dart';
import 'package:vitalia/presentation/widgets/auth_guard.dart';

// Classe pour la page d'onboarding avec état
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

// État de la page d'onboarding
class _OnboardingPageState extends State<OnboardingPage> {
  // Contrôleur pour la PageView
  final PageController _pageController = PageController();
  
  // Index de la page courante
  int _currentPage = 0;

  // Données pour les écrans d'onboarding
  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Bienvenue sur VITALIA',
      'description': 'Votre carnet de santé numérique communautaire',
      'image': 'assets/images/onboarding1.png'
    },
    {
      'title': 'Gestion des Rendez-vous',
      'description': 'Prenez et gérez vos rendez-vous facilement',
      'image': 'assets/images/onboarding2.png'
    },
    {
      'title': 'Carnet de Santé',
      'description': 'Conservez toutes vos informations médicales',
      'image': 'assets/images/onboarding3.png'
    },
    {
      'title': 'Pharmacies & Hôpitaux',
      'description': 'Trouvez les services de santé près de chez vous',
      'image': 'assets/images/onboarding4.png'
    },
  ];

  // Construction de l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView pour le carrousel d'onboarding
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingScreen(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                imagePath: onboardingData[index]['image']!,
              );
            },
          ),
          
          // Bouton "Suivant" positionné en bas à droite
          Positioned(
            bottom: 20,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (_currentPage < onboardingData.length - 1) {
                  // Navigation vers la page suivante
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  // Navigation vers la page d'authentification après le dernier écran
                  Navigator.pushReplacementNamed(context, '/auth');
                }
              },
              child: Text(
                _currentPage < onboardingData.length - 1 ? 'SUIV' : 'COMMENCER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26A69A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}