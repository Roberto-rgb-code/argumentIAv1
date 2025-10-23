import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../models/lesson_models.dart';
import '../../data/lessons_data.dart';
import '../../widgets/common/dialecta_card.dart';
import '../../widgets/common/dialecta_button.dart';
import '../../widgets/common/dialecta_animations.dart';
import '../../theme/app_theme.dart';
import 'lesson_detail_page.dart';

class LessonsPageV2 extends StatefulWidget {
  const LessonsPageV2({super.key});

  @override
  State<LessonsPageV2> createState() => _LessonsPageV2State();
}

class _LessonsPageV2State extends State<LessonsPageV2>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _progressController;
  late AnimationController _streakController;

  final List<Lesson> _allLessons = LessonsData.getAllLessons();
  LessonType _selectedType = LessonType.areal;
  
  // Progreso del usuario (simulado)
  int _totalXP = 1250;
  int _currentLevel = 3;
  int _streak = 7;
  int _lessonsCompleted = 12;
  int _totalLessons = 50;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _progressController.forward();
    _streakController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _progressController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  List<Lesson> get _filteredLessons {
    return _allLessons.where((lesson) => lesson.type == _selectedType).toList();
  }

  List<Lesson> get _featuredLessons {
    return _allLessons.take(6).toList();
  }

  double get _progressPercentage {
    return _lessonsCompleted / _totalLessons;
  }

  int get _xpToNextLevel {
    return (_currentLevel + 1) * 500 - _totalXP;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildProgressSection(),
          _buildQuickStats(),
          _buildFeaturedLessons(),
          _buildLessonsList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aprende Pensamiento Crítico',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Desarrolla habilidades de argumentación',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStreakBadge(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakBadge() {
    return AnimatedBuilder(
      animation: _streakController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _streakController.value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.brightOrange,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.brightOrange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_streak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DialectaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.successGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tu Progreso',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.charcoalBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Nivel $_currentLevel • $_totalXP XP',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.charcoalBlack.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.mintGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$_xpToNextLevel XP para nivel ${_currentLevel + 1}',
                      style: TextStyle(
                        color: AppTheme.mintGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lecciones Completadas',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.charcoalBlack.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '$_lessonsCompleted/$_totalLessons',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.charcoalBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progressPercentage * _progressController.value,
                          backgroundColor: AppTheme.lightGray,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.mintGreen),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events_rounded,
                title: 'Racha',
                value: '$_streak días',
                color: AppTheme.brightOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_rounded,
                value: '$_totalXP',
                title: 'XP Total',
                color: AppTheme.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle_rounded,
                value: '$_lessonsCompleted',
                title: 'Completadas',
                color: AppTheme.mintGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return DialectaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.charcoalBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.charcoalBlack.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedLessons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Lecciones Destacadas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.charcoalBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                DialectaButton(
                  text: 'Ver todas',
                  type: DialectaButtonType.outline,
                  size: DialectaButtonSize.small,
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _featuredLessons.length,
                itemBuilder: (context, index) {
                  final lesson = _featuredLessons[index];
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(
                      right: index < _featuredLessons.length - 1 ? 16 : 0,
                    ),
                    child: _buildLessonCard(lesson, isFeatured: true),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todas las Lecciones',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.charcoalBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredLessons.length,
                itemBuilder: (context, index) {
                  final lesson = _filteredLessons[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLessonCard(lesson),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, {bool isFeatured = false}) {
    final isCompleted = _lessonsCompleted > 0 && 
        _allLessons.indexOf(lesson) < _lessonsCompleted;
    
    return GestureDetector(
      onTap: () => _navigateToLesson(lesson),
      child: DialectaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: _getLessonGradient(lesson.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getLessonIcon(lesson.type),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.charcoalBlack,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.charcoalBlack.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.mintGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDifficultyChip(lesson.difficulty),
                const SizedBox(width: 8),
                _buildTimeChip(lesson.estimatedMinutes),
                const Spacer(),
                _buildPointsChip(lesson.pointsReward),
              ],
            ),
            if (lesson.exercises.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.quiz_rounded,
                    size: 16,
                    color: AppTheme.charcoalBlack.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${lesson.exercises.length} ejercicios',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.charcoalBlack.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(Difficulty difficulty) {
    final colors = {
      Difficulty.basico: AppTheme.mintGreen,
      Difficulty.intermedio: AppTheme.brightOrange,
      Difficulty.avanzado: AppTheme.coralRed,
    };
    
    final labels = {
      Difficulty.basico: 'Básico',
      Difficulty.intermedio: 'Intermedio',
      Difficulty.avanzado: 'Avanzado',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[difficulty]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        labels[difficulty]!,
        style: TextStyle(
          color: colors[difficulty],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeChip(int minutes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 4),
          Text(
            '${minutes}m',
            style: TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsChip(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 12,
            color: AppTheme.purple,
          ),
          const SizedBox(width: 4),
          Text(
            '$points XP',
            style: TextStyle(
              color: AppTheme.purple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getLessonGradient(LessonType type) {
    switch (type) {
      case LessonType.areal:
        return AppTheme.primaryGradient;
      case LessonType.falacias:
        return AppTheme.warningGradient;
      case LessonType.fortalecerArgumento:
        return AppTheme.successGradient;
      case LessonType.completarArgumento:
        return AppTheme.premiumGradient;
      case LessonType.refutacion:
        return LinearGradient(
          colors: [AppTheme.coralRed, const Color(0xFFE53E3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LessonType.evidencia:
        return AppTheme.successGradient;
      case LessonType.razonamiento:
        return AppTheme.premiumGradient;
      case LessonType.limitaciones:
        return LinearGradient(
          colors: [AppTheme.charcoalBlack, const Color(0xFF2D2D2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.areal:
        return Icons.psychology_rounded;
      case LessonType.falacias:
        return Icons.warning_rounded;
      case LessonType.fortalecerArgumento:
        return Icons.trending_up_rounded;
      case LessonType.completarArgumento:
        return Icons.edit_rounded;
      case LessonType.refutacion:
        return Icons.reply_rounded;
      case LessonType.evidencia:
        return Icons.fact_check_rounded;
      case LessonType.razonamiento:
        return Icons.psychology_alt_rounded;
      case LessonType.limitaciones:
        return Icons.balance_rounded;
    }
  }

  void _navigateToLesson(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailPage(lesson: lesson),
      ),
    );
  }
}
