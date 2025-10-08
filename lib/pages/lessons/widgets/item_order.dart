import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;

class ItemOrder extends StatefulWidget {
  final String enunciado;
  final List<String> elementos;
  final List<int> ordenCorrecto; // índices en base a 'elementos'
  final void Function({required bool isCorrect}) onAnswered;

  const ItemOrder({
    super.key,
    required this.enunciado,
    required this.elementos,
    required this.ordenCorrecto,
    required this.onAnswered,
  });

  @override
  State<ItemOrder> createState() => _ItemOrderState();
}

class _ItemOrderState extends State<ItemOrder> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.elementos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.enunciado, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: _items.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            itemBuilder: (context, i) {
              return Card(
                key: ValueKey(_items[i]),
                child: ListTile(
                  leading: const Icon(Icons.drag_handle),
                  title: Text(_items[i]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submit,
            child: const Text('Validar'),
          ),
        ),
      ],
    );
  }

  void _submit() {
    final expected = widget.ordenCorrecto;
    final current = _items.map((s) => widget.elementos.indexOf(s)).toList();
    final ok = listEquals(expected, current);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '¡Orden correcto!' : 'Revisa el orden propuesto')),
    );
    widget.onAnswered(isCorrect: ok);
  }
}
