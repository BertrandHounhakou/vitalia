// Import des packages Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Configuration et initialisation de Firebase
class FirebaseConfig {
  // Initialisation de Firebase
  static Future<void> init() async {
    await Firebase.initializeApp();
  }

  // Getter pour l'authentification
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // Getter pour Firestore
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Getter pour Storage
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Références aux collections Firestore
  static CollectionReference get usersCollection => firestore.collection('users');
  static CollectionReference get appointmentsCollection => firestore.collection('appointments');
  static CollectionReference get hospitalsCollection => firestore.collection('hospitals');
  static CollectionReference get pharmaciesCollection => firestore.collection('pharmacies');
  static CollectionReference get insurancesCollection => firestore.collection('insurances');
  static CollectionReference get medicalRecordsCollection => firestore.collection('medical_records');
}