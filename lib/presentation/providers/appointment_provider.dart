// Import des packages Flutter et des modèles
import 'package:flutter/foundation.dart';
import 'package:vitalia/core/services/local_storage_service.dart';
import 'package:vitalia/data/models/appointment_model.dart';

// Provider pour la gestion des rendez-vous
class AppointmentProvider with ChangeNotifier {
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

  // Méthode pour charger les rendez-vous d'un centre
  Future<void> loadCenterAppointments(String centerId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulation - À remplacer par un appel API réel
      await Future.delayed(const Duration(seconds: 2));
      
      _appointments = [
        AppointmentModel(
          id: '1',
          patientId: 'patient_1',
          centerId: centerId,
          dateTime: DateTime.now().add(const Duration(days: 3)),
          status: 'scheduled',
          notes: 'Consultation de routine',
        ),
        AppointmentModel(
          id: '2',
          patientId: 'patient_2',
          centerId: centerId,
          dateTime: DateTime.now().add(const Duration(days: 5)),
          status: 'scheduled',
          notes: 'Suivi traitement',
        ),
      ];
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors du chargement des rendez-vous: $e';
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

  // Méthode pour ajouter un rendez-vous
  Future<void> addAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Sauvegarde locale
      await LocalStorageService.saveAppointment(appointment);
      _appointments.add(appointment);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de l\'ajout du rendez-vous: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour annuler un rendez-vous
  Future<void> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final appointment = _appointments.firstWhere((apt) => apt.id == appointmentId);
      final updatedAppointment = AppointmentModel(
        id: appointment.id,
        patientId: appointment.patientId,
        centerId: appointment.centerId,
        dateTime: appointment.dateTime,
        status: 'cancelled',
        notes: appointment.notes,
      );
      
      await LocalStorageService.saveAppointment(updatedAppointment);
      _appointments.removeWhere((apt) => apt.id == appointmentId);
      _appointments.add(updatedAppointment);
      
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de l\'annulation du rendez-vous: $e';
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