class DebateEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String organizer;
  final int maxParticipants;
  final int currentParticipants;
  final String category;
  final List<String> topics;
  final bool isOnline;
  final String? meetingLink;
  final double? price;
  final String status; // 'upcoming', 'ongoing', 'completed', 'cancelled'
  final List<String> registeredUsers;
  final Map<String, dynamic>? prizes;
  final String? rules;

  const DebateEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizer,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.category,
    required this.topics,
    required this.isOnline,
    this.meetingLink,
    this.price,
    required this.status,
    this.registeredUsers = const [],
    this.prizes,
    this.rules,
  });

  factory DebateEvent.fromMap(Map<String, dynamic> map) {
    return DebateEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
      location: map['location'] ?? '',
      organizer: map['organizer'] ?? '',
      maxParticipants: map['maxParticipants'] ?? 0,
      currentParticipants: map['currentParticipants'] ?? 0,
      category: map['category'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      isOnline: map['isOnline'] ?? false,
      meetingLink: map['meetingLink'],
      price: map['price']?.toDouble(),
      status: map['status'] ?? 'upcoming',
      registeredUsers: List<String>.from(map['registeredUsers'] ?? []),
      prizes: map['prizes'],
      rules: map['rules'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'organizer': organizer,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'category': category,
      'topics': topics,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
      'price': price,
      'status': status,
      'registeredUsers': registeredUsers,
      'prizes': prizes,
      'rules': rules,
    };
  }

  bool get isFull => currentParticipants >= maxParticipants;
  bool get isFree => price == null || price == 0;
  bool get isUpcoming => status == 'upcoming';
  bool get isOngoing => status == 'ongoing';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  String get formattedDate {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${startDate.day} ${months[startDate.month - 1]}';
  }

  String get formattedTime {
    final hour = startDate.hour.toString().padLeft(2, '0');
    final minute = startDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDuration {
    final duration = endDate.difference(startDate);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}

enum EventCategory {
  torneo,
  workshop,
  conferencia,
  debatePublico,
  competencia,
  seminario,
  networking,
  otros,
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.torneo:
        return 'Torneo';
      case EventCategory.workshop:
        return 'Workshop';
      case EventCategory.conferencia:
        return 'Conferencia';
      case EventCategory.debatePublico:
        return 'Debate Público';
      case EventCategory.competencia:
        return 'Competencia';
      case EventCategory.seminario:
        return 'Seminario';
      case EventCategory.networking:
        return 'Networking';
      case EventCategory.otros:
        return 'Otros';
    }
  }

  String get emoji {
    switch (this) {
      case EventCategory.torneo:
        return '🏆';
      case EventCategory.workshop:
        return '🔧';
      case EventCategory.conferencia:
        return '🎤';
      case EventCategory.debatePublico:
        return '🗣️';
      case EventCategory.competencia:
        return '⚔️';
      case EventCategory.seminario:
        return '📚';
      case EventCategory.networking:
        return '🤝';
      case EventCategory.otros:
        return '📅';
    }
  }

  String get color {
    switch (this) {
      case EventCategory.torneo:
        return '#FFD93D';
      case EventCategory.workshop:
        return '#6C5CE7';
      case EventCategory.conferencia:
        return '#00B4DB';
      case EventCategory.debatePublico:
        return '#FF6B6B';
      case EventCategory.competencia:
        return '#00B894';
      case EventCategory.seminario:
        return '#FDCB6E';
      case EventCategory.networking:
        return '#A29BFE';
      case EventCategory.otros:
        return '#636E72';
    }
  }
}

class EventRegistration {
  final String id;
  final String eventId;
  final String userId;
  final DateTime registeredAt;
  final String status; // 'registered', 'confirmed', 'cancelled'
  final Map<String, dynamic>? additionalInfo;

  const EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.registeredAt,
    required this.status,
    this.additionalInfo,
  });

  factory EventRegistration.fromMap(Map<String, dynamic> map) {
    return EventRegistration(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      registeredAt: DateTime.parse(map['registeredAt'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 'registered',
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'registeredAt': registeredAt.toIso8601String(),
      'status': status,
      'additionalInfo': additionalInfo,
    };
  }

  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
}
