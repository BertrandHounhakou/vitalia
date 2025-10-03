import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalia/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode de connexion complète
  Future<UserModel> signIn(String email, String password) async {
    try {
      print('Tentative de connexion pour: $email');
      
      // 1. Connexion Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Utilisateur non trouvé');
      }

      print('Utilisateur Firebase connecté: ${user.uid}');

      // 2. Vérification email
      if (!user.emailVerified) {
        await _auth.signOut();
        throw Exception('Veuillez vérifier votre email avant de vous connecter');
      }

      // 3. Récupération des données utilisateur depuis Firestore
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      print('Document Firestore existe: ${userDoc.exists}');

      if (!userDoc.exists) {
        throw Exception('Aucun compte ne correspond à ces identifiants');
      }

      // 4. Conversion en UserModel avec fromFirestore
      final UserModel userModel = UserModel.fromFirestore(userDoc);
      
      print('Utilisateur final: ${userModel.name} - ${userModel.email} - ${userModel.role}');
      
      return userModel;

    } on FirebaseAuthException catch (e) {
      print('Erreur Firebase: ${e.code} - ${e.message}');
      throw Exception(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      print('Erreur générale: $e');
      rethrow;
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Aucun compte ne correspond à cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'invalid-email':
        return 'Adresse email invalide';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      case 'network-request-failed':
        return 'Erreur de connexion réseau';
      default:
        return 'Erreur de connexion. Veuillez réessayer';
    }
  }

  // Réinitialisation mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Vérifier si l'utilisateur est connecté
  Stream<User?> get userStream => _auth.authStateChanges();
}