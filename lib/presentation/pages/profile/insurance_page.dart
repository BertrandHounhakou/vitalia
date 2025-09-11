// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:vitalia/presentation/widgets/insurance_card.dart';

// Classe pour la page des assurances avec état
class InsurancePage extends StatefulWidget {
  const InsurancePage({Key? key}) : super(key: key);

  // Création de l'état de la page des assurances
  @override
  _InsurancePageState createState() => _InsurancePageState();
}

// État de la page des assurances
class _InsurancePageState extends State<InsurancePage> {
  // Liste des assurances de l'utilisateur
  final List<Map<String, dynamic>> _insurances = [];
  
  // Liste des assurances disponibles (simulation)
  final List<Map<String, dynamic>> _availableInsurances = [
    {'id': '1', 'name': 'AFRICAINE DES ASSURANCES'},
    {'id': '2', 'name': 'ALLIANZ ASSURANCES'},
    {'id': '3', 'name': 'ARGG'},
    {'id': '4', 'name': 'SCOMA SANTE BENIN'},
    {'id': '5', 'name': 'ATLANTIQUE ASSURANCES'},
    {'id': '6', 'name': 'BECOTRAC'},
    {'id': '7', 'name': 'CIF et VIE'},
  ];

  // Indicateur de chargement
  bool _isLoading = true;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadInsurances(); // Chargement des assurances
  }

  // Méthode pour charger les assurances (simulation)
  Future<void> _loadInsurances() async {
    // Simulation de délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false; // Fin du chargement
    });
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading // Affichage conditionnel pendant le chargement
          ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : _insurances.isEmpty // Si aucune assurance
              ? Center( // Affichage centré pour état vide
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
                    children: [
                      Icon( // Icône d'assurance
                        Icons.verified_user, // Icône de vérification/utilisateur
                        size: 64, // Taille de l'icône
                        color: Colors.grey, // Couleur grise
                      ),
                      SizedBox(height: 16), // Espacement
                      Text(
                        'Aucune donnée disponible.', // Message d'absence d'assurance
                        style: TextStyle(color: Colors.grey), // Style gris
                      ),
                    ],
                  ),
                )
              : ListView.builder( // Liste des assurances si existantes
                  itemCount: _insurances.length, // Nombre d'assurances
                  itemBuilder: (context, index) {
                    final insurance = _insurances[index]; // Assurance courante
                    return InsuranceCard(insurance: insurance); // Carte d'assurance
                  },
                ),
      floatingActionButton: FloatingActionButton( // Bouton flottant d'ajout
        onPressed: _showAddInsuranceDialog, // Ouverture de la dialog d'ajout
        child: Icon(Icons.add), // Icône d'ajout
        tooltip: 'Ajouter une assurance', // Info-bulle
      ),
    );
  }

  // Méthode pour afficher la dialog d'ajout d'assurance
  void _showAddInsuranceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter assurance'), // Titre de la dialog
          content: Text('Veuillez sélectionner votre assurance dans la liste ci-dessous'), // Instructions
          actions: [
            // Liste déroulante des assurances disponibles
            SizedBox(
              height: 300, // Hauteur fixe pour la liste
              width: double.maxFinite, // Largeur maximale
              child: ListView.builder(
                itemCount: _availableInsurances.length, // Nombre d'assurances disponibles
                itemBuilder: (context, index) {
                  final insurance = _availableInsurances[index]; // Assurance courante
                  return ListTile(
                    title: Text(insurance['name']), // Nom de l'assurance
                    onTap: () {
                      Navigator.pop(context); // Fermeture de la dialog actuelle
                      _showInsuranceDetailsDialog(insurance); // Ouverture de la dialog de détails
                    },
                  );
                },
              ),
            ),
            // Bouton d'annulation
            TextButton(
              onPressed: () => Navigator.pop(context), // Fermeture de la dialog
              child: Text('ANNULER'), // Texte d'annulation
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher la dialog des détails de l'assurance
  void _showInsuranceDetailsDialog(Map<String, dynamic> insurance) {
    // Contrôleurs pour les champs de date
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(insurance['name']), // Titre avec le nom de l'assurance
          content: Column(
            mainAxisSize: MainAxisSize.min, // Taille minimale
            children: [
              Text('Validité de l\'assurance'), // Sous-titre
              SizedBox(height: 16), // Espacement
              
              // Champ pour la date de début
              TextFormField(
                controller: startDateController, // Contrôleur de la date de début
                decoration: InputDecoration(
                  labelText: 'Date de début', // Label du champ
                  suffixIcon: IconButton( // Icône de calendrier
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(startDateController), // Sélection de date
                  ),
                ),
                readOnly: true, // Lecture seule pour ouvrir le sélecteur
              ),
              SizedBox(height: 16), // Espacement
              
              // Champ pour la date de fin
              TextFormField(
                controller: endDateController, // Contrôleur de la date de fin
                decoration: InputDecoration(
                  labelText: 'Date de fin', // Label du champ
                  suffixIcon: IconButton( // Icône de calendrier
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(endDateController), // Sélection de date
                  ),
                ),
                readOnly: true, // Lecture seule pour ouvrir le sélecteur
              ),
            ],
          ),
          actions: [
            // Bouton d'annulation
            TextButton(
              onPressed: () => Navigator.pop(context), // Fermeture de la dialog
              child: Text('ANNULER'), // Texte d'annulation
            ),
            // Bouton de validation
            TextButton(
              onPressed: () {
                // Validation des champs de date
                if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
                  setState(() {
                    // Ajout de l'assurance à la liste
                    _insurances.add({
                      ...insurance, // Données de l'assurance
                      'startDate': startDateController.text, // Date de début
                      'endDate': endDateController.text, // Date de fin
                    });
                  });
                  Navigator.pop(context); // Fermeture de la dialog
                }
              },
              child: Text('VALIDER'), // Texte de validation
            ),
          ],
        );
      },
    );
  }

  // Méthode pour sélectionner une date
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Date initiale (aujourd'hui)
      firstDate: DateTime(2000), // Date minimale (année 2000)
      lastDate: DateTime(2100), // Date maximale (année 2100)
    );
    
    if (picked != null) { // Si une date a été sélectionnée
      // Formatage de la date en JJ/MM/AAAA
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }
}