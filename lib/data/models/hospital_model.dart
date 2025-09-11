// Import du package Hive
import 'package:hive/hive.dart';

// Partie générée par Hive
part 'hospital_model.g.dart';

// Annotation HiveType pour l'ID de type 3
@HiveType(typeId: 3)
class HospitalModel {
  // Champ ID hôpital
  @HiveField(0)
  final String id;
  
  // Champ nom de l'hôpital
  @HiveField(1)
  final String name;
  
  // Champ adresse
  @HiveField(2)
  final String address;
  
  // Champ latitude pour la géolocalisation
  @HiveField(3)
  final double latitude;
  
  // Champ longitude pour la géolocalisation
  @HiveField(4)
  final double longitude;
  
  // Champ distance en kilomètres
  @HiveField(5)
  final double distance;
  
  // Champ type d'établissement
  @HiveField(6)
  final String type;

  // Constructeur de HospitalModel
  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.type,
  });

  // Méthode fromJson
  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: json['distance'],
      type: json['type'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'type': type,
    };
  }
}