// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

// Classe pour la page de connexion avec état
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _LoginPageState createState() => _LoginPageState();
}

// État de la page de connexion
class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Code pays par défaut
  final String _countryCode = '229';

  // Construction de l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SUPPRESSION DE L'APPBAR POUR LAISSER PLACE AU DÉGRADÉ COMPLET
      body: Container(
        // DÉGRADÉ DE FOND SUR TOUTE LA PAGE
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A7FDE), // Bleu VITALIA en haut
              Color(0xFF4CAF50), // Vert en bas
            ],
            stops: [0.3, 0.7], // Contrôle de la transition des couleurs
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Marge interne
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
              children: [
                // En-tête avec le logo et le titre
                Column(
                  children: [
                    // Logo de l'application VITALIA
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.medical_services,
                        size: 50,
                        color: Color(0xFF2A7FDE),
                      ),
                    ),
                    SizedBox(height: 20), // Espacement vertical de 20 pixels
                    
                    // Titre de l'application
                    Text(
                      'VITALIA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8), // Espacement réduit
                    
                    // Sous-titre
                    Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30), // Espacement avant le formulaire
                  ],
                ),

                // CONTENU PRINCIPAL DU FORMULAIRE TRANSPARENT
                Column(
                  children: [
                    // Champ pour le numéro de téléphone avec sélecteur de pays
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                        borderRadius: BorderRadius.circular(8), // Coins arrondis
                      ),
                      child: Row(
                        children: [
                          // Sélecteur de code pays
                          Container(
                            width: 80,
                            child: DropdownButtonFormField<String>(
                              value: _countryCode,
                              items: ['229', '226', '225', '33', '1'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('+$value', style: TextStyle(color: Colors.white)), // Texte en blanc
                                );
                              }).toList(),
                              onChanged: (value) {}, // TODO: Implémenter le changement de pays
                              dropdownColor: Color(0xFF2A7FDE).withOpacity(0.9), // Fond du dropdown
                              style: TextStyle(color: Colors.white), // Texte en blanc
                              decoration: InputDecoration(
                                border: InputBorder.none, // PAS DE BORDURE INTERNE
                                enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                labelText: 'Code', // Label du sélecteur
                                labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                filled: false, // FOND TRANSPARENT
                              ),
                            ),
                          ),
                          // Ligne séparatrice verticale
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(width: 10), // Espacement
                          
                          // Champ pour le numéro de téléphone
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              style: TextStyle(color: Colors.white), // Texte en blanc
                              keyboardType: TextInputType.phone, // Clavier numérique
                              decoration: InputDecoration(
                                labelText: 'Numéro de téléphone', // Label du champ
                                labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                border: InputBorder.none, // PAS DE BORDURE INTERNE
                                enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                filled: false, // FOND TRANSPARENT
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Espacement
                    
                    // Champ pour le mot de passe
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                        borderRadius: BorderRadius.circular(8), // Coins arrondis
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white), // Texte en blanc
                        obscureText: true, // Masquer le texte
                        decoration: InputDecoration(
                          labelText: 'Mot de passe', // Label du champ
                          labelStyle: TextStyle(color: Colors.white), // Label en blanc
                          border: InputBorder.none, // PAS DE BORDURE INTERNE
                          enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                          focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                          suffixIcon: Icon(Icons.visibility_off, color: Colors.white), // Icône de visibilité en blanc
                          filled: false, // FOND TRANSPARENT
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Espacement
                    
                    // Lien "Mot de passe oublié"
                    Align(
                      alignment: Alignment.centerRight, // Alignement à droite
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implémenter la réinitialisation du mot de passe
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            color: Colors.white, // Texte en blanc
                            decoration: TextDecoration.underline, // Soulignement
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Espacement
                    
                    // Bouton de connexion
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // Coins arrondis
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.9)], // Dégradé blanc
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _login, // Appel de la méthode de connexion
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // BOUTON TRANSPARENT
                          foregroundColor: Color(0xFF2A7FDE), // Texte bleu
                          shadowColor: Colors.transparent, // Pas d'ombre
                          padding: EdgeInsets.symmetric(vertical: 15), // Padding vertical
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Coins arrondis
                          ),
                        ),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Espacement
                    
                    // Lien vers la page d'inscription
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrage horizontal
                      children: [
                        Text(
                          'Pas encore membre ?',
                          style: TextStyle(color: Colors.white), // Texte en blanc
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register'); // Navigation vers l'inscription
                          },
                          child: Text(
                            'Créer un compte',
                            style: TextStyle(
                              color: Colors.white, // Texte en blanc
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline, // Soulignement
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour gérer la connexion
  void _login() {
    // Récupération des valeurs des champs
    final phone = _phoneController.text;
    final password = _passwordController.text;
    
    // Validation basique
    if (phone.isNotEmpty && password.isNotEmpty) {
      // TODO: Implémenter la logique de connexion réelle
      Navigator.pushReplacementNamed(context, '/home'); // Navigation vers l'accueil
    }
  }
}