// Fichier de constantes globales de l'application
class AppConstants {
  // Nom de l'application
  static const String appName = 'VITALIA';
  
  // Version de l'application
  static const String appVersion = '1.0.0';
  
  // Couleurs principales de l'application
  static const int primaryColorValue = 0xFF2A7FDE; // Bleu primaire
  static const int secondaryColorValue = 0xFF4CAF50; // Vert secondaire
  static const int accentColorValue = 0xFFFF9800;   // Orange accent
  
  // Textes constants
  static const String welcomeMessage = 'Bienvenue sur VITALIA';
  static const String loginTitle = 'Connexion';
  static const String registerTitle = 'Créer un compte';
  
  // URLs API (à remplacer par les vraies URLs)
  static const String apiBaseUrl = 'https://api.vitalia.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String hospitalsEndpoint = '/hospitals';
  static const String pharmaciesEndpoint = '/pharmacies';
  static const String appointmentsEndpoint = '/appointments';
  
  // Messages d'erreur
  static const String networkError = 'Erreur de connexion réseau';
  static const String serverError = 'Erreur du serveur';
  static const String unknownError = 'Erreur inconnue';
  
  // Textes de validation
  static const String requiredField = 'Ce champ est requis';
  static const String invalidEmail = 'Email invalide';
  static const String invalidPhone = 'Numéro de téléphone invalide';
  static const String passwordTooShort = 'Le mot de passe doit contenir au moins 6 caractères';
  
  // Durées d'animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
}