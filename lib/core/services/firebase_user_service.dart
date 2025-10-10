import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_service_interface.dart';
import '../../data/models/user_model.dart';

class FirebaseUserService implements UserService {
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
        'name': user.name,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
        'role': user.role,
        'address': user.address,
        'gender': user.gender,
        'dateOfBirth': user.dateOfBirth != null 
            ? Timestamp.fromDate(user.dateOfBirth!)
            : null,
        'medicalHistory': user.medicalHistory,
        'emergencyContact': user.emergencyContact,
        'emailVerified': user.emailVerified,
        // CHAMPS SPÉCIFIQUES AUX CENTRES
        'specialties': user.specialties,
        'description': user.description,
        'openingHours': user.openingHours,
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

  // MÉTHODE SPÉCIFIQUE POUR METTRE À JOUR LE PROFIL UTILISATEUR
  Future<void> updateUserProfile(UserModel user) async {
    try {
      print('🚀 FirebaseUserService: Mise à jour du profil ${user.id}');
      
      final updates = {
        'name': user.name,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'address': user.address,
        'gender': user.gender,
        'dateOfBirth': user.dateOfBirth != null 
            ? Timestamp.fromDate(user.dateOfBirth!)
            : null,
        // CHAMPS MÉDICAUX PATIENTS
        'bloodType': user.bloodType,
        'allergies': user.allergies,
        'emergencyContact': user.emergencyContact,
        'medicalHistory': user.medicalHistory,
        'profession': user.profession,
        // CHAMPS SPÉCIFIQUES AUX CENTRES DE SANTÉ
        'specialties': user.specialties,
        'description': user.description,
        'openingHours': user.openingHours,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Supprimer les valeurs null pour éviter les erreurs Firestore
      updates.removeWhere((key, value) => value == null);

      await _firestore.collection('users').doc(user.id).update(updates);

      print('✅ FirebaseUserService: Profil mis à jour dans Firestore');
      print('📝 Champs mis à jour: ${updates.keys.join(", ")}');
    } on FirebaseException catch (e) {
      print('❌ FirebaseUserService: Erreur Firestore - ${e.code}: ${e.message}');
      throw Exception('Erreur Firestore: ${e.code} - ${e.message}');
    } catch (e) {
      print('❌ FirebaseUserService: Erreur inattendue: $e');
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }
}