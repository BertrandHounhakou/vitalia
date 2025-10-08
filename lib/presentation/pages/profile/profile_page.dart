// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:vitalia/presentation/pages/profile/insurance_detail_page.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
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
      // AppBar personnalisée avec dégradé (avec bouton MENU)
      appBar: CustomAppBar(
        title: 'Mon profil',
        showMenuButton: true, // Bouton MENU
      ),
      
      // Menu latéral
      drawer: MenuPage(),
      
      body: Column(
        children: [
          // Barre d'onglets sur fond blanc (en dessous de l'AppBar)
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
                Tab(text: 'PROFIL'),
                Tab(text: 'CONSTANTES'),
                Tab(text: 'ASSURANCES'),
              ],
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PersonalInfoPage(), // Page des informations personnelles
                MedicalConstantsPage(), // Page des constantes médicales
                InsuranceDetailPage(), // Page des assurances
              ],
            ),
          ),
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