import 'package:flutter/material.dart';
import 'package:vitalia/data/models/doctor_model.dart';
import 'package:vitalia/presentation/widgets/custom_app_bar.dart';

/// Page de détails d'un médecin
/// Affiche toutes les informations détaillées d'un médecin
class DoctorDetailPage extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailPage({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profil du médecin',
        showMenuButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec photo et infos principales
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF26A69A), Color(0xFF2A9D8F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Photo de profil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: doctor.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              doctor.photoUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            doctor.name.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                              color: Color(0xFF26A69A),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  
                  // Nom
                  Text(
                    doctor.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  
                  // Spécialité
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      doctor.specialty,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Note et expérience
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (doctor.rating != null) ...[
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${doctor.rating!.toStringAsFixed(1)} (${doctor.reviewCount ?? 0} avis)',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(width: 16),
                      ],
                      if (doctor.yearsOfExperience != null) ...[
                        Icon(Icons.work_history, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${doctor.yearsOfExperience} ans',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Contenu de la page
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (doctor.description != null) ...[
                    _buildSectionTitle('À propos'),
                    SizedBox(height: 8),
                    Text(
                      doctor.description!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Hôpitaux
                  _buildSectionTitle('Hôpitaux'),
                  SizedBox(height: 8),
                  ...doctor.hospitals.map((hospital) => _buildListItem(
                        Icons.local_hospital,
                        hospital,
                      )),
                  SizedBox(height: 24),

                  // Traitements/Services
                  if (doctor.treatments != null && doctor.treatments!.isNotEmpty) ...[
                    _buildSectionTitle('Traitements & Services'),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: doctor.treatments!
                          .map((treatment) => Chip(
                                label: Text(treatment),
                                backgroundColor: Colors.blue[50],
                                labelStyle: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Disponibilités
                  if (doctor.availableDays != null && doctor.availableDays!.isNotEmpty) ...[
                    _buildSectionTitle('Disponibilités'),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: doctor.availableDays!
                          .map((day) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF26A69A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color(0xFF26A69A).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: Color(0xFF26A69A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 8),
                    if (doctor.consultationHours != null)
                      _buildListItem(
                        Icons.access_time,
                        'Horaires: ${doctor.consultationHours}',
                      ),
                    SizedBox(height: 24),
                  ],

                  // Contact
                  _buildSectionTitle('Contact'),
                  SizedBox(height: 8),
                  if (doctor.phone != null)
                    _buildListItem(Icons.phone, doctor.phone!),
                  if (doctor.email != null)
                    _buildListItem(Icons.email, doctor.email!),
                  SizedBox(height: 24),

                  // Tarif
                  if (doctor.consultationFee != null) ...[
                    _buildSectionTitle('Tarif de consultation'),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green[200]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Consultation',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${doctor.consultationFee!.toStringAsFixed(0)} FCFA',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),

      // Bouton flottant pour prendre rendez-vous
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/book-appointment',
              arguments: doctor,
            );
          },
          icon: Icon(Icons.calendar_today, size: 20),
          label: Text(
            'Prendre rendez-vous',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF26A69A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  // Widget pour un titre de section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Widget pour un élément de liste avec icône
  Widget _buildListItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Color(0xFF26A69A),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

