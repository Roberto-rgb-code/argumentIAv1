import 'package:flutter/services.dart' show rootBundle;
import '../models/content_models.dart';

abstract class LessonsRepository {
  Future<Habilidad> loadHabilidadByAsset(String assetPath);
}

class LocalAssetsLessonsRepository implements LessonsRepository {
  @override
  Future<Habilidad> loadHabilidadByAsset(String assetPath) async {
    final text = await rootBundle.loadString(assetPath);
    return Habilidad.fromJson(text);
  }
}
