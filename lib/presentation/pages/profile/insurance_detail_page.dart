// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
//import 'package:vitalia/data/models/user_model.dart';

// Classe pour la page détaillée de gestion des assurances
class InsuranceDetailPage extends StatefulWidget {
  const InsuranceDetailPage({Key? key}) : super(key: key);

  // Création de l'état de la page
  @override
  _InsuranceDetailPageState createState() => _InsuranceDetailPageState();
}

// État de la page détaillée des assurances
class _InsuranceDetailPageState extends State<InsuranceDetailPage> {
  // Liste des assurances de l'utilisateur
  List<Map<String, dynamic>> _insurances = [];
  
  // Liste des assurances disponibles
  final List<Map<String, dynamic>> _availableInsurances = [
    {'id': '1', 'name': 'AFRICAINE DES ASSURANCES'},
    {'id': '2', 'name': 'ALLIANZ ASSURANCES'},
    {'id': '3', 'name': 'ARGG'},
    {'id': '4', 'name': 'SCOMA SANTE BENIN'},
    {'id': '5', 'name': 'ATLANTIQUE ASSURANCES'},
    {'id': '6', 'name': 'BECOTRAC'},
    {'id': '7', 'name': 'CIF et VIE'},
  ];

  // Indicateur de chargement
  bool _isLoading = true;
  bool _isSaving = false;

  // Initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadInsurances();
  }

  // Méthode pour charger les assurances depuis Firestore
  Future<void> _loadInsurances() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user != null && user.medicalHistory != null && user.medicalHistory!.contains('Assurances:')) {
        // Extraire les assurances depuis medicalHistory
        final insuranceData = _parseInsurancesFromMedicalHistory(user.medicalHistory!);
        setState(() {
          _insurances = insuranceData;
        });
      }
    } catch (e) {
      print('Erreur chargement assurances: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Parser les assurances depuis medicalHistory
  List<Map<String, dynamic>> _parseInsurancesFromMedicalHistory(String medicalHistory) {
    final List<Map<String, dynamic>> insurances = [];
    
    try {
      if (medicalHistory.contains('Assurances:')) {
        final insurancePart = medicalHistory.split('Assurances:')[1].split('|||')[0];
        final insuranceEntries = insurancePart.split(';');
        
        for (final entry in insuranceEntries) {
          if (entry.trim().isNotEmpty) {
            final parts = entry.split('|');
            if (parts.length >= 3) {
              insurances.add({
                'name': parts[0].trim(),
                'startDate': parts[1].trim(),
                'endDate': parts[2].trim(),
              });
            }
          }
        }
      }
    } catch (e) {
      print('Erreur parsing assurances: $e');
    }
    
    return insurances;
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Assurances'),
        backgroundColor: Color(0xFF2A7FDE),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _insurances.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucune assurance enregistrée',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Appuyez sur le bouton + pour ajouter une assurance',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // En-tête informatif
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_insurances.length} assurance(s) enregistrée(s)',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Liste des assurances
                    Expanded(
                      child: ListView.builder(
                        itemCount: _insurances.length,
                        itemBuilder: (context, index) {
                          final insurance = _insurances[index];
                          return _buildInsuranceCard(insurance, index);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _isSaving
          ? FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : FloatingActionButton(
              onPressed: _showAddInsuranceDialog,
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF2A7FDE),
              tooltip: 'Ajouter une assurance',
            ),
    );
  }

  // Méthode pour construire une carte d'assurance
  Widget _buildInsuranceCard(Map<String, dynamic> insurance, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.health_and_safety, color: Colors.purple, size: 24),
        ),
        title: Text(
          insurance['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            if (insurance['startDate'] != null && insurance['endDate'] != null)
              Text(
                'Valide du ${insurance['startDate']} au ${insurance['endDate']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            SizedBox(height: 4),
            _buildValidityStatus(insurance),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => _editInsurance(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _deleteInsurance(index),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour le statut de validité
  Widget _buildValidityStatus(Map<String, dynamic> insurance) {
    try {
      if (insurance['endDate'] != null) {
        final parts = insurance['endDate'].toString().split('/');
        if (parts.length == 3) {
          final endDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0])
          );
          final now = DateTime.now();
          
          if (endDate.isBefore(now)) {
            return Chip(
              label: Text('Expirée', style: TextStyle(color: Colors.white, fontSize: 10)),
              backgroundColor: Colors.red,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          } else if (endDate.difference(now).inDays <= 30) {
            return Chip(
              label: Text('Bientôt expirée', style: TextStyle(color: Colors.white, fontSize: 10)),
              backgroundColor: Colors.orange,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          } else {
            return Chip(
              label: Text('Valide', style: TextStyle(color: Colors.white, fontSize: 10)),
              backgroundColor: Colors.green,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          }
        }
      }
    } catch (e) {
      print('Erreur calcul validité: $e');
    }
    
    return SizedBox.shrink();
  }

  // Méthode pour afficher la dialog d'ajout d'assurance
  void _showAddInsuranceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une assurance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.health_and_safety, size: 48, color: Colors.purple),
              SizedBox(height: 16),
              Text(
                'Sélectionnez votre assurance dans la liste ci-dessous',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: _availableInsurances.length,
                itemBuilder: (context, index) {
                  final insurance = _availableInsurances[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.business, color: Colors.purple),
                      title: Text(insurance['name']),
                      onTap: () {
                        Navigator.pop(context);
                        _showInsuranceDetailsDialog(insurance);
                      },
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ANNULER'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher la dialog des détails de l'assurance
  void _showInsuranceDetailsDialog(Map<String, dynamic> insurance, {int? editIndex}) {
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    
    // Pré-remplir si édition
    if (editIndex != null && _insurances.length > editIndex) {
      final existingInsurance = _insurances[editIndex];
      startDateController.text = existingInsurance['startDate'] ?? '';
      endDateController.text = existingInsurance['endDate'] ?? '';
    }
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(insurance['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Période de validité de l\'assurance'),
              SizedBox(height: 16),
              
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Date de début',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(startDateController),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'Date de fin',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(endDateController),
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ANNULER'),
            ),
            ElevatedButton(
              onPressed: () {
                if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
                  if (editIndex != null) {
                    // Édition d'une assurance existante
                    _updateInsurance(editIndex, insurance, startDateController.text, endDateController.text);
                  } else {
                    // Ajout d'une nouvelle assurance
                    _addInsurance(insurance, startDateController.text, endDateController.text);
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez renseigner les dates de début et de fin'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: Text(editIndex != null ? 'MODIFIER' : 'AJOUTER'),
            ),
          ],
        );
      },
    );
  }

  // Ajouter une assurance
  void _addInsurance(Map<String, dynamic> insurance, String startDate, String endDate) {
    setState(() {
      _insurances.add({
        'name': insurance['name'],
        'startDate': startDate,
        'endDate': endDate,
      });
    });
    _saveInsurancesToFirestore();
  }

  // Modifier une assurance
  void _updateInsurance(int index, Map<String, dynamic> insurance, String startDate, String endDate) {
    setState(() {
      _insurances[index] = {
        'name': insurance['name'],
        'startDate': startDate,
        'endDate': endDate,
      };
    });
    _saveInsurancesToFirestore();
  }

  // Supprimer une assurance
  void _deleteInsurance(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer l\'assurance'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'assurance ${_insurances[index]['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _insurances.removeAt(index);
              });
              _saveInsurancesToFirestore();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }

  // Éditer une assurance
  void _editInsurance(int index) {
    final insurance = _insurances[index];
    _showInsuranceDetailsDialog(
      {'name': insurance['name']},
      editIndex: index,
    );
  }

  // Méthode pour sélectionner une date
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  // SAUVEGARDER LES ASSURANCES DANS FIRESTORE
  Future<void> _saveInsurancesToFirestore() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;

      if (currentUser != null) {
        // Construire la chaîne des assurances
        final insuranceString = _buildInsuranceString();
        
        // Mettre à jour l'utilisateur
        final updatedUser = currentUser.copyWith(
          medicalHistory: insuranceString,
          updatedAt: DateTime.now(),
        );

        // Sauvegarder dans Firestore
        await authProvider.updateUserProfile(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Assurances sauvegardées avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Construire la chaîne des assurances pour medicalHistory
  String _buildInsuranceString() {
    if (_insurances.isEmpty) {
      return '';
    }

    final insuranceEntries = _insurances.map((insurance) {
      return '${insurance['name']}|${insurance['startDate']}|${insurance['endDate']}';
    }).join(';');

    return 'Assurances:$insuranceEntries|||';
  }
}