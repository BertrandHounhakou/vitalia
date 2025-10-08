import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

//part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String phone;
  
  @HiveField(3)
  final String role; // 'patient', 'center', 'admin'
  
  @HiveField(4)
  final String? profileImage;
  
  @HiveField(5)
  final String? emergencyContact;
  
  @HiveField(6)
  final String email;
  
  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  // NOUVEAUX CHAMPS AJOUTÉS
  @HiveField(9)
  final String? firstName;
  
  @HiveField(10)
  final String? lastName;
  
  @HiveField(11)
  final String? address;
  
  @HiveField(12)
  final DateTime? dateOfBirth;
  
  @HiveField(13)
  final String? gender; // 'male', 'female', 'other'
  
  @HiveField(14)
  final String? bloodType;
  
  @HiveField(15)
  final String? allergies;
  
  @HiveField(16)
  final String? medicalHistory;
  
  @HiveField(17)
  final bool emailVerified;
  
  @HiveField(18)
  final String? profession;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
    this.emergencyContact,
    // NOUVEAUX CHAMPS AVEC VALEURS PAR DÉFAUT
    this.firstName,
    this.lastName,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.allergies,
    this.medicalHistory,
    this.emailVerified = false,
    this.profession,
  });

  // Méthode copyWith améliorée avec tous les champs
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phone,
    String? profileImage,
    String? emergencyContact,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstName,
    String? lastName,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? allergies,
    String? medicalHistory,
    bool? emailVerified,
    String? profession,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      emailVerified: emailVerified ?? this.emailVerified,
      profession: profession ?? this.profession,
    );
  }

  // Conversion vers Map pour Firestore avec tous les champs
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'email': email,
      'profileImage': profileImage,
      'emergencyContact': emergencyContact,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalHistory': medicalHistory,
      'emailVerified': emailVerified,
      'profession': profession,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.now(),
    };
  }

  // Création à partir d'un document Firestore avec tous les champs
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'patient',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      emergencyContact: data['emergencyContact'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      address: data['address'],
      dateOfBirth: data['dateOfBirth'] != null ? (data['dateOfBirth'] as Timestamp).toDate() : null,
      gender: data['gender'],
      bloodType: data['bloodType'],
      allergies: data['allergies'],
      medicalHistory: data['medicalHistory'],
      emailVerified: data['emailVerified'] ?? false,
      profession: data['profession'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Méthode pour mettre à jour avec tous les champs
  Map<String, dynamic> toUpdate() {
    return {
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'emergencyContact': emergencyContact,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalHistory': medicalHistory,
      'emailVerified': emailVerified,
      'profession': profession,
      'updatedAt': Timestamp.now(),
    };
  }

  // Getters pratiques
  String get fullName => name;
  String get displayName => firstName != null ? '$firstName ${lastName ?? ""}'.trim() : name;
  
  bool get isPatient => role == 'patient';
  bool get isCenter => role == 'center';
  bool get isAdmin => role == 'admin';

  // Méthode pour obtenir l'âge (si dateOfBirth est disponible)
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}