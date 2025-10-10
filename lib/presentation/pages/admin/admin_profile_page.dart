// Import des packages Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/menu/admin_menu_page.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

/// Page de profil pour les Administrateurs
class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  /// Charger les données de l'administrateur
  void _loadAdminData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final admin = authProvider.currentUser;
    
    if (admin != null) {
      setState(() {
        _nameController.text = admin.name;
        _emailController.text = admin.email;
        _phoneController.text = admin.phone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final admin = authProvider.currentUser;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Mon profil',
            showMenuButton: true,
          ),
          
          drawer: AdminMenuPage(),
          
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête avec avatar et badge
                Card(
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF9800),
                          Color(0xFFF44336),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 50,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          admin?.name ?? 'Administrateur',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            'ADMINISTRATEUR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          admin?.email ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        if (admin?.createdAt != null) ...[
                          SizedBox(height: 8),
                          Text(
                            'Membre depuis ${DateFormat('MMMM yyyy', 'fr_FR').format(admin!.createdAt)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Formulaire de modification
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations du compte',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      SizedBox(height: 16),

                      // Nom
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Email (lecture seule)
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

                      // Téléphone (lecture seule)
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

                      SizedBox(height: 24),

                      // Carte de sécurité
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
                          backgroundColor: Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Informations système
                      Card(
                        color: Colors.grey[50],
                        elevation: 1,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                                  SizedBox(width: 8),
                                  Text(
                                    'Informations système',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              _buildSystemInfoRow('ID Utilisateur', admin?.id ?? 'N/A'),
                              _buildSystemInfoRow(
                                'Compte créé',
                                admin?.createdAt != null
                                    ? DateFormat('dd/MM/yyyy à HH:mm').format(admin!.createdAt)
                                    : 'N/A',
                              ),
                              _buildSystemInfoRow(
                                'Dernière mise à jour',
                                admin?.updatedAt != null
                                    ? DateFormat('dd/MM/yyyy à HH:mm').format(admin!.updatedAt)
                                    : 'N/A',
                              ),
                              _buildSystemInfoRow(
                                'Email vérifié',
                                admin?.emailVerified == true ? 'Oui ✅' : 'Non ⚠️',
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget pour une ligne d'information système
  Widget _buildSystemInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF9800),
            ),
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
        final currentAdmin = authProvider.currentUser;

        if (currentAdmin != null) {
          final updatedAdmin = currentAdmin.copyWith(
            name: _nameController.text,
            updatedAt: DateTime.now(),
          );

          await authProvider.updateUserProfile(updatedAdmin);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil mis à jour avec succès !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          _loadAdminData();
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

