// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/core/services/firebase_user_service.dart';

/// Page pour créer des comptes utilisateurs (patients ou centres)
/// Accessible uniquement aux administrateurs
class CreateUserPage extends StatefulWidget {
  // Type d'utilisateur à créer ('patient' ou 'center')
  final String userType;

  const CreateUserPage({Key? key, required this.userType}) : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  // Clé du formulaire pour validation
  final _formKey = GlobalKey<FormState>();
  
  // Service utilisateur
  final FirebaseUserService _userService = FirebaseUserService();

  // Contrôleurs pour les champs communs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Indicateur de chargement
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isCenter = widget.userType == 'center';
    final title = isCenter ? 'Créer un centre de santé' : 'Créer un compte patient';

    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: title,
        showMenuButton: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête informatif
              Card(
                color: isCenter ? Colors.green[50] : Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        isCenter ? Icons.local_hospital : Icons.person_add,
                        color: isCenter ? Colors.green : Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isCenter
                              ? 'Créer un nouveau centre de santé'
                              : 'Enregistrer un nouveau patient',
                          style: TextStyle(
                            color: isCenter ? Colors.green[800] : Colors.blue[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Nom complet ou Nom du centre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: isCenter ? 'Nom du centre *' : 'Nom complet *',
                  hintText: isCenter ? 'Ex: Clinique Pôle Santé' : 'Ex: Jean Dupont',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(isCenter ? Icons.business : Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Adresse email *',
                  hintText: 'exemple@email.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'email est requis';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Téléphone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone *',
                  hintText: '+229 XX XX XX XX',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le téléphone est requis';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Adresse
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Adresse *',
                  hintText: isCenter
                      ? 'Adresse du centre de santé'
                      : 'Adresse de résidence',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'adresse est requise';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Mot de passe
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe *',
                  hintText: 'Minimum 6 caractères',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le mot de passe est requis';
                  }
                  if (value.length < 6) {
                    return 'Minimum 6 caractères';
                  }
                  return null;
                },
              ),

              SizedBox(height: 32),

              // Bouton de création
              ElevatedButton(
                onPressed: _isLoading ? null : _createUser,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isCenter ? 'CRÉER LE CENTRE' : 'CRÉER LE COMPTE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCenter ? Color(0xFF2A9D8F) : Color(0xFF1E88E5),
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
  }

  /// Créer le compte utilisateur
  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Création du modèle utilisateur
        final newUser = UserModel(
          id: '', // Sera généré par Firebase
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          role: widget.userType,
          address: _addressController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emailVerified: true, // Vérifié par défaut pour les comptes créés par admin
        );

        // Création du compte via Firebase
        await _userService.createUser(newUser, _passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.userType == 'center'
                  ? 'Centre de santé créé avec succès !'
                  : 'Compte patient créé avec succès !',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Retour à la page précédente
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
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
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

