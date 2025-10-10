// Import des packages nécessaires
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Partie générée par Hive
part 'appointment_model.g.dart';

// Annotation HiveType pour l'ID de type 2
@HiveType(typeId: 2)
class AppointmentModel {
  // Champ ID rendez-vous
  @HiveField(0)
  final String id;
  
  // Champ ID patient
  @HiveField(1)
  final String patientId;
  
  // Champ ID centre de santé
  @HiveField(2)
  final String centerId;
  
  // Champ date et heure du rendez-vous
  @HiveField(3)
  final DateTime dateTime;
  
  // Champ statut du rendez-vous (scheduled, completed, cancelled)
  @HiveField(4)
  final String status;
  
  // Champ notes optionnelles
  @HiveField(5)
  final String? notes;

  // Constructeur de la classe AppointmentModel
  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.centerId,
    required this.dateTime,
    required this.status,
    this.notes,
  });

  // Méthode pour formater la date en français
  String get formattedDate {
    return DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(dateTime);
  }

  // Méthode pour vérifier si le rendez-vous est passé
  bool get isPast {
    return dateTime.isBefore(DateTime.now());
  }

  // Méthode fromJson
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      patientId: json['patientId'],
      centerId: json['centerId'],
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'],
      notes: json['notes'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'centerId': centerId,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  // Méthode toFirestore pour sauvegarder dans Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'patientId': patientId,
      'centerId': centerId,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Méthode fromFirestore pour charger depuis Firestore
  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: data['id'] ?? doc.id,
      patientId: data['patientId'] ?? '',
      centerId: data['centerId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      status: data['status'] ?? 'scheduled',
      notes: data['notes'],
    );
  }
}