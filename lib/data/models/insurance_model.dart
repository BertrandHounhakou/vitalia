// Import du package Hive
import 'package:hive/hive.dart';

// Partie générée par Hive
part 'insurance_model.g.dart';

// Annotation HiveType pour l'ID de type 5
@HiveType(typeId: 5)
class InsuranceModel {
  // Champ ID assurance
  @HiveField(0)
  final String id;
  
  // Champ nom de l'assurance
  @HiveField(1)
  final String name;
  
  // Champ date de début de validité
  @HiveField(2)
  final DateTime startDate;
  
  // Champ date de fin de validité
  @HiveField(3)
  final DateTime endDate;
  
  // Champ numéro de police
  @HiveField(4)
  final String policyNumber;

  // Constructeur de InsuranceModel
  InsuranceModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.policyNumber,
  });

  // Méthode pour vérifier si l'assurance est valide
  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Méthode fromJson
  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      policyNumber: json['policyNumber'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'policyNumber': policyNumber,
    };
  }
}