import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/forum_models.dart';
import 'create_debate_page.dart';
import 'debate_detail_page.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({super.key});

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  DebateCategory _selectedCategory = DebateCategory.politica;

  // Datos de ejemplo para los debates
  final List<DebateTopic> _debates = [
    DebateTopic(
      id: '1',
      title: 'La IA es una amenaza para la humanidad',
      description: 'Discutamos si la inteligencia artificial representa un riesgo existencial para la humanidad o si es una herramienta que nos ayudará a progresar.',
      category: 'tecnologia',
      votes: 120,
      comments: 45,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      authorId: 'user1',
      authorName: 'Ana García',
      tags: ['IA', 'tecnología', 'futuro'],
      isActive: true,
    ),
    DebateTopic(
      id: '2',
      title: 'El cambio climático es la mayor crisis de nuestro tiempo',
      description: 'Analicemos la urgencia del cambio climático y las acciones necesarias para combatirlo.',
      category: 'medioAmbiente',
      votes: 95,
      comments: 32,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      authorId: 'user2',
      authorName: 'Carlos López',
      tags: ['clima', 'sostenibilidad', 'medio ambiente'],
      isActive: true,
    ),
    DebateTopic(
      id: '3',
      title: 'La educación online es mejor que la presencial',
      description: 'Debatamos sobre las ventajas y desventajas de la educación virtual vs presencial.',
      category: 'educacion',
      votes: 88,
      comments: 28,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      authorId: 'user3',
      authorName: 'María Rodríguez',
      tags: ['educación', 'tecnología', 'aprendizaje'],
      isActive: true,
    ),
    DebateTopic(
      id: '4',
      title: 'La globalización es beneficiosa para todos',
      description: 'Evaluemos el impacto de la globalización en las economías mundiales y las sociedades.',
      category: 'economia',
      votes: 75,
      comments: 22,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      authorId: 'user4',
      authorName: 'José Martínez',
      tags: ['economía', 'globalización', 'comercio'],
      isActive: true,
    ),
    DebateTopic(
      id: '5',
      title: 'La energía nuclear es necesaria para el futuro',
      description: 'Discutamos el papel de la energía nuclear en la transición energética.',
      category: 'medioAmbiente',
      votes: 62,
      comments: 18,
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      authorId: 'user5',
      authorName: 'Laura Sánchez',
      tags: ['energía', 'nuclear', 'sostenibilidad'],
      isActive: true,
    ),
    DebateTopic(
      id: '6',
      title: 'La exploración espacial es una pérdida de recursos',
      description: 'Analicemos si la exploración espacial justifica la inversión económica.',
      category: 'tecnologia',
      votes: 50,
      comments: 15,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      authorId: 'user6',
      authorName: 'Roberto Díaz',
      tags: ['espacio', 'ciencia', 'recursos'],
      isActive: true,
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

  List<DebateTopic> get _filteredDebates {
    if (_selectedCategory == DebateCategory.politica) {
      return _debates;
    }
    return _debates.where((d) => d.category == _selectedCategory.name).toList();
  }

  List<DebateTopic> get _popularDebates {
    final sorted = List<DebateTopic>.from(_filteredDebates);
    sorted.sort((a, b) => b.votes.compareTo(a.votes));
    return sorted;
  }

  List<DebateTopic> get _recentDebates {
    final sorted = List<DebateTopic>.from(_filteredDebates);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Foros de Debate',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showCreateDebateDialog(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: 'Crear debate',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6C5CE7),
          unselectedLabelColor: const Color(0xFF636E72),
          indicatorColor: const Color(0xFF6C5CE7),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Populares'),
            Tab(text: 'Recientes'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtro de categorías
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: DebateCategory.values.length,
              itemBuilder: (context, index) {
                final category = DebateCategory.values[index];
                final isSelected = category == _selectedCategory;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF6C5CE7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFFE9ECEF),
                        width: 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.displayName,
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

          // Lista de debates
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDebatesList(_popularDebates),
                _buildDebatesList(_recentDebates),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebatesList(List<DebateTopic> debates) {
    if (debates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 48,
                color: const Color(0xFF6C5CE7).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay debates en esta categoría',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF636E72),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Sé el primero en crear un debate!',
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
      itemCount: debates.length,
      itemBuilder: (context, index) {
        final debate = debates[index];
        return _buildDebateCard(debate, index);
      },
    );
  }

  Widget _buildDebateCard(DebateTopic debate, int index) {
    final category = DebateCategory.values.firstWhere(
      (c) => c.name == debate.category,
      orElse: () => DebateCategory.otros,
    );

    return GestureDetector(
      onTap: () => _navigateToDebate(debate),
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
            // Header del debate
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.campaign_rounded,
                    color: const Color(0xFF6C5CE7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF6C5CE7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'por ${debate.authorName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${category.emoji}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Título del debate
            Text(
              debate.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              debate.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Tags
            if (debate.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: debate.tags.take(3).map((tag) {
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
            if (debate.tags.isNotEmpty) const SizedBox(height: 16),

            // Footer con estadísticas
            Row(
              children: [
                _buildStatItem(
                  icon: Icons.thumb_up_outlined,
                  count: debate.votes,
                  label: 'votos',
                  color: const Color(0xFF00B894),
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  icon: Icons.comment_outlined,
                  count: debate.comments,
                  label: 'comentarios',
                  color: const Color(0xFF6C5CE7),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(debate.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF636E72),
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

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF636E72),
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'hace ${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes}m';
    } else {
      return 'ahora';
    }
  }

  void _navigateToDebate(DebateTopic debate) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DebateDetailPage(debate: debate),
      ),
    );
  }

  void _showCreateDebateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Crear nuevo debate',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          '¿Qué tipo de debate quieres crear?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateDebatePage(),
                ),
              );
            },
            child: const Text('Crear debate'),
          ),
        ],
      ),
    );
  }
}