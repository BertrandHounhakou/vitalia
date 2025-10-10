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
  
  // Liste des données du carrousel (image, texte, bouton)
  final List<Map<String, String>> carouselData = [
    {
      'image': 'assets/images/carousel1.png',
      'text': 'Retrouvez la spécialité d\'urologie dans une clinique pas loin de chez vous',
      'buttonText': 'Trouver un hôpital',
      'route': '/hospitals',
    },
    {
      'image': 'assets/images/carousel2.png',
      'text': 'Retrouvez ici désormais toutes les pharmacies de garde proches de vous',
      'buttonText': 'Trouver une pharmacie de garde',
      'route': '/pharmacies',
    },
    {
      'image': 'assets/images/carousel3.png',
      'text': 'Obtenez instantanément le prix de vos médicaments sans vous déplacer',
      'buttonText': 'Commencer',
      'route': '/appointments',
    },
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
                    
                    // Hauteur fixe du carrousel (augmentée pour le contenu)
                    height: 200,
                    
                    child: Stack(
                      children: [
                        // Widget CarouselSlider pour le diaporama
                        CarouselSlider(
                          items: carouselData.isNotEmpty ? carouselData.map((carouselItem) {
                            return Container(
                              // Largeur maximale
                              width: double.infinity,
                              
                              // Décoration du conteneur
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              
                              child: ClipRRect(
                                // Coins arrondis pour le contenu
                                borderRadius: BorderRadius.circular(12),
                                
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Image de fond
                                    Image.asset(
                                      carouselItem['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Image de fallback si l'asset n'est pas trouvé
                                        return Container(
                                          color: Color(0xFF4CAF50),
                                          child: Icon(
                                      Icons.image,
                                            color: Colors.white.withOpacity(0.7),
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
                                    
                                    // Overlay sombre pour améliorer la lisibilité du texte
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // Contenu : texte et bouton
                                    Padding(
                                      padding: EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 20),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Colonne de gauche : texte et bouton
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Texte promotionnel sur deux lignes
                                                Text(
                                                  carouselItem['text']!,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.3,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(0, 1),
                                                        blurRadius: 3.0,
                                                        color: Colors.black.withOpacity(0.5),
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                
                                                // Espacement
                                                SizedBox(height: 16),
                                                
                                                // Bouton d'action
                                    ElevatedButton(
                                      onPressed: () {
                                                    Navigator.pushNamed(context, carouselItem['route']!);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white, // Fond blanc
                                                    foregroundColor: Colors.black, // Texte noir
                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20), // Bouton arrondi
                                        ),
                                                    elevation: 4,
                                      ),
                                      child: Text(
                                                    carouselItem['buttonText']!,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Espacement pour centrer le contenu
                                          Expanded(flex: 2, child: SizedBox()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList() : [],
                          
                          // Options du carrousel
                          options: CarouselOptions(
                            height: 200, // Hauteur augmentée
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
                        
                        // Indicateurs de points en bas
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: carouselData.isNotEmpty ? carouselData.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentCarouselIndex == entry.key
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                ),
                              );
                            }).toList() : [],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Espacement entre le carrousel et la grille (réduit)
                  SizedBox(height: 8),
                  
                  // Grille des services avec 2 colonnes
                  Padding(
                    // Padding horizontal autour de la grille (augmenté pour compenser l'espacement)
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    
                    child: GridView.builder(
                      // Rétrécissement pour s'adapter au contenu
                      shrinkWrap: true,
                      
                      // Désactive le défilement propre (géré par le parent)
                      physics: NeverScrollableScrollPhysics(),
                      
                      // Configuration de la grille
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 colonnes
                        crossAxisSpacing: 20, // Espacement horizontal augmenté
                        mainAxisSpacing: 15, // Espacement vertical augmenté
                        childAspectRatio: 1.8, // Ratio augmenté pour cartes plus plates et petites
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
                // Couleur de fond teal
                backgroundColor: Color(0xFF26A69A),
                
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
