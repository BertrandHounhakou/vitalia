/*// Import des modèles de données
import 'package:vitalia/data/models/user_model.dart';

// Service de gestion des utilisateurs
class UserService {
  // Méthode pour récupérer la liste des utilisateurs (simulée)
  Future<List<UserModel>> getUsers() async {
    // Simulation de délai réseau
    await Future.delayed(const Duration(seconds: 2));
    
    // Données simulées - À remplacer par un appel API
    return [
      UserModel(
        id: '1',
        name: 'Jean Dupont',
        phone: '+229 12345678',
        role: 'patient',
        emergencyContact: '+229 87654321',
      ),
      UserModel(
        id: '2',
        name: 'Centre Hospitalier Regional',
        phone: '+229 22334455',
        role: 'center',
      ),
      UserModel(
        id: '3',
        name: 'Admin VITALIA',
        phone: '+229 99887766',
        role: 'admin',
      ),
    ];
  }

  // Méthode pour créer un utilisateur
  Future<void> createUser(UserModel user, String password) async {
    // Simulation de création utilisateur
    await Future.delayed(const Duration(seconds: 1));
    print('Utilisateur créé: ${user.name}');
  }

  // Méthode pour supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    // Simulation de suppression
    await Future.delayed(const Duration(seconds: 1));
    print('Utilisateur supprimé: $userId');
  }

  // Méthode pour mettre à jour un utilisateur
  Future<void> updateUser(UserModel user) async {
    // Simulation de mise à jour
    await Future.delayed(const Duration(seconds: 1));
    print('Utilisateur mis à jour: ${user.name}');
  }

  // Méthode pour rechercher des utilisateurs
  Future<List<UserModel>> searchUsers(String query) async {
    // Simulation de recherche
    await Future.delayed(const Duration(seconds: 1));
    
    final allUsers = await getUsers();
    return allUsers.where((user) => 
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.phone.contains(query)
    ).toList();
  }
}*/