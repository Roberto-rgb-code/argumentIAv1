import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ForumsPage extends StatelessWidget {
  const ForumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = List.generate(12, (i) => '¿El impuesto a la riqueza reduce la desigualdad? #${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Foros')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: threads.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          return _ThreadCard(title: threads[i], votes: 10 + i)
              .animate()
              .fadeIn(duration: (220 + 40 * i).ms)
              .slide(begin: const Offset(0, .05));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('Nuevo hilo'),
      ),
    );
  }
}

class _ThreadCard extends StatefulWidget {
  final String title;
  final int votes;

  const _ThreadCard({required this.title, required this.votes});

  @override
  State<_ThreadCard> createState() => _ThreadCardState();
}

class _ThreadCardState extends State<_ThreadCard> {
  int score = 0;

  @override
  void initState() {
    super.initState();
    score = widget.votes;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => setState(() => score++),
              child: const Icon(Icons.keyboard_arrow_up_rounded, size: 28),
            )
                .animate(target: score.toDouble())
                .scaleXY(begin: 1, end: 1.08, duration: 140.ms),
            Text('$score', style: const TextStyle(fontWeight: FontWeight.w700)),
            InkWell(
              onTap: () => setState(() => score--),
              child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
            ),
          ],
        ),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: const Text('Política pública • 32 respuestas'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
