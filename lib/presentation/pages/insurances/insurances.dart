import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalia/presentation/providers/auth_provider.dart';
import 'package:vitalia/presentation/pages/profile/insurance_detail_page.dart';

class InsurancesPage extends StatelessWidget {
  const InsurancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Assurances'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
      ),
      body: Column(
        children: [
          // En-tête informatif
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestion des assurances santé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ajoutez et gérez vos assurances maladie pour faciliter vos démarches de santé',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Section des statistiques
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Assurances', '3', Icons.verified_user, Colors.green),
                _buildStatCard('Valides', '2', Icons.check_circle, Colors.blue),
                _buildStatCard('Expirées', '1', Icons.warning, Colors.orange),
              ],
            ),
          ),
          
          // Titre de section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mes assurances santé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsuranceDetailPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Ajouter'),
                ),
              ],
            ),
          ),
          
          // Liste des assurances
          Expanded(
            child: _buildInsurancesList(context), // ✅ Passer le context
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Modifier pour accepter le context en paramètre
  Widget _buildInsurancesList(BuildContext context) {
    final List<Map<String, dynamic>> insurances = [
      {
        'id': '1',
        'name': 'SCOMA SANTE BENIN',
        'number': '123456789',
        'status': 'Valide',
        'validUntil': '31/12/2024',
        'color': Colors.green,
      },
      {
        'id': '2',
        'name': 'ATLANTIQUE ASSURANCES',
        'number': '987654321',
        'status': 'Valide',
        'validUntil': '30/06/2024',
        'color': Colors.green,
      },
    ];

    if (insurances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucune assurance enregistrée'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: insurances.length,
      itemBuilder: (context, index) {
        final insurance = insurances[index];
        return _buildInsuranceCard(context, insurance); // ✅ Passer le context
      },
    );
  }

  // ✅ Modifier pour accepter le context en paramètre
  Widget _buildInsuranceCard(BuildContext context, Map<String, dynamic> insurance) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(Icons.verified_user, size: 36, color: insurance['color']),
        title: Text(insurance['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('N°: ${insurance['number']}'),
            Text('Valide jusqu\'au: ${insurance['validUntil']}'),
          ],
        ),
        trailing: Chip(
          label: Text(insurance['status'], style: TextStyle(fontSize: 12, color: Colors.white)),
          backgroundColor: insurance['color'],
        ),
        onTap: () {
          Navigator.push(
            context, // ✅ Context passé en paramètre
            MaterialPageRoute(
              builder: (context) => InsuranceDetailPage(),
            ),
          );
        },
      ),
    );
  }
}