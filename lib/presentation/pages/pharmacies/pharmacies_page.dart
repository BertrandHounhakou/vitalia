// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/location_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/data/models/pharmacy_model.dart';
import 'package:vitalia/core/services/pharmacy_service.dart';
import 'dart:math' show cos, sqrt, asin;

/// Page des pharmacies avec recherche, filtres et géolocalisation
class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({Key? key}) : super(key: key);

  @override
  _PharmaciesPageState createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  // Service pour gérer les pharmacies
  final PharmacyService _pharmacyService = PharmacyService();
  
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Liste complète des pharmacies
  List<PharmacyModel> _pharmacies = [];
  
  // Liste filtrée des pharmacies
  List<PharmacyModel> _filteredPharmacies = [];
  
  // Indicateur de chargement
  bool _isLoading = true;
  
  // Filtre "De garde" activé
  bool _showOnDutyOnly = false;
  
  // Filtre "Proximité" activé
  bool _showNearbyOnly = false;
  
  // Position actuelle de l'utilisateur
  Position? _currentPosition;
  
  // Rayon de recherche en km pour la proximité
  double _proximityRadius = 5.0;

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Charge toutes les pharmacies depuis l'API
  Future<void> _loadPharmacies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pharmacies = await _pharmacyService.getAllPharmacies();
      
      setState(() {
        _pharmacies = pharmacies;
        _filteredPharmacies = pharmacies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des pharmacies'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Calcule la distance entre deux coordonnées GPS (formule de Haversine)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi/180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Filtre les pharmacies selon la recherche
  void _filterPharmacies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPharmacies = _pharmacies;
      } else {
        _filteredPharmacies = _pharmacies.where((pharmacy) {
          final nameMatch = pharmacy.name.toLowerCase().contains(query.toLowerCase());
          final addressMatch = pharmacy.address.toLowerCase().contains(query.toLowerCase());
          final cityMatch = pharmacy.city.toLowerCase().contains(query.toLowerCase());
          return nameMatch || addressMatch || cityMatch;
        }).toList();
      }
      
      // Réappliquer les filtres actifs
      _applyActiveFilters();
    });
  }

  /// Applique les filtres actifs (De garde et/ou Proximité)
  void _applyActiveFilters() {
    List<PharmacyModel> filtered = List.from(_filteredPharmacies);
    
    // Filtre de garde
    if (_showOnDutyOnly) {
      filtered = filtered.where((p) => p.isOnDuty).toList();
    }
    
    // Filtre de proximité
    if (_showNearbyOnly && _currentPosition != null) {
      filtered = filtered.where((p) {
        final distance = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          p.latitude,
          p.longitude,
        );
        return distance <= _proximityRadius;
      }).toList();
    }
    
    setState(() {
      _filteredPharmacies = filtered;
    });
  }

  /// Bascule le filtre "De garde"
  void _toggleOnDutyFilter() {
    setState(() {
      _showOnDutyOnly = !_showOnDutyOnly;
      _filterPharmacies(_searchController.text);
    });
  }

  /// Obtient les pharmacies à proximité
  Future<void> _getNearbyPharmacies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtenir la position actuelle
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.getCurrentLocation();
      _currentPosition = locationProvider.currentPosition;

      if (_currentPosition == null) {
        throw Exception('Impossible d\'obtenir votre position');
      }

      // Calculer les distances et filtrer
      List<PharmacyModel> pharmaciesWithDistance = _pharmacies.map((pharmacy) {
        final distance = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          pharmacy.latitude,
          pharmacy.longitude,
        );
        return pharmacy.copyWith(distance: distance);
      }).toList();

      // Trier par distance
      pharmaciesWithDistance.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

      // Filtrer par rayon
      final nearbyPharmacies = pharmaciesWithDistance
          .where((p) => (p.distance ?? 0) <= _proximityRadius)
          .toList();

      setState(() {
        _pharmacies = pharmaciesWithDistance;
        _filteredPharmacies = nearbyPharmacies;
        _showNearbyOnly = true;
        _isLoading = false;
      });

      if (nearbyPharmacies.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aucune pharmacie trouvée dans un rayon de $_proximityRadius km'),
            action: SnackBarAction(
              label: 'Étendre',
              onPressed: () {
                setState(() {
                  _proximityRadius = 10.0;
                  _getNearbyPharmacies();
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de localisation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Réinitialise tous les filtres
  void _resetFilters() {
    setState(() {
      _showOnDutyOnly = false;
      _showNearbyOnly = false;
      _proximityRadius = 5.0;
      _searchController.clear();
      _filteredPharmacies = _pharmacies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pharmacies',
        showMenuButton: true,
        actions: [
          // Bouton de réinitialisation
          if (_showOnDutyOnly || _showNearbyOnly || _searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFilters,
              tooltip: 'Réinitialiser les filtres',
            ),
        ],
      ),
      
      drawer: MenuPage(),
      
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une pharmacie, ville...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF26A69A)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPharmacies('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _filterPharmacies,
            ),
          ),
          
          // Filtres (De garde et Proximité)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleOnDutyFilter,
                    icon: Icon(
                      Icons.medical_services,
                      size: 18,
                    ),
                    label: Text('De garde'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showOnDutyOnly
                          ? Color(0xFF26A69A)
                          : Colors.grey[200],
                      foregroundColor: _showOnDutyOnly
                          ? Colors.white
                          : Colors.black87,
                      elevation: _showOnDutyOnly ? 2 : 0,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _getNearbyPharmacies,
                    icon: Icon(
                      Icons.location_on,
                      size: 18,
                    ),
                    label: Text('Proximité'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showNearbyOnly
                          ? Color(0xFF26A69A)
                          : Colors.grey[200],
                      foregroundColor: _showNearbyOnly
                          ? Colors.white
                          : Colors.black87,
                      elevation: _showNearbyOnly ? 2 : 0,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Nombre de résultats
          if (!_isLoading)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_pharmacy, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        '${_filteredPharmacies.length} pharmacie(s) trouvée(s)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (_showNearbyOnly)
                    Text(
                      'Rayon: ${_proximityRadius.toStringAsFixed(0)} km',
                      style: TextStyle(
                        color: Color(0xFF26A69A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          
          // Liste des pharmacies
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chargement des pharmacies...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : _filteredPharmacies.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadPharmacies,
                        color: Color(0xFF26A69A),
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: _filteredPharmacies.length,
                          itemBuilder: (context, index) {
                            return _buildPharmacyCard(_filteredPharmacies[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  /// Widget pour un état vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_pharmacy_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Aucune pharmacie trouvée',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh),
            label: Text('Réinitialiser'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF26A69A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget pour une carte de pharmacie
  Widget _buildPharmacyCard(PharmacyModel pharmacy) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showPharmacyDetails(pharmacy);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et badge de garde
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pharmacy.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (pharmacy.isOnDuty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.red[700]),
                          SizedBox(width: 4),
                          Text(
                            'DE GARDE',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Adresse et ville
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${pharmacy.address}, ${pharmacy.city}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Distance et téléphone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (pharmacy.distance != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF26A69A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.directions_walk, size: 14, color: Color(0xFF26A69A)),
                          SizedBox(width: 4),
                          Text(
                            '${pharmacy.distance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              color: Color(0xFF26A69A),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        pharmacy.phone,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              if (pharmacy.openingHours != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      pharmacy.openingHours!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche les détails d'une pharmacie
  void _showPharmacyDetails(PharmacyModel pharmacy) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pharmacy.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (pharmacy.isOnDuty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Text(
                        'DE GARDE',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 16),
              
              _buildDetailRow(Icons.location_on, '${pharmacy.address}, ${pharmacy.city}'),
              _buildDetailRow(Icons.phone, pharmacy.phone),
              if (pharmacy.openingHours != null)
                _buildDetailRow(Icons.schedule, pharmacy.openingHours!),
              if (pharmacy.email != null)
                _buildDetailRow(Icons.email, pharmacy.email!),
              if (pharmacy.distance != null)
                _buildDetailRow(
                  Icons.directions_walk,
                  '${pharmacy.distance!.toStringAsFixed(1)} km de votre position',
                ),
              
              SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Ouvrir l'application téléphone
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.phone),
                      label: Text('Appeler'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF26A69A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Ouvrir Google Maps
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.directions),
                      label: Text('Itinéraire'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF26A69A),
                        side: BorderSide(color: Color(0xFF26A69A)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Widget pour une ligne de détail
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF26A69A)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
