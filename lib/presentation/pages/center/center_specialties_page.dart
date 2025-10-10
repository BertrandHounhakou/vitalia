// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Page de gestion des spécialités médicales du centre
class CenterSpecialtiesPage extends StatefulWidget {
  const CenterSpecialtiesPage({Key? key}) : super(key: key);

  @override
  _CenterSpecialtiesPageState createState() => _CenterSpecialtiesPageState();
}

class _CenterSpecialtiesPageState extends State<CenterSpecialtiesPage> {
  final TextEditingController _specialtyController = TextEditingController();
  bool _isLoading = false;
  
  // Liste des spécialités médicales communes (suggestions)
  final List<String> _commonSpecialties = [
    'Cardiologie',
    'Dermatologie',
    'Gynécologie',
    'Pédiatrie',
    'Ophtalmologie',
    'Orthopédie',
    'ORL (Oto-rhino-laryngologie)',
    'Pneumologie',
    'Rhumatologie',
    'Neurologie',
    'Psychiatrie',
    'Endocrinologie',
    'Gastro-entérologie',
    'Urologie',
    'Néphrologie',
    'Oncologie',
    'Radiologie',
    'Anesthésiologie',
    'Médecine générale',
    'Urgences',
    'Soins dentaires',
    'Kinésithérapie',
    'Laboratoire d\'analyses',
    'Imagerie médicale',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final center = authProvider.currentUser;
        final specialties = center?.specialties ?? [];

        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Section d'ajout de spécialité
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Ajouter une spécialité',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _specialtyController,
                                decoration: InputDecoration(
                                  hintText: 'Ex: Cardiologie',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.medical_services),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onSubmitted: (_) => _addSpecialty(),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _addSpecialty,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF26A69A),
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Suggestions de spécialités
                        Text(
                          'Suggestions',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _commonSpecialties
                              .where((specialty) => !specialties.contains(specialty))
                              .take(6)
                              .map((specialty) {
                            return ActionChip(
                              label: Text(
                                specialty,
                                style: TextStyle(fontSize: 12),
                              ),
                              avatar: Icon(Icons.add, size: 16),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFF26A69A)),
                              onPressed: () => _addSpecialtyFromSuggestion(specialty),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Divider
                  Divider(height: 1),
                  
                  // Liste des spécialités actuelles
                  Expanded(
                    child: specialties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.medical_services_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Aucune spécialité ajoutée',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Ajoutez les spécialités disponibles dans votre centre',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: specialties.length,
                            itemBuilder: (context, index) {
                              final specialty = specialties[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF26A69A).withOpacity(0.1),
                                    child: Icon(
                                      Icons.medical_services,
                                      color: Color(0xFF26A69A),
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    specialty,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeSpecialty(specialty),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
      },
    );
  }

  /// Ajouter une spécialité
  Future<void> _addSpecialty() async {
    final specialtyName = _specialtyController.text.trim();
    
    if (specialtyName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer une spécialité'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCenter = authProvider.currentUser;

      if (currentCenter != null) {
        final currentSpecialties = currentCenter.specialties ?? [];
        
        if (currentSpecialties.contains(specialtyName)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cette spécialité existe déjà'),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final updatedSpecialties = [...currentSpecialties, specialtyName];
        final updatedCenter = currentCenter.copyWith(
          specialties: updatedSpecialties,
          updatedAt: DateTime.now(),
        );

        await authProvider.updateUserProfile(updatedCenter);

        _specialtyController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Spécialité ajoutée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Ajouter une spécialité depuis les suggestions
  Future<void> _addSpecialtyFromSuggestion(String specialty) async {
    _specialtyController.text = specialty;
    await _addSpecialty();
  }

  /// Supprimer une spécialité
  Future<void> _removeSpecialty(String specialty) async {
    // Confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "$specialty" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCenter = authProvider.currentUser;

      if (currentCenter != null) {
        final currentSpecialties = currentCenter.specialties ?? [];
        final updatedSpecialties = currentSpecialties.where((s) => s != specialty).toList();
        
        final updatedCenter = currentCenter.copyWith(
          specialties: updatedSpecialties,
          updatedAt: DateTime.now(),
        );

        await authProvider.updateUserProfile(updatedCenter);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Spécialité supprimée'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    super.dispose();
  }
}

