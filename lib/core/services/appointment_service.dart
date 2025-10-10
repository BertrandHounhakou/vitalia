// Import des packages nécessaires
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalia/data/models/appointment_model.dart';

/// Service Firebase pour gérer les rendez-vous médicaux
class AppointmentService {
  // Instance de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Nom de la collection dans Firestore
  final String _collectionName = 'appointments';

  /// Créer un nouveau rendez-vous
  Future<void> createAppointment(AppointmentModel appointment) async {
    try {
      print('🚀 AppointmentService: Création rendez-vous pour patient ${appointment.patientId}');
      
      await _firestore
          .collection(_collectionName)
          .doc(appointment.id)
          .set(appointment.toFirestore());
      
      print('✅ AppointmentService: Rendez-vous créé avec succès');
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur Firestore - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la création du rendez-vous: ${e.message}');
    }
  }

  /// Récupérer tous les rendez-vous d'un patient
  Future<List<AppointmentModel>> getPatientAppointments(String patientId) async {
    try {
      print('🔍 AppointmentService: Récupération rendez-vous patient $patientId');
      
      // Requête simplifiée sans orderBy pour éviter le besoin d'index
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('patientId', isEqualTo: patientId)
          .get();
      
      // Tri côté client
      final appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
      
      // Trier par date
      appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      
      print('✅ AppointmentService: ${appointments.length} rendez-vous trouvés');
      return appointments;
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération des rendez-vous: ${e.message}');
    }
  }

  /// Récupérer tous les rendez-vous d'un centre de santé
  Future<List<AppointmentModel>> getCenterAppointments(String centerId) async {
    try {
      print('🔍 AppointmentService: Récupération rendez-vous centre $centerId');
      
      // Requête simplifiée sans orderBy pour éviter le besoin d'index
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('centerId', isEqualTo: centerId)
          .get();
      
      // Tri côté client
      final appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
      
      // Trier par date
      appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      
      print('✅ AppointmentService: ${appointments.length} rendez-vous trouvés');
      return appointments;
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération des rendez-vous: ${e.message}');
    }
  }

  /// Récupérer un rendez-vous par ID
  Future<AppointmentModel?> getAppointmentById(String appointmentId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(appointmentId)
          .get();
      
      if (doc.exists) {
        return AppointmentModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la récupération du rendez-vous: ${e.message}');
    }
  }

  /// Mettre à jour un rendez-vous existant
  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      print('🔄 AppointmentService: Mise à jour rendez-vous ${appointment.id}');
      
      await _firestore
          .collection(_collectionName)
          .doc(appointment.id)
          .update(appointment.toFirestore());
      
      print('✅ AppointmentService: Rendez-vous mis à jour');
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la mise à jour: ${e.message}');
    }
  }

  /// Annuler un rendez-vous (changer son statut)
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      print('🗑️ AppointmentService: Annulation rendez-vous $appointmentId');
      
      await _firestore
          .collection(_collectionName)
          .doc(appointmentId)
          .update({
            'status': 'cancelled',
            'updatedAt': FieldValue.serverTimestamp(),
          });
      
      print('✅ AppointmentService: Rendez-vous annulé');
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de l\'annulation: ${e.message}');
    }
  }

  /// Supprimer un rendez-vous
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      print('🗑️ AppointmentService: Suppression rendez-vous $appointmentId');
      
      await _firestore
          .collection(_collectionName)
          .doc(appointmentId)
          .delete();
      
      print('✅ AppointmentService: Rendez-vous supprimé');
    } on FirebaseException catch (e) {
      print('❌ AppointmentService: Erreur - ${e.code}: ${e.message}');
      throw Exception('Erreur lors de la suppression: ${e.message}');
    }
  }

  /// Récupérer les rendez-vous à venir pour un patient
  Future<List<AppointmentModel>> getUpcomingPatientAppointments(String patientId) async {
    try {
      final now = Timestamp.now();
      
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('patientId', isEqualTo: patientId)
          .where('dateTime', isGreaterThan: now)
          .where('status', whereIn: ['scheduled', 'confirmed'])
          .orderBy('dateTime', descending: false)
          .get();
      
      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur lors de la récupération: ${e.message}');
    }
  }

  /// Récupérer les rendez-vous passés pour un patient
  Future<List<AppointmentModel>> getPastPatientAppointments(String patientId) async {
    try {
      final now = Timestamp.now();
      
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('patientId', isEqualTo: patientId)
          .where('dateTime', isLessThan: now)
          .orderBy('dateTime', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Erreur lors de la récupération: ${e.message}');
    }
  }
}

