class DebateTopic {
  final String id;
  final String title;
  final String description;
  final String category;
  final int votes;
  final int comments;
  final DateTime createdAt;
  final String authorId;
  final String authorName;
  final bool isActive;
  final List<String> tags;

  const DebateTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.votes,
    required this.comments,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    required this.isActive,
    this.tags = const [],
  });

  factory DebateTopic.fromMap(Map<String, dynamic> map) {
    return DebateTopic(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      votes: map['votes'] ?? 0,
      comments: map['comments'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      isActive: map['isActive'] ?? true,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'votes': votes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'authorId': authorId,
      'authorName': authorName,
      'isActive': isActive,
      'tags': tags,
    };
  }

  DebateTopic copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? votes,
    int? comments,
    DateTime? createdAt,
    String? authorId,
    String? authorName,
    bool? isActive,
    List<String>? tags,
  }) {
    return DebateTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      votes: votes ?? this.votes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
    );
  }
}

class DebateComment {
  final String id;
  final String debateId;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final int votes;
  final bool isPro;
  final List<String> replies;

  const DebateComment({
    required this.id,
    required this.debateId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.votes,
    required this.isPro,
    this.replies = const [],
  });

  factory DebateComment.fromMap(Map<String, dynamic> map) {
    return DebateComment(
      id: map['id'] ?? '',
      debateId: map['debateId'] ?? '',
      content: map['content'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      votes: map['votes'] ?? 0,
      isPro: map['isPro'] ?? true,
      replies: List<String>.from(map['replies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'debateId': debateId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt.toIso8601String(),
      'votes': votes,
      'isPro': isPro,
      'replies': replies,
    };
  }
}

enum DebateCategory {
  politica,
  tecnologia,
  sociedad,
  educacion,
  economia,
  medioAmbiente,
  salud,
  deporte,
  cultura,
  otros,
}

extension DebateCategoryExtension on DebateCategory {
  String get displayName {
    switch (this) {
      case DebateCategory.politica:
        return 'Política';
      case DebateCategory.tecnologia:
        return 'Tecnología';
      case DebateCategory.sociedad:
        return 'Sociedad';
      case DebateCategory.educacion:
        return 'Educación';
      case DebateCategory.economia:
        return 'Economía';
      case DebateCategory.medioAmbiente:
        return 'Medio Ambiente';
      case DebateCategory.salud:
        return 'Salud';
      case DebateCategory.deporte:
        return 'Deporte';
      case DebateCategory.cultura:
        return 'Cultura';
      case DebateCategory.otros:
        return 'Otros';
    }
  }

  String get emoji {
    switch (this) {
      case DebateCategory.politica:
        return '🏛️';
      case DebateCategory.tecnologia:
        return '💻';
      case DebateCategory.sociedad:
        return '👥';
      case DebateCategory.educacion:
        return '📚';
      case DebateCategory.economia:
        return '💰';
      case DebateCategory.medioAmbiente:
        return '🌱';
      case DebateCategory.salud:
        return '🏥';
      case DebateCategory.deporte:
        return '⚽';
      case DebateCategory.cultura:
        return '🎭';
      case DebateCategory.otros:
        return '💬';
    }
  }
}
