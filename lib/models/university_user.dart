import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityUser {
  final String id;
  final String email;
  final String displayName;
  final String university;
  final String career;
  final String studentId;
  final int semester;
  final String profileImageUrl;
  final List<String> interests;
  final Map<String, dynamic> stats;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isVerified;
  final String? bio;
  final String? linkedinUrl;
  final String? githubUrl;

  const UniversityUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.university,
    required this.career,
    required this.studentId,
    required this.semester,
    this.profileImageUrl = '',
    this.interests = const [],
    this.stats = const {},
    required this.createdAt,
    required this.lastActive,
    this.isVerified = false,
    this.bio,
    this.linkedinUrl,
    this.githubUrl,
  });

  // Crear desde Firestore
  factory UniversityUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UniversityUser(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      university: data['university'] ?? '',
      career: data['career'] ?? '',
      studentId: data['studentId'] ?? '',
      semester: data['semester'] ?? 1,
      profileImageUrl: data['profileImageUrl'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      stats: Map<String, dynamic>.from(data['stats'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      bio: data['bio'],
      linkedinUrl: data['linkedinUrl'],
      githubUrl: data['githubUrl'],
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'university': university,
      'career': career,
      'studentId': studentId,
      'semester': semester,
      'profileImageUrl': profileImageUrl,
      'interests': interests,
      'stats': stats,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'isVerified': isVerified,
      'bio': bio,
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
    };
  }

  // Copiar con cambios
  UniversityUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? university,
    String? career,
    String? studentId,
    int? semester,
    String? profileImageUrl,
    List<String>? interests,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isVerified,
    String? bio,
    String? linkedinUrl,
    String? githubUrl,
  }) {
    return UniversityUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      university: university ?? this.university,
      career: career ?? this.career,
      studentId: studentId ?? this.studentId,
      semester: semester ?? this.semester,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      interests: interests ?? this.interests,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
    );
  }

  // Getters para stats
  int get totalDebates => stats['totalDebates'] ?? 0;
  int get totalEvents => stats['totalEvents'] ?? 0;
  int get totalVotes => stats['totalVotes'] ?? 0;
  int get totalComments => stats['totalComments'] ?? 0;
  int get xp => stats['xp'] ?? 0;
  int get level => (xp / 100).floor() + 1;
  int get streak => stats['streak'] ?? 0;
  String get rank => _getRank();

  String _getRank() {
    if (level >= 50) return 'Maestro Dialecta';
    if (level >= 40) return 'Experto en Debate';
    if (level >= 30) return 'Orador Avanzado';
    if (level >= 20) return 'Debatiente Experto';
    if (level >= 10) return 'Orador Intermedio';
    return 'Debatiente Novato';
  }

  // Validaciones
  bool get isCompleteProfile => 
      displayName.isNotEmpty && 
      university.isNotEmpty && 
      career.isNotEmpty && 
      studentId.isNotEmpty;

  bool get hasProfileImage => profileImageUrl.isNotEmpty;

  // Intereses disponibles
  static const List<String> availableInterests = [
    'Política',
    'Tecnología',
    'Ciencia',
    'Filosofía',
    'Economía',
    'Medio Ambiente',
    'Educación',
    'Salud',
    'Arte y Cultura',
    'Deportes',
    'Historia',
    'Psicología',
    'Derecho',
    'Medicina',
    'Ingeniería',
    'Negocios',
    'Comunicación',
    'Sociología',
  ];

  // Universidades disponibles (ejemplo)
  static const List<String> availableUniversities = [
    'Universidad Nacional',
    'Universidad de los Andes',
    'Universidad Javeriana',
    'Universidad del Rosario',
    'Universidad Externado',
    'Universidad de Antioquia',
    'Universidad del Valle',
    'Universidad Industrial de Santander',
    'Universidad de Caldas',
    'Universidad del Norte',
    'Universidad EAFIT',
    'Universidad Pontificia Bolivariana',
    'Universidad de Medellín',
    'Universidad Santo Tomás',
    'Universidad de La Sabana',
    'Otra',
  ];

  // Carreras disponibles (ejemplo)
  static const List<String> availableCareers = [
    'Ingeniería de Sistemas',
    'Medicina',
    'Derecho',
    'Psicología',
    'Economía',
    'Administración de Empresas',
    'Comunicación Social',
    'Periodismo',
    'Filosofía',
    'Historia',
    'Sociología',
    'Antropología',
    'Ciencia Política',
    'Relaciones Internacionales',
    'Arquitectura',
    'Ingeniería Civil',
    'Ingeniería Industrial',
    'Ingeniería Mecánica',
    'Ingeniería Eléctrica',
    'Contaduría Pública',
    'Marketing',
    'Publicidad',
    'Diseño Gráfico',
    'Arte',
    'Música',
    'Teatro',
    'Cine',
    'Otra',
  ];
}
