// Import des packages Hive et path_provider
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitalia/data/models/appointment_model.dart';
import 'package:vitalia/data/models/hospital_model.dart';
import 'package:vitalia/data/models/insurance_model.dart';
import 'package:vitalia/data/models/pharmacy_model.dart';
import 'package:vitalia/data/models/user_model.dart';

// Service de stockage local utilisant Hive
class LocalStorageService {
  // Méthode d'initialisation du stockage local
  static Future<void> init() async {
    // Obtention du répertoire de documents de l'application
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    
    // Initialisation de Hive avec le chemin du répertoire
    Hive.init(appDocumentDirectory.path);
    
    // Ouverture des différentes boîtes (tables) de stockage
    await Hive.openBox<UserModel>('users');
    await Hive.openBox<AppointmentModel>('appointments');
    await Hive.openBox<HospitalModel>('hospitals');
    await Hive.openBox<PharmacyModel>('pharmacies');
    await Hive.openBox<InsuranceModel>('insurances');
    await Hive.openBox('settings');
  }

  // Méthode pour sauvegarder un utilisateur
  static Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>('users');
    await box.put(user.id, user);
  }

  // Méthode pour récupérer un utilisateur par ID
  static UserModel? getUser(String userId) {
    final box = Hive.box<UserModel>('users');
    return box.get(userId);
  }

  // Méthode pour sauvegarder un rendez-vous
  static Future<void> saveAppointment(AppointmentModel appointment) async {
    final box = Hive.box<AppointmentModel>('appointments');
    await box.put(appointment.id, appointment);
  }

  // Méthode pour récupérer les rendez-vous d'un patient
  static List<AppointmentModel> getPatientAppointments(String patientId) {
    final box = Hive.box<AppointmentModel>('appointments');
    return box.values.where((appointment) => appointment.patientId == patientId).toList();
  }

  // Méthode pour effacer toutes les données
  static Future<void> clearAllData() async {
    final boxes = [
      Hive.box<UserModel>('users'),
      Hive.box<AppointmentModel>('appointments'),
      Hive.box<HospitalModel>('hospitals'),
      Hive.box<PharmacyModel>('pharmacies'),
      Hive.box<InsuranceModel>('insurances'),
      Hive.box('settings'),
    ];
    
    for (final box in boxes) {
      await box.clear();
    }
  }

  // Méthode pour fermer toutes les boîtes
  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}