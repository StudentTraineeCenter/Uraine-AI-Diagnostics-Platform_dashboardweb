// lib/screens/dashboard_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uraine_web/services/dashboard_service.dart';
import 'package:uraine_web/screens/patient_profile_screen.dart';
import 'package:uraine_web/widgets/dashboard_card.dart';
import 'package:uraine_web/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardService = DashboardService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. KPI KARTY (LIVE DÁTA)
          StreamBuilder<Map<String, int>>(
            stream: dashboardService.getStatsStream(),
            builder: (context, snapshot) {
              final stats = snapshot.data ?? {'total': 0, 'critical': 0, 'today': 0};
              
              return Row(
                children: [
                  Expanded(child: _buildKpiCard("Monitorovaní Pacienti", "${stats['total']}", Icons.people_alt, AppColors.primaryBlue)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildKpiCard("Rizikové Nálezy", "${stats['critical']}", Icons.warning_rounded, AppColors.errorRed)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildKpiCard("Dnešné Analýzy", "${stats['today']}", Icons.today, AppColors.actionGreen)),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),

          // 2. HLAVNÁ SEKCIA
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URGENTNÉ PRÍPADY (LAVÁ STRANA - ŠIRŠIA)
              Expanded(
                flex: 2,
                child: DashboardCard(
                  title: "⚠️ Urgentné Upozornenia",
                  width: double.infinity,
                  child: StreamBuilder<List<PatientSummary>>(
                    stream: dashboardService.getPatientsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      // Filtrujeme len kritických pacientov
                      final criticalPatients = snapshot.data!.where((p) => p.isCritical).take(5).toList();

                      if (criticalPatients.isEmpty) {
                        return Container(
                          height: 150,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 48, color: Colors.green.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              const Text("Všetci pacienti sú stabilizovaní.", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: criticalPatients.map((patient) => _buildAlertRow(context, patient)).toList(),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 32),

              // POSLEDNÁ AKTIVITA (PRAVÁ STRANA - UžŠIA)
              Expanded(
                flex: 1,
                child: DashboardCard(
                  title: "🕒 Posledná Aktivita",
                  width: double.infinity,
                  child: StreamBuilder<List<PatientSummary>>(
                    stream: dashboardService.getPatientsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      // Zoberieme prvých 6 záznamov (sú už zoradené podľa času v službe, ale pre istotu...)
                      // Poznámka: DashboardService už vracia zoradený list, kde sú kritickí prví. 
                      // Ak chceme čisto časovú os, museli by sme to zoradiť znova, ale zatiaľ necháme logiku služby.
                      final latest = snapshot.data!.take(6).toList(); 
                      
                      if (latest.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text("Žiadna aktivita."));

                      return Column(
                        children: latest.map((p) => _buildActivityRow(context, p)).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGETY ---

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Jemne zaoblenejšie
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow(BuildContext context, PatientSummary patient) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => PatientProfileScreen(userId: patient.userId, patientName: "Načítavam...")
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.errorRed.withOpacity(0.2))
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MENO PACIENTA (Z Users kolekcie)
                  _buildUserName(patient.userId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
                  const SizedBox(height: 4),
                  Text("Nález: ${patient.lastColor}, ${patient.lastClarity}", 
                    style: const TextStyle(color: AppColors.errorRed, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text("Posledná aktualizácia: ${DateFormat('HH:mm').format(patient.lastUpdate)}",
                    style: TextStyle(color: AppColors.errorRed.withOpacity(0.7), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.errorRed),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow(BuildContext context, PatientSummary patient) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: patient.isCritical ? AppColors.errorRed.withOpacity(0.1) : AppColors.background,
        radius: 20,
        child: Icon(
          patient.isCritical ? Icons.priority_high : Icons.history, 
          size: 18, 
          color: patient.isCritical ? AppColors.errorRed : Colors.grey[600]
        ),
      ),
      // MENO PACIENTA
      title: _buildUserName(patient.userId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      
      subtitle: Text(DateFormat('dd.MM  HH:mm').format(patient.lastUpdate), style: const TextStyle(fontSize: 11, color: Colors.grey)),
      
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
           color: patient.isCritical ? AppColors.errorRed.withOpacity(0.1) : AppColors.actionGreen.withOpacity(0.1),
           borderRadius: BorderRadius.circular(20)
        ),
        child: Text(patient.isCritical ? "Riziko" : "OK", 
          style: TextStyle(
            fontSize: 11, 
            fontWeight: FontWeight.bold, 
            color: patient.isCritical ? AppColors.errorRed : AppColors.actionGreen
          )
        ),
      ),
      onTap: () {
         Navigator.push(context, MaterialPageRoute(
            builder: (_) => PatientProfileScreen(userId: patient.userId, patientName: "Načítavam...")
          ));
      },
    );
  }

  // HELPER PRE NAČÍTANIE MENA Z DATABÁZY
  Widget _buildUserName(String userId, {required TextStyle style}) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 80, 
            height: 14, 
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))
          );
        }
        
        String displayName = "Neznámy pacient";
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          displayName = data['fullName'] ?? data['name'] ?? userId;
        }

        return Text(displayName, style: style, overflow: TextOverflow.ellipsis);
      },
    );
  }
}