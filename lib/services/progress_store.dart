import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore {
  static const _kPrefix = 'arg_progress_';

  Future<double> getProgress(String leccionId) async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble('$_kPrefix$leccionId') ?? 0.0;
  }

  Future<void> setProgress(String leccionId, double value) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble('$_kPrefix$leccionId', value.clamp(0.0, 1.0));
  }
}
