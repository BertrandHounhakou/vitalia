// Import du package Hive pour la persistance des données
import 'package:hive/hive.dart';

// Annotation Hive pour générer l'adaptateur
part 'user_model.g.dart';

// Annotation HiveType pour définir l'ID de type
@HiveType(typeId: 0)
class UserModel {
  // Champs avec annotations HiveField pour la sérialisation
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String phone;
  
  @HiveField(3)
  final String role; // 'patient', 'center', 'admin'
  
  @HiveField(4)
  final String? profileImage; // Image de profil optionnelle
  
  @HiveField(5)
  final String? emergencyContact; // Contact d'urgence optionnel

  // Constructeur avec paramètres requis et optionnels
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.profileImage,
    this.emergencyContact,
  });

  // Méthode pour créer un utilisateur à partir de données JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      profileImage: json['profileImage'],
      emergencyContact: json['emergencyContact'],
    );
  }

  // Méthode pour convertir l'utilisateur en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'emergencyContact': emergencyContact,
    };
  }

  // Méthode pour copier l'utilisateur avec de nouvelles valeurs
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? role,
    String? profileImage,
    String? emergencyContact,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  // Surcharge de l'opérateur == pour comparer les utilisateurs
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.role == role;
  }

  // Surcharge de hashCode pour la cohérence avec ==
  @override
  int get hashCode {
    return Object.hash(id, name, phone, role);
  }

  // Surcharge de toString pour le débogage
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, role: $role)';
  }
}