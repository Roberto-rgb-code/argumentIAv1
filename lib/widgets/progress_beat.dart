import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressBeat extends StatelessWidget {
  final double value; // 0..1
  const ProgressBeat({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 16,
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
              borderRadius: BorderRadius.circular(999),
            ),
          )
              .animate()
              .scaleX(begin: 0, end: 1, duration: 600.ms, curve: Curves.easeOutCubic),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(period: 2.seconds))
        .shimmer(duration: 1200.ms);
  }
}
