import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_stats.dart';

class UserStatsService {
  UserStatsService._();
  static final UserStatsService instance = UserStatsService._();

  static const String _kStatsKey = 'arg_user_stats';
  static const String _kAchievementsKey = 'arg_achievements';

  UserStats? _cachedStats;

  /// Obtiene las estadísticas del usuario
  Future<UserStats> getStats() async {
    if (_cachedStats != null) return _cachedStats!;

    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_kStatsKey);

    if (statsJson != null) {
      _cachedStats = UserStats.fromJson(statsJson);
    } else {
      _cachedStats = UserStats();
    }

    return _cachedStats!;
  }

  /// Guarda las estadísticas
  Future<void> saveStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStatsKey, stats.toJson());
    _cachedStats = stats;
  }

  /// Agrega tokens al usuario
  Future<UserStats> addTokens(int amount) async {
    final stats = await getStats();
    final updated = stats.addTokens(amount);
    await saveStats(updated);
    return updated;
  }

  /// Agrega XP y actualiza nivel
  Future<UserStats> addXP(int amount) async {
    final stats = await getStats();
    final updated = stats.addXP(amount).addDailyProgress(amount);
    await saveStats(updated);
    return updated;
  }

  /// Incrementa lecciones completadas
  Future<UserStats> incrementLessons() async {
    final stats = await getStats();
    final updated = stats.incrementLessons().updateStreak();
    await saveStats(updated);
    return updated;
  }

  /// Incrementa debates completados
  Future<UserStats> incrementDebates() async {
    final stats = await getStats();
    final updated = stats.incrementDebates().updateStreak();
    await saveStats(updated);
    return updated;
  }

  /// Actualiza racha diaria
  Future<UserStats> updateStreak() async {
    final stats = await getStats();
    final updated = stats.updateStreak();
    await saveStats(updated);
    return updated;
  }

  /// Recompensa completa al terminar lección
  Future<UserStats> rewardLessonCompleted() async {
    final stats = await getStats();
    final updated = stats
        .incrementLessons()
        .addTokens(10)
        .addXP(20)
        .updateStreak()
        .addDailyProgress(20);
    await saveStats(updated);
    return updated;
  }

  /// Recompensa al completar debate
  Future<UserStats> rewardDebateCompleted({int score = 50}) async {
    final stats = await getStats();
    // Tokens y XP basados en el score (0-100)
    final tokensEarned = (score / 10).round() + 5; // 5-15 tokens
    final xpEarned = (score / 2).round() + 10; // 10-60 XP
    
    final updated = stats
        .incrementDebates()
        .addTokens(tokensEarned)
        .addXP(xpEarned)
        .updateStreak()
        .addDailyProgress(xpEarned);
    await saveStats(updated);
    return updated;
  }

  /// Obtiene progreso de los últimos 7 días
  Future<Map<String, int>> getWeeklyProgress() async {
    final stats = await getStats();
    final now = DateTime.now();
    final weekProgress = <String, int>{};

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      weekProgress[dateKey] = stats.dailyProgress[dateKey] ?? 0;
    }

    return weekProgress;
  }

  /// Lista de logros predefinidos
  List<Achievement> getAchievements(UserStats stats) {
    return [
      Achievement(
        id: 'first_lesson',
        title: 'Primer Paso',
        description: 'Completa tu primera lección',
        icon: '🎓',
        unlocked: stats.lessonsCompleted >= 1,
      ),
      Achievement(
        id: 'lesson_master',
        title: 'Maestro de Lecciones',
        description: 'Completa 10 lecciones',
        icon: '📚',
        unlocked: stats.lessonsCompleted >= 10,
      ),
      Achievement(
        id: 'first_debate',
        title: 'Debatiente',
        description: 'Completa tu primer debate',
        icon: '💬',
        unlocked: stats.debatesCompleted >= 1,
      ),
      Achievement(
        id: 'debate_champion',
        title: 'Campeón de Debate',
        description: 'Completa 20 debates',
        icon: '🏆',
        unlocked: stats.debatesCompleted >= 20,
      ),
      Achievement(
        id: 'streak_week',
        title: 'Racha Semanal',
        description: 'Mantén 7 días de racha',
        icon: '🔥',
        unlocked: stats.currentStreak >= 7,
      ),
      Achievement(
        id: 'level_5',
        title: 'Nivel 5 Alcanzado',
        description: 'Llega al nivel 5',
        icon: '⭐',
        unlocked: stats.level >= 5,
      ),
      Achievement(
        id: 'token_collector',
        title: 'Coleccionista',
        description: 'Acumula 500 tokens',
        icon: '💰',
        unlocked: stats.totalTokens >= 500,
      ),
      Achievement(
        id: 'critical_thinker',
        title: 'Pensador Crítico',
        description: 'Alcanza 1000 XP',
        icon: '🧠',
        unlocked: stats.totalXP >= 1000,
      ),
    ];
  }

  /// Limpia caché (útil para testing)
  void clearCache() {
    _cachedStats = null;
  }

  /// Reinicia todas las estadísticas (¡cuidado!)
  Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStatsKey);
    _cachedStats = null;
  }
}

