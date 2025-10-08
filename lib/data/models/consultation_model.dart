// Import des packages nécessaires
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour représenter une consultation médicale
/// Utilisé par les centres de santé pour enregistrer les consultations des patients
class ConsultationModel {
  // Identifiant unique de la consultation
  final String id;
  
  // ID du patient concerné
  final String patientId;
  
  // ID du centre de santé qui effectue la consultation
  final String centerId;
  
  // Nom du docteur qui a fait la consultation
  final String doctorName;
  
  // Date et heure de la consultation
  final DateTime dateTime;
  
  // Motif de la consultation
  final String reason;
  
  // Diagnostic établi par le médecin
  final String diagnosis;
  
  // Traitement prescrit
  final String? treatment;
  
  // Ordonnance (peut être un texte ou une URL)
  final String? prescription;
  
  // Notes supplémentaires du médecin
  final String? notes;
  
  // Constantes vitales prises pendant la consultation
  final Map<String, dynamic>? vitalSigns; // Ex: tension, température, poids, etc.
  
  // Date de création dans la base de données
  final DateTime createdAt;
  
  // Date de dernière modification
  final DateTime updatedAt;

  /// Constructeur du modèle Consultation
  ConsultationModel({
    required this.id,
    required this.patientId,
    required this.centerId,
    required this.doctorName,
    required this.dateTime,
    required this.reason,
    required this.diagnosis,
    this.treatment,
    this.prescription,
    this.notes,
    this.vitalSigns,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Méthode copyWith pour créer une copie modifiée de la consultation
  ConsultationModel copyWith({
    String? id,
    String? patientId,
    String? centerId,
    String? doctorName,
    DateTime? dateTime,
    String? reason,
    String? diagnosis,
    String? treatment,
    String? prescription,
    String? notes,
    Map<String, dynamic>? vitalSigns,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      centerId: centerId ?? this.centerId,
      doctorName: doctorName ?? this.doctorName,
      dateTime: dateTime ?? this.dateTime,
      reason: reason ?? this.reason,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Conversion vers Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'patientId': patientId,
      'centerId': centerId,
      'doctorName': doctorName,
      'dateTime': Timestamp.fromDate(dateTime),
      'reason': reason,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'prescription': prescription,
      'notes': notes,
      'vitalSigns': vitalSigns,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Création à partir d'un document Firestore
  factory ConsultationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConsultationModel(
      id: data['id'] ?? doc.id,
      patientId: data['patientId'] ?? '',
      centerId: data['centerId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
      diagnosis: data['diagnosis'] ?? '',
      treatment: data['treatment'],
      prescription: data['prescription'],
      notes: data['notes'],
      vitalSigns: data['vitalSigns'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Conversion en Map pour affichage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'centerId': centerId,
      'doctorName': doctorName,
      'dateTime': dateTime.toIso8601String(),
      'reason': reason,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'prescription': prescription,
      'notes': notes,
      'vitalSigns': vitalSigns,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ConsultationModel(id: $id, patientId: $patientId, doctorName: $doctorName, date: $dateTime)';
  }
}

