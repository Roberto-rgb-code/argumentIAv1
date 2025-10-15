import 'package:shared_preferences/shared_preferences.dart';
import 'user_stats_service.dart';

class ProgressStore {
  static const _kPrefix = 'arg_progress_';

  Future<double> getProgress(String leccionId) async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble('$_kPrefix$leccionId') ?? 0.0;
  }

  Future<void> setProgress(String leccionId, double value) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble('$_kPrefix$leccionId', value.clamp(0.0, 1.0));
    
    // Si completó la lección (progreso = 1.0), otorgar recompensas
    if (value >= 1.0) {
      final wasCompleted = await p.getBool('${_kPrefix}${leccionId}_completed') ?? false;
      if (!wasCompleted) {
        await UserStatsService.instance.rewardLessonCompleted();
        await p.setBool('${_kPrefix}${leccionId}_completed', true);
      }
    }
  }
}
