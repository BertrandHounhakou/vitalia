import 'package:flutter/foundation.dart';
import 'package:vitalia/core/services/firebase_auth.dart';
import 'package:vitalia/data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Inscription avec gestion d'erreur améliorée
  Future<void> signUp(UserModel user, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 AuthProvider: Début de l\'inscription pour ${user.email}');
      
      _currentUser = await _authService.signUp(user, password);
      _error = null;
      
      print('✅ AuthProvider: Inscription réussie pour ${user.email}');
      
    } catch (e) {
      print('❌ AuthProvider: Erreur d\'inscription: $e');
      
      // Gestion détaillée des erreurs Firebase
      String errorMessage = 'Erreur lors de la création du compte';
      
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Cette adresse email est déjà utilisée';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Le mot de passe est trop faible (minimum 6 caractères)';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Adresse email invalide';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Problème de connexion internet';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Trop de tentatives. Réessayez plus tard';
      } else {
        errorMessage = 'Erreur d\'inscription: ${e.toString()}';
      }
      
      _error = errorMessage;
      rethrow; // Important pour que register_page.dart puisse aussi capturer l'erreur
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Connexion avec gestion d'erreur améliorée
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 AuthProvider: Tentative de connexion pour $email');
      
      _currentUser = await _authService.signIn(email, password);
      _error = null;
      
      print('✅ AuthProvider: Connexion réussie pour $email');
      
    } catch (e) {
      print('❌ AuthProvider: Erreur de connexion: $e');
      
      // Gestion détaillée des erreurs Firebase
      String errorMessage = 'Erreur de connexion';
      
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'Aucun compte trouvé avec cet email';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Mot de passe incorrect';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Adresse email invalide';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Problème de connexion internet';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Trop de tentatives. Réessayez plus tard';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'Ce compte a été désactivé';
      } else {
        errorMessage = 'Erreur de connexion: ${e.toString()}';
      }
      
      _error = errorMessage;
      rethrow;
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Erreur de déconnexion: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode logout (alias de signOut pour cohérence)
  Future<void> logout() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la déconnexion: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Vérifier la connexion
  Future<bool> checkAuthStatus() async {
    try {
      if (_authService.isLoggedIn && _currentUser == null) {
        _currentUser = await _authService.getCurrentUser();
        notifyListeners();
        return true;
      }
      return _authService.isLoggedIn;
    } catch (e) {
      print('❌ AuthProvider: Erreur vérification statut: $e');
      return false;
    }
  }

  // Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Mettre à jour le profil utilisateur
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      // Implémentez la mise à jour du profil si nécessaire
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _error = 'Erreur mise à jour profil: $e';
      rethrow;
    }
  }
}