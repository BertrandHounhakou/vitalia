// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

// Classe pour la page d'accueil principale avec état
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // Création de l'état de la page d'accueil
  @override
  _HomePageState createState() => _HomePageState();
}

// État de la page d'accueil
class _HomePageState extends State<HomePage> {
  // Index courant du carrousel d'images
  int _currentCarouselIndex = 0;
  
  // Liste des images du carrousel
  final List<String> carouselImages = [
    'assets/images/carousel1.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
  ];

  // Liste des éléments de la page d'accueil avec leurs routes
  final List<Map<String, dynamic>> homeItems = [
    {
      'title': 'Annuaire',
      'icon': Icons.contacts,
      'route': '/directory',
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
      'icon': Icons.verified_user,
      'route': '/insurances',
    },
    {
      'title': 'Blog',
      'icon': Icons.article,
      'route': '/blog',
    },
  ];

  // Construction de l'interface de la page d'accueil
  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.name ?? 'Utilisateur';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bonjour $userName !'), // Titre personnalisé avec le nom
        leading: IconButton(
          icon: Icon(Icons.menu), // Icône du menu
          onPressed: () {
            Navigator.pushNamed(context, '/menu'); // Navigation vers le menu
          },
        ),
      ),
      body: SingleChildScrollView( // Permet le défilement
        child: Column(
          children: [
            // Section du carrousel d'images
            CarouselSlider(
              items: carouselImages.map((imagePath) {
                return Container(
                  margin: EdgeInsets.all(5.0), // Marge autour de chaque image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0), // Coins arrondis
                    image: DecorationImage(
                      image: AssetImage(imagePath), // Image depuis les assets
                      fit: BoxFit.cover, // Adaptation de l'image
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180.0, // Hauteur du carrousel
                autoPlay: true, // Lecture automatique
                enlargeCenterPage: true, // Agrandissement de l'image centrale
                aspectRatio: 16/9, // Ratio d'aspect
                autoPlayCurve: Curves.fastOutSlowIn, // Courbe d'animation
                enableInfiniteScroll: true, // Défilement infini
                autoPlayAnimationDuration: Duration(milliseconds: 800), // Durée d'animation
                viewportFraction: 0.8, // Fraction de la vue
                onPageChanged: (index, reason) { // Callback du changement de page
                  setState(() {
                    _currentCarouselIndex = index; // Mise à jour de l'index
                  });
                },
              ),
            ),
            SizedBox(height: 20), // Espacement
            
            // Indicateurs de position du carrousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrage horizontal
              children: carouselImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0, // Largeur des indicateurs
                  height: 8.0, // Hauteur des indicateurs
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Marge
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Forme circulaire
                    color: _currentCarouselIndex == entry.key // Couleur conditionnelle
                        ? Theme.of(context).primaryColor // Couleur primaire si actif
                        : Colors.grey, // Gris si inactif
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20), // Espacement
            
            // Grille des services de l'application
            GridView.builder(
              shrinkWrap: true, // Rétrécissement pour s'adapter au contenu
              physics: NeverScrollableScrollPhysics(), // Désactive le défilement propre
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 colonnes
                crossAxisSpacing: 10, // Espacement horizontal entre les éléments
                mainAxisSpacing: 10, // Espacement vertical entre les éléments
                childAspectRatio: 0.9, // Ratio largeur/hauteur des enfants
              ),
              itemCount: homeItems.length, // Nombre d'éléments
              itemBuilder: (context, index) {
                return _buildServiceItem(homeItems[index]); // Construction de chaque élément
              },
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire un élément de service
  Widget _buildServiceItem(Map<String, dynamic> item) {
    return Card(
      elevation: 2, // Élévation de la carte
      child: InkWell( // Effet de clic
        onTap: () {
          Navigator.pushNamed(context, item['route']); // Navigation vers la route
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
          children: [
            Icon(item['icon'], size: 30, color: Theme.of(context).primaryColor), // Icône
            SizedBox(height: 8), // Espacement
            Text(
              item['title'], // Titre du service
              textAlign: TextAlign.center, // Centrage du texte
              style: TextStyle(fontSize: 12), // Taille de police réduite
            ),
          ],
        ),
      ),
    );
  }
}