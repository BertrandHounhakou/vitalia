// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Page des informations du centre de santé
class CenterInfoPage extends StatefulWidget {
  const CenterInfoPage({Key? key}) : super(key: key);

  @override
  _CenterInfoPageState createState() => _CenterInfoPageState();
}

class _CenterInfoPageState extends State<CenterInfoPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCenterData();
  }

  /// Charger les données du centre
  void _loadCenterData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final center = authProvider.currentUser;
    
    if (center != null) {
      setState(() {
        _centerNameController.text = center.name;
        _emailController.text = center.email;
        _phoneController.text = center.phone;
        _addressController.text = center.address ?? '';
        _descriptionController.text = center.description ?? '';
        _openingHoursController.text = center.openingHours ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Nom du centre
                      TextFormField(
                        controller: _centerNameController,
                        decoration: InputDecoration(
                          labelText: 'Nom du centre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_hospital),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true, // Non modifiable
                      ),
                      SizedBox(height: 16),
                      
                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true, // Non modifiable
                      ),
                      SizedBox(height: 16),

                      // Téléphone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true, // Non modifiable
                      ),
                      SizedBox(height: 16),
                      
                      // Adresse - MODIFIABLE
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Adresse du centre',
                          hintText: 'Entrez l\'adresse complète du centre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer l\'adresse du centre';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Description - MODIFIABLE
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description du centre',
                          hintText: 'Décrivez votre centre de santé',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Horaires d'ouverture - MODIFIABLE
                      TextFormField(
                        controller: _openingHoursController,
                        decoration: InputDecoration(
                          labelText: 'Horaires d\'ouverture',
                          hintText: 'Ex: Lun-Ven: 8h-18h, Sam: 8h-12h',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.schedule),
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 24),
                      
                      // Carte pour la sécurité du compte
                      Card(
                        elevation: 1,
                        child: ListTile(
                          leading: Icon(Icons.lock_reset, color: Colors.orange),
                          title: Text('Sécurité du compte'),
                          subtitle: Text('Réinitialiser votre mot de passe'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _resetPassword,
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Bouton de sauvegarde
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('ENREGISTRER LES MODIFICATIONS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF26A69A),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  /// Réinitialiser le mot de passe
  void _resetPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Réinitialisation du mot de passe'),
        content: Text(
          'Un email de réinitialisation sera envoyé à votre adresse ${_emailController.text}. Voulez-vous continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _sendPasswordResetEmail();
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  /// Envoyer l'email de réinitialisation
  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email de réinitialisation envoyé à ${_emailController.text}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'envoi de l\'email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Sauvegarder le profil
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final currentCenter = authProvider.currentUser;

        if (currentCenter != null) {
          final updatedCenter = currentCenter.copyWith(
            address: _addressController.text,
            description: _descriptionController.text,
            openingHours: _openingHoursController.text.isNotEmpty 
                ? _openingHoursController.text 
                : null,
            updatedAt: DateTime.now(),
          );

          await authProvider.updateUserProfile(updatedCenter);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil mis à jour avec succès !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          _loadCenterData();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _centerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }
}

