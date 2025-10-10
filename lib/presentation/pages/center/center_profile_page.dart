// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/menu/center_menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'center_info_page.dart';
import 'center_specialties_page.dart';

/// Classe pour la page principale du profil du centre avec onglets
class CenterProfilePage extends StatefulWidget {
  const CenterProfilePage({Key? key}) : super(key: key);

  @override
  _CenterProfilePageState createState() => _CenterProfilePageState();
}

/// État de la page de profil du centre avec gestion des onglets
class _CenterProfilePageState extends State<CenterProfilePage> with SingleTickerProviderStateMixin {
  // Contrôleur pour les onglets
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Création du contrôleur avec 2 onglets
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final centerName = authProvider.currentUser?.name ?? 'Centre de santé';

    return Scaffold(
      // AppBar personnalisée avec dégradé
      appBar: CustomAppBar(
        title: 'Profil du centre',
        showMenuButton: true,
      ),
      
      // Menu latéral personnalisé pour Centre
      drawer: CenterMenuPage(),
      
      body: Column(
        children: [
          // En-tête avec informations du centre
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF26A69A),
                  child: Icon(
                    Icons.local_hospital,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  centerName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  authProvider.currentUser?.email ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Barre d'onglets
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF26A69A),
              indicatorWeight: 3,
              labelColor: Color(0xFF26A69A),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'INFORMATIONS'),
                Tab(text: 'SPÉCIALITÉS'),
              ],
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CenterInfoPage(),
                CenterSpecialtiesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

