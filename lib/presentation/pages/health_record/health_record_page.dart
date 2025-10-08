// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/profile/medical_constants_page.dart';
import 'package:vitalia/presentation/pages/menu/menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

/// Page du carnet de santé affichant les constantes médicales et l'historique des consultations
class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({Key? key}) : super(key: key);

  @override
  _HealthRecordPageState createState() => _HealthRecordPageState();
}

/// État de la page du carnet de santé
class _HealthRecordPageState extends State<HealthRecordPage> {
  // Liste des consultations (historique persistant)
  final List<Map<String, dynamic>> _consultations = [
    // Exemples de consultations - Ces données devraient venir de Firebase
    {
      'date': DateTime(2024, 3, 15, 10, 30),
      'doctorName': 'Dr. Dupont',
      'reason': 'Consultation de routine',
      'notes': 'Tout va bien, bon état général',
    },
    {
      'date': DateTime(2024, 2, 20, 14, 15),
      'doctorName': 'Dr. Martin',
      'reason': 'Suivi traitement',
      'notes': 'Traitement efficace, continuer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Récupération de l'utilisateur connecté et de ses constantes médicales
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      // Utilisation de l'AppBar personnalisée unifiée
      appBar: CustomAppBar(
        title: 'Mon carnet de santé',
        showMenuButton: true,
      ),
      
      // Menu latéral
      drawer: MenuPage(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section des constantes médicales
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre avec icône (sans bouton modifier)
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Color(0xFF2A9D8F),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Mes constantes médicales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Grille des constantes médicales (3 colonnes, cartes très compactes)
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3, // 3 colonnes
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1.0,
                    children: [
                      // Carte Groupe sanguin
                      _buildCompactConstantCard(
                        icon: Icons.bloodtype,
                        iconColor: Colors.red,
                        title: 'B+',
                        subtitle: 'Groupe sanguin',
                        value: user?.bloodType ?? 'N/A',
                      ),

                      // Carte Taille
                      _buildCompactConstantCard(
                        icon: Icons.height,
                        iconColor: Colors.blue,
                        title: '162',
                        subtitle: 'Taille',
                        value: _extractHeight(user?.medicalHistory),
                      ),

                      // Carte Poids
                      _buildCompactConstantCard(
                        icon: Icons.monitor_weight,
                        iconColor: Colors.orange,
                        title: '65',
                        subtitle: 'Poids',
                        value: _extractWeight(user?.medicalHistory),
                      ),

                      // Carte Glycémie
                      _buildCompactConstantCard(
                        icon: Icons.monitor_heart,
                        iconColor: Colors.pink,
                        title: '1',
                        subtitle: 'Glycémie',
                        value: _extractGlycemia(user?.medicalHistory),
                      ),

                      // Carte Électrophorèse
                      _buildCompactConstantCard(
                        icon: Icons.science,
                        iconColor: Colors.purple,
                        title: 'AA',
                        subtitle: 'Electrophorèse',
                        value: _extractElectrophoresis(user?.medicalHistory),
                      ),

                      // Carte IMC
                      _buildCompactConstantCard(
                        icon: Icons.calculate,
                        iconColor: Colors.teal,
                        title: '24,8',
                        subtitle: 'Imc',
                        value: _extractBMI(user?.medicalHistory),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Divider(thickness: 8, color: Colors.grey[200]),

            // Section de l'historique des consultations
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Color(0xFF2A9D8F),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Historique des consultations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Liste des consultations ou message vide
                  _consultations.isEmpty
                      ? _buildEmptyConsultationsMessage()
                      : Column(
                          children: _consultations.map((consultation) {
                            return _buildConsultationCard(consultation);
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bouton flottant pour ajouter une consultation
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddConsultationDialog();
        },
        backgroundColor: Color(0xFF2A9D8F),
        child: Icon(Icons.add),
        tooltip: 'Ajouter une consultation',
      ),
    );
  }

  /// Widget pour construire une carte de constante compacte (comme sur la photo)
  Widget _buildCompactConstantCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône (très petite)
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),

            SizedBox(height: 3),

            // Valeur principale (plus petite)
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2),

            // Libellé (très petit)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour construire une carte de consultation
  Widget _buildConsultationCard(Map<String, dynamic> consultation) {
    final date = consultation['date'] as DateTime;
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône avec fond coloré
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF2A9D8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medical_services,
                color: Color(0xFF2A9D8F),
                size: 24,
              ),
            ),

            SizedBox(width: 12),

            // Informations de la consultation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du docteur
                  Text(
                    consultation['doctorName'] ?? 'Docteur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4),

                  // Date et heure
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  // Raison de la consultation
                  Text(
                    consultation['reason'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Notes si disponibles
                  if (consultation['notes'] != null &&
                      consultation['notes'].toString().isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      consultation['notes'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour le message quand il n'y a pas de consultations
  Widget _buildEmptyConsultationsMessage() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Vous n\'avez effectué aucune consultation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Vos consultations apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Dialog pour ajouter une consultation
  void _showAddConsultationDialog() {
    final TextEditingController doctorController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une consultation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: doctorController,
                  decoration: InputDecoration(
                    labelText: 'Nom du docteur',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: 'Raison de la consultation',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (optionnel)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (doctorController.text.isNotEmpty &&
                    reasonController.text.isNotEmpty) {
                  setState(() {
                    _consultations.insert(0, {
                      'date': DateTime.now(),
                      'doctorName': doctorController.text,
                      'reason': reasonController.text,
                      'notes': notesController.text,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Consultation ajoutée avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  // Méthodes pour extraire les données du medicalHistory
  String _extractHeight(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Taille: (\d+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractWeight(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Poids: (\d+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractGlycemia(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Glycémie: ([\d.]+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractElectrophoresis(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'Électrophorèse: (\w+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }

  String _extractBMI(String? medicalHistory) {
    if (medicalHistory == null) return 'N/A';
    final match = RegExp(r'IMC: ([\d.]+)').firstMatch(medicalHistory);
    return match?.group(1) ?? 'N/A';
  }
}
