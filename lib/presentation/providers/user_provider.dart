// Import des packages Flutter et des services
import 'package:flutter/foundation.dart';
import 'package:vitalia/core/services/user_service.dart';
import 'package:vitalia/data/models/user_model.dart';

// Provider pour la gestion des utilisateurs
class UserProvider with ChangeNotifier {
  // Instance du service utilisateur
  final UserService _userService;
  
  // Liste des utilisateurs
  List<UserModel> _users = [];
  
  // Indicateur de chargement
  bool _isLoading = false;
  
  // Message d'erreur
  String? _error;

  // Constructeur avec injection du service
  UserProvider(this._userService);

  // Getter pour la liste des utilisateurs
  List<UserModel> get users => _users;
  
  // Getter pour l'état de chargement
  bool get isLoading => _isLoading;
  
  // Getter pour l'erreur
  String? get error => _error;

  // Méthode pour charger les utilisateurs
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _users = await _userService.getUsers();
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des utilisateurs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour ajouter un utilisateur
  Future<void> addUser(UserModel user, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _userService.createUser(user, password);
      await loadUsers(); // Recharger la liste
    } catch (e) {
      _error = 'Erreur lors de l\'ajout de l\'utilisateur: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _userService.deleteUser(userId);
      _users.removeWhere((user) => user.id == userId);
    } catch (e) {
      _error = 'Erreur lors de la suppression de l\'utilisateur: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour rechercher des utilisateurs
  Future<void> searchUsers(String query) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _users = await _userService.searchUsers(query);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de la recherche: $e';
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