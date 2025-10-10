import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vitalia/data/models/pharmacy_model.dart';

/// Service pour gérer les appels API liés aux pharmacies
class PharmacyService {
  // URL de base de l'API (à remplacer par votre vraie API)
  static const String _baseUrl = 'https://api.example.com/pharmacies';
  
  /// Récupère toutes les pharmacies du Bénin
  /// En attendant une vraie API, on retourne des données simulées
  Future<List<PharmacyModel>> getAllPharmacies() async {
    try {
      // TODO: Remplacer par un vrai appel API quand disponible
      // final response = await http.get(Uri.parse('$_baseUrl/benin'));
      // 
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => PharmacyModel.fromJson(json)).toList();
      // } else {
      //   throw Exception('Erreur lors du chargement des pharmacies');
      // }

      // Simulation d'un délai réseau
      await Future.delayed(Duration(seconds: 1));
      
      // Données simulées complètes pour le Bénin
      return _getMockPharmacies();
    } catch (e) {
      print('Erreur PharmacyService: $e');
      throw Exception('Erreur lors du chargement des pharmacies: $e');
    }
  }

  /// Récupère les pharmacies de garde
  Future<List<PharmacyModel>> getOnDutyPharmacies() async {
    try {
      // TODO: Appel API pour pharmacies de garde
      // final response = await http.get(Uri.parse('$_baseUrl/on-duty'));
      
      await Future.delayed(Duration(milliseconds: 500));
      
      final allPharmacies = await getAllPharmacies();
      return allPharmacies.where((p) => p.isOnDuty).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des pharmacies de garde: $e');
    }
  }

  /// Récupère les pharmacies par ville
  Future<List<PharmacyModel>> getPharmaciesByCity(String city) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      
      final allPharmacies = await getAllPharmacies();
      return allPharmacies
          .where((p) => p.city.toLowerCase().contains(city.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche par ville: $e');
    }
  }

  /// Recherche de pharmacies par nom ou adresse
  Future<List<PharmacyModel>> searchPharmacies(String query) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      
      final allPharmacies = await getAllPharmacies();
      return allPharmacies.where((pharmacy) {
        final nameMatch = pharmacy.name.toLowerCase().contains(query.toLowerCase());
        final addressMatch = pharmacy.address.toLowerCase().contains(query.toLowerCase());
        final cityMatch = pharmacy.city.toLowerCase().contains(query.toLowerCase());
        return nameMatch || addressMatch || cityMatch;
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche: $e');
    }
  }

  /// Données simulées pour les pharmacies du Bénin
  List<PharmacyModel> _getMockPharmacies() {
    return [
      // Cotonou
      PharmacyModel(
        id: '1',
        name: 'Pharmacie Le Sycomore',
        address: 'Avenue Steinmetz, Akpakpa',
        city: 'Cotonou',
        latitude: 6.3654,
        longitude: 2.4283,
        phone: '+229 21 33 44 55',
        isOnDuty: true,
        openingHours: '24h/24',
        email: 'sycomore@pharmacy.bj',
      ),
      PharmacyModel(
        id: '2',
        name: 'Pharmacie Magnificat',
        address: 'Carré 1247, Cococodji',
        city: 'Cotonou',
        latitude: 6.3679,
        longitude: 2.4281,
        phone: '+229 21 30 12 34',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 8h-20h',
        email: 'magnificat@pharmacy.bj',
      ),
      PharmacyModel(
        id: '3',
        name: 'Pharmacie du Plateau',
        address: 'Avenue Clozel',
        city: 'Cotonou',
        latitude: 6.3702,
        longitude: 2.4289,
        phone: '+229 21 31 22 33',
        isOnDuty: true,
        openingHours: '24h/24',
      ),
      PharmacyModel(
        id: '4',
        name: 'Pharmacie Sainte Rita',
        address: 'Boulevard de la Marina',
        city: 'Cotonou',
        latitude: 6.3625,
        longitude: 2.4251,
        phone: '+229 21 31 45 67',
        isOnDuty: false,
        openingHours: 'Lun-Ven: 8h-19h, Sam: 8h-13h',
      ),
      
      // Abomey-Calavi
      PharmacyModel(
        id: '5',
        name: 'Pharmacie Hevie Sari',
        address: 'Carrefour Hevie',
        city: 'Abomey-Calavi',
        latitude: 6.4545,
        longitude: 2.3567,
        phone: '+229 21 36 78 90',
        isOnDuty: true,
        openingHours: '24h/24',
      ),
      PharmacyModel(
        id: '6',
        name: 'Pharmacie Deo-Gratias',
        address: 'Cocotomey',
        city: 'Abomey-Calavi',
        latitude: 6.4321,
        longitude: 2.3456,
        phone: '+229 21 35 56 78',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 7h30-21h',
      ),
      PharmacyModel(
        id: '7',
        name: 'Pharmacie Calavi Centre',
        address: 'Route de Godomey',
        city: 'Abomey-Calavi',
        latitude: 6.4487,
        longitude: 2.3528,
        phone: '+229 21 37 89 01',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 8h-20h',
      ),
      
      // Porto-Novo
      PharmacyModel(
        id: '8',
        name: 'Pharmacie Centrale',
        address: 'Avenue du Gouverneur Bayol',
        city: 'Porto-Novo',
        latitude: 6.4969,
        longitude: 2.6289,
        phone: '+229 20 21 23 45',
        isOnDuty: true,
        openingHours: '24h/24',
      ),
      PharmacyModel(
        id: '9',
        name: 'Pharmacie du Marché',
        address: 'Près du Grand Marché',
        city: 'Porto-Novo',
        latitude: 6.4937,
        longitude: 2.6234,
        phone: '+229 20 22 34 56',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 8h-19h',
      ),
      
      // Parakou
      PharmacyModel(
        id: '10',
        name: 'Pharmacie Borgou',
        address: 'Route Nationale 2',
        city: 'Parakou',
        latitude: 9.3372,
        longitude: 2.6303,
        phone: '+229 23 61 23 45',
        isOnDuty: true,
        openingHours: '24h/24',
      ),
      PharmacyModel(
        id: '11',
        name: 'Pharmacie de l\'Espoir',
        address: 'Quartier Banikanni',
        city: 'Parakou',
        latitude: 9.3389,
        longitude: 2.6278,
        phone: '+229 23 61 34 56',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 7h-20h',
      ),
      
      // Bohicon
      PharmacyModel(
        id: '12',
        name: 'Pharmacie Zou',
        address: 'Carrefour Principal',
        city: 'Bohicon',
        latitude: 7.1781,
        longitude: 2.0667,
        phone: '+229 22 51 12 34',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 8h-19h',
      ),
      
      // Ouidah
      PharmacyModel(
        id: '13',
        name: 'Pharmacie Océane',
        address: 'Route de la Plage',
        city: 'Ouidah',
        latitude: 6.3637,
        longitude: 2.0850,
        phone: '+229 21 34 12 34',
        isOnDuty: true,
        openingHours: '24h/24',
      ),
      PharmacyModel(
        id: '14',
        name: 'Pharmacie Python',
        address: 'Centre-ville',
        city: 'Ouidah',
        latitude: 6.3589,
        longitude: 2.0834,
        phone: '+229 21 34 23 45',
        isOnDuty: false,
        openingHours: 'Lun-Sam: 8h-18h',
      ),
      
      // Natitingou
      PharmacyModel(
        id: '15',
        name: 'Pharmacie Atacora',
        address: 'Avenue Kérékou',
        city: 'Natitingou',
        latitude: 10.3042,
        longitude: 1.3794,
        phone: '+229 23 82 12 34',
        isOnDuty: false,
        openingHours: 'Lun-Ven: 8h-18h, Sam: 8h-13h',
      ),
    ];
  }
}

