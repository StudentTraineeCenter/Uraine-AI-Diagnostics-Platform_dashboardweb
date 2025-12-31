// lib/screens/patient_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uraine_web/services/dashboard_service.dart';
import 'package:uraine_web/screens/patient_profile_screen.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardService = DashboardService();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter / Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Vyhľadať pacienta...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text("Filtrovať"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2C3E50),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  elevation: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // TABUĽKA PACIENTOV
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: StreamBuilder<List<PatientSummary>>(
                // Toto zabezpečuje, že vidíš unikátnych ľudí z DB
                stream: dashboardService.getPatientsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                     return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("Zatiaľ žiadni pacienti v databáze.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    );
                  }

                  // Máme dáta z DB
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FA)),
                        dataRowHeight: 72,
                        horizontalMargin: 24,
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('PACIENT', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF546E7A)))),
                          DataColumn(label: Text('POSLEDNÉ MERANIE', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF546E7A)))),
                          DataColumn(label: Text('VÝSLEDOK', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF546E7A)))),
                          DataColumn(label: Text('STAV', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF546E7A)))),
                          DataColumn(label: Text('AKCIA', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF546E7A)))),
                        ],
                        rows: snapshot.data!.map((patient) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFFE3F2FD),
                                    radius: 18,
                                    child: const Icon(Icons.person, color: Color(0xFF1565C0), size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Zobrazíme ID (neskôr môžeme nahradiť menom z kolekcie Users)
                                      Text("Pacient ${patient.userId.substring(0, 6)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                                      Text(patient.userId, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                ]),
                              ),
                              DataCell(Text(DateFormat('dd.MM.yyyy  HH:mm').format(patient.lastUpdate))),
                              DataCell(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(patient.lastColor, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  Text(patient.lastClarity, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: patient.isCritical ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: patient.isCritical ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3)
                                    )
                                  ),
                                  child: Text(
                                    patient.isCritical ? "Vyžaduje akciu" : "Stabilný",
                                    style: TextStyle(
                                      color: patient.isCritical ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => PatientProfileScreen(
                                        userId: patient.userId, 
                                        patientName: "Pacient ${patient.userId.substring(0, 6)}"
                                      )
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A90E2),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0
                                  ),
                                  child: const Text("Detail"),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}