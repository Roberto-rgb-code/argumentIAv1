import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/lesson_models.dart';
import 'lesson_detail_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  LessonType _selectedType = LessonType.areal;

  // Lecciones de ejemplo
  final List<Lesson> _lessons = [
    // AREAL
    Lesson(
      id: '1',
      title: 'Introducción a AREAL',
      description: 'Aprende los fundamentos del método AREAL para estructurar argumentos sólidos.',
      type: LessonType.areal,
      difficulty: Difficulty.basico,
      estimatedMinutes: 15,
      tags: ['AREAL', 'Estructura', 'Argumentación'],
      pointsReward: 100,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      exercises: [
        Exercise(
          id: '1-1',
          title: 'Componentes AREAL',
          instruction: 'Identifica los 4 componentes del método AREAL',
          type: ExerciseType.multipleChoice,
          content: {
            'question': '¿Cuáles son los componentes de AREAL?',
            'options': [
              'Afirmación, Razonamiento, Evidencia, Limitaciones',
              'Argumento, Razón, Ejemplo, Límite',
              'Análisis, Reflexión, Evaluación, Lógica',
            ],
          },
          correctAnswers: ['0'],
          points: 25,
          hint: 'AREAL es un acrónimo que representa la estructura de un argumento.',
          explanation: 'AREAL significa: Afirmación (tesis principal), Razonamiento (por qué), Evidencia (pruebas), Limitaciones (reconocimiento de debilidades).',
        ),
      ],
    ),

    Lesson(
      id: '2',
      title: 'Construyendo Afirmaciones',
      description: 'Domina el arte de crear afirmaciones claras y específicas.',
      type: LessonType.areal,
      difficulty: Difficulty.basico,
      estimatedMinutes: 12,
      tags: ['Afirmación', 'Tesis', 'Claridad'],
      pointsReward: 80,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      exercises: [],
    ),

    // Falacias
    Lesson(
      id: '3',
      title: 'Falacias Comunes',
      description: 'Identifica y evita las falacias lógicas más frecuentes en debates.',
      type: LessonType.falacias,
      difficulty: Difficulty.intermedio,
      estimatedMinutes: 20,
      tags: ['Falacias', 'Lógica', 'Errores'],
      pointsReward: 150,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      exercises: [
        Exercise(
          id: '3-1',
          title: 'Identificar Falacias',
          instruction: 'Identifica la falacia lógica en el siguiente argumento',
          type: ExerciseType.multipleChoice,
          content: {
            'question': '"Si no apoyas esta política, entonces estás en contra del progreso y quieres que la sociedad retroceda."',
            'options': [
              'Falso dilema',
              'Ad hominem',
              'Apelación a la autoridad',
              'Hombre de paja',
            ],
          },
          correctAnswers: ['0'],
          points: 30,
          hint: 'Esta falacia presenta solo dos opciones cuando hay más posibilidades.',
          explanation: 'El falso dilema presenta una situación como si solo tuviera dos opciones, cuando en realidad hay más alternativas.',
        ),
      ],
    ),

    Lesson(
      id: '4',
      title: 'Ad Hominem y Hombre de Paja',
      description: 'Reconoce y evita estos ataques personales y distorsiones argumentales.',
      type: LessonType.falacias,
      difficulty: Difficulty.basico,
      estimatedMinutes: 18,
      tags: ['Ad Hominem', 'Hombre de Paja', 'Ataques'],
      pointsReward: 120,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      exercises: [],
    ),

    // Fortalecer Argumento
    Lesson(
      id: '5',
      title: 'Fortalecer con Evidencia',
      description: 'Aprende a respaldar tus argumentos con evidencia sólida y relevante.',
      type: LessonType.fortalecerArgumento,
      difficulty: Difficulty.intermedio,
      estimatedMinutes: 25,
      tags: ['Evidencia', 'Fortalecer', 'Pruebas'],
      pointsReward: 180,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      exercises: [
        Exercise(
          id: '5-1',
          title: 'Mejor Evidencia',
          instruction: 'Selecciona la mejor evidencia para fortalecer el argumento',
          type: ExerciseType.multipleChoice,
          content: {
            'argument': 'La inversión en energías renovables es crucial para un futuro sostenible.',
            'question': '¿Cuál es la mejor evidencia para apoyar este argumento?',
            'options': [
              'Un informe del IPCC confirma que las renovables pueden mitigar drásticamente las emisiones de CO2.',
              'Los coches eléctricos son cada vez más populares entre los consumidores.',
              'El costo de los paneles solares ha disminuido un 10% en el último año.',
            ],
          },
          correctAnswers: ['0'],
          points: 35,
          hint: 'Busca evidencia que conecte directamente con la sostenibilidad y el impacto ambiental.',
          explanation: 'El informe del IPCC es evidencia científica sólida que conecta directamente las energías renovables con la sostenibilidad ambiental.',
        ),
      ],
    ),

    Lesson(
      id: '6',
      title: 'Completar Argumentos',
      description: 'Practica completando argumentos usando la estructura AREAL.',
      type: LessonType.completarArgumento,
      difficulty: Difficulty.basico,
      estimatedMinutes: 15,
      tags: ['Completar', 'AREAL', 'Práctica'],
      pointsReward: 100,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      exercises: [],
    ),

    Lesson(
      id: '7',
      title: 'Arte de la Refutación',
      description: 'Desarrolla habilidades para refutar argumentos de manera efectiva y respetuosa.',
      type: LessonType.refutacion,
      difficulty: Difficulty.avanzado,
      estimatedMinutes: 30,
      tags: ['Refutación', 'Contraargumentos', 'Debate'],
      pointsReward: 200,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      exercises: [],
    ),

    Lesson(
      id: '8',
      title: 'Evaluación de Evidencia',
      description: 'Aprende a evaluar la calidad y relevancia de la evidencia presentada.',
      type: LessonType.evidencia,
      difficulty: Difficulty.intermedio,
      estimatedMinutes: 22,
      tags: ['Evidencia', 'Evaluación', 'Calidad'],
      pointsReward: 160,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      exercises: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Lesson> get _filteredLessons {
    return _lessons.where((lesson) => lesson.type == _selectedType).toList();
  }

  List<Lesson> get _featuredLessons {
    return _lessons.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Lecciones',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6C5CE7),
          unselectedLabelColor: const Color(0xFF636E72),
          indicatorColor: const Color(0xFF6C5CE7),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Destacadas'),
            Tab(text: 'Por Categoría'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturedView(),
          _buildCategoryView(),
        ],
      ),
    );
  }

  Widget _buildFeaturedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pensamiento Crítico',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desarrolla tus habilidades argumentativas con nuestras lecciones interactivas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatChip('${_lessons.length} Lecciones'),
                    const SizedBox(width: 12),
                    _buildStatChip('${_lessons.fold<int>(0, (sum, lesson) => sum + lesson.pointsReward)} Puntos'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Lecciones destacadas
          const Text(
            'Lecciones Destacadas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 16),

          ..._featuredLessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            return _buildLessonCard(lesson, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryView() {
    return Column(
      children: [
        // Filtro de tipos
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: LessonType.values.length,
            itemBuilder: (context, index) {
              final type = LessonType.values[index];
              final isSelected = type == _selectedType;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Color(int.parse(type.color.substring(1), radix: 16) + 0xFF000000)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? Color(int.parse(type.color.substring(1), radix: 16) + 0xFF000000)
                          : const Color(0xFFE9ECEF),
                      width: 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Color(int.parse(type.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type.displayName,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white
                              : const Color(0xFF636E72),
                          fontWeight: isSelected 
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Lista de lecciones filtradas
        Expanded(
          child: _buildLessonsList(),
        ),
      ],
    );
  }

  Widget _buildLessonsList() {
    final filteredLessons = _filteredLessons;

    if (filteredLessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(int.parse(_selectedType.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                _selectedType.emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay lecciones en esta categoría',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF636E72),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Próximamente más contenido!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredLessons.length,
      itemBuilder: (context, index) {
        return _buildLessonCard(filteredLessons[index], index);
      },
    );
  }

  Widget _buildLessonCard(Lesson lesson, int index) {
    return GestureDetector(
      onTap: () => _navigateToLesson(lesson),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la lección
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(int.parse(lesson.type.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lesson.type.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(int.parse(lesson.type.color.substring(1), radix: 16) + 0xFF000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(int.parse(lesson.difficulty.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  lesson.difficulty.emoji,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  lesson.difficulty.displayName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(int.parse(lesson.difficulty.color.substring(1), radix: 16) + 0xFF000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B894).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${lesson.pointsReward} pts',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00B894),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Título de la lección
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              lesson.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            if (lesson.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: lesson.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF636E72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (lesson.tags.isNotEmpty) const SizedBox(height: 16),

            // Footer con información
            Row(
              children: [
                _buildInfoItem(
                  icon: Icons.access_time_rounded,
                  text: '${lesson.estimatedMinutes} min',
                  color: const Color(0xFF6C5CE7),
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  icon: Icons.play_lesson_rounded,
                  text: '${lesson.exercises.length} ejercicios',
                  color: const Color(0xFF00B4DB),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF6C5CE7),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Comenzar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100).ms)
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _navigateToLesson(Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonDetailPage(lesson: lesson),
      ),
    );
  }
}
