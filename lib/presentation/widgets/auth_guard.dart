import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';

/// Widget de garde d'authentification qui vérifie si l'utilisateur est connecté
/// avant d'autoriser l'accès aux pages protégées
class AuthGuard extends StatefulWidget {
  final Widget child;
  final String redirectRoute;

  const AuthGuard({
    Key? key,
    required this.child,
    this.redirectRoute = '/login',
  }) : super(key: key);

  @override
  _AuthGuardState createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _hasRedirected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Si l'utilisateur est en cours de chargement, afficher un indicateur
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si l'utilisateur n'est pas connecté, rediriger vers la page de connexion
        if (!authProvider.isAuthenticated && !_hasRedirected) {
          _hasRedirected = true;
          // Utiliser WidgetsBinding pour éviter les erreurs de contexte
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, widget.redirectRoute);
            }
          });
          
          // Retourner une page temporaire pendant la redirection
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Vérification de l\'authentification...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        // Si l'utilisateur est connecté, afficher la page demandée
        return widget.child;
      },
    );
  }
}

/// Widget de garde pour les pages publiques (redirige si déjà connecté)
class PublicGuard extends StatefulWidget {
  final Widget child;
  final String redirectRoute;

  const PublicGuard({
    Key? key,
    required this.child,
    this.redirectRoute = '/home',
  }) : super(key: key);

  @override
  _PublicGuardState createState() => _PublicGuardState();
}

class _PublicGuardState extends State<PublicGuard> {
  bool _hasRedirected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Si l'utilisateur est en cours de chargement, afficher un indicateur
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si l'utilisateur est déjà connecté, rediriger vers la page d'accueil
        if (authProvider.isAuthenticated && !_hasRedirected) {
          _hasRedirected = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, widget.redirectRoute);
            }
          });
          
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Redirection...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        // Si l'utilisateur n'est pas connecté, afficher la page publique
        return widget.child;
      },
    );
  }
}
