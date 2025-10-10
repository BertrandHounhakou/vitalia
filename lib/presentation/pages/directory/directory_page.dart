import 'package:flutter/material.dart';
import 'package:vitalia/data/models/doctor_model.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';
import 'package:vitalia/presentation/pages/directory/doctor_detail_page.dart';

/// Page d'annuaire médical
/// Affiche la liste des médecins par spécialité
class DirectoryPage extends StatefulWidget {
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  // Spécialité sélectionnée pour le filtrage
  String _selectedSpecialty = 'Tous';
  
  // Texte de recherche
  String _searchQuery = '';

  // Liste des spécialités médicales
  final List<String> _specialties = [
    'Tous',
    'Généraliste',
    'Gynécologie',
    'Urologie',
    'Cardiologie',
    'Pédiatrie',
    'Dermatologie',
    'Ophtalmologie',
    'ORL',
    'Psychiatrie',
    'Neurologie',
    'Radiologie',
  ];

  // Données fictives pour démonstration (à remplacer par des données Firebase)
  final List<DoctorModel> _doctors = [
    DoctorModel(
      id: '1',
      name: 'Dr. Marie Kouassi',
      specialty: 'Gynécologie',
      hospitals: ['Clinique Citadelle du Cœur', 'Hôpital St Jean'],
      phone: '+229 97 12 34 56',
      email: 'marie.kouassi@medical.bj',
      photoUrl: null,
      yearsOfExperience: 12,
      description: 'Spécialiste en gynécologie obstétrique avec plus de 12 ans d\'expérience.',
      treatments: ['Consultation prénatale', 'Échographie', 'Suivi de grossesse'],
      availableDays: ['Lundi', 'Mercredi', 'Vendredi'],
      consultationHours: '8h - 17h',
      consultationFee: 15000,
      rating: 4.8,
      reviewCount: 124,
    ),
    DoctorModel(
      id: '2',
      name: 'Dr. Jean-Paul Azonhiho',
      specialty: 'Urologie',
      hospitals: ['Clinique Citadelle du Cœur'],
      phone: '+229 97 23 45 67',
      email: 'jp.azonhiho@medical.bj',
      photoUrl: null,
      yearsOfExperience: 15,
      description: 'Urologue expérimenté, spécialisé dans les pathologies urologiques.',
      treatments: ['Consultation urologique', 'Échographie rénale', 'Cystoscopie'],
      availableDays: ['Mardi', 'Jeudi', 'Samedi'],
      consultationHours: '9h - 16h',
      consultationFee: 18000,
      rating: 4.9,
      reviewCount: 98,
    ),
    DoctorModel(
      id: '3',
      name: 'Dr. Sylvie Agbodjan',
      specialty: 'Pédiatrie',
      hospitals: ['Hôpital St Jean', 'Centre Médical Parakou'],
      phone: '+229 97 34 56 78',
      email: 'sylvie.agbodjan@medical.bj',
      photoUrl: null,
      yearsOfExperience: 10,
      description: 'Pédiatre passionnée par la santé des enfants.',
      treatments: ['Consultation enfants', 'Vaccination', 'Suivi de croissance'],
      availableDays: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'],
      consultationHours: '8h - 18h',
      consultationFee: 12000,
      rating: 4.7,
      reviewCount: 156,
    ),
    DoctorModel(
      id: '4',
      name: 'Dr. Robert Kossou',
      specialty: 'Cardiologie',
      hospitals: ['Clinique Citadelle du Cœur'],
      phone: '+229 97 45 67 89',
      email: 'robert.kossou@medical.bj',
      photoUrl: null,
      yearsOfExperience: 20,
      description: 'Cardiologue réputé avec une vaste expérience.',
      treatments: ['ECG', 'Échographie cardiaque', 'Consultation cardiologique'],
      availableDays: ['Lundi', 'Mercredi', 'Vendredi'],
      consultationHours: '9h - 15h',
      consultationFee: 20000,
      rating: 4.9,
      reviewCount: 210,
    ),
    DoctorModel(
      id: '5',
      name: 'Dr. Aminata Diallo',
      specialty: 'Généraliste',
      hospitals: ['Centre Médical Parakou', 'Clinique Sainte Marie'],
      phone: '+229 97 56 78 90',
      email: 'aminata.diallo@medical.bj',
      photoUrl: null,
      yearsOfExperience: 8,
      description: 'Médecin généraliste à l\'écoute de ses patients.',
      treatments: ['Consultation générale', 'Petite chirurgie', 'Soins de base'],
      availableDays: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
      consultationHours: '7h - 19h',
      consultationFee: 10000,
      rating: 4.6,
      reviewCount: 189,
    ),
  ];

  // Filtrer les médecins selon la spécialité et la recherche
  List<DoctorModel> get _filteredDoctors {
    return _doctors.where((doctor) {
      final matchesSpecialty = _selectedSpecialty == 'Tous' ||
          doctor.specialty == _selectedSpecialty;
      final matchesSearch = _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.hospitals.any((h) => h.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Annuaire Médical',
        showMenuButton: false,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un médecin, spécialité...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF26A69A)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filtres par spécialité (Chips horizontaux)
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                final isSelected = _selectedSpecialty == specialty;
                
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(specialty),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSpecialty = specialty;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Color(0xFF26A69A),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          Divider(height: 1),

          // Nombre de résultats
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[50],
            child: Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  '${_filteredDoctors.length} médecin(s) trouvé(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Liste des médecins
          Expanded(
            child: _filteredDoctors.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(_filteredDoctors[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget pour un état vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Aucun médecin trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Essayez une autre recherche ou spécialité',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour une carte de médecin
  Widget _buildDoctorCard(DoctorModel doctor) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigation vers la page de détails du médecin
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailPage(doctor: doctor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Photo de profil ou avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF26A69A),
                    child: doctor.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              doctor.photoUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            doctor.name.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(width: 16),
                  
                  // Informations principales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 16,
                              color: Color(0xFF26A69A),
                            ),
                            SizedBox(width: 4),
                            Text(
                              doctor.specialty,
                              style: TextStyle(
                                color: Color(0xFF26A69A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (doctor.yearsOfExperience != null)
                          Text(
                            '${doctor.yearsOfExperience} ans d\'expérience',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Note
                  if (doctor.rating != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            doctor.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 8),
              
              // Hôpitaux
              Row(
                children: [
                  Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      doctor.hospitals.join(', '),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Horaires et tarif
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (doctor.consultationHours != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          doctor.consultationHours!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (doctor.consultationFee != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${doctor.consultationFee!.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Bouton Prendre RDV
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigation vers la page de prise de rendez-vous
                    Navigator.pushNamed(
                      context,
                      '/book-appointment',
                      arguments: doctor,
                    );
                  },
                  icon: Icon(Icons.calendar_today, size: 18),
                  label: Text('Prendre rendez-vous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

