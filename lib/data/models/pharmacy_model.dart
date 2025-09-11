// Import du package Hive
import 'package:hive/hive.dart';

// Partie générée par Hive
part 'pharmacy_model.g.dart';

// Annotation HiveType pour l'ID de type 4
@HiveType(typeId: 4)
class PharmacyModel {
  // Champ ID pharmacie
  @HiveField(0)
  final String id;
  
  // Champ nom de la pharmacie
  @HiveField(1)
  final String name;
  
  // Champ adresse
  @HiveField(2)
  final String address;
  
  // Champ distance en kilomètres
  @HiveField(3)
  final double distance;
  
  // Champ indicateur de garde
  @HiveField(4)
  final bool isOnDuty;
  
  // Champ numéro de téléphone
  @HiveField(5)
  final String phone;

  // Constructeur de PharmacyModel
  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.isOnDuty,
    required this.phone,
  });

  // Méthode fromJson
  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      distance: json['distance'],
      isOnDuty: json['isOnDuty'],
      phone: json['phone'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'isOnDuty': isOnDuty,
      'phone': phone,
    };
  }
}