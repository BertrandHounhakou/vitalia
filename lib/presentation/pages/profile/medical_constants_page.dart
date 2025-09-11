// Import des packages Flutter
import 'package:flutter/material.dart';

// Classe pour la page des constantes médicales avec état
class MedicalConstantsPage extends StatefulWidget {
  const MedicalConstantsPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _MedicalConstantsPageState createState() => _MedicalConstantsPageState();
}

// État de la page des constantes médicales
class _MedicalConstantsPageState extends State<MedicalConstantsPage> {
  // Contrôleurs pour les champs des constantes médicales
  final Map<String, TextEditingController> _controllers = {
    'bloodGroup': TextEditingController(), // Groupe sanguin
    'height': TextEditingController(), // Taille
    'weight': TextEditingController(), // Poids
    'glycemia': TextEditingController(), // Glycémie
    'electrophoresis': TextEditingController(), // Électrophorèse
    'bmi': TextEditingController(), // IMC
  };

  // Liste des allergies/pathologies
  final List<Map<String, dynamic>> _allergies = [];
  
  // Liste des contacts d'urgence
  final List<Map<String, dynamic>> _emergencyContacts = [];

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Permet le défilement
      padding: EdgeInsets.all(16.0), // Padding interne
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré
        children: [
          // Champ pour le groupe sanguin
          _buildConstantField('Groupe sanguin', 'bloodGroup', 'Ex: O+'),
          SizedBox(height: 16), // Espacement
          
          // Champ pour la taille
          _buildConstantField('Taille (cm)', 'height', 'Ex: 175'),
          SizedBox(height: 16), // Espacement
          
          // Champ pour le poids
          _buildConstantField('Poids (kg)', 'weight', 'Ex: 70'),
          SizedBox(height: 16), // Espacement
          
          // Champ pour la glycémie
          _buildConstantField('Glycémie', 'glycemia', 'Ex: 1.0 g/L'),
          SizedBox(height: 16), // Espacement
          
          // Champ pour l'électrophorèse
          _buildConstantField('Electrophorèse', 'electrophoresis', 'Ex: AA'),
          SizedBox(height: 16), // Espacement
          
          // Champ pour l'IMC (calcul automatique)
          _buildConstantField('IMC', 'bmi', 'Calcul automatique'),
          
          Divider(height: 40), // Séparateur
          
          // Section des allergies/pathologies
          Text(
            'Allergies/Pathologies', // Titre de section
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style du titre
          ),
          SizedBox(height: 16), // Espacement
          
          // Message si aucune allergie définie
          if (_allergies.isEmpty)
            Text(
              'Aucune Pathologie définie', // Message d'absence
              style: TextStyle(color: Colors.grey), // Style gris
            ),
          
          SizedBox(height: 16), // Espacement
          
          // Bouton pour ajouter une allergie/pathologie
          ElevatedButton.icon(
            onPressed: _addAllergy, // Ajout d'allergie
            icon: Icon(Icons.add), // Icône d'ajout
            label: Text('Ajouter une allergie/pathologie'), // Texte du bouton
          ),
          
          Divider(height: 40), // Séparateur
          
          // Section des numéros d'urgence
          Text(
            'Numéros d\'urgence', // Titre de section
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style du titre
          ),
          SizedBox(height: 16), // Espacement
          
          // Message si aucun contact d'urgence défini
          if (_emergencyContacts.isEmpty)
            Text(
              'Aucun numéro d\'urgence défini', // Message d'absence
              style: TextStyle(color: Colors.grey), // Style gris
            ),
          
          SizedBox(height: 16), // Espacement
          
          // Bouton pour ajouter un contact d'urgence
          ElevatedButton.icon(
            onPressed: _addEmergencyContact, // Ajout de contact
            icon: Icon(Icons.add), // Icône d'ajout
            label: Text('Ajouter un contact d\'urgence'), // Texte du bouton
          ),
          
          SizedBox(height: 24), // Espacement
          
          // Bouton de sauvegarde
          ElevatedButton(
            onPressed: _saveConstants, // Sauvegarde des constantes
            child: Text('ENREGISTRER'), // Texte du bouton
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16), // Padding vertical
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire un champ de constante
  Widget _buildConstantField(String label, String key, String hint) {
    return TextFormField(
      controller: _controllers[key], // Contrôleur du champ
      decoration: InputDecoration(
        labelText: label, // Label du champ
        hintText: hint, // Texte d'indication
        border: OutlineInputBorder(), // Bordure avec outline
      ),
      keyboardType: key == 'height' || key == 'weight' || key == 'bmi' 
          ? TextInputType.number // Clavier numérique pour les nombres
          : TextInputType.text, // Clavier texte pour les autres
    );
  }

  // Méthode pour ajouter une allergie/pathologie
  void _addAllergy() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController allergyController = TextEditingController();
        return AlertDialog(
          title: Text('Ajouter une allergie/pathologie'), // Titre de la dialog
          content: TextField(
            controller: allergyController,
            decoration: InputDecoration(
              hintText: 'Nom de l\'allergie/pathologie', // Indication
            ),
          ),
          actions: [
            // Bouton d'annulation
            TextButton(
              onPressed: () => Navigator.pop(context), // Fermeture de la dialog
              child: Text('Annuler'), // Texte d'annulation
            ),
            // Bouton d'ajout
            TextButton(
              onPressed: () {
                if (allergyController.text.isNotEmpty) { // Validation
                  setState(() {
                    _allergies.add({'name': allergyController.text}); // Ajout à la liste
                  });
                  Navigator.pop(context); // Fermeture de la dialog
                }
              },
              child: Text('Ajouter'), // Texte d'ajout
            ),
          ],
        );
      },
    );
  }

  // Méthode pour ajouter un contact d'urgence
  void _addEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController phoneController = TextEditingController();
        return AlertDialog(
          title: Text('Ajouter un contact d\'urgence'), // Titre de la dialog
          content: Column(
            mainAxisSize: MainAxisSize.min, // Taille minimale
            children: [
              // Champ pour le nom
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet', // Label du champ
                ),
              ),
              SizedBox(height: 16), // Espacement
              
              // Champ pour le téléphone
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone', // Label du champ
                ),
                keyboardType: TextInputType.phone, // Clavier téléphone
              ),
            ],
          ),
          actions: [
            // Bouton d'annulation
            TextButton(
              onPressed: () => Navigator.pop(context), // Fermeture de la dialog
              child: Text('Annuler'), // Texte d'annulation
            ),
            // Bouton d'ajout
            TextButton(
              onPressed: () {
                // Validation des champs
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  setState(() {
                    _emergencyContacts.add({
                      'name': nameController.text, // Nom du contact
                      'phone': phoneController.text, // Téléphone du contact
                    });
                  });
                  Navigator.pop(context); // Fermeture de la dialog
                }
              },
              child: Text('Ajouter'), // Texte d'ajout
            ),
          ],
        );
      },
    );
  }

  // Méthode pour sauvegarder les constantes médicales
  void _saveConstants() {
    // TODO: Sauvegarder les constantes médicales
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Constantes médicales sauvegardées')), // Message de succès
    );
  }
}