// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/location_provider.dart';
import 'package:vitalia/presentation/widgets/pharmacy_card.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

// Classe pour la page des pharmacies avec état
class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _PharmaciesPageState createState() => _PharmaciesPageState();
}

// État de la page des pharmacies
class _PharmaciesPageState extends State<PharmaciesPage> {
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Liste complète des pharmacies
  List<Map<String, dynamic>> _pharmacies = [];
  
  // Liste filtrée des pharmacies
  List<Map<String, dynamic>> _filteredPharmacies = [];
  
  // Indicateur de chargement
  bool _isLoading = true;
  
  // Filtre "De garde" activé
  bool _showOnDutyOnly = false;
  
  // Filtre "Autour de moi" activé
  bool _showNearbyOnly = false;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadPharmacies(); // Chargement des pharmacies
  }

  // Méthode pour charger les pharmacies (simulation)
  Future<void> _loadPharmacies() async {
    // Données simulées - À remplacer par un appel API réel
    final pharmacies = [
      {
        'id': '1',
        'name': 'Pharmacie Le Sycomore',
        'address': 'Abomey-calavi, Cococođji',
        'distance': 0.45,
        'isOnDuty': true,
        'latitude': 6.4545,
        'longitude': 2.3567,
        'phone': '+229 12345678',
      },
      {
        'id': '2',
        'name': 'Pharmacie Magnificat',
        'address': 'Cotonou, Cococođji',
        'distance': 0.75,
        'isOnDuty': false,
        'latitude': 6.3679,
        'longitude': 2.4281,
        'phone': '+229 22334455',
      },
      {
        'id': '3',
        'name': 'Pharmacie Hevie Sari',
        'address': 'Abomey-calavi',
        'distance': 2.19,
        'isOnDuty': true,
        'latitude': 6.3784,
        'longitude': 2.4392,
        'phone': '+229 33445566',
      },
      {
        'id': '4',
        'name': 'Pharmacie Deo-gratias',
        'address': 'Abomey-calavi, Cocotomey',
        'distance': 2.98,
        'isOnDuty': false,
        'latitude': 6.5123,
        'longitude': 2.1456,
        'phone': '+229 44556677',
      },
    ];

    setState(() {
      _pharmacies = pharmacies; // Liste complète
      _filteredPharmacies = pharmacies; // Liste filtrée (initialement complète)
      _isLoading = false; // Fin du chargement
    });
  }

  // Méthode pour filtrer les pharmacies selon la recherche
  void _filterPharmacies(String query) {
    setState(() {
      _filteredPharmacies = _pharmacies.where((pharmacy) {
        final nameMatch = pharmacy['name'].toLowerCase().contains(query.toLowerCase()); // Recherche dans le nom
        final addressMatch = pharmacy['address'].toLowerCase().contains(query.toLowerCase()); // Recherche dans l'adresse
        return nameMatch || addressMatch; // Retourne true si correspondance
      }).toList();
    });
  }

  // Méthode pour filtrer les pharmacies de garde
  void _toggleOnDutyFilter() {
    setState(() {
      _showOnDutyOnly = !_showOnDutyOnly; // Inversion du filtre
      if (_showOnDutyOnly) {
        _filteredPharmacies = _pharmacies.where((pharmacy) => pharmacy['isOnDuty']).toList(); // Filtrage
      } else {
        _filteredPharmacies = _pharmacies; // Réinitialisation
      }
    });
  }

  // Méthode pour obtenir les pharmacies à proximité
  Future<void> _getNearbyPharmacies() async {
    setState(() {
      _isLoading = true; // Début du chargement
    });

    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.getCurrentLocation(); // Obtention de la position

      // Filtrage des pharmacies à proximité (simulation)
      setState(() {
        _filteredPharmacies = _pharmacies.where((pharmacy) => pharmacy['distance'] <= 5).toList(); // 5km max
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
        title: 'Pharmacies',
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
                labelText: 'Rechercher une pharmacie', // Label du champ
                prefixIcon: Icon(Icons.search), // Icône de recherche
                border: OutlineInputBorder(), // Bordure avec outline
                suffixIcon: _searchController.text.isNotEmpty // Icône de suppression conditionnelle
                    ? IconButton(
                        icon: Icon(Icons.clear), // Icône de suppression
                        onPressed: () {
                          _searchController.clear(); // Effacement du texte
                          _filterPharmacies(''); // Réinitialisation du filtre
                        },
                      )
                    : null,
              ),
              onChanged: _filterPharmacies, // Filtrage à chaque changement
            ),
          ),
          
          // Filtres (De garde et Proximité)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal
            child: Row(
              children: [
                Expanded( // Prend tout l'espace disponible
                  child: ElevatedButton.icon(
                    onPressed: _toggleOnDutyFilter, // Filtre de garde
                    icon: Icon(Icons.medical_services), // Icône médicale
                    label: Text('De garde'), // Texte du bouton
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showOnDutyOnly // Couleur conditionnelle
                          ? Theme.of(context).primaryColor // Couleur primaire si actif
                          : Colors.grey[300], // Gris si inactif
                      foregroundColor: _showOnDutyOnly // Couleur du texte conditionnelle
                          ? Colors.white // Blanc si actif
                          : Colors.black, // Noir si inactif
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacement horizontal
                Expanded( // Prend tout l'espace disponible
                  child: ElevatedButton.icon(
                    onPressed: _getNearbyPharmacies, // Filtre de proximité
                    icon: Icon(Icons.location_on), // Icône de localisation
                    label: Text('Proximité'), // Texte du bouton
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
          
          // Liste des pharmacies
          Expanded(
            child: _isLoading // Affichage conditionnel
                ? Center(child: CircularProgressIndicator()) // Indicateur de chargement
                : _filteredPharmacies.isEmpty // Si aucune pharmacie
                    ? Center(child: Text('Aucune pharmacie trouvée')) // Message d'absence
                    : ListView.builder( // Liste des pharmacies
                        itemCount: _filteredPharmacies.length,
                        itemBuilder: (context, index) {
                          final pharmacy = _filteredPharmacies[index];
                          return PharmacyCard(pharmacy: pharmacy); // Carte de pharmacie
                        },
                      ),
          ),
        ],
      ),
    );
  }
}