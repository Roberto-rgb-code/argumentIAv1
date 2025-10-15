import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/event_models.dart';

class EventDetailPage extends StatefulWidget {
  final DebateEvent event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    final category = EventCategory.values.firstWhere(
      (c) => c.name == widget.event.category,
      orElse: () => EventCategory.otros,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Detalles del Evento',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del evento
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría y organizador
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.event_rounded,
                          color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.displayName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.event.organizer,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Título
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  Text(
                    widget.event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF636E72),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Información detallada
                  _buildInfoSection(),
                ],
              ),
            ),

            // Temas del debate
            if (widget.event.topics.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    Row(
                      children: [
                        Icon(
                          Icons.topic_rounded,
                          color: const Color(0xFF6C5CE7),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Temas del debate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.event.topics.map((topic) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C5CE7).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            topic,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Premios (si es un torneo)
            if (widget.event.prizes != null && widget.event.prizes!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events_rounded,
                          color: const Color(0xFFFFD93D),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Premios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...widget.event.prizes!.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD93D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getPrizeIcon(entry.key),
                              color: const Color(0xFFFFD93D),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                color: Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Reglas (si existen)
            if (widget.event.rules != null && widget.event.rules!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    Row(
                      children: [
                        Icon(
                          Icons.rule_rounded,
                          color: const Color(0xFFE17055),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Reglas del evento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.event.rules!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF636E72),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Botón de registro
            Container(
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: widget.event.isFull || _isRegistered 
                      ? null 
                      : () => _registerForEvent(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isRegistered
                        ? const Color(0xFF00B894)
                        : widget.event.isFull
                            ? const Color(0xFF636E72)
                            : const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    _isRegistered
                        ? Icons.check_circle_rounded
                        : widget.event.isFull
                            ? Icons.block_rounded
                            : Icons.event_available_rounded,
                    size: 20,
                  ),
                  label: Text(
                    _isRegistered
                        ? 'Ya estás registrado'
                        : widget.event.isFull
                            ? 'Evento lleno'
                            : 'Registrarse al evento',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.access_time_rounded,
          label: 'Fecha y hora',
          value: '${_formatDate(widget.event.startDate)} a las ${widget.event.formattedTime}',
          color: const Color(0xFF6C5CE7),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.schedule_rounded,
          label: 'Duración',
          value: widget.event.formattedDuration,
          color: const Color(0xFF00B4DB),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: widget.event.isOnline ? Icons.videocam_rounded : Icons.location_on_rounded,
          label: widget.event.isOnline ? 'Modalidad' : 'Ubicación',
          value: widget.event.isOnline ? 'Online' : widget.event.location,
          color: widget.event.isOnline ? const Color(0xFF00B894) : const Color(0xFFE17055),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.people_rounded,
          label: 'Participantes',
          value: '${widget.event.currentParticipants}/${widget.event.maxParticipants}',
          color: const Color(0xFF00B4DB),
        ),
        if (widget.event.price != null && widget.event.price! > 0) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.payment_rounded,
            label: 'Costo',
            value: '\$${widget.event.price!.toStringAsFixed(0)}',
            color: const Color(0xFFFFD93D),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
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
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF636E72),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3436),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getPrizeIcon(String position) {
    switch (position.toLowerCase()) {
      case 'primerlugar':
        return Icons.emoji_events_rounded;
      case 'segundolugar':
        return Icons.military_tech_rounded;
      case 'tercerlugar':
        return Icons.military_tech_rounded;
      default:
        return Icons.card_giftcard_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  void _registerForEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirmar registro',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Confirmas tu registro para este evento?',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(widget.event.startDate)} a las ${widget.event.formattedTime}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.event.isOnline && widget.event.meetingLink != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B894).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.link_rounded,
                      color: Color(0xFF00B894),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Enlace del evento:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _copyMeetingLink(),
                      child: const Text(
                        'Copiar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRegistered = true;
              });
              _showRegistrationSuccess();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _copyMeetingLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.link_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Enlace copiado al portapapeles'),
          ],
        ),
        backgroundColor: Color(0xFF00B894),
      ),
    );
  }

  void _showRegistrationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '¡Registro exitoso!',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: const Text(
          'Te has registrado exitosamente para este evento. Recibirás una confirmación por correo electrónico.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Compartir evento',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          '¿Cómo quieres compartir este evento?',
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
