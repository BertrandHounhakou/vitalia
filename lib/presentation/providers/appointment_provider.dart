// Import des packages Flutter et des modèles
import 'package:flutter/foundation.dart';
import 'package:vitalia/core/services/local_storage_service.dart';
import 'package:vitalia/core/services/appointment_service.dart';
import 'package:vitalia/data/models/appointment_model.dart';

// Provider pour la gestion des rendez-vous
class AppointmentProvider with ChangeNotifier {
  // Service Firebase pour les rendez-vous (initialisation lazy)
  AppointmentService? _appointmentService;
  
  // Getter pour obtenir le service (initialisation à la demande)
  AppointmentService get appointmentService {
    _appointmentService ??= AppointmentService();
    return _appointmentService!;
  }
  
  // Liste des rendez-vous
  List<AppointmentModel> _appointments = [];
  
  // Indicateur de chargement
  bool _isLoading = false;
  
  // Message d'erreur
  String? _error;

  // Getter pour la liste des rendez-vous
  List<AppointmentModel> get appointments => _appointments;
  
  // Getter pour l'état de chargement
  bool get isLoading => _isLoading;
  
  // Getter pour l'erreur
  String? get error => _error;

  // Méthode pour charger les rendez-vous d'un patient depuis Firestore
  Future<void> loadPatientAppointments(String patientId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _appointments = await appointmentService.getPatientAppointments(patientId);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des rendez-vous: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour charger les rendez-vous d'un centre depuis Firestore
  Future<void> loadCenterAppointments(String centerId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _appointments = await appointmentService.getCenterAppointments(centerId);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des rendez-vous: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour récupérer les rendez-vous du jour
  List<AppointmentModel> getTodaysAppointments() {
    final now = DateTime.now();
    return _appointments.where((appointment) => 
      appointment.dateTime.year == now.year &&
      appointment.dateTime.month == now.month &&
      appointment.dateTime.day == now.day
    ).toList();
  }

  // Méthode pour ajouter un rendez-vous dans Firestore ET en local
  Future<void> addAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      print('📝 AppointmentProvider: Début ajout rendez-vous');
      print('📝 AppointmentProvider: Service initialisé: ${appointmentService != null}');
      
      // Sauvegarde dans Firestore (PRIORITAIRE)
      await appointmentService.createAppointment(appointment);
      print('✅ Rendez-vous sauvegardé dans Firestore');
      
      // Sauvegarde locale pour le mode hors-ligne (OPTIONNELLE)
      try {
        await LocalStorageService.saveAppointment(appointment);
        print('✅ Rendez-vous sauvegardé localement');
      } catch (hiveError) {
        // Hive peut ne pas fonctionner sur Web, c'est OK
        print('⚠️ Sauvegarde locale ignorée (mode Web): $hiveError');
      }
      
      // Ajout à la liste locale
      _appointments.add(appointment);
      _error = null;
      
      print('✅ AppointmentProvider: Rendez-vous ajouté avec succès');
    } catch (e) {
      _error = 'Erreur lors de l\'ajout du rendez-vous: $e';
      print('❌ AppointmentProvider: $_error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour annuler un rendez-vous dans Firestore
  Future<void> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Annulation dans Firestore
      await appointmentService.cancelAppointment(appointmentId);
      
      // Mise à jour de la liste locale
      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        final appointment = _appointments[index];
        final updatedAppointment = AppointmentModel(
          id: appointment.id,
          patientId: appointment.patientId,
          centerId: appointment.centerId,
          dateTime: appointment.dateTime,
          status: 'cancelled',
          notes: appointment.notes,
        );
        
        // Sauvegarde locale (optionnelle)
        try {
          await LocalStorageService.saveAppointment(updatedAppointment);
        } catch (hiveError) {
          print('⚠️ Sauvegarde locale ignorée: $hiveError');
        }
        
        _appointments[index] = updatedAppointment;
      }
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de l\'annulation du rendez-vous: $e';
      print('❌ AppointmentProvider: $_error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}