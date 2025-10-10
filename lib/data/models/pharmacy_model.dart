/// Modèle de données pour une pharmacie
class PharmacyModel {
  // Identifiant unique de la pharmacie
  final String id;
  
  // Nom de la pharmacie
  final String name;
  
  // Adresse complète
  final String address;
  
  // Ville
  final String city;
  
  // Latitude GPS
  final double latitude;
  
  // Longitude GPS
  final double longitude;
  
  // Distance en kilomètres (calculée depuis la position de l'utilisateur)
  final double? distance;
  
  // Indicateur de garde (24h/24)
  final bool isOnDuty;
  
  // Numéro de téléphone
  final String phone;
  
  // Horaires d'ouverture
  final String? openingHours;
  
  // Email (optionnel)
  final String? email;

  // Constructeur de PharmacyModel
  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.distance,
    required this.isOnDuty,
    required this.phone,
    this.openingHours,
    this.email,
  });

  // Méthode fromJson
  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      distance: json['distance']?.toDouble(),
      isOnDuty: json['isOnDuty'] ?? false,
      phone: json['phone'] ?? '',
      openingHours: json['openingHours'],
      email: json['email'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'isOnDuty': isOnDuty,
      'phone': phone,
      'openingHours': openingHours,
      'email': email,
    };
  }
  
  // Méthode pour créer une copie avec une distance calculée
  PharmacyModel copyWith({double? distance}) {
    return PharmacyModel(
      id: id,
      name: name,
      address: address,
      city: city,
      latitude: latitude,
      longitude: longitude,
      distance: distance ?? this.distance,
      isOnDuty: isOnDuty,
      phone: phone,
      openingHours: openingHours,
      email: email,
    );
  }
}