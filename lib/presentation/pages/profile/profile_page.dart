// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:vitalia/presentation/pages/insurances/insurances.dart';
import 'package:vitalia/presentation/pages/profile/insurance_detail_page.dart';
import 'personal_info_page.dart';
import 'medical_constants_page.dart';

// Classe pour la page principale du profil avec onglets
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Création de l'état de la page de profil
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// État de la page de profil avec gestion des onglets
class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  // Contrôleur pour les onglets
  late TabController _tabController;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    // Création du contrôleur avec 3 onglets
    _tabController = TabController(length: 3, vsync: this);
  }

  // Construction de l'interface de la page de profil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'), // Titre de la page
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icône de retour
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        bottom: TabBar( // Barre d'onglets
          controller: _tabController, // Contrôleur des onglets
          tabs: [
            Tab(text: 'PROFIL'), // Onglet Profil
            Tab(text: 'CONSTANTES'), // Onglet Constantes
            Tab(text: 'ASSURANCES'), // Onglet Assurances
          ],
        ),
      ),
      body: TabBarView( // Contenu des onglets
        controller: _tabController,
        children: [
          PersonalInfoPage(), // Page des informations personnelles
          MedicalConstantsPage(), // Page des constantes médicales
          InsuranceDetailPage(), // Page des assurances
        ],
      ),
    );
  }

  // Nettoyage des ressources
  @override
  void dispose() {
    _tabController.dispose(); // Destruction du contrôleur
    super.dispose();
  }
}