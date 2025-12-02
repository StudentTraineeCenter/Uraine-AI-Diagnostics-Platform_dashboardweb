// lib/screens/patient_list_screen.dart

import 'package:flutter/material.dart';
import 'package:uraine_web/screens/patient_profile_screen.dart';

// Aby sme to mali "profi", vytvoríme si malú triedu (model)
// pre naše falošné dáta.
class _DummyPatient {
  final String name;
  final String lastMeasurement;
  final IconData trendIcon;
  final Color trendColor;

  const _DummyPatient({
    required this.name,
    required this.lastMeasurement,
    required this.trendIcon,
    required this.trendColor,
  });
}

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  // Vytvoríme si zoznam našich falošných (dummy) pacientov
  final List<_DummyPatient> _dummyPatients = const [
    _DummyPatient(
      name: "P. Mráz",
      lastMeasurement: "21.01.2024",
      trendIcon: Icons.check_circle,
      trendColor: Colors.green,
    ),
    _DummyPatient(
      name: "M. Veselý",
      lastMeasurement: "21.01.2024",
      trendIcon: Icons.warning,
      trendColor: Colors.orange,
    ),
    _DummyPatient(
      name: "J. Horváthová",
      lastMeasurement: "20.01.2024",
      trendIcon: Icons.check_circle,
      trendColor: Colors.green,
    ),
    _DummyPatient(
      name: "A. Holá",
      lastMeasurement: "19.01.2024",
      trendIcon: Icons.error, // Červený výkričník z dizajnu
      trendColor: Colors.red,
    ),
    _DummyPatient(
      name: "A. Kováč",
      lastMeasurement: "18.01.2024",
      trendIcon: Icons.check_circle,
      trendColor: Colors.green,
    ),
     _DummyPatient(
      name: "E. Urbanová",
      lastMeasurement: "17.01.2024",
      trendIcon: Icons.check_circle,
      trendColor: Colors.green,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    // Celá obrazovka bude jeden stĺpec
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // 1. HORNÁ LIŠTA S FILTRAMI (ako v dizajne)
        // (Zatiaľ len vizuálna, bez funkčnosti)
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // Zarovnáme doprava
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Vyhľadávanie...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Bez okraja
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () { /* TODO: Logika filtra */ },
              icon: const Icon(Icons.filter_list),
              label: const Text("Posledná aktivita"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1.0,
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24), // Medzera

        // 2. KARTA S TABUĽKOU PACIENTOV
        // Dáme ju do Expanded, aby vyplnila zvyšok miesta
        Expanded(
          child: Container(
            width: double.infinity, // Zaberie celú šírku
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DataTable(
              // Definícia stĺpcov (hlavička tabuľky)
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Meno', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Posledné meranie', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Trend', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text('Akcie', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              
              // Definícia riadkov (dáta)
              // Prejdeme cez náš zoznam pacientov a pre každého vytvoríme riadok
              rows: _dummyPatients.map((patient) {
                return DataRow(
                  cells: <DataCell>[
                    // Bunka 1: Meno
                    DataCell(Text(patient.name)),
                    
                    // Bunka 2: Posledné meranie
                    DataCell(Text(patient.lastMeasurement)),
                    
                    // Bunka 3: Trend (ikonka)
                    DataCell(Icon(patient.trendIcon, color: patient.trendColor)),
                    
                    // Bunka 4: Akcie (tlačidlo)
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          // Krok 7: Navigacia na profil pacienta
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PatientProfileScreen(
                                patientName: patient.name),
                            ),
                          );
                        },
                        child: const Text('Otvoriť profil'),
                      ),
                    ),
                  ],
                );
              }).toList(), // .toList() premení výsledok na zoznam riadkov
              
            ),
          ),
        ),
      ],
    );
  }
}