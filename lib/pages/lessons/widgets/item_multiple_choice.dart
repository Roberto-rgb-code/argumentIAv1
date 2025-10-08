import 'package:flutter/material.dart';

class ItemMultipleChoice extends StatefulWidget {
  final String pregunta;
  final List<String> opciones;
  final int indiceCorrecto;
  final String? explicacion;
  final void Function({required bool isCorrect}) onAnswered;

  const ItemMultipleChoice({
    super.key,
    required this.pregunta,
    required this.opciones,
    required this.indiceCorrecto,
    required this.onAnswered,
    this.explicacion,
  });

  @override
  State<ItemMultipleChoice> createState() => _ItemMultipleChoiceState();
}

class _ItemMultipleChoiceState extends State<ItemMultipleChoice> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.pregunta, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...List.generate(widget.opciones.length, (i) {
          final sel = selected == i;
          return Card(
            child: RadioListTile<int>(
              value: i,
              groupValue: selected,
              onChanged: (v) => setState(() => selected = v),
              title: Text(widget.opciones[i]),
              selected: sel,
            ),
          );
        }),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: selected == null ? null : _submit,
            child: const Text('Continuar'),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final ok = selected == widget.indiceCorrecto;
    if (widget.explicacion != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? '¡Correcto!' : 'Revisa: ${widget.explicacion}')),
      );
    }
    widget.onAnswered(isCorrect: ok);
  }
}
