// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Pre kDebugMode

class AuthService {
  // Získame inštanciu FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. STREAM: Toto je najdôležitejšia časť
  // Stream, ktorý nám kedykoľvek povie, či sa stav používateľa zmenil
  // (prihlásil sa, odhlásil sa, atď.)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 2. FUNKCIA: Prihlásenie
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Ak prebehlo OK, vrátime null (žiadna chyba)
      return null;
    } on FirebaseAuthException catch (e) {
      // Ak nastala chyba, vrátime chybovú hlášku
      if (kDebugMode) {
        print(e.message); // Pre nás na ladenie
      }
      return e.message ?? "Neznáma chyba pri prihlasovaní.";
    } catch (e) {
      return e.toString();
    }
  }

  // 3. FUNKCIA: Odhlásenie
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // TODO: Tu by prišla logika pre 2FA [cite: 374-385], 
  // ktorá je pokročilejšia (vyžaduje Multi-Factor Authentication v Firebase)
  // Zatiaľ ju pre milestone môžeme preskočiť.
}