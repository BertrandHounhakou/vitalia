// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/data/models/appointment_model.dart';
import 'package:vitalia/presentation/providers/appointment_provider.dart';
import 'package:vitalia/presentation/widgets/appointment_card.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'book_appointment_page.dart';

// Classe pour la page des rendez-vous avec état et onglets
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  // Création de l'état de la page des rendez-vous
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

// État de la page des rendez-vous avec gestion des onglets
class _AppointmentsPageState extends State<AppointmentsPage> with SingleTickerProviderStateMixin {
  // Contrôleur pour les onglets
  late TabController _tabController;
  
  // Référence au provider des rendez-vous
  late AppointmentProvider _appointmentProvider;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    // Création du contrôleur avec 2 onglets
    _tabController = TabController(length: 2, vsync: this);
    
    // Chargement des rendez-vous
    _loadAppointments();
  }

  // Méthode pour charger les rendez-vous
  Future<void> _loadAppointments() async {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    // Simulation - À remplacer par le vrai chargement
    await appointmentProvider.loadCenterAppointments('current_center_id');
  }

  // Construction de l'interface de la page des rendez-vous
  @override
  Widget build(BuildContext context) {
    // Récupération du provider
    _appointmentProvider = Provider.of<AppointmentProvider>(context);

    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Mes Rendez-vous',
        showMenuButton: true,
      ),
      
      // Menu latéral
      drawer: MenuPage(),
      
      body: Column(
        children: [
          // Barre d'onglets sur fond blanc
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF26A69A), // Indicateur vert-bleu
              indicatorWeight: 3,
              labelColor: Color(0xFF26A69A), // Texte onglet actif
              unselectedLabelColor: Colors.grey, // Texte onglet inactif
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'À VENIR'),
                Tab(text: 'PASSÉS'),
              ],
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet des rendez-vous à venir
                _buildAppointmentsList(_appointmentProvider.appointments.where((apt) => 
                  !apt.isPast && apt.status != 'cancelled').toList(), true),
                
                // Onglet des rendez-vous passés
                _buildAppointmentsList(_appointmentProvider.appointments.where((apt) => 
                  apt.isPast || apt.status == 'cancelled').toList(), false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Bouton flottant d'ajout
        onPressed: () {
          Navigator.push( // Navigation vers la page de prise de RDV
            context,
            MaterialPageRoute(builder: (context) => BookAppointmentPage()),
          );
        },
        child: Icon(Icons.add), // Icône d'ajout
        tooltip: 'Prendre un rendez-vous', // Info-bulle
      ),
    );
  }

  // Méthode pour construire la liste des rendez-vous
  Widget _buildAppointmentsList(List<AppointmentModel> appointments, bool isUpcoming) {
    if (_appointmentProvider.isLoading) { // Pendant le chargement
      return Center(child: CircularProgressIndicator()); // Indicateur de chargement
    }

    if (appointments.isEmpty) { // Si aucun rendez-vous
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
          children: [
            Icon( // Icône de calendrier
              Icons.calendar_today,
              size: 64, // Taille de l'icône
              color: Colors.grey, // Couleur grise
            ),
            SizedBox(height: 16), // Espacement
            Text(
              'Pas de RDV !', // Message principal
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style
            ),
            SizedBox(height: 8), // Espacement
            Text(
              'Souhaitez-vous en prendre maintenant ?', // Message secondaire
              textAlign: TextAlign.center, // Centrage du texte
            ),
            SizedBox(height: 16), // Espacement
            ElevatedButton(
              onPressed: () {
                Navigator.push( // Navigation vers la prise de RDV
                  context,
                  MaterialPageRoute(builder: (context) => BookAppointmentPage()),
                );
              },
              child: Text('Prendre un rendez-vous'), // Texte du bouton
            ),
          ],
        ),
      );
    }

    return ListView.builder( // Liste des rendez-vous
      itemCount: appointments.length, // Nombre de rendez-vous
      itemBuilder: (context, index) {
        final appointment = appointments[index]; // Rendez-vous courant
        return AppointmentCard(appointment: appointment); // Carte de rendez-vous
      },
    );
  }

  // Nettoyage des ressources
  @override
  void dispose() {
    _tabController.dispose(); // Destruction du contrôleur
    super.dispose();
  }
}