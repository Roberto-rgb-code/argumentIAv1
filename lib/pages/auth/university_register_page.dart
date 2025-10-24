import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../widgets/m3/dialecta_m3_components.dart';
import '../../theme/app_theme.dart';
import '../../models/university_user.dart';
import '../../services/firebase_service.dart';
import '../../services/auth_service.dart';

class UniversityRegisterPage extends StatefulWidget {
  const UniversityRegisterPage({super.key});

  @override
  State<UniversityRegisterPage> createState() => _UniversityRegisterPageState();
}

class _UniversityRegisterPageState extends State<UniversityRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseService = FirebaseService();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  // Controladores
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();

  // Variables de estado
  String _selectedUniversity = '';
  String _selectedCareer = '';
  int _selectedSemester = 1;
  List<String> _selectedInterests = [];
  File? _profileImage;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _studentIdController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Registro Universitario',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppTheme.primaryBlue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppTheme.primaryBlue,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de perfil
              _buildProfileImageSection(),
              const SizedBox(height: 24),

              // Información básica
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // Información universitaria
              _buildUniversityInfoSection(),
              const SizedBox(height: 24),

              // Intereses
              _buildInterestsSection(),
              const SizedBox(height: 24),

              // Información adicional
              _buildAdditionalInfoSection(),
              const SizedBox(height: 32),

              // Botón de registro
              _buildRegisterButton(),
              const SizedBox(height: 16),

              // Términos y condiciones
              _buildTermsAndConditions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickProfileImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryBlue,
                  width: 3,
                ),
                color: AppTheme.primaryBlue.withOpacity(0.1),
              ),
              child: _profileImage != null
                  ? ClipOval(
                      child: Image.file(
                        _profileImage!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    )
                  : Icon(
                      Icons.person_add_rounded,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca para agregar foto de perfil',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Básica',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        const SizedBox(height: 16),

        // Email
        DialectaM3Components.textField(
          label: 'Correo electrónico',
          hint: 'tu.email@universidad.edu.co',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty == true) return 'El correo es requerido';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Contraseña
        DialectaM3Components.textField(
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: (value) {
            if (value?.isEmpty == true) return 'La contraseña es requerida';
            if (value!.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppTheme.primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirmar contraseña
        DialectaM3Components.textField(
          label: 'Confirmar contraseña',
          hint: 'Repite tu contraseña',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          validator: (value) {
            if (value?.isEmpty == true) return 'Confirma tu contraseña';
            if (value != _passwordController.text) return 'Las contraseñas no coinciden';
            return null;
          },
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppTheme.primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Nombre completo
        DialectaM3Components.textField(
          label: 'Nombre completo',
          hint: 'Tu nombre y apellidos',
          controller: _displayNameController,
          validator: (value) {
            if (value?.isEmpty == true) return 'El nombre es requerido';
            if (value!.length < 2) return 'Mínimo 2 caracteres';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUniversityInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Universitaria',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        const SizedBox(height: 16),

        // Universidad
        DropdownButtonFormField<String>(
          value: _selectedUniversity.isEmpty ? null : _selectedUniversity,
          decoration: InputDecoration(
            labelText: 'Universidad',
            hintText: 'Selecciona tu universidad',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: UniversityUser.availableUniversities.map((university) {
            return DropdownMenuItem(
              value: university,
              child: Text(university),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedUniversity = value ?? ''),
          validator: (value) => value?.isEmpty == true ? 'Selecciona tu universidad' : null,
        ),
        const SizedBox(height: 16),

        // Carrera
        DropdownButtonFormField<String>(
          value: _selectedCareer.isEmpty ? null : _selectedCareer,
          decoration: InputDecoration(
            labelText: 'Carrera',
            hintText: 'Selecciona tu carrera',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: UniversityUser.availableCareers.map((career) {
            return DropdownMenuItem(
              value: career,
              child: Text(career),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedCareer = value ?? ''),
          validator: (value) => value?.isEmpty == true ? 'Selecciona tu carrera' : null,
        ),
        const SizedBox(height: 16),

        // Semestre
        Row(
          children: [
            Expanded(
              child: Text(
                'Semestre: $_selectedSemester',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.charcoalBlack,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _selectedSemester > 1
                      ? () => setState(() => _selectedSemester--)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                  color: AppTheme.primaryBlue,
                ),
                IconButton(
                  onPressed: _selectedSemester < 20
                      ? () => setState(() => _selectedSemester++)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                  color: AppTheme.primaryBlue,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ID de estudiante
        DialectaM3Components.textField(
          label: 'ID de estudiante',
          hint: 'Tu número de identificación estudiantil',
          controller: _studentIdController,
          validator: (value) {
            if (value?.isEmpty == true) return 'El ID de estudiante es requerido';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intereses',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona los temas que te interesan (máximo 5)',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.charcoalBlack.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UniversityUser.availableInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedInterests.remove(interest);
                  } else if (_selectedInterests.length < 5) {
                    _selectedInterests.add(interest);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                    width: 1,
                  ),
                ),
                child: Text(
                  interest,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.primaryBlue,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Adicional (Opcional)',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        const SizedBox(height: 16),

        // Bio
        DialectaM3Components.textField(
          label: 'Biografía',
          hint: 'Cuéntanos sobre ti...',
          controller: _bioController,
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        // LinkedIn
        DialectaM3Components.textField(
          label: 'LinkedIn (opcional)',
          hint: 'https://linkedin.com/in/tu-perfil',
          controller: _linkedinController,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),

        // GitHub
        DialectaM3Components.textField(
          label: 'GitHub (opcional)',
          hint: 'https://github.com/tu-usuario',
          controller: _githubController,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: DialectaM3Components.filledButton(
        text: _isLoading ? 'Creando cuenta...' : 'Crear cuenta universitaria',
        onPressed: _isLoading ? null : _registerUser,
        icon: _isLoading ? null : Icons.person_add_rounded,
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Text(
      'Al crear una cuenta, aceptas nuestros Términos de Servicio y Política de Privacidad',
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppTheme.charcoalBlack.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: AppTheme.coralRed,
        ),
      );
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Crear usuario en Firebase Auth
      await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Subir imagen de perfil si existe
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await _firebaseService.uploadProfileImage(_profileImage!);
      }

      // Crear perfil universitario
      await _firebaseService.createUniversityUser(
        email: _emailController.text.trim(),
        displayName: _displayNameController.text.trim(),
        university: _selectedUniversity,
        career: _selectedCareer,
        studentId: _studentIdController.text.trim(),
        semester: _selectedSemester,
        interests: _selectedInterests,
        bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        linkedinUrl: _linkedinController.text.trim().isEmpty ? null : _linkedinController.text.trim(),
        githubUrl: _githubController.text.trim().isEmpty ? null : _githubController.text.trim(),
      );

      // Navegar al home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Cuenta creada exitosamente!'),
            backgroundColor: AppTheme.mintGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear cuenta: $e'),
            backgroundColor: AppTheme.coralRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
