import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/forum_models.dart';

class DebateDetailPage extends StatefulWidget {
  final DebateTopic debate;

  const DebateDetailPage({
    super.key,
    required this.debate,
  });

  @override
  State<DebateDetailPage> createState() => _DebateDetailPageState();
}

class _DebateDetailPageState extends State<DebateDetailPage> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isPro = true;
  int _votes = 0;

  // Comentarios de ejemplo
  final List<DebateComment> _comments = [
    DebateComment(
      id: '1',
      debateId: '1',
      content: 'Estoy de acuerdo con la moción. La IA puede ser una herramienta increíble para resolver problemas complejos y mejorar la eficiencia en muchas industrias.',
      authorId: 'user1',
      authorName: 'Ana García',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      votes: 12,
      isPro: true,
    ),
    DebateComment(
      id: '2',
      debateId: '1',
      content: 'Sin embargo, debemos ser cautelosos. La IA puede generar desempleo masivo y crear dependencias peligrosas. ¿Qué pasará cuando las máquinas tomen todas las decisiones?',
      authorId: 'user2',
      authorName: 'Carlos López',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      votes: 8,
      isPro: false,
    ),
    DebateComment(
      id: '3',
      debateId: '1',
      content: 'La clave está en la regulación y educación. Si preparamos a la sociedad para coexistir con la IA, los beneficios superarán los riesgos.',
      authorId: 'user3',
      authorName: 'María Rodríguez',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      votes: 15,
      isPro: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _votes = widget.debate.votes;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _voteDebate() {
    setState(() {
      _votes++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.thumb_up_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Voto registrado!'),
          ],
        ),
        backgroundColor: const Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _addComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final newComment = DebateComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      debateId: widget.debate.id,
      content: content,
      authorId: 'current_user',
      authorName: 'Tú',
      createdAt: DateTime.now(),
      votes: 0,
      isPro: _isPro,
    );

    setState(() {
      _comments.insert(0, newComment);
    });

    _commentController.clear();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _voteComment(DebateComment comment) {
    setState(() {
      // Simular votación
      final index = _comments.indexWhere((c) => c.id == comment.id);
      if (index != -1) {
        _comments[index] = comment.copyWith(votes: comment.votes + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = DebateCategory.values.firstWhere(
      (c) => c.name == widget.debate.category,
      orElse: () => DebateCategory.otros,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Debate',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showShareDialog(),
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header del debate
          Container(
            margin: const EdgeInsets.all(16),
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
                // Categoría y autor
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.megaphone_rounded,
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
                            'por ${widget.debate.authorName}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF636E72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      category.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Título
                Text(
                  widget.debate.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3436),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Descripción
                Text(
                  widget.debate.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF636E72),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Tags
                if (widget.debate.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.debate.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF636E72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (widget.debate.tags.isNotEmpty) const SizedBox(height: 16),

                // Botón de votación
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _voteDebate,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.thumb_up_rounded),
                        label: Text('Votar ($_votes)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            color: Color(0xFF6C5CE7),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_comments.length} comentarios',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w500,
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

          // Lista de comentarios
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return _buildCommentCard(comment, index);
              },
            ),
          ),

          // Input para nuevo comentario
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Selector de postura
                  Row(
                    children: [
                      Expanded(
                        child: _buildStanceSelector(true, 'PROS'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStanceSelector(false, 'CONTRAS'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Input de comentario
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu argumento...',
                            filled: true,
                            fillColor: const Color(0xFFF5F7FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _addComment(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C5CE7).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _addComment,
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStanceSelector(bool isPro, String label) {
    final isSelected = _isPro == isPro;
    final color = isPro ? const Color(0xFF00B894) : const Color(0xFFE17055);

    return GestureDetector(
      onTap: () => setState(() => _isPro = isPro),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPro ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
              color: isSelected ? color : const Color(0xFF636E72),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : const Color(0xFF636E72),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(DebateComment comment, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: comment.isPro 
              ? const Color(0xFF00B894).withOpacity(0.2)
              : const Color(0xFFE17055).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del comentario
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: comment.isPro 
                      ? const Color(0xFF00B894).withOpacity(0.1)
                      : const Color(0xFFE17055).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  comment.isPro ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
                  color: comment.isPro ? const Color(0xFF00B894) : const Color(0xFFE17055),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      _formatTimeAgo(comment.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: comment.isPro 
                      ? const Color(0xFF00B894).withOpacity(0.1)
                      : const Color(0xFFE17055).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  comment.isPro ? 'PROS' : 'CONTRAS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: comment.isPro ? const Color(0xFF00B894) : const Color(0xFFE17055),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Contenido del comentario
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3436),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Botón de votación
          Row(
            children: [
              GestureDetector(
                onTap: () => _voteComment(comment),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.thumb_up_outlined,
                        size: 14,
                        color: Color(0xFF636E72),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${comment.votes}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.reply_rounded, size: 14),
                label: const Text('Responder'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms)
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.1, curve: Curves.easeOut);
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

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Compartir debate',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          '¿Cómo quieres compartir este debate?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enlace copiado al portapapeles'),
                  backgroundColor: Color(0xFF00B894),
                ),
              );
            },
            child: const Text('Copiar enlace'),
          ),
        ],
      ),
    );
  }
}

extension on DebateComment {
  DebateComment copyWith({
    String? id,
    String? debateId,
    String? content,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    int? votes,
    bool? isPro,
    List<String>? replies,
  }) {
    return DebateComment(
      id: id ?? this.id,
      debateId: debateId ?? this.debateId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      votes: votes ?? this.votes,
      isPro: isPro ?? this.isPro,
      replies: replies ?? this.replies,
    );
  }
}
