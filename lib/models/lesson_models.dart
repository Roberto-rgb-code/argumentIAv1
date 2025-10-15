enum LessonType {
  areal,
  falacias,
  fortalecerArgumento,
  completarArgumento,
  refutacion,
  evidencia,
  razonamiento,
  limitaciones,
}

enum Difficulty {
  basico,
  intermedio,
  avanzado,
}

enum ExerciseType {
  multipleChoice,
  textInput,
  dragAndDrop,
  trueFalse,
  matching,
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final Difficulty difficulty;
  final int estimatedMinutes;
  final List<Exercise> exercises;
  final List<String> tags;
  final int pointsReward;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime createdAt;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.exercises,
    required this.tags,
    required this.pointsReward,
    this.imageUrl,
    this.videoUrl,
    required this.createdAt,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: LessonType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => LessonType.areal,
      ),
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'],
        orElse: () => Difficulty.basico,
      ),
      estimatedMinutes: map['estimatedMinutes'] ?? 10,
      exercises: (map['exercises'] as List?)
          ?.map((e) => Exercise.fromMap(e))
          .toList() ?? [],
      tags: List<String>.from(map['tags'] ?? []),
      pointsReward: map['pointsReward'] ?? 50,
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty.name,
      'estimatedMinutes': estimatedMinutes,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'tags': tags,
      'pointsReward': pointsReward,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Exercise {
  final String id;
  final String title;
  final String instruction;
  final ExerciseType type;
  final Map<String, dynamic> content;
  final List<String> correctAnswers;
  final int points;
  final String? hint;
  final String? explanation;

  const Exercise({
    required this.id,
    required this.title,
    required this.instruction,
    required this.type,
    required this.content,
    required this.correctAnswers,
    required this.points,
    this.hint,
    this.explanation,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      instruction: map['instruction'] ?? '',
      type: ExerciseType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => ExerciseType.multipleChoice,
      ),
      content: map['content'] ?? {},
      correctAnswers: List<String>.from(map['correctAnswers'] ?? []),
      points: map['points'] ?? 10,
      hint: map['hint'],
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'instruction': instruction,
      'type': type.name,
      'content': content,
      'correctAnswers': correctAnswers,
      'points': points,
      'hint': hint,
      'explanation': explanation,
    };
  }
}

class ExerciseResult {
  final String exerciseId;
  final List<String> userAnswers;
  final bool isCorrect;
  final int pointsEarned;
  final DateTime completedAt;
  final Duration timeSpent;

  const ExerciseResult({
    required this.exerciseId,
    required this.userAnswers,
    required this.isCorrect,
    required this.pointsEarned,
    required this.completedAt,
    required this.timeSpent,
  });

  factory ExerciseResult.fromMap(Map<String, dynamic> map) {
    return ExerciseResult(
      exerciseId: map['exerciseId'] ?? '',
      userAnswers: List<String>.from(map['userAnswers'] ?? []),
      isCorrect: map['isCorrect'] ?? false,
      pointsEarned: map['pointsEarned'] ?? 0,
      completedAt: DateTime.parse(map['completedAt'] ?? DateTime.now().toIso8601String()),
      timeSpent: Duration(milliseconds: map['timeSpent'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'userAnswers': userAnswers,
      'isCorrect': isCorrect,
      'pointsEarned': pointsEarned,
      'completedAt': completedAt.toIso8601String(),
      'timeSpent': timeSpent.inMilliseconds,
    };
  }
}

class LessonProgress {
  final String lessonId;
  final String userId;
  final List<ExerciseResult> exerciseResults;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int totalPointsEarned;

  const LessonProgress({
    required this.lessonId,
    required this.userId,
    required this.exerciseResults,
    required this.isCompleted,
    required this.startedAt,
    this.completedAt,
    required this.totalPointsEarned,
  });

  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonId: map['lessonId'] ?? '',
      userId: map['userId'] ?? '',
      exerciseResults: (map['exerciseResults'] as List?)
          ?.map((e) => ExerciseResult.fromMap(e))
          .toList() ?? [],
      isCompleted: map['isCompleted'] ?? false,
      startedAt: DateTime.parse(map['startedAt'] ?? DateTime.now().toIso8601String()),
      completedAt: map['completedAt'] != null 
          ? DateTime.parse(map['completedAt'])
          : null,
      totalPointsEarned: map['totalPointsEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'userId': userId,
      'exerciseResults': exerciseResults.map((e) => e.toMap()).toList(),
      'isCompleted': isCompleted,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalPointsEarned': totalPointsEarned,
    };
  }

  double get completionPercentage {
    if (exerciseResults.isEmpty) return 0.0;
    final correctExercises = exerciseResults.where((r) => r.isCorrect).length;
    return (correctExercises / exerciseResults.length) * 100;
  }
}

extension LessonTypeExtension on LessonType {
  String get displayName {
    switch (this) {
      case LessonType.areal:
        return 'AREAL';
      case LessonType.falacias:
        return 'Falacias Lógicas';
      case LessonType.fortalecerArgumento:
        return 'Fortalecer Argumento';
      case LessonType.completarArgumento:
        return 'Completar Argumento';
      case LessonType.refutacion:
        return 'Refutación';
      case LessonType.evidencia:
        return 'Evidencia';
      case LessonType.razonamiento:
        return 'Razonamiento';
      case LessonType.limitaciones:
        return 'Limitaciones';
    }
  }

  String get emoji {
    switch (this) {
      case LessonType.areal:
        return '🏗️';
      case LessonType.falacias:
        return '⚠️';
      case LessonType.fortalecerArgumento:
        return '💪';
      case LessonType.completarArgumento:
        return '🧩';
      case LessonType.refutacion:
        return '⚔️';
      case LessonType.evidencia:
        return '📊';
      case LessonType.razonamiento:
        return '🧠';
      case LessonType.limitaciones:
        return '🎯';
    }
  }

  String get color {
    switch (this) {
      case LessonType.areal:
        return '#6C5CE7';
      case LessonType.falacias:
        return '#E17055';
      case LessonType.fortalecerArgumento:
        return '#00B894';
      case LessonType.completarArgumento:
        return '#00B4DB';
      case LessonType.refutacion:
        return '#FF6B6B';
      case LessonType.evidencia:
        return '#FDCB6E';
      case LessonType.razonamiento:
        return '#A29BFE';
      case LessonType.limitaciones:
        return '#636E72';
    }
  }
}

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.basico:
        return 'Básico';
      case Difficulty.intermedio:
        return 'Intermedio';
      case Difficulty.avanzado:
        return 'Avanzado';
    }
  }

  String get emoji {
    switch (this) {
      case Difficulty.basico:
        return '🌱';
      case Difficulty.intermedio:
        return '🌿';
      case Difficulty.avanzado:
        return '🌳';
    }
  }

  String get color {
    switch (this) {
      case Difficulty.basico:
        return '#00B894';
      case Difficulty.intermedio:
        return '#FDCB6E';
      case Difficulty.avanzado:
        return '#E17055';
    }
  }
}
