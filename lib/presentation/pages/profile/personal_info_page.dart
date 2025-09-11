// Import des packages Flutter
import 'package:flutter/material.dart';

// Classe pour la page des informations personnelles avec état
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

// État de la page des informations personnelles
class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Clé pour le formulaire
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs du formulaire
  final TextEditingController _lastNameController = TextEditingController(text: 'Hounhakou');
  final TextEditingController _firstNameController = TextEditingController(text: 'Bertrand');
  final TextEditingController _emailController = TextEditingController(text: 'bertrandhounhakou@email.com');
  final TextEditingController _addressController = TextEditingController(text: '');
  final TextEditingController _professionController = TextEditingController(text: '');
  final TextEditingController _birthDateController = TextEditingController(text: '1995-12-13');
  
  // Genre sélectionné
  String _gender = 'Masculin';

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Permet le défilement
      padding: EdgeInsets.all(16.0), // Padding interne
      child: Form(
        key: _formKey, // Clé du formulaire
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
          children: [
            // Champ pour le nom
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Nom', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              validator: (value) { // Validation du champ
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom'; // Message d'erreur
                }
                return null; // Validation réussie
              },
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour le prénom
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Prénom(s)', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              validator: (value) { // Validation du champ
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre prénom'; // Message d'erreur
                }
                return null; // Validation réussie
              },
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour l'email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress, // Clavier email
              decoration: InputDecoration(
                labelText: 'Email', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
              ),
              validator: (value) { // Validation du champ
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email'; // Message d'erreur
                }
                if (!value.contains('@')) { // Vérification de la présence de @
                  return 'Veuillez entrer un email valide'; // Message d'erreur
                }
                return null; // Validation réussie
              },
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour l'adresse
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Adresse', // Label du champ
                hintText: 'Entrez votre adresse', // Texte d'indication
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la profession
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(
                labelText: 'Profession', // Label du champ
                hintText: 'Votre Profession', // Texte d'indication
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 16), // Espacement
            
            // Champ pour la date de naissance
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Date de naissance', // Label du champ
                border: OutlineInputBorder(), // Bordure avec outline
                suffixIcon: IconButton( // Icône de calendrier
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectBirthDate, // Sélection de la date
                ),
              ),
              readOnly: true, // Lecture seule pour ouvrir le sélecteur
            ),
            SizedBox(height: 16), // Espacement
            
            // Sélecteur de genre
            DropdownButtonFormField<String>(
              value: _gender, // Valeur actuelle
              items: ['Masculin', 'Féminin'].map((String value) { // Options
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Affichage de la valeur
                );
              }).toList(),
              onChanged: (value) { // Callback du changement
                setState(() {
                  _gender = value!; // Mise à jour du genre
                });
              },
              decoration: InputDecoration(
                labelText: 'Sexe', // Label du dropdown
                border: OutlineInputBorder(), // Bordure avec outline
              ),
            ),
            SizedBox(height: 24), // Espacement
            
            // Lien pour réinitialiser le mot de passe
            TextButton(
              onPressed: () {
                // TODO: Implémenter la réinitialisation du mot de passe
              },
              child: Text('Réinitialiser votre mot de passe'), // Texte du lien
            ),
            SizedBox(height: 24), // Espacement
            
            // Bouton de sauvegarde
            ElevatedButton(
              onPressed: _saveProfile, // Sauvegarde du profil
              child: Text('ENREGISTRER'), // Texte du bouton
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16), // Padding vertical
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour sélectionner la date de naissance
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 12, 13), // Date initiale
      firstDate: DateTime(1900), // Date minimale
      lastDate: DateTime.now(), // Date maximale (aujourd'hui)
    );
    
    if (picked != null) { // Si une date a été sélectionnée
      setState(() {
        // Formatage de la date en string
        _birthDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Méthode pour sauvegarder le profil
  void _saveProfile() {
    if (_formKey.currentState!.validate()) { // Validation du formulaire
      // TODO: Sauvegarder les informations du profil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès')), // Message de succès
      );
    }
  }
}