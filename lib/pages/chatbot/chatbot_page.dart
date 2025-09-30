import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot de Debate'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat_rounded), text: 'Debate'),
              Tab(icon: Icon(Icons.history_rounded), text: 'Historial'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DebateTab(),
            _HistorialTab(),
          ],
        ),
      ),
    );
  }
}

class _DebateTab extends StatefulWidget {
  const _DebateTab();

  @override
  State<_DebateTab> createState() => _DebateTabState();
}

class _DebateTabState extends State<_DebateTab> {
  final _topics = const [
    'Renta básica universal',
    'Prohibición de apps corta-videos en escuelas',
    'Impuesto a la riqueza',
  ];

  String _selected = 'Renta básica universal';
  int _seconds = 60;
  Timer? _timer;
  bool _running = false;
  int _turn = 1; // 1 = Tú, 2 = IA

  void _start() {
    setState(() {
      _seconds = 60;
      _running = true;
      _turn = 1;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds == 0) {
        setState(() {
          _running = false;
          _turn = _turn == 1 ? 2 : 1;
        });
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          // Selección de tema
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.topic_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selected,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Tema de debate',
                      ),
                      items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: _running ? null : (v) => setState(() => _selected = v!),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 250.ms)
              .slide(begin: const Offset(0, .05), curve: Curves.easeOut),

          const SizedBox(height: 12),

          // Temporizador circular + turno
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _TimerRing(seconds: _seconds, active: _running),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Turno: ${_turn == 1 ? "Tú" : "IA"}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                          _running ? 'Habla con argumentos claros en 60s' : 'Pulsa “Empezar turno”',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _running ? null : _start,
                    icon: const Icon(Icons.timer_rounded),
                    label: Text(_running ? 'En curso' : 'Empezar turno'),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 280.ms)
              .slide(begin: const Offset(0, .04), curve: Curves.easeOut),

          const SizedBox(height: 12),

          // Área de mensajes (placeholder)
          Expanded(
            child: ListView(
              children: [
                _Bubble.me('Mi postura inicial es…'),
                _Bubble.ai('Gracias. Considera también el costo de oportunidad…'),
                if (_running)
                  const _Hint('Consejo: estructura AREL (Afirmación, Razón, Evidencia, Limitaciones)')
                      .animate()
                      .fadeIn(duration: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final int seconds;
  final bool active;
  const _TimerRing({required this.seconds, required this.active});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = seconds / 60.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 78,
          height: 78,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: value, end: value),
            duration: 400.ms,
            builder: (context, v, _) {
              return CircularProgressIndicator(
                value: v,
                strokeWidth: 8,
                color: cs.primary,
                backgroundColor: cs.primary.withOpacity(.15),
              );
            },
          ),
        ),
        AnimatedSwitcher(
          duration: 250.ms,
          transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
          child: Text(
            '$seconds',
            key: ValueKey(seconds),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final IconData avatar;

  const _Bubble._(this.text, this.isMe, this.avatar);

  factory _Bubble.me(String t) => _Bubble._(t, true, Icons.person);
  factory _Bubble.ai(String t) => _Bubble._(t, false, Icons.smart_toy_rounded);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isMe ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe) Icon(avatar, size: 16, color: isMe ? Colors.white : cs.onSurfaceVariant),
            if (!isMe) const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: isMe ? Colors.white : cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).move(begin: Offset(isMe ? 10 : -10, 0));
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates_rounded, color: cs.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: cs.onSecondaryContainer))),
        ],
      ),
    );
  }
}

class _HistorialTab extends StatelessWidget {
  const _HistorialTab();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => 'Debate #${i + 1} • ${i + 12}/09/2025 • 60s por turno');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history_edu_rounded),
            title: Text(items[i]),
            subtitle: const Text('Tema: Renta básica • Resultado: equilibrio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ).animate().fadeIn(duration: (200 + i * 60).ms).slide(begin: const Offset(0, .05));
      },
    );
  }
}
