// Import des packages Flutter et des services
import 'package:flutter/foundation.dart';
import 'package:vitalia/core/services/auth_service.dart';
import 'package:vitalia/data/models/user_model.dart';

// Provider pour la gestion de l'état d'authentification
class AuthProvider with ChangeNotifier {
  // Instance du service d'authentification
  final AuthService _authService;
  
  // Utilisateur courant
  UserModel? _currentUser;
  
  // Indicateur de chargement
  bool _isLoading = false;
  
  // Message d'erreur
  String? _error;

  // Constructeur avec injection du service
  AuthProvider(this._authService);

  // Getter pour l'utilisateur courant
  UserModel? get currentUser => _currentUser;
  
  // Getter pour l'état de chargement
  bool get isLoading => _isLoading;
  
  // Getter pour l'erreur
  String? get error => _error;
  
  // Getter pour le rôle utilisateur
  String? get userRole => _currentUser?.role;

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> checkIfLoggedIn() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
      }
      _error = null;
      return isLoggedIn;
    } catch (e) {
      _error = 'Erreur de vérification de connexion: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode de connexion
  Future<void> login(String userType, String phone, String password, {String? id}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Création d'un utilisateur factice pour la démo
      _currentUser = UserModel(
        id: id ?? 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: userType == 'patient' ? 'Patient Demo' : 
              userType == 'center' ? 'Centre Demo' : 'Admin Demo',
        phone: phone,
        role: userType,
        emergencyContact: '+229 00000000',
      );
      
      // Appel du service de connexion
      await _authService.login(_currentUser!, password);
      _error = null;
    } catch (e) {
      _error = 'Échec de la connexion: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.logout();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de la déconnexion: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}