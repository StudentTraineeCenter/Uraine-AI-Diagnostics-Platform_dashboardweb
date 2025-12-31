// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotif = true;
  bool _pushNotif = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Profil Lekára"),
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(radius: 24, backgroundColor: Color(0xFF4A90E2), child: Text("MS", style: TextStyle(color: Colors.white))),
                  title: const Text("MUDr. Milan Smieško", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: const Text("Urológia • ID: 849201"),
                  trailing: OutlinedButton(onPressed: () {}, child: const Text("Upraviť")),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.email_outlined, color: Colors.grey),
                  title: Text("Email"),
                  subtitle: Text("milansmiesko4@gmail.com"),
                ),
                const ListTile(
                  leading: Icon(Icons.phone_outlined, color: Colors.grey),
                  title: Text("Kontakt na ambulanciu"),
                  subtitle: Text("+421 950 430 915"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader("Notifikácie & Upozornenia"),
          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Kritické upozornenia emailom"),
                  subtitle: const Text("Dostávať okamžité správy pri rizikových výsledkoch"),
                  value: _emailNotif,
                  activeColor: const Color(0xFF4A90E2),
                  onChanged: (val) => setState(() => _emailNotif = val),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text("Push notifikácie"),
                  subtitle: const Text("Upozornenia v prehliadači"),
                  value: _pushNotif,
                  activeColor: const Color(0xFF4A90E2),
                  onChanged: (val) => setState(() => _pushNotif = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader("Systém"),
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.grey),
                  title: const Text("Jazyk rozhrania"),
                  subtitle: const Text("Slovenčina"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text("Tmavý režim"),
                  secondary: const Icon(Icons.dark_mode_outlined, color: Colors.grey),
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Center(
             child: Text("Verzia platformy: 1.0.5 (Build 48)", style: TextStyle(color: Colors.grey[400])),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF2C3E50),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}