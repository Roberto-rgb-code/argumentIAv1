import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/lessons_repository.dart';
import '../../models/content_models.dart';
import '../../services/progress_store.dart';

import 'widgets/item_multiple_choice.dart';
import 'widgets/item_free_text.dart';
import 'widgets/item_order.dart';

class LessonPage extends StatefulWidget {
  final String assetPath; // 'assets/content/unidad_u4_eficacia.json'
  final String leccionId; // 'L1_definicion'
  const LessonPage({super.key, required this.assetPath, required this.leccionId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final repo = LocalAssetsLessonsRepository();
  final store = ProgressStore();

  Habilidad? _habilidad;
  Leccion? _leccion;
  int _index = 0;
  int _correct = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await repo.loadHabilidadByAsset(widget.assetPath);
    final l = h.lecciones.firstWhere((l) => l.leccionId == widget.leccionId, orElse: () => h.lecciones.first);
    setState(() {
      _habilidad = h;
      _leccion = l;
      _index = 0;
      _correct = 0;
      _loading = false;
    });
  }

  void _onAnswer({required bool isCorrect}) async {
    if (isCorrect) _correct++;
    final total = _leccion!.items.length;
    final next = _index + 1;

    final progress = (next / total);
    await store.setProgress(_leccion!.leccionId, progress);

    if (next >= total) {
      if (!mounted) return;
      final pct = ((_correct / total) * 100).toStringAsFixed(0);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¡Lección completada!'),
          content: Text('Aciertos: $_correct / $total • $pct%'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
          ],
        ),
      ).then((_) => Navigator.of(context).pop());
    } else {
      setState(() => _index = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _habilidad == null || _leccion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final items = _leccion!.items;
    final item = items[_index];
    final pct = ((_index) / items.length);

    return Scaffold(
      appBar: AppBar(title: Text('${_habilidad!.titulo} — ${_leccion!.leccionId}')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          children: [
            LinearProgressIndicator(value: pct),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: 250.ms,
                child: _buildItem(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ItemContenido it) {
    switch (it.tipo) {
      case ItemType.opcion_multiple:
        return ItemMultipleChoice(
          key: ValueKey(it.itemId),
          pregunta: it.pregunta ?? '',
          opciones: it.opciones ?? const [],
          indiceCorrecto: it.respuestaCorrecta ?? 0,
          explicacion: it.explicacion,
          onAnswered: _onAnswer,
        );
      case ItemType.respuesta_corta:
        return ItemFreeText(
          key: ValueKey(it.itemId),
          pregunta: it.pregunta ?? '',
          respuesta: it.respuestaTexto ?? '',
          explicacion: it.explicacion,
          onAnswered: _onAnswer,
        );
      case ItemType.ordenar:
        return ItemOrder(
          key: ValueKey(it.itemId),
          enunciado: it.pregunta ?? 'Ordena los pasos',
          elementos: List.of(it.ordenar ?? const []),
          ordenCorrecto: it.ordenCorrecto ?? [],
          onAnswered: _onAnswer,
        );
    }
  }
}
