import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/core/config/firebase_config.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseConfig.auth;
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Envoyer un email de vérification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print('✅ Email de vérification envoyé à ${user.email}');
      } catch (e) {
        print('❌ Erreur envoi email vérification: $e');
        throw Exception('Erreur lors de l\'envoi de l\'email de vérification: $e');
      }
    }
  }

  // Inscription utilisateur avec logs détaillés et email de vérification
  Future<UserModel> signUp(UserModel user, String password) async {
    UserCredential? userCredential;
    
    try {
      print('🚀 FirebaseAuthService: Début inscription pour ${user.email}');
      
      // Création du compte Firebase Auth
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      print('✅ FirebaseAuthService: Compte Auth créé - ${userCredential.user!.uid}');

      // ENVOI IMMÉDIAT DE L'EMAIL DE VÉRIFICATION APRÈS CRÉATION DU COMPTE
      try {
        await userCredential.user!.sendEmailVerification();
        print('📧 FirebaseAuthService: Email de vérification envoyé à ${user.email}');
      } catch (emailError) {
        print('⚠️ FirebaseAuthService: Attention - Erreur envoi email: $emailError');
        // On continue même si l'email échoue
      }

      // Création du document utilisateur dans Firestore
      final userDoc = FirebaseConfig.usersCollection.doc(userCredential.user!.uid);
      
      final userWithId = user.copyWith(
        id: userCredential.user!.uid,
        emailVerified: false, // Marqué comme non vérifié
      );
      
      print('📝 FirebaseAuthService: Création document Firestore...');
      
      await userDoc.set(userWithId.toFirestore());

      print('✅ FirebaseAuthService: Document Firestore créé avec succès');

      return userWithId;
      
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthService: Erreur Auth - ${e.code}: ${e.message}');
      
      // Si l'inscription Auth a réussi mais qu'il y a une erreur après, supprimer le compte
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
          print('🗑️ Compte Auth supprimé suite à une erreur');
        } catch (deleteError) {
          print('⚠️ Erreur lors de la suppression du compte: $deleteError');
        }
      }
      
      throw Exception('Erreur Firebase Auth: ${e.code} - ${e.message}');
    } on FirebaseException catch (e) {
      print('❌ FirebaseAuthService: Erreur Firestore - ${e.code}: ${e.message}');
      
      // Si l'inscription Auth a réussi mais Firestore échoue, supprimer le compte
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
          print('🗑️ Compte Auth supprimé suite à une erreur Firestore');
        } catch (deleteError) {
          print('⚠️ Erreur lors de la suppression du compte: $deleteError');
        }
      }
      
      throw Exception('Erreur Firestore: ${e.code} - ${e.message}');
    } catch (e) {
      print('❌ FirebaseAuthService: Erreur inattendue: $e');
      
      // Nettoyage en cas d'erreur inattendue
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
          print('🗑️ Compte Auth supprimé suite à une erreur inattendue');
        } catch (deleteError) {
          print('⚠️ Erreur lors de la suppression du compte: $deleteError');
        }
      }
      
      throw Exception('Erreur lors de l\'inscription: $e');
    }
  }

  // Renvoyer un email de vérification
  Future<void> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Aucun utilisateur connecté');
      }
      
      if (user.emailVerified) {
        throw Exception('Email déjà vérifié');
      }
      
      await user.sendEmailVerification();
      print('📧 Email de vérification renvoyé à ${user.email}');
    } catch (e) {
      print('❌ Erreur renvoi email vérification: $e');
      throw Exception('Erreur lors du renvoi de l\'email de vérification: $e');
    }
  }

  // Vérifier si l'email est vérifié
  Future<bool> checkEmailVerified() async {
    // Recharger l'utilisateur pour avoir les données à jour
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Connexion utilisateur avec logs détaillés
  Future<UserModel> signIn(String email, String password) async {
    try {
      print('🚀 FirebaseAuthService: Tentative connexion pour $email');
      
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ FirebaseAuthService: Connexion Auth réussie - ${userCredential.user!.uid}');

      // Vérifier si l'email est vérifié
      if (!userCredential.user!.emailVerified) {
        print('⚠️ FirebaseAuthService: Email non vérifié pour $email');
        // Vous pouvez choisir de throw une exception ou de continuer
        // throw Exception('Veuillez vérifier votre adresse email avant de vous connecter');
      }

      // Récupération des données utilisateur depuis Firestore
      final userDoc = await FirebaseConfig.usersCollection.doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        print('❌ FirebaseAuthService: Document utilisateur non trouvé dans Firestore');
        throw Exception('Utilisateur non trouvé dans la base de données');
      }

      print('✅ FirebaseAuthService: Données Firestore récupérées avec succès');
      
      return UserModel.fromFirestore(userDoc);
      
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthService: Erreur Auth - ${e.code}: ${e.message}');
      throw Exception('Erreur Firebase Auth: ${e.code} - ${e.message}');
    } on FirebaseException catch (e) {
      print('❌ FirebaseAuthService: Erreur Firestore - ${e.code}: ${e.message}');
      throw Exception('Erreur Firestore: ${e.code} - ${e.message}');
    } catch (e) {
      print('❌ FirebaseAuthService: Erreur inattendue: $e');
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      print('🚀 FirebaseAuthService: Déconnexion en cours...');
      await _auth.signOut();
      print('✅ FirebaseAuthService: Déconnexion réussie');
    } catch (e) {
      print('❌ FirebaseAuthService: Erreur déconnexion: $e');
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  // Utilisateur courant
  User? get currentUser => _auth.currentUser;

  // Vérifier si connecté
  bool get isLoggedIn => _auth.currentUser != null;

  // Récupérer l'utilisateur actuel depuis Firestore
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Aucun utilisateur connecté');
      }

      final userDoc = await FirebaseConfig.usersCollection.doc(user.uid).get();
      
      if (!userDoc.exists) {
        throw Exception('Profil utilisateur non trouvé');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      print('❌ FirebaseAuthService: Erreur récupération utilisateur: $e');
      throw Exception('Erreur lors de la récupération du profil: $e');
    }
  }

  // Vérifier si l'email est déjà utilisé
  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('❌ FirebaseAuthService: Erreur vérification email: $e');
      return false;
    }
  }
}