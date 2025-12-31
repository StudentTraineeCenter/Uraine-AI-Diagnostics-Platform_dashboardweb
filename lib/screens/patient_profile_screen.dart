// lib/screens/patient_profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uraine_web/theme/app_colors.dart';
import 'package:uraine_web/widgets/dashboard_card.dart';

class PatientProfileScreen extends StatelessWidget {
  final String userId;
  final String patientName;

  const PatientProfileScreen({super.key, required this.userId, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(patientName, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('analyses').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).limit(1).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text("Žiadne dáta"));

          var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          
          Map<String, dynamic> params = data['bioParameters'] ?? {
             "pH": "6.0", "Glukóza": "Negat", "Bielkoviny": "Negat", "Krv": "Negat"
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horný riadok s AI Diagnózou
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // TERAZ TO UŽ PÔJDE, LEBO SME TO PRIDALI DO APP COLORS
                    gradient: AppColors.primaryGradient, 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("AI Diagnostika (Gemini Analysis)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        data['aiAnalysis'] ?? "Analýza sa spracováva...",
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text("Bio-Chemické Parametre", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: params.entries.map((e) {
                    return _buildParamCard(e.key, e.value.toString());
                  }).toList(),
                ),
                
                const SizedBox(height: 32),
                
                Row(
                  children: [
                    Expanded(child: DashboardCard(
                      title: "Vizuálna Kontrola",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                           _buildVisualItem("Farba", data['farba'] ?? "?", Icons.colorize, Colors.amber),
                           _buildVisualItem("Zákal", data['zakal'] ?? "?", Icons.opacity, Colors.blue),
                        ],
                      ),
                    )),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParamCard(String title, String value) {
    bool isNegative = value.toLowerCase().contains("negat") || value == "Norma";
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isNegative ? Colors.transparent : AppColors.errorRed.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(
            color: isNegative ? AppColors.primaryDark : AppColors.errorRed, 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          )),
        ],
      ),
    );
  }

  Widget _buildVisualItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}