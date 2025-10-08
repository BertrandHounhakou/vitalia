// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:vitalia/presentation/providers/auth_provider.dart';
//import 'package:vitalia/data/models/user_model.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  
  String _gender = 'Masculin';
  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Charger les données de l'utilisateur connecté
  void _loadUserData() {
    // CORRECTION : Utilisez 'listen: false' pour éviter les rebuilds inutiles
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      setState(() {
        // Séparation du nom complet en prénom et nom
        final nameParts = user.name.split(' ');
        _firstNameController.text = user.firstName ?? (nameParts.isNotEmpty ? nameParts.first : '');
        _lastNameController.text = user.lastName ?? (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _addressController.text = user.address ?? '';
        _professionController.text = user.profession ?? '';
        _gender = user.gender ?? 'Masculin';
        
        if (user.dateOfBirth != null) {
          _selectedBirthDate = user.dateOfBirth;
          _birthDateController.text = _formatDate(user.dateOfBirth!);
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    // CORRECTION : Utilisez Consumer au lieu de Provider.of dans build
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: Text('Informations Personnelles'),
            backgroundColor: Color(0xFF2A7FDE),
            foregroundColor: Colors.white,
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (user != null) ...[
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xFF2A7FDE),
                                    child: Text(
                                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.phone,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],

                        // ... Tous vos champs de formulaire restent identiques ...
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Prénom(s)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre prénom';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nom';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
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
                          readOnly: true,
                        ),
                        SizedBox(height: 16),

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
                          readOnly: true,
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Adresse',
                            hintText: 'Entrez votre adresse complète',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.home),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _professionController,
                          decoration: InputDecoration(
                            labelText: 'Profession',
                            hintText: 'Votre profession actuelle',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.work),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _birthDateController,
                          decoration: InputDecoration(
                            labelText: 'Date de naissance',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: _selectBirthDate,
                            ),
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 16),
                        
                        DropdownButtonFormField<String>(
                          value: _gender,
                          items: ['Masculin', 'Féminin', 'Autre'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Genre',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                        ),
                        SizedBox(height: 32),
                        
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
                            backgroundColor: Color(0xFF2A7FDE),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  void _resetPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Réinitialisation du mot de passe'),
        content: Text('Un email de réinitialisation sera envoyé à votre adresse ${_emailController.text}. Voulez-vous continuer ?'),
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

  // MÉTHODE DE SAUVEGARDE
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // CORRECTION : Utilisez Provider.of avec listen: false
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final currentUser = authProvider.currentUser;

        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            name: '${_firstNameController.text} ${_lastNameController.text}',
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            address: _addressController.text.isNotEmpty ? _addressController.text : null,
            gender: _gender,
            dateOfBirth: _selectedBirthDate,
            profession: _professionController.text.isNotEmpty ? _professionController.text : null,
            updatedAt: DateTime.now(),
          );

          // SAUVEGARDE DANS FIRESTORE
          await authProvider.updateUserProfile(updatedUser);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil mis à jour avec succès !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Recharger les données
          _loadUserData();
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
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _professionController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}