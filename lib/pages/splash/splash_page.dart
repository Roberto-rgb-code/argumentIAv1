import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../auth/auth_gate.dart';
import '../home_page.dart' as home;
import '../chatbot/chatbot_final_page.dart' as chat;
import '../forums/forums_page.dart' as forums;
import '../events/events_page.dart' as events;
import '../lessons/lessons_page_v2.dart' as lessons;
import '../profile/profile_page.dart' as profile;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    
    // Controlador para la animación de pulso
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Controlador para el fade in/out
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Iniciar la secuencia de animación
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Esperar 1 segundo antes de empezar el fade in
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      _fadeController.forward();
    }

    // Esperar 3 segundos totales antes de navegar
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AuthGate(shell: _AppShell()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.primaryBlue.withOpacity(0.8),
              AppTheme.mintGreen.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación Lottie centrada
            Container(
              width: 200,
              height: 200,
              child: Lottie.network(
                'https://lottie.host/739368b9-9d98-466e-90ac-19e448d2f3d5/hPX0ns4DBQ.lottie',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback animado si Lottie falla
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (0.3 * _animationController.value),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Texto de bienvenida
            FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: [
                  Text(
                    '¡Bienvenido a',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ArgumentIA',
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Desarrolla tu pensamiento crítico',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Indicador de carga
            FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell({super.key});
  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _index = 0;

  late final List<Widget> _tabs = const <Widget>[
    home.HomePage(),
    chat.ChatbotFinalPage(),
    forums.ForumsPage(),
    events.EventsPage(),
    lessons.LessonsPageV2(),
    profile.ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Solo cargar la página actual para mejor rendimiento
    final content = _tabs[_index];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: 250.ms,
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeInQuad,
        child: content
            .animate()
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.02, end: 0, duration: 220.ms),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home), 
            label: 'Inicio'
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline), 
            selectedIcon: Icon(Icons.chat_bubble), 
            label: 'Debate'
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined), 
            selectedIcon: Icon(Icons.forum), 
            label: 'Foros'
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined), 
            selectedIcon: Icon(Icons.event), 
            label: 'Eventos'
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined), 
            selectedIcon: Icon(Icons.school), 
            label: 'Lecciones'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined), 
            selectedIcon: Icon(Icons.person), 
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}
