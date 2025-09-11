// Import des packages Flutter et geolocator
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// Provider pour la gestion de la localisation
class LocationProvider with ChangeNotifier {
  // Position actuelle
  Position? _currentPosition;
  
  // Indicateur de chargement
  bool _isLoading = false;
  
  // Message d'erreur
  String? _error;
  
  // Permission de localisation
  LocationPermission? _permission;

  // Getter pour la position actuelle
  Position? get currentPosition => _currentPosition;
  
  // Getter pour l'état de chargement
  bool get isLoading => _isLoading;
  
  // Getter pour l'erreur
  String? get error => _error;
  
  // Getter pour la permission
  LocationPermission? get permission => _permission;

  // Méthode pour obtenir la position actuelle
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Vérification des permissions
      _permission = await Geolocator.checkPermission();
      
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        
        if (_permission == LocationPermission.denied) {
          _error = 'Permission de localisation refusée';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      
      if (_permission == LocationPermission.deniedForever) {
        _error = 'Permission de localisation définitivement refusée';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Obtention de la position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      _error = null;
    } catch (e) {
      _error = 'Erreur de localisation: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour calculer la distance entre deux points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // Conversion en kilomètres
  }

  // Méthode pour effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}