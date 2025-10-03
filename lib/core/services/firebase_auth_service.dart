import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalia/data/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription
  Future<UserModel> signUp(UserModel user, String password) async {
    try {
      // 1. Créer l'utilisateur dans Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // 2. Mettre à jour l'ID de l'utilisateur
      final UserModel userWithId = user.copyWith(id: firebaseUser.uid);

      // 3. Créer le document dans Firestore
      await _firestore.collection('users').doc(firebaseUser.uid).set(
        userWithId.toFirestore(),
      );

      // 4. Envoyer l'email de vérification
      await firebaseUser.sendEmailVerification();

      return userWithId;

    } catch (e) {
      rethrow;
    }
  }

  // Connexion
  Future<UserModel> signIn(String email, String password) async {
    try {
      // 1. Connexion Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // 2. Vérification email
      if (!user.emailVerified) {
        await _auth.signOut();
        throw Exception('Veuillez vérifier votre email avant de vous connecter');
      }

      // 3. Récupération des données depuis Firestore
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception('Aucun compte ne correspond à ces identifiants');
      }

      // 4. Conversion en UserModel
      return UserModel.fromFirestore(userDoc);

    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Vérifier si connecté
  bool get isLoggedIn => _auth.currentUser != null;

  // Récupérer l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}