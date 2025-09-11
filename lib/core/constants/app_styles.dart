// Import du package Flutter
import 'package:flutter/material.dart';

// Fichier de styles globaux de l'application
class AppStyles {
  // Style pour les titres de page
  static TextStyle pageTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ) ?? TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }
  
  // Style pour les sous-titres
  static TextStyle sectionTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ) ?? TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  }
  
  // Style pour le texte corporel
  static TextStyle bodyText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
        ) ?? TextStyle(fontSize: 16);
  }
  
  // Style pour les textes secondaires
  static TextStyle secondaryText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ) ?? TextStyle(fontSize: 16, color: Colors.grey[600]);
  }
  
  // Style pour les erreurs
  static TextStyle errorText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.red,
        ) ?? TextStyle(fontSize: 16, color: Colors.red);
  }
  
  // Style pour les succès
  static TextStyle successText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.green,
        ) ?? TextStyle(fontSize: 16, color: Colors.green);
  }
  
  // Padding standard
  static EdgeInsets standardPadding = EdgeInsets.all(16);
  
  // Padding pour les cartes
  static EdgeInsets cardPadding = EdgeInsets.all(12);
  
  // Border radius standard
  static BorderRadius standardBorderRadius = BorderRadius.circular(8);
  
  // Border radius pour les cartes
  static BorderRadius cardBorderRadius = BorderRadius.circular(12);
}