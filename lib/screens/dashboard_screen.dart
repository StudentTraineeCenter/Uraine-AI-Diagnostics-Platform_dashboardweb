// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Použijeme 'Wrap' pre responzívne zobrazenie kariet
    return Wrap(
      spacing: 24.0, // Horizontálna medzera medzi kartami
      runSpacing: 24.0, // Vertikálna medzera medzi kartami
      
      children: [
        
        // KARTA 1: Urgentné Upozornenia 
        DashboardCard(
          title: "Urgentné Upozornenia",
          width: 400,
          child: Column(
            children: [
              _buildAlertItem(
                text: "Pacient Mráz: Kritický zákal moču",
                color: Colors.red,
                icon: Icons.error,
              ),
              const Divider(),
              _buildAlertItem(
                text: "Pacientka Horváthová: Nezrovnalosti vo farbe",
                color: Colors.orange,
                icon: Icons.warning,
              ),
            ],
          ),
        ),

        // KARTA 2: Posledné Merania 
        DashboardCard(
          title: "Posledné Merania",
          width: 400,
          child: Column(
            children: [
              _buildMeasurementItem(
                name: "P. Mráz",
                result: "Vysoký zákal",
                time: "09:18:28",
              ),
              const Divider(),
              _buildMeasurementItem(
                name: "J. Horváthová (Svetlá farba)",
                result: "07:43:58", // Tu je v dizajne len čas
                time: "",
              ),
              const Divider(),
               _buildMeasurementItem(
                name: "M. Novotný (Normálne)",
                result: "07:43:58",
                time: "",
              ),
            ],
          ),
        ),

        // KARTA 3: Štatistické karty (použijeme Row na ich zoskupenie)
        // Toto je malý "trik", aby boli vedľa seba a spolu zabrali 400px
        Row(
          mainAxisSize: MainAxisSize.min, // Zmenší sa na obsah
          children: [
            // KARTA 3a: Aktívni pacienti 
            DashboardCard(
              title: "Aktívny pacienti",
              width: 188, // 400 / 2 - medzera
              child: _buildStatItem(
                value: "145",
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 24),
            // KARTA 3b: Nové merania (24h) 
            DashboardCard(
              title: "Nové merania (24h)",
              width: 188, // 400 / 2 - medzera
              child: _buildStatItem(
                value: "15+3",
                color: Colors.green,
                icon: Icons.arrow_upward,
              ),
            ),
          ],
        ),

        // KARTA 4: Graf Trendov 
        const DashboardCard(
          title: "Graf trendov",
          width: 400,
          child: SizedBox(
            height: 200, // Dáme grafu nejakú výšku
            child: Center(
              // TODO: Neskôr nahradiť reálnym grafom
              child: Text("... (placeholder pre graf) ..."),
            ),
          ),
        ),
        
      ],
    );
  }

  // Pomocný widget pre položku v "Posledné Merania"
  Widget _buildMeasurementItem({required String name, required String result, required String time}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 14)),
          Text("$result $time", style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  // Pomocný widget pre položku v "Urgentné Upozornenia"
  Widget _buildAlertItem({required String text, required Color color, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // Pomocný widget pre štatistickú položku
  Widget _buildStatItem({required String value, required Color color, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, color: color, size: 28),
          ]
        ],
      ),
    );
  }
}


// -----------------------------------------------------------------
// TOTO JE NÁŠ NOVÝ "PROFI" OPAKOVANE POUŽITEĽNÝ WIDGET
// -----------------------------------------------------------------
// Tento kód môžeš nechať tu, alebo (ešte lepšie) vytvoriť 
// v 'lib/' priečinok 'widgets' a tam súbor 'dashboard_card.dart'
// a vložiť ho tam (a potom ho sem importovať).
// Pre jednoduchosť ho nechávam tu.

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double width;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.width = 300, // Predvolená šírka
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hlavička karty
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          // Telo karty
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }
}