import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../../models/university_user.dart';
import '../../theme/app_theme.dart';
import 'login_page.dart';

class RegisterPageNew extends StatefulWidget {
  const RegisterPageNew({super.key});
  @override
  State<RegisterPageNew> createState() => _RegisterPageNewState();
}

class _RegisterPageNewState extends State<RegisterPageNew> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
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
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppTheme.backgroundGrey,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Información básica
                      Text(
                        'Información Personal',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoalBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _displayNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'El nombre es requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.isEmpty || !v.contains('@')) ? 'Ingresa un correo válido' : null,
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
                        validator: (v) => (v == null || v != _passCtrl.text) ? 'Las contraseñas no coinciden' : null,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Información universitaria
                      Text(
                        'Información Universitaria',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoalBlack,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _universityCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Universidad',
                          prefixIcon: Icon(Icons.school),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'La universidad es requerida' : null,
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _careerCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Carrera',
                          prefixIcon: Icon(Icons.work),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'La carrera es requerida' : null,
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _studentIdCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Número de estudiante',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'El número de estudiante es requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<int>(
                        value: _selectedSemester,
                        decoration: const InputDecoration(
                          labelText: 'Semestre',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: List.generate(12, (index) => index + 1).map((semester) {
                          return DropdownMenuItem(
                            value: semester,
                            child: Text('Semestre $semester'),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedSemester = value ?? 1),
                      ),
                      const SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _bioCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Biografía (opcional)',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Crear cuenta',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
