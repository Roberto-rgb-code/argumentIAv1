import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de records (titulo, fecha/hora)
    final events = <(String, String)>[
      ('Taller de refutación AREL', 'Mié 09 Oct • 18:00'),
      ('Debate en vivo: IA y trabajo', 'Vie 11 Oct • 20:00'),
      ('Club de lectura: Política y datos', 'Sáb 12 Oct • 10:00'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        itemCount: events.length,
        itemBuilder: (context, i) {
          final e = events[i];
          final title = e.$1; // campo 1 del record
          final when  = e.$2; // campo 2 del record

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(when),
              trailing: FilledButton(
                onPressed: () {},
                child: const Text('Registrar'),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: (220 + 60 * i).ms)
              .move(begin: const Offset(0, 6));
        },
      ),
    );
  }
}
