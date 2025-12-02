// main.dart

import 'package:flutter/material.dart';
// 1. Importuj firebase_core a náš konfiguračný súbor
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:uraine_web/auth_wrapper.dart';

// 2. Importujeme si našu budúcu prihlasovaciu obrazovku
// (Zatiaľ bude červená, o chvíľu ju vytvoríme)
// import 'package:uraine_md_web/login_screen.dart'; 

void main() async {
  // 3. Tieto dva riadky sú dôležité na inicializáciu
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const UraineMdApp());
}

class UraineMdApp extends StatelessWidget {
  const UraineMdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URAINE MD Portál',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 4. Toto bude naša štartovacia obrazovka
      // Odkomentuj tento riadok, keď vytvoríme súbor
      // home: const LoginScreen(), 
      
      // Zatiaľ tam nechaj toto, aby si nemal chybu:
      home: const AuthWrapper(),
    );
  }
}