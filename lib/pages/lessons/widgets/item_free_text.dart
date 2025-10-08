import 'package:flutter/material.dart';

class ItemFreeText extends StatefulWidget {
  final String pregunta;
  final String respuesta; // validación simple
  final String? explicacion;
  final void Function({required bool isCorrect}) onAnswered;

  const ItemFreeText({
    super.key,
    required this.pregunta,
    required this.respuesta,
    required this.onAnswered,
    this.explicacion,
  });

  @override
  State<ItemFreeText> createState() => _ItemFreeTextState();
}

class _ItemFreeTextState extends State<ItemFreeText> {
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.pregunta, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
          controller: ctrl,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Escribe en 1–2 oraciones…',
            border: OutlineInputBorder(),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submit,
            child: const Text('Continuar'),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final user = ctrl.text.trim().toLowerCase();
    final expected = widget.respuesta.trim().toLowerCase();
    final ok = user.contains(expected) || user == expected;
    if (widget.explicacion != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? '¡Bien!' : 'Pista: ${widget.explicacion}')),
      );
    }
    widget.onAnswered(isCorrect: ok);
  }
}
