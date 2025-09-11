// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';

// Classe pour la page d'inscription avec état
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  // Création de l'état de la page d'inscription
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// État de la page d'inscription
class _RegisterPageState extends State<RegisterPage> {
  // Contrôleurs pour les champs de texte du formulaire d'inscription
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  
  // Code pays par défaut (Bénin)
  final String _countryCode = '229';
  
  // Variable pour suivre le type d'utilisateur (patient, centre, admin)
  String _userType = 'patient';

  // Construction de l'interface utilisateur de la page d'inscription
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'), // Titre de la page d'inscription
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Marge interne de 20 pixels
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré horizontalement
          children: [
            // Logo de l'application VITALIA
            Image.asset(
              'assets/images/logo.png',
              height: 100, // Hauteur réduite pour la page d'inscription
            ),
            SizedBox(height: 20), // Espacement vertical de 20 pixels
            
            // Sélecteur du type d'utilisateur (patient, centre de santé, administrateur)
            DropdownButtonFormField<String>(
              value: _userType, // Valeur actuellement sélectionnée
              items: const [ // Options disponibles dans le dropdown
                DropdownMenuItem(value: 'patient', child: Text('Patient')),
                DropdownMenuItem(value: 'center', child: Text('Centre de santé')),
                DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
              ],
              onChanged: (value) { // Callback quand la valeur change
                setState(() {
                  _userType = value!; // Mise à jour du type d'utilisateur
                });
              },
              decoration: InputDecoration(
                labelText: 'Type de compte', // Label du dropdown
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 20), // Espacement vertical de 20 pixels
            
            // Champ pour le prénom (uniquement pour les patients)
            if (_userType == 'patient') ...[
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom', // Label du champ prénom
                  border: OutlineInputBorder(), // Bordure avec outline
                ),
                validator: (value) { // Validation du champ
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom'; // Message d'erreur
                  }
                  return null; // Validation réussie
                },
              ),
              SizedBox(height: 16), // Espacement vertical de 16 pixels
            ],
            
            // Champ pour le nom (uniquement pour les patients)
            if (_userType == 'patient') ...[
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Nom', // Label du champ nom
                  border: OutlineInputBorder(), // Bordure avec outline
                ),
                validator: (value) { // Validation du champ
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom'; // Message d'erreur
                  }
                  return null; // Validation réussie
                },
              ),
              SizedBox(height: 16), // Espacement vertical de 16 pixels
            ],
            
            // Champ pour le nom de l'établissement (uniquement pour les centres)
            if (_userType == 'center') ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom du centre de santé', // Label pour les centres
                  border: OutlineInputBorder(), // Bordure avec outline
                ),
                validator: (value) { // Validation du champ
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du centre'; // Message d'erreur
                  }
                  return null; // Validation réussie
                },
              ),
              SizedBox(height: 16), // Espacement vertical de 16 pixels
            ],
            
            // Champ pour le numéro de téléphone avec sélecteur de pays
            Row(
              children: [
                // Sélecteur de code pays (dropdown)
                Container(
                  width: 80, // Largeur fixe pour le sélecteur de pays
                  child: DropdownButtonFormField<String>(
                    value: _countryCode, // Valeur actuelle (229 pour Bénin)
                    items: ['229', '226', '225'].map((String value) { // Options de codes pays
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('+$value'), // Affichage avec le signe +
                      );
                    }).toList(),
                    onChanged: (value) { // Callback quand le code pays change
                      // TODO: Implémenter le changement de code pays
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Bordure avec outline
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacement horizontal de 10 pixels
                
                // Champ pour le numéro de téléphone
                Expanded( // Prend tout l'espace disponible
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone, // Clavier numérique pour les téléphones
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone', // Label du champ
                      border: OutlineInputBorder(), // Bordure avec outline
                    ),
                    validator: (value) { // Validation du champ
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro'; // Message d'erreur
                      }
                      if (value.length < 8) { // Validation de la longueur
                        return 'Numéro de téléphone invalide'; // Message d'erreur
                      }
                      return null; // Validation réussie
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espacement vertical de 20 pixels
            
            // Champ pour le mot de passe
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Masquer le texte (pour les mots de passe)
              decoration: InputDecoration(
                labelText: 'Mot de passe', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              validator: (value) { // Validation du champ
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe'; // Message d'erreur
                }
                if (value.length < 6) { // Validation de la longueur minimale
                  return 'Le mot de passe doit contenir au moins 6 caractères'; // Message d'erreur
                }
                return null; // Validation réussie
              },
            ),
            SizedBox(height: 20), // Espacement vertical de 20 pixels
            
            // Champ pour la confirmation du mot de passe
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true, // Masquer le texte
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              validator: (value) { // Validation du champ
                if (value == null || value.isEmpty) {
                  return 'Veuillez confirmer votre mot de passe'; // Message d'erreur
                }
                if (value != _passwordController.text) { // Vérification de la correspondance
                  return 'Les mots de passe ne correspondent pas'; // Message d'erreur
                }
                return null; // Validation réussie
              },
            ),
            SizedBox(height: 30), // Espacement vertical de 30 pixels
            
            // Bouton de création de compte
            ElevatedButton(
              onPressed: _register, // Appel de la méthode d'inscription
              child: Text('Créer un compte'), // Texte du bouton
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), // Padding vertical de 15 pixels
              ),
            ),
            SizedBox(height: 20), // Espacement vertical de 20 pixels
            
            // Lien vers la page de connexion pour les utilisateurs déjà inscrits
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrage horizontal
              children: [
                Text('Déjà un compte ?'), // Texte informatif
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Retour à la page précédente (connexion)
                  },
                  child: Text('Se connecter'), // Texte du lien
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour gérer l'inscription d'un nouvel utilisateur
  void _register() {
    // Récupération des valeurs des champs du formulaire
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    
    // Validation de base des champs obligatoires
    if (phone.isNotEmpty && 
        password.isNotEmpty && 
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      
      // Validation spécifique pour les patients (prénom et nom requis)
      if (_userType == 'patient' && (firstName.isEmpty || lastName.isEmpty)) {
        // Affichage d'un message d'erreur pour les champs manquants
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez remplir tous les champs requis')),
        );
        return; // Arrêt de l'exécution
      }
      
      // TODO: Implémenter la logique d'inscription réelle
      // avec appel API et sauvegarde dans la base de données
      
      // Simulation réussie d'inscription
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compte créé avec succès')), // Message de succès
      );
      
      // Navigation vers la page de connexion après inscription réussie
      Navigator.pop(context); // Retour à la page de connexion
      
    } else {
      // Affichage d'un message d'erreur en cas de problème de validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs correctement')), // Message d'erreur
      );
    }
  }
}