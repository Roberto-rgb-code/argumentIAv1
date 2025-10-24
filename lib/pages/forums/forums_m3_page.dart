import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/m3/dialecta_m3_components.dart';
import '../../theme/app_theme.dart';
import '../../models/forum_models.dart';

class ForumsM3Page extends StatefulWidget {
  const ForumsM3Page({super.key});

  @override
  State<ForumsM3Page> createState() => _ForumsM3PageState();
}

class _ForumsM3PageState extends State<ForumsM3Page> {
  int _selectedCategory = 0;
  final List<String> _categories = ['Todos', 'Política', 'Tecnología', 'Ciencia', 'Cultura'];

  final List<DebateTopic> _debates = [
    DebateTopic(
      id: '1',
      title: '¿La inteligencia artificial reemplazará a los humanos?',
      description: 'Debate sobre el futuro del trabajo y la IA',
      category: 'Tecnología',
      votes: 42,
      comments: 18,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      authorId: 'user1',
      authorName: 'Ana García',
      tags: ['IA', 'Futuro', 'Trabajo'],
      isActive: true,
    ),
    DebateTopic(
      id: '2',
      title: '¿El cambio climático es reversible?',
      description: 'Análisis de las posibilidades de revertir el calentamiento global',
      category: 'Ciencia',
      votes: 67,
      comments: 25,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      authorId: 'user2',
      authorName: 'Carlos López',
      tags: ['Medio Ambiente', 'Sostenibilidad'],
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Foros de Debate',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppTheme.primaryBlue,
        actions: [
          IconButton(
            onPressed: () {
              // Mostrar filtros
              _showFilterDialog();
            },
            icon: const Icon(Icons.filter_list_rounded),
            color: AppTheme.primaryBlue,
          ),
          IconButton(
            onPressed: () {
              // Buscar debates
              _showSearchDialog();
            },
            icon: const Icon(Icons.search_rounded),
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
      body: Column(
        children: [
          // Categorías con Segmented Control M3
          Padding(
            padding: const EdgeInsets.all(16),
            child: DialectaM3Components.segmentedControl(
              options: _categories,
              selectedIndex: _selectedCategory,
              onSelectionChanged: (index) {
                setState(() {
                  _selectedCategory = index;
                });
              },
            ),
          ),

          // Lista de debates
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _debates.length,
              itemBuilder: (context, index) {
                final debate = _debates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DialectaM3Components.card(
                    onTap: () {
                      // Navegar al detalle del debate
                      _navigateToDebateDetail(debate);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header del debate
                        Row(
                          children: [
                            // Avatar del autor
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                              child: Text(
                                debate.authorName[0],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    debate.authorName,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.charcoalBlack,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(debate.createdAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppTheme.primaryBlue.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Chip de categoría
                            DialectaM3Components.chip(
                              label: debate.category,
                              selected: false,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Título del debate
                        Text(
                          debate.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.charcoalBlack,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Descripción
                        Text(
                          debate.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.charcoalBlack.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: debate.tags.map((tag) {
                            return DialectaM3Components.chip(
                              label: tag,
                              selected: false,
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Stats y acciones
                        Row(
                          children: [
                            // Votos
                            DialectaM3Components.textButton(
                              text: '${debate.votes} votos',
                              onPressed: () {
                                // Votar
                                _voteDebate(debate);
                              },
                              icon: Icons.thumb_up_rounded,
                            ),
                            const SizedBox(width: 16),
                            // Comentarios
                            DialectaM3Components.textButton(
                              text: '${debate.comments} comentarios',
                              onPressed: () {
                                // Ver comentarios
                                _navigateToDebateDetail(debate);
                              },
                              icon: Icons.comment_rounded,
                            ),
                            const Spacer(),
                            // Compartir
                            IconButton(
                              onPressed: () {
                                _shareDebate(debate);
                              },
                              icon: const Icon(Icons.share_rounded),
                              color: AppTheme.primaryBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: DialectaM3Components.fab(
        onPressed: () {
          // Crear nuevo debate
          _createNewDebate();
        },
        icon: Icons.add_rounded,
        tooltip: 'Nuevo Debate',
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => DialectaM3Components.alertDialog(
        title: 'Filtrar Debates',
        content: 'Selecciona los filtros que deseas aplicar',
        confirmText: 'Aplicar',
        cancelText: 'Cancelar',
        onConfirm: () {
          Navigator.pop(context);
          // Aplicar filtros
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Buscar Debates',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.charcoalBlack,
          ),
        ),
        content: DialectaM3Components.textField(
          label: 'Término de búsqueda',
          hint: 'Escribe palabras clave...',
          controller: TextEditingController(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Realizar búsqueda
            },
            child: Text(
              'Buscar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _navigateToDebateDetail(DebateTopic debate) {
    // Navegar al detalle del debate
    Navigator.pushNamed(context, '/debate-detail', arguments: debate);
  }

  void _voteDebate(DebateTopic debate) {
    // Implementar votación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Votaste en "${debate.title}"'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _shareDebate(DebateTopic debate) {
    // Implementar compartir
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiste "${debate.title}"'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _createNewDebate() {
    // Navegar a crear debate
    Navigator.pushNamed(context, '/create-debate');
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours}h';
    } else {
      return 'hace ${difference.inDays}d';
    }
  }
}
