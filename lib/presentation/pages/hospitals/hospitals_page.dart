// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/location_provider.dart';
import 'package:vitalia/presentation/widgets/hospital_card.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

// Classe pour la page des hôpitaux avec état
class HospitalsPage extends StatefulWidget {
  const HospitalsPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _HospitalsPageState createState() => _HospitalsPageState();
}

// État de la page des hôpitaux
class _HospitalsPageState extends State<HospitalsPage> {
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Liste complète des hôpitaux
  List<Map<String, dynamic>> _hospitals = [];
  
  // Liste filtrée des hôpitaux
  List<Map<String, dynamic>> _filteredHospitals = [];
  
  // Indicateur de chargement
  bool _isLoading = true;
  
  // Filtre "Autour de moi" activé
  bool _showNearbyOnly = false;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadHospitals(); // Chargement des hôpitaux
  }

  // Méthode pour charger les hôpitaux (simulation)
  Future<void> _loadHospitals() async {
    // Données simulées - À remplacer par un appel API réel
    final hospitals = [
      {
        'id': '1',
        'name': 'Cabinet medical saint antoine de padoue nasaiara',
        'address': 'Cocotomey, Situé À 200m De La Pharmacie Concorde Pour Womey',
        'distance': 2.5,
        'latitude': 6.4545,
        'longitude': 2.3567,
        'type': 'Cabinet médical',
      },
      {
        'id': '2',
        'name': 'Clinique Pôle Santé',
        'address': 'Cotonou, Agla Les Pylones',
        'distance': 5.2,
        'latitude': 6.3679,
        'longitude': 2.4281,
        'type': 'Clinique',
      },
      {
        'id': '3',
        'name': 'Clinique Sevi',
        'address': 'Gbèdjromédé, Cotonou, Ilôt 1112',
        'distance': 3.8,
        'latitude': 6.3784,
        'longitude': 2.4392,
        'type': 'Clinique',
      },
      {
        'id': '4',
        'name': 'Clinique aye de tori',
        'address': 'Tori-bossito, Située Dans La Von Face Au Bar Restaurant Chez Patou De To...',
        'distance': 15.7,
        'latitude': 6.5123,
        'longitude': 2.1456,
        'type': 'Clinique',
      },
      {
        'id': '5',
        'name': 'Cabinet De Cardiologie Gml',
        'address': 'Abomey-calavi, Akassato Centre',
        'distance': 1.2,
        'latitude': 6.4456,
        'longitude': 2.3567,
        'type': 'Cabinet spécialisé',
      },
    ];

    setState(() {
      _hospitals = hospitals; // Liste complète
      _filteredHospitals = hospitals; // Liste filtrée (initialement complète)
      _isLoading = false; // Fin du chargement
    });
  }

  // Méthode pour filtrer les hôpitaux selon la recherche
  void _filterHospitals(String query) {
    setState(() {
      _filteredHospitals = _hospitals.where((hospital) {
        final nameMatch = hospital['name'].toLowerCase().contains(query.toLowerCase()); // Recherche dans le nom
        final addressMatch = hospital['address'].toLowerCase().contains(query.toLowerCase()); // Recherche dans l'adresse
        return nameMatch || addressMatch; // Retourne true si correspondance
      }).toList();
    });
  }

  // Méthode pour obtenir les hôpitaux à proximité
  Future<void> _getNearbyHospitals() async {
    setState(() {
      _isLoading = true; // Début du chargement
    });

    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.getCurrentLocation(); // Obtention de la position

      // Filtrage des hôpitaux à proximité (simulation)
      setState(() {
        _filteredHospitals = _hospitals.where((hospital) => hospital['distance'] <= 10).toList(); // 10km max
        _showNearbyOnly = true; // Activation du filtre
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de localisation: $e')), // Message d'erreur
      );
      setState(() {
        _isLoading = false; // Fin du chargement (avec erreur)
      });
    }
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Unités sanitaires',
        showMenuButton: true,
      ),
      
      // Menu latéral
      drawer: MenuPage(),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0), // Padding interne
            child: TextField(
              controller: _searchController, // Contrôleur de la recherche
              decoration: InputDecoration(
                labelText: 'Rechercher un hôpital', // Label du champ
                prefixIcon: Icon(Icons.search), // Icône de recherche
                border: OutlineInputBorder(), // Bordure avec outline
                suffixIcon: _searchController.text.isNotEmpty // Icône de suppression conditionnelle
                    ? IconButton(
                        icon: Icon(Icons.clear), // Icône de suppression
                        onPressed: () {
                          _searchController.clear(); // Effacement du texte
                          _filterHospitals(''); // Réinitialisation du filtre
                        },
                      )
                    : null,
              ),
              onChanged: _filterHospitals, // Filtrage à chaque changement
            ),
          ),
          
          // Bouton "Autour de moi"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
            child: Row(
              children: [
                Expanded( // Prend tout l'espace disponible
                  child: ElevatedButton.icon(
                    onPressed: _getNearbyHospitals, // Obtention des hôpitaux proximité
                    icon: Icon(Icons.location_on), // Icône de localisation
                    label: Text('Autour de moi 🍟️'), // Texte du bouton
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showNearbyOnly // Couleur conditionnelle
                          ? Theme.of(context).primaryColor // Couleur primaire si actif
                          : Colors.grey[300], // Gris si inactif
                      foregroundColor: _showNearbyOnly // Couleur du texte conditionnelle
                          ? Colors.white // Blanc si actif
                          : Colors.black, // Noir si inactif
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Espacement
          
          // Liste des hôpitaux
          Expanded(
            child: _isLoading // Affichage conditionnel
                ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
                : _filteredHospitals.isEmpty // Si aucun hôpital
                    ? Center(child: Text('Aucun hôpital trouvé')) // Message d'absence
                    : ListView.builder( // Liste des hôpitaux
                        itemCount: _filteredHospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = _filteredHospitals[index];
                          return HospitalCard(hospital: hospital); // Carte d'hôpital
                        },
                      ),
          ),
        ],
      ),
    );
  }
}