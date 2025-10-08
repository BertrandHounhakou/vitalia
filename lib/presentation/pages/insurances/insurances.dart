// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/profile/insurance_detail_page.dart';
import 'package:vitalia/presentation/widgets/insurance_card.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

/// Page principale pour afficher et gérer les assurances de l'utilisateur
/// Affiche la liste des assurances avec statistiques et possibilité d'ajout
class InsurancesPage extends StatelessWidget {
  const InsurancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Mes Assurances',
        showMenuButton: true,
      ),
      
      // Menu latéral
      drawer: MenuPage(),
      
      body: Column(
        children: [
          // En-tête informatif
          Container(
            padding: EdgeInsets.all(16), // Padding interne
            color: Colors.blue[50], // Couleur de fond bleu clair
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
              children: [
                Text(
                  'Gestion des assurances santé',
                  style: TextStyle(
                    fontSize: 18, // Taille de la police
                    fontWeight: FontWeight.bold, // Texte en gras
                    color: Colors.blue[800], // Couleur bleu foncé
                  ),
                ),
                SizedBox(height: 8), // Espacement
                Text(
                  'Ajoutez et gérez vos assurances maladie pour faciliter vos démarches de santé',
                  style: TextStyle(
                    fontSize: 14, // Taille de la police
                    color: Colors.blue[700], // Couleur bleu moyen
                  ),
                ),
              ],
            ),
          ),
          
          // Section des statistiques
          Padding(
            padding: EdgeInsets.all(16), // Padding autour
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacement égal
              children: [
                _buildStatCard('Assurances', '3', Icons.verified_user, Colors.green), // Carte statistique
                _buildStatCard('Valides', '2', Icons.check_circle, Colors.blue), // Carte statistique
                _buildStatCard('Expirées', '1', Icons.warning, Colors.orange), // Carte statistique
              ],
            ),
          ),
          
          // Titre de section avec bouton d'ajout
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding horizontal et vertical
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement entre les éléments
              children: [
                Text(
                  'Mes assurances santé',
                  style: TextStyle(
                    fontSize: 18, // Taille de la police
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                ElevatedButton.icon(
                  // Bouton pour ajouter une assurance
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsuranceDetailPage(), // Page de détails d'assurance
                      ),
                    );
                  },
                  icon: Icon(Icons.add, size: 18), // Icône d'ajout
                  label: Text('Ajouter'), // Texte du bouton
                ),
              ],
            ),
          ),
          
          // Liste des assurances
          Expanded(
            child: _buildInsurancesList(context), // Construction de la liste
          ),
        ],
      ),
    );
  }

  /// Widget pour construire une carte de statistique
  /// Affiche une valeur avec une icône et un titre
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2, // Élévation de la carte
      child: Padding(
        padding: EdgeInsets.all(12), // Padding interne
        child: Column(
          children: [
            Icon(icon, size: 24, color: color), // Icône colorée
            SizedBox(height: 8), // Espacement
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Taille de la police
                fontWeight: FontWeight.bold, // Texte en gras
                color: color, // Couleur de la valeur
              ),
            ),
            SizedBox(height: 4), // Espacement
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // Taille de la police
                color: Colors.grey[600], // Couleur grise
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour construire la liste des assurances
  /// Utilise le widget InsuranceCard réutilisable
  Widget _buildInsurancesList(BuildContext context) {
    // Liste simulée des assurances - À remplacer par des données réelles
    final List<Map<String, dynamic>> insurances = [
      {
        'id': '1',
        'name': 'SCOMA SANTE BENIN',
        'number': '123456789',
        'status': 'Valide',
        'startDate': '01/01/2024', // Date de début
        'endDate': '31/12/2024', // Date de fin
        'color': Colors.green,
      },
      {
        'id': '2',
        'name': 'ATLANTIQUE ASSURANCES',
        'number': '987654321',
        'status': 'Valide',
        'startDate': '01/01/2024', // Date de début
        'endDate': '30/06/2024', // Date de fin
        'color': Colors.green,
      },
    ];

    // Si aucune assurance
    if (insurances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
          children: [
            Icon(Icons.verified_user, size: 64, color: Colors.grey), // Grande icône grise
            SizedBox(height: 16), // Espacement
            Text('Aucune assurance enregistrée'), // Message
          ],
        ),
      );
    }

    // Liste des assurances avec le widget réutilisable InsuranceCard
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16), // Padding horizontal
      itemCount: insurances.length, // Nombre d'assurances
      itemBuilder: (context, index) {
        final insurance = insurances[index]; // Assurance courante
        return InsuranceCard(insurance: insurance); // Utilisation du widget réutilisable
      },
    );
  }
}
