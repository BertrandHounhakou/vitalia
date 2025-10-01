// Import des packages Flutter de base
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour la configuration de l'orientation
import 'package:flutter/foundation.dart' show kIsWeb; // 👈 pour tester le Web

// Import des packages de gestion d'état
import 'package:provider/provider.dart';

// Import de la configuration Firebase
import 'package:firebase_core/firebase_core.dart';
import 'core/services/firebase_auth.dart';
import 'package:vitalia/presentation/pages/insurances/insurances.dart';
import 'firebase_options.dart'; // Fichier généré par FlutterFire

// Import des services Firebase
//import 'core/config/firebase_config.dart';
//import 'core/services/firebase_auth_service.dart';
import 'core/services/firebase_user_service.dart' as firebase_service;
import 'core/services/local_storage_service.dart';
import 'core/services/user_service_interface.dart'; 

// Import des providers
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/appointment_provider.dart';
import 'presentation/providers/location_provider.dart';

// Import des pages principales
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/menu/menu_page.dart';

// Import des pages de contenu
import 'presentation/pages/hospitals/hospitals_page.dart';
import 'presentation/pages/pharmacies/pharmacies_page.dart';
import 'presentation/pages/appointments/appointments_page.dart';
import 'presentation/pages/appointments/book_appointment_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/profile/personal_info_page.dart';
import 'presentation/pages/profile/medical_constants_page.dart';
import 'presentation/pages/profile/insurance_detail_page.dart';
import 'presentation/pages/health_record/health_record_page.dart';
//import 'presentation/pages/insurances/insurances_page.dart';
//import 'presentation/pages/directory/directory_page.dart';

// Fonction principale asynchrone qui lance l'application
void main() async {
  // Assure que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de l'orientation de l'application
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Orientation portrait uniquement
    DeviceOrientation.portraitDown,
  ]);

  // Configuration de la barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Barre de statut transparente
    statusBarIconBrightness: Brightness.dark, // Icônes sombres
  ));

  try {
    // Initialisation de Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

     // ⚠️ N’exécuter que sur plateformes non-Web
    if (!kIsWeb) {
      await LocalStorageService.init(); // Initialisation des services de stockage local
    }

    // Initialisation des services Firebase
    final FirebaseAuthService authService = FirebaseAuthService();
    final UserService userService = firebase_service.FirebaseUserService(); 

    // Lancement de l'application avec les services injectés
    runApp(VitaliaApp(
      authService: authService,
      userService: userService,
    ));
  } catch (e) {
    // Gestion des erreurs d'initialisation
    print('Erreur lors de l\'initialisation: $e');
    // Fallback: Lancement sans Firebase en mode démo
    //runApp(const VitaliaAppFallback());
  }
}

// Classe principale de l'application avec Firebase
class VitaliaApp extends StatelessWidget {
  // Services injectés via le constructeur
  final FirebaseAuthService authService;
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
    return MultiProvider(
      // Fournisseur multiple pour tous les providers
      providers: [
        // Provider d'authentification Firebase
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService),
        ),

        // Provider d'utilisateur Firebase
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(userService),
        ),

        // Provider de rendez-vous
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) => AppointmentProvider(),
        ),

        // Provider de localisation
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        // Configuration de l'application
        title: 'VITALIA - Carnet de Santé', // Titre de l'application
        debugShowCheckedModeBanner: false, // Masquer la bannière de debug
        theme: _buildAppTheme(), // Thème personnalisé
        darkTheme: _buildDarkTheme(), // Thème sombre
        themeMode: ThemeMode.light, // Utiliser le thème light par défaut
        initialRoute: '/onboarding', // Route initiale au lancement

        // Définition de toutes les routes de l'application
        routes: {
          // Routes d'authentification et onboarding
          '/onboarding': (context) => const OnboardingPage(),
          '/auth': (context) => const LoginPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),

          // Page principale
          '/home': (context) => const HomePage(),

          // Menu et navigation
          '/menu': (context) => const MenuPage(),

          // Services de santé
          '/hospitals': (context) => const HospitalsPage(),
          '/pharmacies': (context) => const PharmaciesPage(),

          // Gestion des rendez-vous
          '/appointments': (context) => const AppointmentsPage(),
          '/book-appointment': (context) => const BookAppointmentPage(),

          // Profil utilisateur
          '/profile': (context) => const ProfilePage(),
          '/profile/personal-info': (context) => const PersonalInfoPage(),
          '/profile/medical-constants': (context) => const MedicalConstantsPage(),
          '/profile/insurances': (context) => const InsuranceDetailPage(),

          // Carnet de santé
          '/health-record': (context) => const HealthRecordPage(),

          // Pages supplémentaires
          //'/directory': (context) => const DirectoryPage(),
          '/insurances': (context) => const InsurancesPage(),
        },

        // Gestion des routes inconnues (404)
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Page non trouvée')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Page non trouvée: ${settings.name}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                      child: const Text('Retour à l\'accueil'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },

        // Gestion des erreurs de construction
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // Désactiver le scaling automatique du texte
            ),
            child: child!,
          );
        },
      ),
    );
  }

  // Construction du thème light de l'application
  ThemeData _buildAppTheme() {
    return ThemeData(
      // Couleurs principales
      primaryColor: const Color(0xFF2A7FDE), // Bleu VITALIA
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: const Color(0xFF4CAF50), // Vert pour les actions
        backgroundColor: Colors.white,
      ),

      // Typographie
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A7FDE), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A7FDE),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),

      // Card theme
      /*cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),*/

      // Autres configurations
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Construction du thème sombre
  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF2A7FDE),
        secondary: const Color(0xFF4CAF50),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }
}

// Classe fallback si Firebase échoue
class VitaliaAppFallback extends StatelessWidget {
  const VitaliaAppFallback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VITALIA (Mode Démo)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('VITALIA - Mode Démo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning, size: 64, color: Colors.orange),
                const SizedBox(height: 20),
                const Text(
                  'Application en mode démonstration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Les données ne seront pas sauvegardées. Configuration Firebase requise.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingPage()),
                    );
                  },
                  child: const Text('Continuer en mode démo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension pour la navigation facile
/*extension NavigationExtension on BuildContext {
  Future<void> pushNamed(String routeName, {Object? arguments}) async {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<void> pushReplacementNamed(String routeName, {Object? arguments}) async {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();

  bool get canPop => Navigator.of(this).canPop();
}*/

// Extension pour les médias queries
extension MediaQueryExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;
}