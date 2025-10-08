// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';

// Import des widgets réutilisables
import 'package:vitalia/presentation/widgets/service_card.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

/// Classe pour la page d'accueil principale avec état
/// Affiche le carrousel, les services et le bouton de rendez-vous
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // Création de l'état de la page d'accueil
  @override
  _HomePageState createState() => _HomePageState();
}

/// État de la page d'accueil
/// Gère l'index du carrousel et les données des services
class _HomePageState extends State<HomePage> {
  // Index courant du carrousel d'images
  int _currentCarouselIndex = 0;
  
  // Liste des images du carrousel
  // TODO: Remplacer par vos vraies images
  final List<String> carouselImages = [
    'assets/images/carousel1.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
  ];

  // Liste des services de l'application avec leurs informations
  // Chaque service contient : titre, icône et route de navigation
  final List<Map<String, dynamic>> homeItems = [
    {
      'title': 'Annuaire', // Titre affiché
      'icon': Icons.contacts, // Icône du service
      'route': '/directory', // Route de navigation
    },
    {
      'title': 'Rendez-vous',
      'icon': Icons.calendar_today,
      'route': '/appointments',
    },
    {
      'title': 'Mon carnet de santé',
      'icon': Icons.medical_services,
      'route': '/health-record',
    },
    {
      'title': 'Les pharmacies',
      'icon': Icons.local_pharmacy,
      'route': '/pharmacies',
    },
    {
      'title': 'Les hôpitaux',
      'icon': Icons.local_hospital,
      'route': '/hospitals',
    },
    {
      'title': 'Les assurances',
      'icon': Icons.shield,
      'route': '/insurances',
    },
  ];

  // Construction de l'interface de la page d'accueil
  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Récupération du nom de l'utilisateur connecté
    final userName = authProvider.currentUser?.name ?? 'Utilisateur';

    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Bonjour $userName !',
        showMenuButton: true,
      ),
      
      // Menu latéral (drawer)
      drawer: MenuPage(),
      
      // Corps de la page avec structure Column
      body: Column(
        children: [
          // Partie scrollable : carrousel + grille de services
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Section du carrousel d'images
                  Container(
                    // Marge autour du carrousel
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    
                    // Hauteur fixe du carrousel (ajustée)
                    height: 140,
                    
                    // Décoration : fond vert avec bordures arrondies
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF4CAF50), // Couleur verte
                    ),
                    
                    child: Stack(
                      children: [
                        // Widget CarouselSlider pour le diaporama
                        CarouselSlider(
                          items: carouselImages.map((imagePath) {
                            return Container(
                              // Largeur maximale
                              width: double.infinity,
                              
                              // Décoration du conteneur
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xFF4CAF50),
                              ),
                              
                              child: ClipRRect(
                                // Coins arrondis pour le contenu
                                borderRadius: BorderRadius.circular(12),
                                
                                child: Column(
                                  // Centrage vertical du contenu
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  
                                  children: [
                                    // Icône placeholder pour les images (plus petite)
                                    Icon(
                                      Icons.image,
                                      size: 35,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    
                                    // Espacement réduit
                                    SizedBox(height: 6),
                                    
                                    // Texte promotionnel (plus petit)
                                    Text(
                                      'Retrouvez votre Clinique\nCitadelle du cœur, Parakou sur\ngoMediCAL',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    
                                    // Espacement réduit
                                    SizedBox(height: 8),
                                    
                                    // Bouton d'action "Trouver un hôpital" (plus petit)
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/hospitals');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white, // Fond blanc
                                        foregroundColor: Color(0xFF4CAF50), // Texte vert
                                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20), // Bouton arrondi
                                        ),
                                      ),
                                      child: Text(
                                        'Trouver un hôpital',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          
                          // Options du carrousel
                          options: CarouselOptions(
                            height: 140, // Hauteur ajustée
                            autoPlay: true, // Lecture automatique
                            enlargeCenterPage: false, // Pas d'agrandissement
                            viewportFraction: 1.0, // Fraction de la vue
                            autoPlayInterval: Duration(seconds: 5), // Intervalle de 5 secondes
                            autoPlayAnimationDuration: Duration(milliseconds: 800), // Durée d'animation
                            
                            // Callback lors du changement de page
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentCarouselIndex = index;
                              });
                            },
                          ),
                        ),
                        
                        // Flèche de navigation gauche
                        Positioned(
                          left: 10,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.3), // Fond semi-transparent
                              child: Icon(Icons.chevron_left, color: Colors.white), // Icône blanche
                            ),
                          ),
                        ),
                        
                        // Flèche de navigation droite
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.3), // Fond semi-transparent
                              child: Icon(Icons.chevron_right, color: Colors.white), // Icône blanche
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Espacement entre le carrousel et la grille (réduit)
                  SizedBox(height: 8),
                  
                  // Grille des services avec 2 colonnes
                  Padding(
                    // Padding horizontal autour de la grille (réduit)
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    
                    child: GridView.builder(
                      // Rétrécissement pour s'adapter au contenu
                      shrinkWrap: true,
                      
                      // Désactive le défilement propre (géré par le parent)
                      physics: NeverScrollableScrollPhysics(),
                      
                      // Configuration de la grille
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 colonnes
                        crossAxisSpacing: 8, // Espacement horizontal réduit
                        mainAxisSpacing: 8, // Espacement vertical réduit
                        childAspectRatio: 1.4, // Ratio augmenté pour cartes plus plates
                      ),
                      
                      // Nombre total d'éléments
                      itemCount: homeItems.length,
                      
                      // Construction de chaque carte de service
                      itemBuilder: (context, index) {
                        final item = homeItems[index];
                        
                        // Utilisation du widget ServiceCard réutilisable
                        return ServiceCard(
                          title: item['title'], // Titre du service
                          icon: item['icon'], // Icône du service
                          route: item['route'], // Route de navigation
                        );
                      },
                    ),
                  ),
                  
                  // Espacement en bas de la grille (réduit)
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          // Bouton fixe en bas : "PRENDRE UN RENDEZ-VOUS"
          Container(
            // Largeur maximale (bord à bord)
            width: double.infinity,
            
            child: ElevatedButton(
              // Action au clic : navigation vers la page des rendez-vous
              onPressed: () {
                Navigator.pushNamed(context, '/appointments');
              },
              
              // Style du bouton
              style: ElevatedButton.styleFrom(
                // Couleur de fond verte
                backgroundColor: Color(0xFF4CAF50),
                
                // Padding vertical pour la hauteur
                padding: EdgeInsets.symmetric(vertical: 18),
                
                // Forme : coins carrés (pas de borderRadius)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                
                // Élévation pour l'ombre
                elevation: 8,
              ),
              
              // Texte du bouton
              child: Text(
                'PRENDRE UN RENDEZ-VOUS',
                style: TextStyle(
                  color: Colors.white, // Couleur du texte blanc
                  fontSize: 18, // Taille de la police
                  fontWeight: FontWeight.bold, // Texte en gras
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
