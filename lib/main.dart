// Import des packages Flutter et des dépendances
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import manquant

// Import des services
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';
import 'core/services/local_storage_service.dart';

// Import des providers
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/appointment_provider.dart';
import 'presentation/providers/location_provider.dart';

// Import des pages
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/menu/menu_page.dart';
import 'presentation/pages/hospitals/hospitals_page.dart';
import 'presentation/pages/pharmacies/pharmacies_page.dart';
import 'presentation/pages/appointments/appointments_page.dart';
import 'presentation/pages/profile/profile_page.dart';

// Fonction principale qui lance l'application
void main() async {
  // Assurance que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation des services de stockage local
  await LocalStorageService.init();
  
  // Initialisation des services partagés
  final SharedPreferences prefs = await SharedPreferences.getInstance(); // Service de préférences partagées
  final AuthService authService = AuthService(prefs); // Service d'authentification
  final UserService userService = UserService(); // Service utilisateur
  
  // Lancement de l'application
  runApp(VitaliaApp(
    authService: authService,
    userService: userService,
  ));
}

// Classe principale de l'application
class VitaliaApp extends StatelessWidget {
  // Services injectés via le constructeur
  final AuthService authService;
  final UserService userService;

  // Constructeur avec services requis
  const VitaliaApp({
    Key? key,
    required this.authService,
    required this.userService,
  }) : super(key: key);

  // Construction de l'interface de l'application
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Fournisseur multiple pour tous les providers
      providers: [
        // Provider d'authentification
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        // Provider d'utilisateur
        ChangeNotifierProvider(
          create: (_) => UserProvider(userService),
        ),
        // Provider de rendez-vous
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(),
        ),
        // Provider de localisation
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp( // Application Material Design
        title: 'VITALIA', // Titre de l'application
        theme: ThemeData(
          primarySwatch: Colors.blue, // Couleur principale
          visualDensity: VisualDensity.adaptivePlatformDensity, // Densité visuelle adaptative
          useMaterial3: true, // Utilisation de Material 3
        ),
        initialRoute: '/onboarding', // Route initiale au lancement
        routes: { // Définition de toutes les routes de l'application
          '/onboarding': (context) => const OnboardingPage(),
          '/auth': (context) => const LoginPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/menu': (context) => const MenuPage(),
          '/hospitals': (context) => const HospitalsPage(),
          '/pharmacies': (context) => const PharmaciesPage(),
          '/appointments': (context) => const AppointmentsPage(),
          '/profile': (context) => const ProfilePage(),
        },
        debugShowCheckedModeBanner: false, // Masquer la bannière de debug
      ),
    );
  }
}