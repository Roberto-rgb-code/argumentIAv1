import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../../models/university_user.dart';
import '../../theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _universityCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _studentIdCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  
  bool _loading = false;
  bool _obscure = true;
  int _selectedSemester = 1;
  List<String> _selectedInterests = [];
  
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    _displayNameCtrl.dispose();
    _universityCtrl.dispose();
    _careerCtrl.dispose();
    _studentIdCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // Crear usuario en Firebase Auth
      await AuthService.instance.registerWithEmail(_emailCtrl.text, _passCtrl.text);
      
      // Crear perfil universitario
      await _firebaseService.createUniversityUser(
        email: _emailCtrl.text.trim(),
        displayName: _displayNameCtrl.text.trim(),
        university: _universityCtrl.text.trim(),
        career: _careerCtrl.text.trim(),
        studentId: _studentIdCtrl.text.trim(),
        semester: _selectedSemester,
        interests: _selectedInterests,
        bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
      );
      
      if (!mounted) return;
      Navigator.of(context).pop(); // vuelve al login; AuthGate abrirá tu app por sesión activa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. ¡Bienvenido!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrarse: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || v.isEmpty || !v.contains('@')) ? 'Ingresa un correo válido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      decoration: InputDecoration(
                        labelText: 'Contraseña (mín. 6)',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                      obscureText: _obscure,
                      validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pass2Ctrl,
                      decoration: const InputDecoration(
                        labelText: 'Repite contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: _obscure,
                      validator: (v) => (v != _passCtrl.text) ? 'No coincide' : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _register,
                        icon: _loading
                            ? const SizedBox(
                                width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.person_add_alt_1),
                        label: const Text('Crear cuenta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .move(begin: const Offset(0, 8)),
        ),
      ),
    );
  }
}
