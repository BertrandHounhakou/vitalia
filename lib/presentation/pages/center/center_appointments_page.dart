// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/appointment_model.dart';
import 'package:vitalia/presentation/providers/appointment_provider.dart';

/// Page de gestion des rendez-vous pour les centres de santé
/// Permet de voir, confirmer, annuler les rendez-vous
class CenterAppointmentsPage extends StatefulWidget {
  const CenterAppointmentsPage({Key? key}) : super(key: key);

  @override
  _CenterAppointmentsPageState createState() => _CenterAppointmentsPageState();
}

class _CenterAppointmentsPageState extends State<CenterAppointmentsPage>
    with SingleTickerProviderStateMixin {
  // Contrôleur pour les onglets
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointments();
  }

  /// Charger les rendez-vous du centre
  Future<void> _loadAppointments() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final centerId = authProvider.currentUser?.id ?? '';
    
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    await appointmentProvider.loadCenterAppointments(centerId);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Gestion des rendez-vous',
        showMenuButton: false,
      ),

      body: Column(
        children: [
          // Barre d'onglets sur fond blanc
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF26A69A),
              indicatorWeight: 3,
              labelColor: Color(0xFF26A69A),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'EN ATTENTE'),
                Tab(text: 'CONFIRMÉS'),
                Tab(text: 'TERMINÉS'),
              ],
            ),
          ),

          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet En attente
                _buildAppointmentsList(
                  appointmentProvider.appointments
                      .where((apt) => apt.status == 'scheduled')
                      .toList(),
                  'scheduled',
                ),

                // Onglet Confirmés
                _buildAppointmentsList(
                  appointmentProvider.appointments
                      .where((apt) => apt.status == 'confirmed')
                      .toList(),
                  'confirmed',
                ),

                // Onglet Terminés
                _buildAppointmentsList(
                  appointmentProvider.appointments
                      .where((apt) => apt.status == 'completed' || apt.status == 'cancelled')
                      .toList(),
                  'completed',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget pour construire la liste des rendez-vous
  Widget _buildAppointmentsList(List<AppointmentModel> appointments, String status) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Aucun rendez-vous dans cette catégorie',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment, status);
      },
    );
  }

  /// Widget pour construire une carte de rendez-vous
  Widget _buildAppointmentCard(AppointmentModel appointment, String status) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(appointment.dateTime);
    final formattedTime = DateFormat('HH:mm').format(appointment.dateTime);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec ID et statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RDV #${appointment.id.substring(0, 8)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    _getStatusText(appointment.status),
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(appointment.status),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),

            Divider(),

            // Informations patient
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Patient ID: ${appointment.patientId.substring(0, 8)}...',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Date et heure
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('$formattedDate à $formattedTime'),
              ],
            ),

            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(child: Text(appointment.notes!)),
                ],
              ),
            ],

            // Actions si rendez-vous en attente
            if (status == 'scheduled') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmAppointment(appointment),
                      icon: Icon(Icons.check, size: 16),
                      label: Text('Confirmer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelAppointment(appointment),
                      icon: Icon(Icons.close, size: 16),
                      label: Text('Annuler'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Confirmer un rendez-vous
  void _confirmAppointment(AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer le rendez-vous'),
        content: Text('Voulez-vous confirmer ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Mettre à jour le statut dans Firebase
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rendez-vous confirmé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  /// Annuler un rendez-vous
  void _cancelAppointment(AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler le rendez-vous'),
        content: Text('Voulez-vous vraiment annuler ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Mettre à jour le statut dans Firebase
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rendez-vous annulé'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Annuler RDV'),
          ),
        ],
      ),
    );
  }

  /// Obtenir le texte du statut
  String _getStatusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'EN ATTENTE';
      case 'confirmed':
        return 'CONFIRMÉ';
      case 'cancelled':
        return 'ANNULÉ';
      case 'completed':
        return 'TERMINÉ';
      default:
        return status.toUpperCase();
    }
  }

  /// Obtenir la couleur selon le statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

