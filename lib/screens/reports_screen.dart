// lib/screens/reports_screen.dart

import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hlavička s akciami
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mesačné výkazy & Exporty",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              ElevatedButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.add),
                label: const Text("Vytvoriť nový report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              )
            ],
          ),
          
          const SizedBox(height: 32),

          // Štatistické karty (Grid)
          Row(
            children: [
              Expanded(child: _buildStatCard("Počet Analýz (Tento mesiac)", "1,240", Colors.blue)),
              const SizedBox(width: 24),
              Expanded(child: _buildStatCard("Odhalené Riziká", "42", Colors.orange)),
              const SizedBox(width: 24),
              Expanded(child: _buildStatCard("Vygenerované PDF", "156", Colors.green)),
            ],
          ),

          const SizedBox(height: 40),
          const Text("Archív reportov", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Zoznam reportov (Tabuľka)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (c, i) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text("Mesačný súhrn - ${[
                    "December 2025", "November 2025", "Október 2025", "September 2025", "August 2025"
                  ][index]}"),
                  subtitle: const Text("Vytvoril: Dr. Smieško • Veľkosť: 1.2 MB"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: Colors.grey)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
        ],
      ),
    );
  }
}