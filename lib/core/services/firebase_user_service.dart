import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_service_interface.dart'; // Import de l'interface
import '../../data/models/user_model.dart';

class FirebaseUserService implements UserService { // implements UserService
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs: $e');
    }
  }

  @override
  Future<void> createUser(UserModel user, String password) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      final UserCredential userCredential = 
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Ajouter les données utilisateur dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'email': user.email,
        'firstName': user.name,
        'lastName': user.role,
        'phoneNumber': user.phone,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      // Supprimer de Firestore
      await _firestore.collection('users').doc(userId).delete();
      
      // Supprimer de Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur: $e');
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('firstName', isGreaterThanOrEqualTo: query)
          .where('firstName', isLessThan: query + 'z')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche d\'utilisateurs: $e');
    }
  }

  // Ajoutez ces méthodes manquantes de l'interface
  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: $e');
    }
  }
}