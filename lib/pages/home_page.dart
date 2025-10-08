// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/progress_beat.dart';
import '../widgets/animated_button.dart';

// NUEVO: abre la lección tipo Duolingo desde assets
import 'lessons/lesson_page.dart';
// NUEVO: para mostrar el progreso real de la lección
import '../services/progress_store.dart';
// Para cerrar sesión
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _progressStore = ProgressStore();

  // IDs fijos para el MVP (puedes cambiarlos cuando agregues más lecciones)
  static const _assetEficacia = 'assets/content/unidad_u4_eficacia.json';
  static const _leccionEficacia = 'L1_definicion';

  double _progresoEficacia = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
  }

  Future<void> _cargarProgreso() async {
    final p = await _progressStore.getProgress(_leccionEficacia);
    if (mounted) setState(() => _progresoEficacia = p);
  }

  void _abrirLeccionEficacia() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LessonPage(
          assetPath: _assetEficacia,
          leccionId: _leccionEficacia,
        ),
      ),
    );
    // Al volver, refresca el progreso mostrado en Home
    _cargarProgreso();
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Cerrar sesión?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('¿Estás seguro que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await AuthService.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Argumenta — Inicio',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A1A2E),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: _cerrarSesion,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          // Hero con racha, tokens y CTA - COLORES MEJORADOS
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6C5CE7), // Púrpura vibrante
                  Color(0xFF00B4DB), // Azul brillante
                  Color(0xFF0083B0), // Azul profundo
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '¡Hola! 👋',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sigue tu racha de\npensamiento crítico',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),

                // Progreso diario con mejor visualización
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            color: Color(0xFFFFD93D),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Progreso de hoy',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(_progresoEficacia * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProgressBeat(value: _progresoEficacia.clamp(0, 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stats chips mejorados
                Row(
                  children: const [
                    _StatChip(
                      icon: Icons.local_fire_department,
                      label: 'Racha',
                      value: '3 días',
                      bgColor: Color(0xFFFF6B6B),
                    ),
                    SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.stars_rounded,
                      label: 'Tokens',
                      value: '120',
                      bgColor: Color(0xFFFFD93D),
                    ),
                    SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Nivel',
                      value: '2',
                      bgColor: Color(0xFF4ECDC4),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Botones CTA mejorados
                Row(
                  children: [
                    Expanded(
                      child: AnimatedCTAButton(
                        onPressed: _abrirLeccionEficacia,
                        label: _progresoEficacia <= 0
                            ? 'Iniciar lección'
                            : (_progresoEficacia < 1 ? 'Continuar' : 'Repasar'),
                        icon: Icons.play_arrow_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        onPressed: _abrirLeccionEficacia,
                        icon: const Icon(Icons.bolt, color: Colors.white),
                        iconSize: 28,
                        tooltip: 'Práctica 3 min',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut),

          const SizedBox(height: 28),

          // Sección de recomendaciones mejorada
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recomendado para hoy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cards mejoradas
          _LessonCard(
            title: 'Criterio: Eficacia (Nivel 1)',
            minutes: 5,
            progress: _progresoEficacia,
            onTap: _abrirLeccionEficacia,
            color: const Color(0xFF6C5CE7),
            icon: Icons.psychology_rounded,
          )
              .animate()
              .fadeIn(duration: 250.ms)
              .slideX(begin: -0.1, curve: Curves.easeOut),

          _LessonCard(
            title: 'Principios en tensión (Nivel 1)',
            minutes: 5,
            progress: 0.0,
            onTap: _abrirLeccionEficacia,
            color: const Color(0xFFFF6B6B),
            icon: Icons.balance_rounded,
          )
              .animate()
              .fadeIn(duration: 330.ms, delay: 100.ms)
              .slideX(begin: -0.1, curve: Curves.easeOut),

          _LessonCard(
            title: 'Estrategia de Gobierno (modelo)',
            minutes: 7,
            progress: 0.0,
            onTap: _abrirLeccionEficacia,
            color: const Color(0xFF4ECDC4),
            icon: Icons.account_balance_rounded,
          )
              .animate()
              .fadeIn(duration: 410.ms, delay: 200.ms)
              .slideX(begin: -0.1, curve: Curves.easeOut),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color bgColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
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

class _LessonCard extends StatelessWidget {
  final String title;
  final int minutes;
  final double progress;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  const _LessonCard({
    required this.title,
    required this.minutes,
    required this.progress,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícono con gradiente
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Barra de progreso mejorada
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 6,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0, 1),
                            backgroundColor: color.withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$minutes min',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Ejercicios',
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Flecha
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}