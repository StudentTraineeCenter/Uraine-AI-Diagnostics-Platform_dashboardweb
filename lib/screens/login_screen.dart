// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:uraine_web/services/auth_service.dart'; // Importuj service

class LoginScreen extends StatefulWidget {
  // Tento konštruktor sme minule nemali ako 'const', preto bola chyba v auth_wrapperi
  const LoginScreen({Key? key}) : super(key: key);

  // Táto funkcia chýbala v tvojom kóde, preto chyba 'createState'
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _2faController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _2faController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await _authService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (error != null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
    
    // Ak sa prihlásenie podarilo, AuthWrapper nás presmeruje
    // Ale ak sme stále tu a načítavame, zrušme to (pre prípad chyby)
    if (mounted && _isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      
      // TOTO JE DÔLEŽITÁ OPRAVA: 'body:' a nie 'child:'
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Vložiť logo URAINE MD
              const Text(
                "URAINE MD",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                "Prihlásenie pre lekárov",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Formulárové polia
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Heslo",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _2faController,
                decoration: const InputDecoration(
                  labelText: "Dvojfaktorová autentifikácia (2FA)",
                  helperText: "Kód z aplikácie",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Prihlasovacie tlačidlo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text("Prihlásiť sa"),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Logika pre zabudnuté heslo
                },
                child: const Text("Zabudnuté heslo?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // <-- TÁTO ZÁTVORKA ASI CHÝBALA