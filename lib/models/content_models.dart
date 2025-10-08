import 'dart:convert';

enum ItemType { opcion_multiple, respuesta_corta, ordenar }

ItemType itemTypeFrom(String s) {
  switch (s) {
    case 'opcion_multiple': return ItemType.opcion_multiple;
    case 'respuesta_corta': return ItemType.respuesta_corta;
    case 'ordenar': return ItemType.ordenar;
    default: return ItemType.opcion_multiple;
  }
}

class ItemContenido {
  final String itemId;
  final ItemType tipo;
  final String? pregunta;
  final List<String>? opciones;
  final int? respuestaCorrecta;
  final String? respuestaTexto;
  final List<String>? ordenar;
  final List<int>? ordenCorrecto;
  final String? explicacion;

  ItemContenido({
    required this.itemId,
    required this.tipo,
    this.pregunta,
    this.opciones,
    this.respuestaCorrecta,
    this.respuestaTexto,
    this.ordenar,
    this.ordenCorrecto,
    this.explicacion,
  });

  factory ItemContenido.fromMap(Map<String, dynamic> m) {
    return ItemContenido(
      itemId: m['item_id'],
      tipo: itemTypeFrom(m['tipo_item']),
      pregunta: m['pregunta'],
      opciones: (m['opciones'] as List?)?.map((e) => e.toString()).toList(),
      respuestaCorrecta: m['respuesta_correcta'],
      respuestaTexto: m['respuesta_texto'],
      ordenar: (m['ordenar'] as List?)?.map((e) => e.toString()).toList(),
      ordenCorrecto: (m['orden_correcto'] as List?)?.map((e) => e as int).toList(),
      explicacion: m['explicacion'],
    );
  }
}

class Leccion {
  final String leccionId;
  final String objetivo;
  final List<ItemContenido> items;

  Leccion({required this.leccionId, required this.objetivo, required this.items});

  factory Leccion.fromMap(Map<String, dynamic> m) {
    return Leccion(
      leccionId: m['leccion_id'],
      objetivo: m['objetivo'],
      items: (m['items'] as List).map((e) => ItemContenido.fromMap(e)).toList(),
    );
  }
}

class Habilidad {
  final String habilidadId;
  final String titulo;
  final String descripcion;
  final String tipo;
  final List<Leccion> lecciones;

  Habilidad({
    required this.habilidadId,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.lecciones,
  });

  factory Habilidad.fromMap(Map<String, dynamic> m) {
    return Habilidad(
      habilidadId: m['habilidad_id'],
      titulo: m['titulo'],
      descripcion: m['descripcion'],
      tipo: m['tipo'],
      lecciones: (m['lecciones'] as List).map((e) => Leccion.fromMap(e)).toList(),
    );
  }

  static Habilidad fromJson(String jsonStr) => Habilidad.fromMap(json.decode(jsonStr));
}
