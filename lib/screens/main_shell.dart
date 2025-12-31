// lib/screens/main_shell.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uraine_web/services/auth_service.dart';
import 'package:uraine_web/screens/dashboard_screen.dart';
import 'package:uraine_web/screens/patient_list_screen.dart';
import 'package:uraine_web/screens/reports_screen.dart';
import 'package:uraine_web/screens/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  
  // Zoznam obrazoviek
  static const List<Widget> _screens = <Widget>[
    DashboardScreen(),
    PatientListScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  static const List<String> _screenTitles = [
    "Prehľad Ambulancie",
    "Databáza Pacientov",
    "Lekárske Reporty",
    "Nastavenia Platformy"
  ];

  @override
  Widget build(BuildContext context) {
    // HARDCODED ÚDAJE LEKÁRA (Pre konzistenciu)
    const String doctorName = "MUDr. Milan Smieško";
    const String doctorEmail = "milansmiesko4@gmail.com";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Text(
          _screenTitles[_selectedIndex],
          style: const TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.w800),
        ),
        actions: [
          // Profil vpravo hore
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 50),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4A90E2),
                    child: Text("MS", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(doctorName, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("Urológia - Ambulancia", style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
              onSelected: (val) {
                if (val == 'logout') AuthService().signOut();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(enabled: false, child: Text(doctorEmail, style: TextStyle(fontSize: 12, color: Colors.grey))),
                const PopupMenuItem(value: 'logout', child: Text("Odhlásiť sa", style: TextStyle(color: Colors.red))),
              ],
            ),
          )
        ],
      ),
      body: Row(
        children: [
          // BOČNÝ PANEL
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
            extended: true,
            minExtendedWidth: 240,
            backgroundColor: Colors.white,
            selectedIconTheme: const IconThemeData(color: Color(0xFF1565C0)), 
            selectedLabelTextStyle: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelTextStyle: const TextStyle(color: Color(0xFF607D8B), fontWeight: FontWeight.w500),
            
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.health_and_safety_rounded, color: Color(0xFF4A90E2), size: 32),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("URAINE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF2C3E50))),
                      Text("MD PLATFORM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF4A90E2), letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
            ),
            
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Prehľad')),
              NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Pacienti')),
              NavigationRailDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: Text('Reporty')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Nastavenia')),
            ],
          ),
          
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFEEEEEE)),
          
          // HLAVNÝ OBSAH
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}