import 'dart:convert';

class UserStats {
  final int totalTokens;
  final int currentStreak;
  final int longestStreak;
  final int totalXP;
  final int level;
  final int lessonsCompleted;
  final int debatesCompleted;
  final int forumPosts;
  final DateTime? lastActivityDate;
  final Map<String, int> dailyProgress; // {fecha: xp_ganado}

  UserStats({
    this.totalTokens = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXP = 0,
    this.level = 1,
    this.lessonsCompleted = 0,
    this.debatesCompleted = 0,
    this.forumPosts = 0,
    this.lastActivityDate,
    this.dailyProgress = const {},
  });

  // Calcula nivel basado en XP (cada nivel = 100 XP)
  int get calculatedLevel => (totalXP / 100).floor() + 1;

  // XP necesario para próximo nivel
  int get xpForNextLevel => (level * 100) - totalXP;

  // Progreso del nivel actual (0.0 a 1.0)
  double get levelProgress {
    final xpInCurrentLevel = totalXP % 100;
    return xpInCurrentLevel / 100.0;
  }

  factory UserStats.fromMap(Map<String, dynamic> m) {
    return UserStats(
      totalTokens: m['total_tokens'] ?? 0,
      currentStreak: m['current_streak'] ?? 0,
      longestStreak: m['longest_streak'] ?? 0,
      totalXP: m['total_xp'] ?? 0,
      level: m['level'] ?? 1,
      lessonsCompleted: m['lessons_completed'] ?? 0,
      debatesCompleted: m['debates_completed'] ?? 0,
      forumPosts: m['forum_posts'] ?? 0,
      lastActivityDate: m['last_activity_date'] != null
          ? DateTime.parse(m['last_activity_date'])
          : null,
      dailyProgress: m['daily_progress'] != null
          ? Map<String, int>.from(m['daily_progress'])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_tokens': totalTokens,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_xp': totalXP,
      'level': level,
      'lessons_completed': lessonsCompleted,
      'debates_completed': debatesCompleted,
      'forum_posts': forumPosts,
      'last_activity_date': lastActivityDate?.toIso8601String(),
      'daily_progress': dailyProgress,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserStats.fromJson(String source) =>
      UserStats.fromMap(json.decode(source));

  UserStats copyWith({
    int? totalTokens,
    int? currentStreak,
    int? longestStreak,
    int? totalXP,
    int? level,
    int? lessonsCompleted,
    int? debatesCompleted,
    int? forumPosts,
    DateTime? lastActivityDate,
    Map<String, int>? dailyProgress,
  }) {
    return UserStats(
      totalTokens: totalTokens ?? this.totalTokens,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      debatesCompleted: debatesCompleted ?? this.debatesCompleted,
      forumPosts: forumPosts ?? this.forumPosts,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      dailyProgress: dailyProgress ?? this.dailyProgress,
    );
  }

  // Métodos útiles
  UserStats addTokens(int amount) {
    return copyWith(totalTokens: totalTokens + amount);
  }

  UserStats addXP(int amount) {
    final newXP = totalXP + amount;
    final newLevel = (newXP / 100).floor() + 1;
    return copyWith(totalXP: newXP, level: newLevel);
  }

  UserStats incrementLessons() {
    return copyWith(lessonsCompleted: lessonsCompleted + 1);
  }

  UserStats incrementDebates() {
    return copyWith(debatesCompleted: debatesCompleted + 1);
  }

  UserStats updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastActivityDate == null) {
      return copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: today,
      );
    }

    final lastDate = DateTime(
      lastActivityDate!.year,
      lastActivityDate!.month,
      lastActivityDate!.day,
    );

    final daysDiff = today.difference(lastDate).inDays;

    if (daysDiff == 0) {
      // Mismo día, no cambia racha
      return this;
    } else if (daysDiff == 1) {
      // Día consecutivo, incrementa racha
      final newStreak = currentStreak + 1;
      return copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
        lastActivityDate: today,
      );
    } else {
      // Racha rota, reinicia
      return copyWith(
        currentStreak: 1,
        lastActivityDate: today,
      );
    }
  }

  UserStats addDailyProgress(int xp) {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final newProgress = Map<String, int>.from(dailyProgress);
    newProgress[dateKey] = (newProgress[dateKey] ?? 0) + xp;
    
    return copyWith(dailyProgress: newProgress);
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> m) {
    return Achievement(
      id: m['id'],
      title: m['title'],
      description: m['description'],
      icon: m['icon'],
      unlocked: m['unlocked'] ?? false,
      unlockedAt: m['unlocked_at'] != null ? DateTime.parse(m['unlocked_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'unlocked': unlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }
}

