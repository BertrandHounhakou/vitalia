// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/data/models/user_model.dart';

// Classe pour la page d'inscription avec état
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  // Création de l'état de la page d'inscription
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

// État de la page d'inscription
class _RegisterPageState extends State<RegisterPage> {
  // Clé pour le formulaire de validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs de texte du formulaire d'inscription
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  
  // Code pays par défaut (Bénin)
  final String _countryCode = '229';
  
  // Variable pour suivre le type d'utilisateur (patient, centre, admin)
  String _userType = 'patient';
  
  // Variables pour gérer la visibilité des mots de passe
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Variable pour gérer l'acceptation des conditions d'utilisation
  bool _acceptTerms = false;
  
  // Indicateur de chargement pendant l'inscription
  bool _isLoading = false;

  // Construction de l'interface de la page d'inscription
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // DÉGRADÉ DE FOND SUR TOUTE LA PAGE
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A7FDE), // Bleu VITALIA en haut
              Color(0xFF4CAF50), // Vert en bas
            ],
            stops: [0.3, 0.7], // Contrôle de la transition des couleurs
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ) // Indicateur de chargement avec couleur blanche
            : SafeArea(
                child: SingleChildScrollView( // Permet le défilement sur les petits écrans
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Marge interne de 20 pixels
                    child: Form(
                      key: _formKey, // Clé pour la validation du formulaire
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // Alignement étiré horizontalement
                        children: [
                          // En-tête avec le logo et le titre
                          Column(
                            children: [
                              // Logo de l'application VITALIA
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.medical_services,
                                  size: 50,
                                  color: Color(0xFF2A7FDE),
                                ),
                              ),
                              SizedBox(height: 20), // Espacement vertical de 20 pixels
                              
                              // Titre de l'application
                              Text(
                                'VITALIA',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8), // Espacement réduit
                              
                              // Sous-titre
                              Text(
                                'Créer un compte',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 30), // Espacement avant le formulaire
                            ],
                          ),

                          // CONTENU PRINCIPAL DU FORMULAIRE TRANSPARENT
                          Column(
                            children: [
                              // Sélecteur du type d'utilisateur (patient, centre de santé, administrateur)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _userType, // Valeur actuellement sélectionnée
                                  items: const [ // Options disponibles dans le dropdown
                                    DropdownMenuItem(value: 'patient', child: Text('Patient', style: TextStyle(color: Colors.white))),
                                    DropdownMenuItem(value: 'center', child: Text('Centre de santé', style: TextStyle(color: Colors.white))),
                                    DropdownMenuItem(value: 'admin', child: Text('Administrateur', style: TextStyle(color: Colors.white))),
                                  ],
                                  onChanged: (value) { // Callback quand la valeur change
                                    setState(() {
                                      _userType = value!; // Mise à jour du type d'utilisateur
                                    });
                                  },
                                  dropdownColor: Color(0xFF2A7FDE).withOpacity(0.9), // Fond du dropdown
                                  style: TextStyle(color: Colors.white), // Texte en blanc
                                  decoration: InputDecoration(
                                    labelText: 'Type de compte', // Label du dropdown
                                    labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                    border: InputBorder.none, // PAS DE BORDURE INTERNE
                                    enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                    focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                    prefixIcon: Icon(Icons.person, color: Colors.white), // Icône blanche
                                    filled: false, // FOND TRANSPARENT
                                  ),
                                  validator: (value) { // Validation du champ
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez sélectionner un type de compte'; // Message d'erreur
                                    }
                                    return null; // Validation réussie
                                  },
                                ),
                              ),
                              SizedBox(height: 20), // Espacement vertical de 20 pixels
                              
                              // Champ pour le prénom (uniquement pour les patients)
                              if (_userType == 'patient') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                                  ),
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    style: TextStyle(color: Colors.white), // Texte en blanc
                                    decoration: InputDecoration(
                                      labelText: 'Prénom', // Label du champ prénom
                                      labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                      border: InputBorder.none, // PAS DE BORDURE INTERNE
                                      enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                      focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                      prefixIcon: Icon(Icons.person, color: Colors.white), // Icône blanche
                                      filled: false, // FOND TRANSPARENT
                                    ),
                                    validator: (value) { // Validation du champ
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer votre prénom'; // Message d'erreur
                                      }
                                      if (value.length < 2) {
                                        return 'Le prénom doit contenir au moins 2 caractères'; // Message d'erreur
                                      }
                                      return null; // Validation réussie
                                    },
                                  ),
                                ),
                                SizedBox(height: 16), // Espacement vertical de 16 pixels
                              ],
                              
                              // Champ pour le nom (uniquement pour les patients)
                              if (_userType == 'patient') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                                  ),
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    style: TextStyle(color: Colors.white), // Texte en blanc
                                    decoration: InputDecoration(
                                      labelText: 'Nom', // Label du champ nom
                                      labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                      border: InputBorder.none, // PAS DE BORDURE INTERNE
                                      enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                      focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                      prefixIcon: Icon(Icons.person, color: Colors.white), // Icône blanche
                                      filled: false, // FOND TRANSPARENT
                                    ),
                                    validator: (value) { // Validation du champ
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer votre nom'; // Message d'erreur
                                      }
                                      if (value.length < 2) {
                                        return 'Le nom doit contenir au moins 2 caractères'; // Message d'erreur
                                      }
                                      return null; // Validation réussie
                                    },
                                  ),
                                ),
                                SizedBox(height: 16), // Espacement vertical de 16 pixels
                              ],
                              
                              // Champ pour le nom de l'établissement (uniquement pour les centres)
                              if (_userType == 'center') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                                  ),
                                  child: TextFormField(
                                    controller: _firstNameController, // Réutilisation du contrôleur
                                    style: TextStyle(color: Colors.white), // Texte en blanc
                                    decoration: InputDecoration(
                                      labelText: 'Nom du centre de santé', // Label pour les centres
                                      labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                      border: InputBorder.none, // PAS DE BORDURE INTERNE
                                      enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                      focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                      prefixIcon: Icon(Icons.business, color: Colors.white), // Icône blanche
                                      filled: false, // FOND TRANSPARENT
                                    ),
                                    validator: (value) { // Validation du champ
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le nom du centre'; // Message d'erreur
                                      }
                                      if (value.length < 3) {
                                        return 'Le nom du centre doit contenir au moins 3 caractères'; // Message d'erreur
                                      }
                                      return null; // Validation réussie
                                    },
                                  ),
                                ),
                                SizedBox(height: 16), // Espacement vertical de 16 pixels
                              ],
                              
                              // Champ pour l'adresse email
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white), // Texte en blanc
                                  keyboardType: TextInputType.emailAddress, // Clavier optimisé pour email
                                  decoration: InputDecoration(
                                    labelText: 'Adresse email', // Label du champ email
                                    labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                    border: InputBorder.none, // PAS DE BORDURE INTERNE
                                    enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                    focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                    prefixIcon: Icon(Icons.email, color: Colors.white), // Icône blanche
                                    filled: false, // FOND TRANSPARENT
                                  ),
                                  validator: (value) { // Validation du champ
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre adresse email'; // Message d'erreur
                                    }
                                    if (!value.contains('@') || !value.contains('.')) {
                                      return 'Veuillez entrer une adresse email valide'; // Message d'erreur
                                    }
                                    return null; // Validation réussie
                                  },
                                ),
                              ),
                              SizedBox(height: 16), // Espacement vertical de 16 pixels
                              
                              // Champ pour le numéro de téléphone avec sélecteur de pays
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                ),
                                child: Row(
                                  children: [
                                    // Sélecteur de code pays (dropdown)
                                    Container(
                                      width: 80, // Largeur fixe pour le sélecteur de pays
                                      child: DropdownButtonFormField<String>(
                                        value: _countryCode, // Valeur actuelle (229 pour Bénin)
                                        items: ['229', '226', '225', '33', '1'].map((String value) { // Options de codes pays
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text('+$value', style: TextStyle(color: Colors.white)), // Texte en blanc
                                          );
                                        }).toList(),
                                        onChanged: (value) { // Callback quand le code pays change
                                          // La valeur est mise à jour automatiquement par le DropdownButtonFormField
                                        },
                                        dropdownColor: Color(0xFF2A7FDE).withOpacity(0.9), // Fond du dropdown
                                        style: TextStyle(color: Colors.white), // Texte en blanc
                                        decoration: InputDecoration(
                                          border: InputBorder.none, // PAS DE BORDURE INTERNE
                                          enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                          focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                          labelText: 'Code', // Label du sélecteur
                                          labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                          filled: false, // FOND TRANSPARENT
                                        ),
                                      ),
                                    ),
                                    // Ligne séparatrice verticale
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    SizedBox(width: 10), // Espacement horizontal de 10 pixels
                                    
                                    // Champ pour le numéro de téléphone
                                    Expanded( // Prend tout l'espace disponible
                                      child: TextFormField(
                                        controller: _phoneController,
                                        style: TextStyle(color: Colors.white), // Texte en blanc
                                        keyboardType: TextInputType.phone, // Clavier numérique pour les téléphones
                                        decoration: InputDecoration(
                                          labelText: 'Numéro de téléphone', // Label du champ
                                          labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                          border: InputBorder.none, // PAS DE BORDURE INTERNE
                                          enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                          focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                          prefixIcon: null, // Pas d'icône pour laisser place au code pays
                                          filled: false, // FOND TRANSPARENT
                                        ),
                                        validator: (value) { // Validation du champ
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer votre numéro'; // Message d'erreur
                                          }
                                          if (value.length < 8) { // Validation de la longueur
                                            return 'Le numéro doit contenir au moins 8 chiffres'; // Message d'erreur
                                          }
                                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                            return 'Le numéro ne doit contenir que des chiffres'; // Message d'erreur
                                          }
                                          return null; // Validation réussie
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16), // Espacement vertical de 16 pixels
                              
                              // Champ pour le contact d'urgence (uniquement pour les patients)
                              if (_userType == 'patient') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                                  ),
                                  child: TextFormField(
                                    controller: _emergencyContactController,
                                    style: TextStyle(color: Colors.white), // Texte en blanc
                                    keyboardType: TextInputType.phone, // Clavier numérique
                                    decoration: InputDecoration(
                                      labelText: 'Contact d\'urgence', // Label du champ
                                      labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                      border: InputBorder.none, // PAS DE BORDURE INTERNE
                                      enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                      focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                      prefixIcon: Icon(Icons.emergency, color: Colors.white), // Icône blanche
                                      hintText: 'Numéro d\'une personne à contacter en cas d\'urgence', // Texte d'aide
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Hint en blanc transparent
                                      filled: false, // FOND TRANSPARENT
                                    ),
                                    validator: (value) { // Validation du champ
                                      if (value != null && value.isNotEmpty && value.length < 8) {
                                        return 'Le numéro doit contenir au moins 8 chiffres'; // Message d'erreur
                                      }
                                      return null; // Validation réussie
                                    },
                                  ),
                                ),
                                SizedBox(height: 16), // Espacement vertical de 16 pixels
                              ],
                              
                              // Champ pour le mot de passe
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: TextStyle(color: Colors.white), // Texte en blanc
                                  obscureText: _obscurePassword, // Masquer/afficher le texte
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe', // Label du champ
                                    labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                    border: InputBorder.none, // PAS DE BORDURE INTERNE
                                    enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                    focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                    prefixIcon: Icon(Icons.lock, color: Colors.white), // Icône blanche
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword 
                                            ? Icons.visibility_off 
                                            : Icons.visibility,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      tooltip: _obscurePassword 
                                          ? 'Afficher le mot de passe' 
                                          : 'Masquer le mot de passe',
                                    ),
                                    filled: false, // FOND TRANSPARENT
                                  ),
                                  validator: (value) { // Validation du champ
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer un mot de passe'; // Message d'erreur
                                    }
                                    if (value.length < 6) { // Validation de la longueur minimale
                                      return 'Le mot de passe doit contenir au moins 6 caractères'; // Message d'erreur
                                    }
                                    return null; // Validation réussie
                                  },
                                ),
                              ),
                              SizedBox(height: 16), // Espacement vertical de 16 pixels
                              
                              // Champ pour la confirmation du mot de passe
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.5)), // Bordure blanche transparente
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  style: TextStyle(color: Colors.white), // Texte en blanc
                                  obscureText: _obscureConfirmPassword, // Masquer/afficher le texte
                                  decoration: InputDecoration(
                                    labelText: 'Confirmer le mot de passe', // Label du champ
                                    labelStyle: TextStyle(color: Colors.white), // Label en blanc
                                    border: InputBorder.none, // PAS DE BORDURE INTERNE
                                    enabledBorder: InputBorder.none, // PAS DE BORDURE QUAND ACTIVÉ
                                    focusedBorder: InputBorder.none, // PAS DE BORDURE QUAND FOCUS
                                    prefixIcon: Icon(Icons.lock_outline, color: Colors.white), // Icône blanche
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword 
                                            ? Icons.visibility_off 
                                            : Icons.visibility,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                      tooltip: _obscureConfirmPassword 
                                          ? 'Afficher le mot de passe' 
                                          : 'Masquer le mot de passe',
                                    ),
                                    filled: false, // FOND TRANSPARENT
                                  ),
                                  validator: (value) { // Validation du champ
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez confirmer votre mot de passe'; // Message d'erreur
                                    }
                                    if (value != _passwordController.text) { // Vérification de la correspondance
                                      return 'Les mots de passe ne correspondent pas'; // Message d'erreur
                                    }
                                    return null; // Validation réussie
                                  },
                                ),
                              ),
                              SizedBox(height: 24), // Espacement vertical de 24 pixels
                              
                              // Checkbox pour accepter les conditions d'utilisation
                              Row(
                                children: [
                                  Checkbox(
                                    value: _acceptTerms, // État de la case à cocher
                                    tristate: false, // Explicitement définir que ce n'est pas tristate
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _acceptTerms = value ?? false;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.all(Colors.transparent), // Case transparente
                                    side: BorderSide(
                                      color: _acceptTerms ? Colors.white : Colors.red, // Bordure rouge si non cochée
                                      width: _acceptTerms ? 1.0 : 2.0, // Bordure plus épaisse si non cochée
                                    ),
                                    checkColor: Colors.white, // Coches blanches
                                  ),
                                  Expanded(
                                    child: Text(
                                      'J\'accepte les conditions d\'utilisation et la politique de confidentialité *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white, // Texte en blanc
                                        fontWeight: _acceptTerms ? FontWeight.normal : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24), // Espacement vertical de 24 pixels
                              
                              // Bouton de création de compte
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), // Coins arrondis
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.white.withOpacity(0.9)], // Dégradé blanc
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register, // Désactiver pendant le chargement
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // BOUTON TRANSPARENT
                                    foregroundColor: Color(0xFF2A7FDE), // Texte bleu
                                    shadowColor: Colors.transparent, // Pas d'ombre
                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30), // Padding amélioré
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // Coins arrondis
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox( // Indicateur de chargement dans le bouton
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A7FDE)),
                                          ),
                                        )
                                      : Text(
                                          'Créer un compte',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ), // Texte du bouton
                                ),
                              ),
                              SizedBox(height: 20), // Espacement vertical de 20 pixels
                              
                              // Lien vers la page de connexion pour les utilisateurs déjà inscrits
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Centrage horizontal
                                children: [
                                  Text(
                                    'Déjà un compte ?',
                                    style: TextStyle(color: Colors.white), // Texte en blanc
                                  ),
                                  TextButton(
                                    onPressed: _isLoading
                                        ? null // Désactiver pendant le chargement
                                        : () {
                                            Navigator.pop(context); // Retour à la page précédente (connexion)
                                          },
                                    child: Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        color: Colors.white, // Texte en blanc
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none, // Pas de soulignement
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // Méthode pour gérer l'inscription d'un nouvel utilisateur
  void _register() async {
    // Vérifier l'acceptation des conditions d'utilisation
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vous devez accepter les conditions d\'utilisation pour continuer',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // Vérifier la validation du formulaire
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Activer l'indicateur de chargement
      });

      try {
        // Récupération des valeurs des champs du formulaire
        final phone = _phoneController.text;
        final password = _passwordController.text;
        final email = _emailController.text;
        final firstName = _firstNameController.text;
        final lastName = _lastNameController.text;
        final emergencyContact = _emergencyContactController.text;

        // Récupération du provider d'authentification
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Détermination du nom complet selon le type d'utilisateur
        final String fullName = _userType == 'patient' 
            ? '$firstName $lastName' 
            : firstName; // Pour les centres, utiliser le nom du centre

        // CRÉATION DU MODÈLE UTILISATEUR AVEC TOUS LES CHAMPS
        final user = UserModel(
          id: '', // L'ID sera généré par Firebase
          name: fullName,
          phone: '$_countryCode$phone', // Numéro complet avec code pays
          role: _userType,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emergencyContact: emergencyContact.isNotEmpty ? '$_countryCode$emergencyContact' : null,
          // NOUVEAUX CHAMPS AJOUTÉS
          firstName: _userType == 'patient' ? firstName : null,
          lastName: _userType == 'patient' ? lastName : null,
          emailVerified: false,
          // Les autres champs restent null et seront remplis plus tard
          profileImage: null,
          address: null,
          dateOfBirth: null,
          gender: null,
          bloodType: null,
          allergies: null,
          medicalHistory: null,
        );

        // Appel du service d'inscription
        await authProvider.signUp(user, password);
        
        // Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compte créé avec succès ! Un email de vérification a été envoyé.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        
        // NAVIGATION CORRIGÉE - Attendre que le snackbar soit affiché
        await Future.delayed(Duration(milliseconds: 2000));
        
        // Navigation selon le rôle de l'utilisateur créé
        final currentUser = authProvider.currentUser;
        
        if (currentUser != null) {
          switch (currentUser.role) {
            case 'patient':
              Navigator.pushReplacementNamed(context, '/patient-home');
              break;
            case 'center':
              Navigator.pushReplacementNamed(context, '/center/home');
              break;
            case 'admin':
              Navigator.pushReplacementNamed(context, '/admin/home');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/patient-home');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/patient-home');
        }
        
      } catch (e) {
        // Gestion des erreurs d'inscription
        String errorMessage = 'Erreur lors de la création du compte';
        
        if (e.toString().contains('email-already-in-use')) {
          errorMessage = 'Cette adresse email est déjà utilisée';
        } else if (e.toString().contains('weak-password')) {
          errorMessage = 'Le mot de passe est trop faible (minimum 6 caractères)';
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = 'Adresse email invalide';
        } else if (e.toString().contains('network-request-failed')) {
          errorMessage = 'Problème de connexion internet';
        }
        
        // Affichage du message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Désactiver l'indicateur de chargement
        });
      }
    }
  }

  // Nettoyage des ressources
  @override
  void dispose() {
    // Libération des contrôleurs de texte
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }
}