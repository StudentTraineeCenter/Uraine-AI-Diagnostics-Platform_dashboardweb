// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:uraine_web/services/dashboard_service.dart';
import 'package:uraine_web/widgets/dashboard_card.dart';
import 'package:intl/intl.dart';
import 'package:uraine_web/screens/patient_profile_screen.dart';

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
                  Expanded(child: _buildKpiCard("Monitorovaní Pacienti", "${stats['total']}", Icons.people_alt, const Color(0xFF4A90E2))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildKpiCard("Rizikové Nálezy", "${stats['critical']}", Icons.warning_rounded, const Color(0xFFE74C3C))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildKpiCard("Dnešné Analýzy", "${stats['today']}", Icons.today, const Color(0xFF2ECC71))),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),

          // 2. HLAVNÁ SEKCIA
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URGENTNÉ PRÍPADY
              Expanded(
                flex: 2,
                child: DashboardCard(
                  title: "⚠️ Urgentné Upozornenia",
                  width: double.infinity,
                  child: StreamBuilder<List<PatientSummary>>(
                    stream: dashboardService.getPatientsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      final criticalPatients = snapshot.data!.where((p) => p.isCritical).take(5).toList();

                      if (criticalPatients.isEmpty) {
                        return Container(
                          height: 120,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
                              SizedBox(height: 10),
                              Text("Všetci pacienti sú stabilizovaní.", style: TextStyle(color: Colors.grey)),
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

              // POSLEDNÁ AKTIVITA
              Expanded(
                flex: 1,
                child: DashboardCard(
                  title: "🕒 Posledná Aktivita",
                  width: double.infinity,
                  child: StreamBuilder<List<PatientSummary>>(
                    stream: dashboardService.getPatientsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final latest = snapshot.data!.take(6).toList(); // Posledných 6
                      
                      return Column(
                        children: latest.map((p) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFF5F7FA),
                            radius: 18,
                            child: Icon(Icons.history, size: 18, color: Colors.grey[600]),
                          ),
                          title: Text("Pacient ${p.userId.substring(0, 5)}...", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat('HH:mm').format(p.lastUpdate), style: const TextStyle(fontSize: 11)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                               color: p.isCritical ? Colors.red[50] : Colors.green[50],
                               borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(p.isCritical ? "Riziko" : "OK", 
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: p.isCritical ? Colors.red : Colors.green)),
                          ),
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(
                                builder: (_) => PatientProfileScreen(userId: p.userId, patientName: "Pacient ${p.userId.substring(0, 5)}")
                              ));
                          },
                        )).toList(),
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

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
              Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
          builder: (_) => PatientProfileScreen(userId: patient.userId, patientName: "Pacient ${patient.userId.substring(0, 5)}")
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.2))
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pacient ${patient.userId.substring(0, 6)}...", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  Text("Nález: ${patient.lastColor}, ${patient.lastClarity}", style: TextStyle(color: Colors.red[700], fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
          ],
        ),
      ),
    );
  }
}