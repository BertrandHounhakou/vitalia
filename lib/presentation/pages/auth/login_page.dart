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
      appBar: AppBar(
        title: Text('Se connecter'), // Titre de la page
        automaticallyImplyLeading: false, // Masquer la flèche de retour
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Marge interne
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
          children: [
            // Logo de l'application
            Image.asset(
              'assets/images/logo.png',
              height: 120,
            ),
            SizedBox(height: 30), // Espacement
            
            // Champ pour le numéro de téléphone avec sélecteur de pays
            Row(
              children: [
                // Sélecteur de code pays
                Container(
                  width: 80,
                  child: DropdownButtonFormField<String>(
                    value: _countryCode,
                    items: ['229', '226', '225'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('+$value'),
                      );
                    }).toList(),
                    onChanged: (value) {}, // TODO: Implémenter le changement de pays
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacement
                
                // Champ pour le numéro de téléphone
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone, // Clavier numérique
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espacement
            
            // Champ pour le mot de passe
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Masquer le texte
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off), // Icône de visibilité
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
                child: Text('Mot de passe oublié ?'),
              ),
            ),
            SizedBox(height: 20), // Espacement
            
            // Bouton de connexion
            ElevatedButton(
              onPressed: _login, // Appel de la méthode de connexion
              child: Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), // Padding vertical
              ),
            ),
            SizedBox(height: 20), // Espacement
            
            // Lien vers la page d'inscription
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrage horizontal
              children: [
                Text('Pas encore membre ?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigation vers l'inscription
                  },
                  child: Text('Créer un compte'),
                ),
              ],
            ),
          ],
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