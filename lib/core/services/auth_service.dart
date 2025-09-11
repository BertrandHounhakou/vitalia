// Import des packages nécessaires
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalia/data/models/user_model.dart';

// Service d'authentification pour gérer la connexion/déconnexion
class AuthService {
  // Stockage sécurisé pour les données sensibles
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Préférences partagées pour le stockage simple
  final SharedPreferences _prefs;

  // Constructeur avec injection des préférences
  AuthService(this._prefs);

  // Méthode de connexion utilisateur
  Future<void> login(UserModel user, String password) async {
    // Simulation d'appel API - À remplacer par un vrai appel
    await Future.delayed(const Duration(seconds: 1));
    
    // Stockage des informations utilisateur
    await _prefs.setString('user_id', user.id);
    await _prefs.setString('user_name', user.name);
    await _prefs.setString('user_role', user.role);
    
    // Stockage sécurisé du token (simulé)
    await _secureStorage.write(key: 'auth_token', value: 'simulated_token_${user.id}');
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    // Suppression de toutes les données d'authentification
    await _prefs.remove('user_id');
    await _prefs.remove('user_name');
    await _prefs.remove('user_role');
    await _secureStorage.delete(key: 'auth_token');
  }

  // Vérification si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final String? userId = await _prefs.getString('user_id');
    final String? token = await _secureStorage.read(key: 'auth_token');
    return userId != null && token != null;
  }

  // Récupération de l'ID utilisateur connecté
  Future<String?> getUserId() async {
    return await _prefs.getString('user_id');
  }

  // Récupération du rôle utilisateur
  Future<String?> getUserRole() async {
    return await _prefs.getString('user_role');
  }

  // Récupération des informations utilisateur
  Future<UserModel?> getCurrentUser() async {
    final String? id = await _prefs.getString('user_id');
    final String? name = await _prefs.getString('user_name');
    final String? role = await _prefs.getString('user_role');
    
    if (id == null || name == null || role == null) return null;
    
    return UserModel(
      id: id,
      name: name,
      phone: '', // À récupérer depuis une source de données
      role: role,
    );
  }
}