/// Modèle de données pour un médecin/spécialiste
class DoctorModel {
  /// Identifiant unique du médecin
  final String id;

  /// Nom complet du médecin
  final String name;

  /// Spécialité médicale (Gynécologie, Urologie, Généraliste, etc.)
  final String specialty;

  /// Liste des hôpitaux où le médecin travaille
  final List<String> hospitals;

  /// Numéro de téléphone
  final String? phone;

  /// Email
  final String? email;

  /// Photo de profil (URL)
  final String? photoUrl;

  /// Années d'expérience
  final int? yearsOfExperience;

  /// Description / Bio
  final String? description;

  /// Liste des traitements/services proposés
  final List<String>? treatments;

  /// Disponibilité (jours de consultation)
  final List<String>? availableDays;

  /// Horaires de consultation
  final String? consultationHours;

  /// Tarif de consultation
  final double? consultationFee;

  /// Note moyenne (0-5)
  final double? rating;

  /// Nombre d'avis
  final int? reviewCount;

  /// Constructeur
  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospitals,
    this.phone,
    this.email,
    this.photoUrl,
    this.yearsOfExperience,
    this.description,
    this.treatments,
    this.availableDays,
    this.consultationHours,
    this.consultationFee,
    this.rating,
    this.reviewCount,
  });

  /// Conversion depuis JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      hospitals: (json['hospitals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      phone: json['phone'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      yearsOfExperience: json['yearsOfExperience'],
      description: json['description'],
      treatments: (json['treatments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      consultationHours: json['consultationHours'],
      consultationFee: json['consultationFee']?.toDouble(),
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
    );
  }

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'hospitals': hospitals,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'yearsOfExperience': yearsOfExperience,
      'description': description,
      'treatments': treatments,
      'availableDays': availableDays,
      'consultationHours': consultationHours,
      'consultationFee': consultationFee,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}

