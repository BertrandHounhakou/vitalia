// Import des packages nécessaires
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalia/data/models/consultation_model.dart';

/// Service Firebase pour gérer les consultations médicales
/// Utilisé par les centres de santé pour créer, lire, modifier et supprimer des consultations
class ConsultationService {
  // Instance de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Nom de la collection dans Firestore
  final String _collectionName = 'consultations';

  /// Créer une nouvelle consultation
  Future<void> createConsultation(ConsultationModel consultation) async {
    try {
      print('🚀 ConsultationService: Création consultation pour patient ${consultation.patientId}');
      
      await _firestore
          .collection(_collectionName)
          .doc(consultation.id)
          .set(consultation.toFirestore());
      
      print('✅ ConsultationService: Consultation créée avec succès');
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur Firestore - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la création de la consultation: ${e.message}');
    }
  }

  /// Récupérer toutes les consultations d'un patient
  Future<List<ConsultationModel>> getPatientConsultations(String patientId) async {
    try {
      print('🔍 ConsultationService: Récupération consultations patient $patientId');
      
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('patientId', isEqualTo: patientId)
          .orderBy('dateTime', descending: true)
          .get();
      
      final consultations = querySnapshot.docs
          .map((doc) => ConsultationModel.fromFirestore(doc))
          .toList();
      
      print('✅ ConsultationService: ${consultations.length} consultations trouvées');
      return consultations;
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération des consultations: ${e.message}');
    }
  }

  /// Récupérer toutes les consultations d'un centre de santé
  Future<List<ConsultationModel>> getCenterConsultations(String centerId) async {
    try {
      print('🔍 ConsultationService: Récupération consultations centre $centerId');
      
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('centerId', isEqualTo: centerId)
          .orderBy('dateTime', descending: true)
          .get();
      
      final consultations = querySnapshot.docs
          .map((doc) => ConsultationModel.fromFirestore(doc))
          .toList();
      
      print('✅ ConsultationService: ${consultations.length} consultations trouvées');
      return consultations;
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération des consultations: ${e.message}');
    }
  }

  /// Récupérer une consultation par ID
  Future<ConsultationModel?> getConsultationById(String consultationId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(consultationId)
          .get();
      
      if (doc.exists) {
        return ConsultationModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération de la consultation: ${e.message}');
    }
  }

  /// Mettre à jour une consultation existante
  Future<void> updateConsultation(ConsultationModel consultation) async {
    try {
      print('🔄 ConsultationService: Mise à jour consultation ${consultation.id}');
      
      await _firestore
          .collection(_collectionName)
          .doc(consultation.id)
          .update(consultation.toFirestore());
      
      print('✅ ConsultationService: Consultation mise à jour');
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la mise à jour: ${e.message}');
    }
  }

  /// Supprimer une consultation
  Future<void> deleteConsultation(String consultationId) async {
    try {
      print('🗑️ ConsultationService: Suppression consultation $consultationId');
      
      await _firestore
          .collection(_collectionName)
          .doc(consultationId)
          .delete();
      
      print('✅ ConsultationService: Consultation supprimée');
    } on FirebaseException catch (e) {
      print('❌ ConsultationService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la suppression: ${e.message}');
    }
  }

  /// Récupérer les consultations récentes (pour dashboard)
  Future<List<ConsultationModel>> getRecentConsultations(String centerId, {int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('centerId', isEqualTo: centerId)
          .orderBy('dateTime', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ConsultationModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur lors de la récupération: ${e.message}');
    }
  }

  /// Rechercher des consultations par nom de patient ou diagnostic
  Future<List<ConsultationModel>> searchConsultations(String centerId, String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('centerId', isEqualTo: centerId)
          .get();
      
      // Filtrage local (Firestore ne supporte pas les recherches textuelles complexes)
      final consultations = querySnapshot.docs
          .map((doc) => ConsultationModel.fromFirestore(doc))
          .where((consultation) =>
              consultation.doctorName.toLowerCase().contains(query.toLowerCase()) ||
              consultation.diagnosis.toLowerCase().contains(query.toLowerCase()) ||
              consultation.reason.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      return consultations;
    } on FirebaseException catch (e) {
      throw Exception('Erreur lors de la recherche: ${e.message}');
    }
  }
}

