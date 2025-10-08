// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/core/services/firebase_user_service.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/presentation/pages/center/patient_history_page.dart';

/// Page de recherche et visualisation des patients
/// Permet aux centres de santé de trouver un patient et voir son historique
class PatientsListPage extends StatefulWidget {
  const PatientsListPage({Key? key}) : super(key: key);

  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  // Service utilisateur
  final FirebaseUserService _userService = FirebaseUserService();
  
  // Contrôleur de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Liste des patients
  List<UserModel> _patients = [];
  List<UserModel> _filteredPatients = [];
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  /// Charger tous les patients
  Future<void> _loadPatients() async {
    try {
      final users = await _userService.getUsers();
      
      setState(() {
        // Filtrer uniquement les patients
        _patients = users.where((user) => user.role == 'patient').toList();
        _filteredPatients = _patients;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement patients: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Filtrer les patients selon la recherche
  void _filterPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPatients = _patients;
      } else {
        _filteredPatients = _patients.where((patient) {
          final nameMatch = patient.name.toLowerCase().contains(query.toLowerCase());
          final phoneMatch = patient.phone.contains(query);
          final idMatch = patient.id.toLowerCase().contains(query.toLowerCase());
          return nameMatch || phoneMatch || idMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Rechercher un patient',
        showMenuButton: false,
      ),

      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher par nom, téléphone ou ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPatients('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterPatients,
            ),
          ),

          // En-tête avec nombre de résultats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.people, size: 20, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  '${_filteredPatients.length} patient(s) trouvé(s)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Liste des patients
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredPatients.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = _filteredPatients[index];
                          return _buildPatientCard(patient);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// Widget pour construire une carte patient
  Widget _buildPatientCard(UserModel patient) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        
        // Avatar
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF2A9D8F),
          backgroundImage: patient.profileImage != null
              ? NetworkImage(patient.profileImage!)
              : null,
          child: patient.profileImage == null
              ? Text(
                  patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : null,
        ),

        // Informations patient
        title: Text(
          patient.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(patient.phone),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.badge, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'ID: ${patient.id.substring(0, 8)}...',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            if (patient.bloodType != null) ...[
              SizedBox(height: 4),
              Chip(
                label: Text(
                  'Groupe: ${patient.bloodType}',
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
                backgroundColor: Colors.red,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),

        // Bouton pour voir l'historique
        trailing: Icon(Icons.chevron_right, color: Colors.grey),

        // Action au clic
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientHistoryPage(patient: patient),
            ),
          );
        },
      ),
    );
  }

  /// Widget pour l'état vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Aucun patient enregistré'
                : 'Aucun patient trouvé',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Essayez une autre recherche',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

