// lib/screens/patient_profile_screen.dart

import 'package:flutter/material.dart';
// Importujeme náš widget pre karty z dashboardu, zrecyklujeme ho!
import 'package:uraine_web/screens/dashboard_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  // Budeme chcieť vedieť, ktorého pacienta máme zobraziť
  final String patientName;

  const PatientProfileScreen({
    super.key,
    required this.patientName, // Meno dostaneme z predchádzajúcej obrazovky
  });

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------
    // O OPRAVA: Celý obsah sme zabalili do 'Scaffold'.
    // -----------------------------------------------------------------
    // To poskytne 'Material' widget, ktorý 'TabBar' potrebuje.
    return Scaffold(
      // Dáme mu rovnakú farbu pozadia, ako má náš dashboard
      backgroundColor: const Color(0xFFF0F2F5),

      // Celý náš predošlý kód je teraz vo vlastnosti 'body:'
      body: DefaultTabController(
        length: 4, // Máme 4 záložky
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 1. HLAVIČKA PACIENTA
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // Tlačidlo Späť
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Jednoducho sa vrátime na predošlú obrazovku
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 30,
                    // TODO: Reálna fotka
                    child: Text("JH"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName, // Zobrazíme meno, ktoré sme dostali
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Dátum narodenia: 10.03.1999", // Dummy dáta
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        "Diagnóza: Chronická Pyelonefritída", // Dummy dáta
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. LIŠTA SO ZÁLOŽKAMI (TABS)
            // Teraz je už vnútri Scaffold-u a bude fungovať
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.blue, // Aktívna záložka
                unselectedLabelColor: Colors.grey, // Neaktívne
                tabs: [
                  Tab(text: 'Prehľad'),
                  Tab(text: 'História Meraní'),
                  Tab(text: 'Denník Symptómov'),
                  Tab(text: 'Dokumenty'),
                ],
              ),
            ),

            // 3. OBSAH ZÁLOŽIEK
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24.0),
                child: TabBarView(
                  children: [

                    // OBSAH 1: PREHĽAD (Podľa dizajnu)
                    _buildOverviewTab(),

                    // OBSAH 2: HISTÓRIA (Zatiaľ placeholder)
                    const Center(
                        child: Text("Tu bude detailná história meraní.")),

                    // OBSAH 3: DENNÍK (Zatiaľ placeholder)
                    const Center(child: Text("Tu bude denník symptómov.")),

                    // OBSAH 4: DOKUMENTY (Zatiaľ placeholder)
                    const Center(child: Text("Tu budú zdieľané dokumenty.")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pomocný widget, ktorý stavia obsah záložky "Prehľad"
  Widget _buildOverviewTab() {
    return Wrap(
      spacing: 24.0,
      runSpacing: 24.0,
      children: const [
        // Zrecyklujeme našu kartu z Dashboardu!
        DashboardCard(
          title: "Vývoj zákalu (30 dní)",
          width: 400,
          child: SizedBox(
            height: 200,
            child: Center(child: Text("... (placeholder pre graf zákalu) ...")),
          ),
        ),
        DashboardCard(
          title: "Vývoj farby (30 dní)",
          width: 400,
          child: SizedBox(
            height: 200,
            child: Center(child: Text("... (placeholder pre graf farby) ...")),
          ),
        ),
        DashboardCard(
          title: "Posledné meranie",
          width: 400,
          child: ListTile(
            title: Text("20.01.2024: Vysoký zákal, tmavá farba"),
            subtitle: Text("Dummy dáta merania"),
          ),
        ),
        DashboardCard(
          title: "Posledné symptómy",
          width: 400,
          child: ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text("Pálenie pri močení"),
            subtitle: Text("Bolesť chrbta"),
          ),
        ),
      ],
    );
  }
}