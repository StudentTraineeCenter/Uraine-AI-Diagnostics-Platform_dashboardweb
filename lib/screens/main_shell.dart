// lib/screens/main_shell.dart

import 'package:flutter/material.dart';
import 'package:uraine_web/services/auth_service.dart';

// Importujeme naše 4 obrazovky
import 'package:uraine_web/screens/dashboard_screen.dart';
import 'package:uraine_web/screens/patient_list_screen.dart';
import 'package:uraine_web/screens/reports_screen.dart';
import 'package:uraine_web/screens/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    DashboardScreen(),
    PatientListScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  // Mapovanie indexu na názov obrazovky pre horný panel
  static const List<String> _screenTitles = [
    "Dashboard",
    "Zoznam Pacientov",
    "Reporty",
    "Nastavenia"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // KROK 1: Pridávame horný panel (AppBar)
      appBar: AppBar(
        // Nastavíme bielu farbu pozadia a čierny text
        backgroundColor: Colors.white,
        elevation: 1.0, // Jemný tieň
        iconTheme: const IconThemeData(color: Colors.black),
        
        // Názov sa bude meniť podľa toho, kde sme
        title: Text(
          _screenTitles[_selectedIndex],
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        
        // Komponenty na pravej strane AppBar-u
        actions: [
          // 1. Vyhľadávací panel (zatiaľ len vizuálny)
          Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Vyhľadať pacienta...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.zero, // Zmenšíme výšku
              ),
            ),
          ),

          // 2. Profil lekára a odhlásenie
          PopupMenuButton<String>(
            offset: const Offset(0, 40), // Posunieme menu trochu nižšie
            onSelected: (value) {
              if (value == 'logout') {
                AuthService().signOut();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Môj profil'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Odhlásiť sa', style: TextStyle(color: Colors.red)),
              ),
            ],
            // Toto je tlačidlo, ktoré vidíš (profil)
            child: Row(
              children: const [
                CircleAvatar(
                  // TODO: Pridať reálnu fotku
                  backgroundColor: Colors.blueAccent,
                  child: Text("DS", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text(
                  "Dr. Smieško", // TODO: Načítať reálne meno
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      
      // KROK 2: Telo aplikácie (Row s bočným panelom)
      body: Row(
        children: <Widget>[
          // 1. STĹPEC: Bočný navigačný panel
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            // Zmeníme typ, aby sa text zobrazoval len pri aktívnej položke
            labelType: NavigationRailLabelType.selected,
            backgroundColor: const Color(0xFFF8F9FA), // Svetlé pozadie
            
            // Pridáme logo URAINE MD hore 
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: const [
                  // TODO: Sem vložiť reálne logo
                  Icon(Icons.medical_services, color: Colors.blue, size: 30),
                  Text("URAINE MD", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people_alt),
                label: Text('Pacienti'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Reporty'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Nastavenia'),
              ),
            ],
          ),
          
          const VerticalDivider(thickness: 1, width: 1),

          // 2. STĹPEC: Hlavný obsah
          Expanded(
            child: Container(
              // Dáme obsahu sivé pozadie, aby karty vynikli
              color: const Color(0xFFF0F2F5),
              // Pridáme padding, aby obsah nebol nalepený na okrajoch
              padding: const EdgeInsets.all(24.0),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}