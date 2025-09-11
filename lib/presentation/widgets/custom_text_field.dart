// Import du package Flutter
import 'package:flutter/material.dart';

// Widget personnalisé pour les champs de texte
class CustomTextField extends StatelessWidget {
  // Contrôleur pour le champ de texte
  final TextEditingController controller;
  
  // Label du champ
  final String labelText;
  
  // Type de clavier
  final TextInputType? keyboardType;
  
  // Indicateur de texte masqué (pour les mots de passe)
  final bool obscureText;
  
  // Icône de préfixe
  final IconData? prefixIcon;
  
  // Fonction de validation
  final String? Function(String?)? validator;

  // Constructeur du CustomTextField
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
  }) : super(key: key);

  // Construction de l'interface du widget
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Contrôleur pour gérer le texte
      decoration: InputDecoration(
        labelText: labelText, // Texte du label
        border: const OutlineInputBorder(), // Bordure avec outline
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null, // Icône de préfixe si fournie
      ),
      keyboardType: keyboardType, // Type de clavier
      obscureText: obscureText, // Masquage du texte pour les mots de passe
      validator: validator, // Fonction de validation
    );
  }
}