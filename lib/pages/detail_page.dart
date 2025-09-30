import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de lección')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detecta falacias: ad hominem', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Aprende a identificar ataques personales en lugar de argumentos. '
              'Veremos ejemplos y micro-ejercicios.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: cs.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tip: concéntrate en la afirmación, no en la persona.',
                      style: TextStyle(color: cs.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .move(begin: const Offset(0, 8), curve: Curves.easeOut),

            const Spacer(),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Comenzar ejercicios'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            )
                .animate()
                .fadeIn(duration: 250.ms)
                .scale(begin: const Offset(.98, .98), curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
