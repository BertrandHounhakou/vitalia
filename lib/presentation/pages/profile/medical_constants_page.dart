// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
//import 'package:vitalia/data/models/user_model.dart';

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
    'allergies': TextEditingController(), // Allergies/Pathologies
    'emergencyContact': TextEditingController(), // Contact d'urgence
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMedicalData();
  }

  // Charger les données médicales de l'utilisateur
  void _loadMedicalData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      setState(() {
        _controllers['bloodGroup']!.text = user.bloodType ?? '';
        _controllers['allergies']!.text = user.allergies ?? '';
        _controllers['emergencyContact']!.text = user.emergencyContact ?? '';
        
        // Parser les constantes médicales depuis medicalHistory
        if (user.medicalHistory != null && user.medicalHistory!.isNotEmpty) {
          _parseMedicalHistory(user.medicalHistory!);
        } else {
          // Réinitialiser les champs si pas de données
          _controllers['height']!.text = '';
          _controllers['weight']!.text = '';
          _controllers['glycemia']!.text = '';
          _controllers['electrophoresis']!.text = '';
          _controllers['bmi']!.text = '';
        }
      });
    }
  }
  
  // Parser la chaîne medicalHistory pour extraire les valeurs
  void _parseMedicalHistory(String medicalHistory) {
    // Format: "Taille: 175 cm | Poids: 70 kg | IMC: 22.9 | Glycémie: 1.0 g/L | Électrophorèse: AA"
    final parts = medicalHistory.split(' | ');
    
    for (var part in parts) {
      if (part.contains('Taille:')) {
        final value = part.replaceAll('Taille:', '').replaceAll('cm', '').trim();
        _controllers['height']!.text = value;
      } else if (part.contains('Poids:')) {
        final value = part.replaceAll('Poids:', '').replaceAll('kg', '').trim();
        _controllers['weight']!.text = value;
      } else if (part.contains('IMC:')) {
        final value = part.replaceAll('IMC:', '').trim();
        _controllers['bmi']!.text = value;
      } else if (part.contains('Glycémie:')) {
        final value = part.replaceAll('Glycémie:', '').replaceAll('g/L', '').trim();
        _controllers['glycemia']!.text = value;
      } else if (part.contains('Électrophorèse:')) {
        final value = part.replaceAll('Électrophorèse:', '').trim();
        _controllers['electrophoresis']!.text = value;
      }
    }
  }

  // Calcul automatique de l'IMC
  void _calculateBMI() {
    final heightText = _controllers['height']!.text;
    final weightText = _controllers['weight']!.text;
    
    if (heightText.isNotEmpty && weightText.isNotEmpty) {
      try {
        final height = double.parse(heightText) / 100; // Conversion en mètres
        final weight = double.parse(weightText);
        
        if (height > 0 && weight > 0) {
          final bmi = weight / (height * height);
          _controllers['bmi']!.text = bmi.toStringAsFixed(1);
        }
      } catch (e) {
        // Gestion d'erreur silencieuse
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Constantes Médicales'),
        backgroundColor: Color(0xFF2A7FDE),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Carte d'information utilisateur
                  if (user != null) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF2A7FDE),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            if (user.bloodType != null && user.bloodType!.isNotEmpty)
                              Chip(
                                label: Text(
                                  'Groupe sanguin: ${user.bloodType}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Section des constantes médicales
                  Text(
                    'Constantes Médicales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Champ pour le groupe sanguin
                  _buildConstantField('Groupe sanguin', 'bloodGroup', 'Ex: O+, A-, B+', Icons.bloodtype),
                  SizedBox(height: 16),
                  
                  // Ligne pour taille et poids
                  Row(
                    children: [
                      Expanded(
                        child: _buildConstantField('Taille (cm)', 'height', 'Ex: 175', Icons.height),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildConstantField('Poids (kg)', 'weight', 'Ex: 70', Icons.monitor_weight),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  
                  // Bouton pour calculer l'IMC
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: _calculateBMI,
                      icon: Icon(Icons.calculate, size: 16),
                      label: Text('Calculer IMC'),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Champ pour l'IMC (calcul automatique)
                  _buildConstantField('IMC (Indice de Masse Corporelle)', 'bmi', 'Calcul automatique', Icons.calculate, readOnly: true),
                  SizedBox(height: 16),
                  
                  // Champ pour la glycémie
                  _buildConstantField('Glycémie (g/L)', 'glycemia', 'Ex: 1.0', Icons.monitor_heart),
                  SizedBox(height: 16),
                  
                  // Champ pour l'électrophorèse
                  _buildConstantField('Électrophorèse de l\'hémoglobine', 'electrophoresis', 'Ex: AA, AS, SC', Icons.science),
                  SizedBox(height: 16),
                  
                  Divider(height: 40),
                  
                  // Section des allergies/pathologies
                  Text(
                    'Allergies & Pathologies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Listez vos allergies, maladies chroniques ou conditions médicales',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _controllers['allergies'],
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Allergies et Pathologies',
                      hintText: 'Ex: Allergie aux pénicillines, Asthme, Diabète type 2, Hypertension...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.health_and_safety),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Divider(height: 40),
                  
                  // Section des contacts d'urgence
                  Text(
                    'Contact d\'Urgence',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Personne à contacter en cas d\'urgence médicale',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  
                  // Affichage du contact d'urgence existant
                  if (user?.emergencyContact != null && user!.emergencyContact!.isNotEmpty) ...[
                    Card(
                      color: Colors.orange[50],
                      child: ListTile(
                        leading: Icon(Icons.emergency, color: Colors.orange),
                        title: Text('Contact actuel'),
                        subtitle: Text(user.emergencyContact!),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _controllers['emergencyContact']!.text = user.emergencyContact!;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  
                  TextFormField(
                    controller: _controllers['emergencyContact'],
                    decoration: InputDecoration(
                      labelText: 'Nouveau contact d\'urgence',
                      hintText: 'Numéro de téléphone avec indicatif pays',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.contact_emergency),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Format: +229 XX XX XX XX',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Bouton de sauvegarde
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveMedicalConstants,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('ENREGISTRER LES CONSTANTES MÉDICALES'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A7FDE),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  // Méthode pour construire un champ de constante
  Widget _buildConstantField(String label, String key, String hint, IconData icon, {bool readOnly = false}) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: key == 'height' || key == 'weight' || key == 'bmi' || key == 'glycemia'
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      readOnly: readOnly,
      onChanged: (value) {
        if (key == 'height' || key == 'weight') {
          _calculateBMI();
        }
      },
    );
  }

  // Méthode pour sauvegarder les constantes médicales DANS FIRESTORE
  Future<void> _saveMedicalConstants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;

      if (currentUser != null) {
        // Créer l'utilisateur mis à jour avec les constantes médicales
        final updatedUser = currentUser.copyWith(
          bloodType: _controllers['bloodGroup']!.text.isNotEmpty ? _controllers['bloodGroup']!.text : null,
          allergies: _controllers['allergies']!.text.isNotEmpty ? _controllers['allergies']!.text : null,
          emergencyContact: _controllers['emergencyContact']!.text.isNotEmpty ? _controllers['emergencyContact']!.text : null,
          updatedAt: DateTime.now(),
          // Stocker les autres constantes dans medicalHistory
          medicalHistory: _buildMedicalHistoryString(),
        );

        // SAUVEGARDE RÉELLE DANS FIRESTORE
        await authProvider.updateUserProfile(updatedUser);

        // Recharger les données depuis Firestore pour confirmer la sauvegarde
        await authProvider.reloadUser();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Constantes médicales sauvegardées avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Recharger les données dans les contrôleurs
        _loadMedicalData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Construire une chaîne avec toutes les constantes médicales
  String _buildMedicalHistoryString() {
    final constants = <String>[];
    
    if (_controllers['height']!.text.isNotEmpty) {
      constants.add('Taille: ${_controllers['height']!.text} cm');
    }
    if (_controllers['weight']!.text.isNotEmpty) {
      constants.add('Poids: ${_controllers['weight']!.text} kg');
    }
    if (_controllers['bmi']!.text.isNotEmpty) {
      constants.add('IMC: ${_controllers['bmi']!.text}');
    }
    if (_controllers['glycemia']!.text.isNotEmpty) {
      constants.add('Glycémie: ${_controllers['glycemia']!.text} g/L');
    }
    if (_controllers['electrophoresis']!.text.isNotEmpty) {
      constants.add('Électrophorèse: ${_controllers['electrophoresis']!.text}');
    }
    
    return constants.join(' | ');
  }

  @override
  void dispose() {
    // Nettoyage de tous les contrôleurs
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}