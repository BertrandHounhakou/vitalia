import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Widget qui redirige vers la bonne page d'accueil selon le rôle de l'utilisateur
class RoleBasedHome extends StatelessWidget {
  const RoleBasedHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Si en cours de chargement, afficher un indicateur
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si pas d'utilisateur connecté, rediriger vers login
        if (!authProvider.isAuthenticated || authProvider.currentUser == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Rediriger selon le rôle
        final user = authProvider.currentUser!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          switch (user.role) {
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
        });

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
