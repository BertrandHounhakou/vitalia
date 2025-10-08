# 📋 Architecture Vitalia - Documentation

## 🎯 Vue d'ensemble du projet

Vitalia est une application de carnet de santé numérique avec **3 types d'utilisateurs** :
- 👤 **Patient** : Consulte son dossier médical
- 🏥 **Centre de santé** : Gère les consultations et rendez-vous
- 👨‍💼 **Administrateur** : Gère les utilisateurs du système

---

## 📁 Structure des fichiers créés

### **Modèles de données**
```
lib/data/models/
├── user_model.dart              ✅ (existant, modifié)
├── appointment_model.dart        ✅ (existant)
└── consultation_model.dart       ✅ NOUVEAU
```

### **Services Firebase**
```
lib/core/services/
├── firebase_auth_service.dart    ✅ (existant)
├── firebase_user_service.dart    ✅ (existant, modifié)
└── consultation_service.dart     ✅ NOUVEAU
```

### **Pages Centre de santé**
```
lib/presentation/pages/center/
├── center_home_page.dart         ✅ NOUVEAU - Dashboard centre
├── add_consultation_page.dart    ✅ NOUVEAU - Ajouter consultation
├── center_appointments_page.dart ✅ NOUVEAU - Gestion RDV
├── patients_list_page.dart       ✅ NOUVEAU - Recherche patients
└── patient_history_page.dart     ✅ NOUVEAU - Historique patient
```

### **Pages Administrateur**
```
lib/presentation/pages/admin/
├── admin_home_page.dart          ✅ NOUVEAU - Dashboard admin
├── create_user_page.dart         ✅ NOUVEAU - Créer comptes
└── users_list_page.dart          ✅ NOUVEAU - Liste utilisateurs
```

### **Widgets réutilisables**
```
lib/presentation/widgets/
├── custom_app_bar.dart           ✅ (modifié)
├── service_card.dart             ✅ NOUVEAU
└── widgets.dart                  ✅ NOUVEAU
```

---

## 🔐 Système de rôles et redirections

### **Après connexion (`login_page.dart`):**
```dart
switch (user.role) {
  case 'patient':
    → /home (HomePage - Patient)
  case 'center':
    → /center/home (CenterHomePage - Dashboard Centre)
  case 'admin':
    → /admin/home (AdminHomePage - Dashboard Admin)
}
```

---

## 🏥 Fonctionnalités Centre de santé

### **1. Dashboard Centre (`center_home_page.dart`)**
Affiche :
- Statistiques du jour (consultations, RDV, patients)
- Actions rapides :
  * Ajouter une consultation
  * Gérer les rendez-vous
  * Rechercher un patient
  * Historique des consultations

### **2. Ajouter une consultation (`add_consultation_page.dart`)**
Formulaire complet :
- ID du patient
- Nom du médecin
- Motif de consultation
- Diagnostic
- Traitement prescrit
- Ordonnance
- Constantes vitales (température, tension, pouls, poids)
- Notes additionnelles
→ Sauvegarde dans Firebase (`consultations` collection)

### **3. Gestion des RDV (`center_appointments_page.dart`)**
Onglets :
- EN ATTENTE : RDV à confirmer
- CONFIRMÉS : RDV validés
- TERMINÉS : Historique
Actions : Confirmer / Annuler les RDV

### **4. Recherche patients (`patients_list_page.dart`)**
- Barre de recherche (nom, téléphone, ID)
- Liste de tous les patients
- Affichage : nom, téléphone, groupe sanguin
- Clic → Voir l'historique complet

### **5. Historique patient (`patient_history_page.dart`)**
Affiche :
- Informations patient (photo, nom, contacts)
- Constantes médicales
- Allergies et pathologies
- Contact d'urgence
- **Liste de toutes les consultations** (expandable)
  * Diagnostic
  * Traitement
  * Ordonnance
  * Constantes vitales

---

## 👨‍💼 Fonctionnalités Administrateur

### **1. Dashboard Admin (`admin_home_page.dart`)**
Affiche :
- Statistiques globales :
  * Total patients
  * Total centres de santé
  * Total consultations
  * Activités du jour
- Actions rapides :
  * Créer un centre de santé
  * Créer un compte patient
  * Liste des utilisateurs
  * Statistiques globales

### **2. Créer des comptes (`create_user_page.dart`)**
Formulaire pour créer :
- **Centres de santé** : nom, email, téléphone, adresse, mot de passe
- **Patients** : nom, email, téléphone, adresse, mot de passe
→ Sauvegarde directe dans Firebase

### **3. Liste des utilisateurs (`users_list_page.dart`)**
Onglets :
- PATIENTS : Liste de tous les patients
- CENTRES : Liste de tous les centres
- ADMINS : Liste des administrateurs
Fonctions :
- Recherche multi-critères
- Visualisation
- Suppression de comptes

---

## 🗺️ Routes ajoutées dans `main.dart`

### **Routes Centre de santé**
```dart
'/center/home'            → CenterHomePage (Dashboard)
'/center/add-consultation'→ AddConsultationPage (Nouvelle consultation)
'/center/patients'        → PatientsListPage (Recherche patients)
'/center/appointments'    → CenterAppointmentsPage (Gestion RDV)
```

### **Routes Administrateur**
```dart
'/admin/home'             → AdminHomePage (Dashboard admin)
'/admin/users'            → UsersListPage (Liste utilisateurs)
'/admin/create-center'    → CreateUserPage (Créer centre)
'/admin/create-patient'   → CreateUserPage (Créer patient)
```

---

## 🎨 Design unifié

**Toutes les pages utilisent** :
- ✅ `CustomAppBar` avec dégradé bleu-vert
- ✅ Bouton MENU (ou flèche retour)
- ✅ Même palette de couleurs
- ✅ Cartes avec elevation et bordures arrondies
- ✅ Commentaires complets partout

---

## 🔥 Collection Firebase ajoutée

### **Collection `consultations`**
```
consultations/
  {consultationId}/
    - id: string
    - patientId: string
    - centerId: string
    - doctorName: string
    - dateTime: timestamp
    - reason: string
    - diagnosis: string
    - treatment: string?
    - prescription: string?
    - notes: string?
    - vitalSigns: map?
    - createdAt: timestamp
    - updatedAt: timestamp
```

---

## 🚀 Prochaines étapes pour finaliser

1. **Tester les pages centres** : Connexion en tant que centre
2. **Tester les pages admin** : Connexion en tant qu'admin
3. **Créer des données de test** dans Firebase
4. **Ajuster le design** si besoin
5. **Ajouter la persistance** des consultations dans health_record_page.dart

---

## 📝 Notes importantes

- Tous les fichiers sont **commentés en détail**
- Architecture **modulaire et réutilisable**
- Code **propre et maintenable**
- Design **unifié** sur toute l'application
- Aucune modification du design existant (Patient)
- Prêt pour déploiement et tests

---

**Créé le** : 8 octobre 2025
**Version** : 1.0

