import 'dart:convert';

enum MessageRole { user, assistant, system }

MessageRole messageRoleFrom(String s) {
  switch (s) {
    case 'user':
      return MessageRole.user;
    case 'assistant':
      return MessageRole.assistant;
    case 'system':
      return MessageRole.system;
    default:
      return MessageRole.user;
  }
}

String messageRoleToString(MessageRole role) {
  switch (role) {
    case MessageRole.user:
      return 'user';
    case MessageRole.assistant:
      return 'assistant';
    case MessageRole.system:
      return 'system';
  }
}

class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> m) {
    return ChatMessage(
      id: m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      role: messageRoleFrom(m['role'] ?? 'user'),
      content: m['content'] ?? '',
      timestamp: m['timestamp'] != null
          ? DateTime.parse(m['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': messageRoleToString(role),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'role': messageRoleToString(role),
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));
}

class DebateSession {
  final String id;
  final String topic;
  final List<ChatMessage> messages;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int turnCount;
  final double? finalScore;
  final int tokensEarned;

  DebateSession({
    required this.id,
    required this.topic,
    required this.messages,
    required this.startedAt,
    this.completedAt,
    this.turnCount = 0,
    this.finalScore,
    this.tokensEarned = 0,
  });

  factory DebateSession.fromMap(Map<String, dynamic> m) {
    return DebateSession(
      id: m['id'],
      topic: m['topic'],
      messages: (m['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      startedAt: DateTime.parse(m['started_at']),
      completedAt:
          m['completed_at'] != null ? DateTime.parse(m['completed_at']) : null,
      turnCount: m['turn_count'] ?? 0,
      finalScore: m['final_score']?.toDouble(),
      tokensEarned: m['tokens_earned'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'messages': messages.map((m) => m.toMap()).toList(),
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'turn_count': turnCount,
      'final_score': finalScore,
      'tokens_earned': tokensEarned,
    };
  }

  String toJson() => json.encode(toMap());

  factory DebateSession.fromJson(String source) =>
      DebateSession.fromMap(json.decode(source));

  DebateSession copyWith({
    String? id,
    String? topic,
    List<ChatMessage>? messages,
    DateTime? startedAt,
    DateTime? completedAt,
    int? turnCount,
    double? finalScore,
    int? tokensEarned,
  }) {
    return DebateSession(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      messages: messages ?? this.messages,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      turnCount: turnCount ?? this.turnCount,
      finalScore: finalScore ?? this.finalScore,
      tokensEarned: tokensEarned ?? this.tokensEarned,
    );
  }
}

class ArgumentEvaluation {
  final int score;
  final String structure;
  final List<String> fallacies;
  final List<String> strengths;
  final List<String> improvements;
  final int tokensEarned;
  final String feedback;

  ArgumentEvaluation({
    required this.score,
    required this.structure,
    required this.fallacies,
    required this.strengths,
    required this.improvements,
    required this.tokensEarned,
    required this.feedback,
  });

  factory ArgumentEvaluation.fromMap(Map<String, dynamic> m) {
    return ArgumentEvaluation(
      score: m['score'] ?? 0,
      structure: m['structure'] ?? 'Básico',
      fallacies: (m['fallacies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      strengths: (m['strengths'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      improvements: (m['improvements'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      tokensEarned: m['tokens_earned'] ?? 0,
      feedback: m['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'structure': structure,
      'fallacies': fallacies,
      'strengths': strengths,
      'improvements': improvements,
      'tokens_earned': tokensEarned,
      'feedback': feedback,
    };
  }
}

