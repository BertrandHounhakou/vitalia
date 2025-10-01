// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/appointment_provider.dart';
import 'package:vitalia/data/models/appointment_model.dart';

// Classe pour la page du carnet de santé avec état
class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _HealthRecordPageState createState() => _HealthRecordPageState();
}

// État de la page du carnet de santé
class _HealthRecordPageState extends State<HealthRecordPage> {
  // Données des constantes médicales (simulées)
  final Map<String, String> _medicalConstants = {
    'Groupe sanguin': 'O+',
    'Taille': '175 cm',
    'Poids': '70 kg',
    'Glycémie': '1.0 g/L',
    'Electrophorèse': 'AA',
    'IMC': '22.9',
  };

  // Indicateur de chargement
  bool _isLoading = true;

  // Liste des consultations à venir
  List<AppointmentModel> _upcomingAppointments = [];

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadUpcomingAppointments(); // Chargement des consultations
  }

  // Méthode pour charger les consultations à venir
  Future<void> _loadUpcomingAppointments() async {
    // Simulation de délai de chargement
    await Future.delayed(const Duration(seconds: 1));
    
    // Données simulées - À remplacer par des données réelles
    final appointments = [
      AppointmentModel(
        id: '1',
        patientId: 'patient_1',
        centerId: 'center_1',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        status: 'scheduled',
        notes: 'Consultation de routine avec le cardiologue',
      ),
      AppointmentModel(
        id: '2',
        patientId: 'patient_1',
        centerId: 'center_2',
        dateTime: DateTime.now().add(const Duration(days: 7)),
        status: 'scheduled',
        notes: 'Suivi traitement médicamenteux',
      ),
      AppointmentModel(
        id: '3',
        patientId: 'patient_1',
        centerId: 'center_3',
        dateTime: DateTime.now().add(const Duration(days: 14)),
        status: 'scheduled',
        notes: 'Examen sanguin annuel',
      ),
    ];

    setState(() {
      _upcomingAppointments = appointments;
      _isLoading = false;
    });
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Carnet de Santé'), // Titre de la page
        leading: IconButton(
          icon: Icon(Icons.menu), // Icône du menu
          onPressed: () {
            Navigator.pushNamed(context, '/menu'); // Navigation vers le menu
          },
        ),
      ),
      body: Column(
        children: [
          // Section des constantes médicales
          Expanded(
            flex: 2, // 2 parts pour les constantes
            child: _buildMedicalConstantsSection(),
          ),
          
          // Barre de séparation horizontale
          Container(
            height: 1, // Épaisseur de la barre
            color: Colors.grey[300], // Couleur de la barre
            margin: EdgeInsets.symmetric(vertical: 16), // Marge verticale
          ),
          
          // Titre des consultations à venir
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Consultations à venir', // Titre de section
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 20, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
          SizedBox(height: 8),
          
          // Section des consultations à venir
          Expanded(
            flex: 3, // 3 parts pour les consultations
            child: _buildUpcomingAppointmentsSection(),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire la section des constantes médicales
  Widget _buildMedicalConstantsSection() {
    return SingleChildScrollView( // Permet le défilement si nécessaire
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          Text(
            'Mes Constantes Médicales', // Titre de section
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          
          // Grille des constantes médicales (2 colonnes)
          GridView.builder(
            shrinkWrap: true, // Rétrécissement pour s'adapter
            physics: NeverScrollableScrollPhysics(), // Désactive le défilement propre
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 colonnes
              crossAxisSpacing: 12, // Espacement horizontal
              mainAxisSpacing: 12, // Espacement vertical
              childAspectRatio: 1.5, // Ratio largeur/hauteur
            ),
            itemCount: _medicalConstants.length,
            itemBuilder: (context, index) {
              final key = _medicalConstants.keys.elementAt(index);
              final value = _medicalConstants.values.elementAt(index);
              
              return _buildConstantCard(key, value); // Carte de constante
            },
          ),
          
          // Bouton pour modifier les constantes
          SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _showEditConstantsDialog(); // Dialog de modification
              },
              icon: Icon(Icons.edit, size: 18),
              label: Text('Modifier mes constantes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire une carte de constante
  Widget _buildConstantCard(String title, String value) {
    return Card(
      elevation: 2, // Élévation de la carte
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title, // Titre de la constante
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value, // Valeur de la constante
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire la section des consultations à venir
  Widget _buildUpcomingAppointmentsSection() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator()); // Indicateur de chargement
    }

    if (_upcomingAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Aucune consultation à venir',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Prenez un rendez-vous pour commencer',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: _upcomingAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _upcomingAppointments[index];
        return _buildAppointmentItem(appointment); // Utiliser la nouvelle méthode
      },
    );
  }

  // Méthode pour construire un élément de consultation
  Widget _buildAppointmentItem(AppointmentModel appointment) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(Icons.calendar_today, color: Colors.blue, size: 32),
        title: Text(
          'Consultation #${appointment.id}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(appointment.dateTime)}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Heure: ${DateFormat('HH:mm').format(appointment.dateTime)}',
              style: TextStyle(fontSize: 14),
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 6),
              Text(
                'Notes: ${appointment.notes}',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        trailing: Chip(
          label: Text(
            _getStatusText(appointment.status),
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getStatusColor(appointment.status),
        ),
      ),
    );
  }

  // Méthode pour obtenir le texte du statut
  String _getStatusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'PROGRAMMÉ';
      case 'confirmed':
        return 'CONFIRMÉ';
      case 'cancelled':
        return 'ANNULÉ';
      case 'completed':
        return 'TERMINÉ';
      default:
        return status.toUpperCase();
    }
  }

  // Méthode pour obtenir la couleur selon le statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue; // Bleu pour programmé
      case 'confirmed':
        return Colors.green; // Vert pour confirmé
      case 'cancelled':
        return Colors.red; // Rouge pour annulé
      case 'completed':
        return Colors.grey; // Gris pour terminé
      default:
        return Colors.grey; // Gris par défaut
    }
  }

  // Méthode pour afficher la dialog de modification des constantes
  void _showEditConstantsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier mes constantes'), // Titre de la dialog
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditConstantField('Groupe sanguin', _medicalConstants['Groupe sanguin']!),
                SizedBox(height: 12),
                _buildEditConstantField('Taille (cm)', _medicalConstants['Taille']!),
                SizedBox(height: 12),
                _buildEditConstantField('Poids (kg)', _medicalConstants['Poids']!),
                SizedBox(height: 12),
                _buildEditConstantField('Glycémie (g/L)', _medicalConstants['Glycémie']!),
                SizedBox(height: 12),
                _buildEditConstantField('Electrophorèse', _medicalConstants['Electrophorèse']!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Annulation
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Sauvegarder les modifications
                Navigator.pop(context); // Fermeture de la dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Constantes mises à jour avec succès')),
                );
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour construire un champ d'édition de constante
  Widget _buildEditConstantField(String label, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Mise à jour temporaire de la valeur
        setState(() {
          _medicalConstants[label] = value;
        });
      },
    );
  }
}