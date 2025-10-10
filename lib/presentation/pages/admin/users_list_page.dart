// Import des packages Flutter nécessaires
import 'package:flutter/material.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/core/services/firebase_user_service.dart';
import 'package:vitalia/data/models/user_model.dart';
import 'package:vitalia/presentation/pages/admin/user_details_page.dart';

/// Page de liste et gestion de tous les utilisateurs
/// Accessible uniquement aux administrateurs
class UsersListPage extends StatefulWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage>
    with SingleTickerProviderStateMixin {
  // Service utilisateur
  final FirebaseUserService _userService = FirebaseUserService();
  
  // Contrôleur pour les onglets
  late TabController _tabController;
  
  // Contrôleur de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Listes des utilisateurs
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredPatients = [];
  List<UserModel> _filteredCenters = [];
  List<UserModel> _filteredAdmins = [];
  
  // Indicateur de chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUsers();
  }

  /// Charger tous les utilisateurs
  Future<void> _loadUsers() async {
    try {
      final users = await _userService.getUsers();
      
      setState(() {
        _allUsers = users;
        _filteredPatients = users.where((u) => u.role == 'patient').toList();
        _filteredCenters = users.where((u) => u.role == 'center').toList();
        _filteredAdmins = users.where((u) => u.role == 'admin').toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement utilisateurs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Filtrer les utilisateurs selon la recherche
  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPatients = _allUsers.where((u) => u.role == 'patient').toList();
        _filteredCenters = _allUsers.where((u) => u.role == 'center').toList();
        _filteredAdmins = _allUsers.where((u) => u.role == 'admin').toList();
      } else {
        _filteredPatients = _allUsers
            .where((u) =>
                u.role == 'patient' &&
                (u.name.toLowerCase().contains(query.toLowerCase()) ||
                    u.phone.contains(query) ||
                    u.email.toLowerCase().contains(query.toLowerCase())))
            .toList();

        _filteredCenters = _allUsers
            .where((u) =>
                u.role == 'center' &&
                (u.name.toLowerCase().contains(query.toLowerCase()) ||
                    u.phone.contains(query)))
            .toList();

        _filteredAdmins = _allUsers
            .where((u) =>
                u.role == 'admin' &&
                (u.name.toLowerCase().contains(query.toLowerCase()) ||
                    u.email.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisée
      appBar: CustomAppBar(
        title: 'Gestion des utilisateurs',
        showMenuButton: false,
      ),

      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un utilisateur',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUsers('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterUsers,
            ),
          ),

          // Barre d'onglets
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF26A69A),
              indicatorWeight: 3,
              labelColor: Color(0xFF26A69A),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'PATIENTS (${_filteredPatients.length})'),
                Tab(text: 'CENTRES (${_filteredCenters.length})'),
                Tab(text: 'ADMINS (${_filteredAdmins.length})'),
              ],
            ),
          ),

          // Contenu des onglets
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUsersList(_filteredPatients, 'patient'),
                      _buildUsersList(_filteredCenters, 'center'),
                      _buildUsersList(_filteredAdmins, 'admin'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Widget pour construire la liste des utilisateurs
  Widget _buildUsersList(List<UserModel> users, String userType) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Aucun utilisateur trouvé',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  /// Widget pour construire une carte utilisateur
  Widget _buildUserCard(UserModel user) {
    Color roleColor;
    IconData roleIcon;
    String roleLabel;

    switch (user.role) {
      case 'patient':
        roleColor = Colors.blue;
        roleIcon = Icons.person;
        roleLabel = 'Patient';
        break;
      case 'center':
        roleColor = Colors.green;
        roleIcon = Icons.local_hospital;
        roleLabel = 'Centre';
        break;
      case 'admin':
        roleColor = Colors.orange;
        roleIcon = Icons.admin_panel_settings;
        roleLabel = 'Admin';
        break;
      default:
        roleColor = Colors.grey;
        roleIcon = Icons.person;
        roleLabel = 'Utilisateur';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        
        // Avatar
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: roleColor,
          backgroundImage: user.profileImage != null
              ? NetworkImage(user.profileImage!)
              : null,
          child: user.profileImage == null
              ? Icon(roleIcon, color: Colors.white)
              : null,
        ),

        // Informations
        title: Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(user.email),
            SizedBox(height: 2),
            Text(user.phone),
            SizedBox(height: 4),
            Chip(
              label: Text(
                roleLabel,
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
              backgroundColor: roleColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),

        // Actions
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 18),
                  SizedBox(width: 8),
                  Text('Voir détails'),
                ],
              ),
              value: 'view',
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Supprimer', style: TextStyle(color: Colors.red)),
                ],
              ),
              value: 'delete',
            ),
          ],
          onSelected: (value) {
            if (value == 'view') {
              // Navigation vers la page de détails
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(user: user),
                ),
              );
            } else if (value == 'delete') {
              _deleteUser(user);
            }
          },
        ),
      ),
    );
  }

  /// Supprimer un utilisateur
  void _deleteUser(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer l\'utilisateur'),
        content: Text('Voulez-vous vraiment supprimer ${user.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _userService.deleteUser(user.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Utilisateur supprimé'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadUsers(); // Recharger la liste
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

