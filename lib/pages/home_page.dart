import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'detail_page.dart';
import '../widgets/progress_beat.dart';
import '../widgets/animated_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Argumenta — Inicio')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¡Hola!', style: TextStyle(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 4),
                const Text(
                  'Sigue tu racha de pensamiento crítico',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const ProgressBeat(value: 0.45),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    _StatChip(icon: Icons.local_fire_department, label: 'Racha', value: '3 días'),
                    SizedBox(width: 8),
                    _StatChip(icon: Icons.token, label: 'Tokens', value: '120'),
                    SizedBox(width: 8),
                    _StatChip(icon: Icons.star_rate_rounded, label: 'Nivel', value: '2'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AnimatedCTAButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailPage()));
                      },
                      label: 'Continuar lección',
                      icon: Icons.play_arrow_rounded,
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bolt),
                      label: const Text('Práctica 3 min'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .move(begin: const Offset(0, 12), curve: Curves.easeOut),

          const SizedBox(height: 20),

          Text('Recomendado para hoy', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...List.generate(3, (i) => i).map((i) {
            return _LessonCard(
              title: switch (i) {
                0 => 'Detecta falacias (Nivel 1)',
                1 => 'Refuta con AREL (Nivel 1)',
                _ => 'Costo de oportunidad (casos)',
              },
              minutes: i == 2 ? 7 : 5,
              progress: i == 0 ? 0.7 : (i == 1 ? 0.35 : 0.0),
            )
                .animate()
                .fadeIn(duration: (250 + i * 80).ms)
                .slide(begin: const Offset(0, .05), curve: Curves.easeOut);
          }),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 18),
      label: Text('$label: $value', style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.white.withOpacity(.18),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final int minutes;
  final double progress;

  const _LessonCard({required this.title, required this.minutes, required this.progress});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: cs.primary.withOpacity(.12),
          child: Icon(Icons.menu_book_rounded, color: cs.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            ProgressBeat(value: progress),
            const SizedBox(height: 6),
            Text('$minutes min • ejercicios rápidos'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
