import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event_models.dart';
import 'event_detail_page.dart';
import 'create_event_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Eventos de ejemplo
  final List<DebateEvent> _events = [
    DebateEvent(
      id: '1',
      title: 'Debate sobre el futuro de la educación',
      description: 'Un debate abierto sobre cómo la tecnología está transformando la educación y qué cambios podemos esperar en los próximos años.',
      startDate: DateTime.now().add(const Duration(hours: 2)),
      endDate: DateTime.now().add(const Duration(hours: 4)),
      location: 'Universidad de Guadalajara, Centro Histórico',
      organizer: 'Club de Debate UDG',
      maxParticipants: 50,
      currentParticipants: 32,
      category: 'debatePublico',
      topics: ['Educación', 'Tecnología', 'Futuro'],
      isOnline: false,
      status: 'upcoming',
    ),
    DebateEvent(
      id: '2',
      title: 'Taller de Argumentación AREAL',
      description: 'Aprende a estructurar argumentos sólidos usando la metodología AREAL (Afirmación, Razonamiento, Evidencia, Limitaciones).',
      startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
      endDate: DateTime.now().add(const Duration(days: 1, hours: 12)),
      location: 'Online',
      organizer: 'Argumenta Academy',
      maxParticipants: 30,
      currentParticipants: 18,
      category: 'workshop',
      topics: ['Argumentación', 'AREAL', 'Pensamiento Crítico'],
      isOnline: true,
      meetingLink: 'https://meet.google.com/abc-defg-hij',
      status: 'upcoming',
    ),
    DebateEvent(
      id: '3',
      title: 'Torneo Nacional de Debate 2024',
      description: 'El torneo más importante del año. Participa en competencias de debate en múltiples categorías y demuestra tus habilidades argumentativas.',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7, hours: 8)),
      location: 'Centro de Convenciones Guadalajara',
      organizer: 'Federación Mexicana de Debate',
      maxParticipants: 200,
      currentParticipants: 156,
      category: 'torneo',
      topics: ['Competencia', 'Torneo', 'Nacional'],
      isOnline: false,
      price: 150.0,
      status: 'upcoming',
      prizes: {
        'primerLugar': 'Trofeo + 10,000 MXN',
        'segundoLugar': 'Medalla + 5,000 MXN',
        'tercerLugar': 'Certificado + 2,500 MXN',
      },
    ),
    DebateEvent(
      id: '4',
      title: 'Conferencia: Inteligencia Artificial y Sociedad',
      description: 'Una conferencia magistral sobre el impacto de la IA en la sociedad moderna, seguida de un debate abierto con el público.',
      startDate: DateTime.now().add(const Duration(days: 3, hours: 18)),
      endDate: DateTime.now().add(const Duration(days: 3, hours: 20)),
      location: 'Auditorio Telmex',
      organizer: 'Tecnológico de Monterrey',
      maxParticipants: 300,
      currentParticipants: 287,
      category: 'conferencia',
      topics: ['IA', 'Sociedad', 'Tecnología'],
      isOnline: false,
      status: 'upcoming',
    ),
    DebateEvent(
      id: '5',
      title: 'Debate sobre la renta básica universal',
      description: 'Un debate estructurado sobre los pros y contras de implementar una renta básica universal en México.',
      startDate: DateTime.now().add(const Duration(days: 5, hours: 16)),
      endDate: DateTime.now().add(const Duration(days: 5, hours: 18)),
      location: 'Online',
      organizer: 'Debate México',
      maxParticipants: 40,
      currentParticipants: 25,
      category: 'debatePublico',
      topics: ['Economía', 'Política Social', 'Renta Básica'],
      isOnline: true,
      meetingLink: 'https://zoom.us/j/123456789',
      status: 'upcoming',
    ),
  ];

  List<DebateEvent> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.startDate, day);
    }).toList();
  }

  List<DebateEvent> get _todayEvents {
    return _getEventsForDay(DateTime.now());
  }

  List<DebateEvent> get _upcomingEvents {
    final now = DateTime.now();
    return _events
        .where((event) => event.startDate.isAfter(now) && event.isUpcoming)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Eventos',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showCreateEventDialog(),
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
            tooltip: 'Crear evento',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6C5CE7),
          unselectedLabelColor: const Color(0xFF636E72),
          indicatorColor: const Color(0xFF6C5CE7),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Calendario'),
            Tab(text: 'Hoy'),
            Tab(text: 'Próximos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarView(),
          _buildTodayView(),
          _buildUpcomingView(),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        // Calendario
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
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
          child: TableCalendar<DebateEvent>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Color(0xFF6C5CE7)),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF6C5CE7),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color(0xFF00B4DB),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color(0xFFFF6B6B),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color(0xFF6C5CE7),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Eventos del día seleccionado
        Expanded(
          child: _buildSelectedDayEvents(),
        ),
      ],
    );
  }

  Widget _buildSelectedDayEvents() {
    final selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());

    if (selectedEvents.isEmpty) {
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
                Icons.event_available_outlined,
                size: 48,
                color: const Color(0xFF6C5CE7).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay eventos este día',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        return _buildEventCard(selectedEvents[index], index);
      },
    );
  }

  Widget _buildTodayView() {
    if (_todayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF00B894).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.today_outlined,
                size: 48,
                color: const Color(0xFF00B894).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay eventos hoy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF636E72),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Revisa los próximos eventos!',
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
      itemCount: _todayEvents.length,
      itemBuilder: (context, index) {
        return _buildEventCard(_todayEvents[index], index);
      },
    );
  }

  Widget _buildUpcomingView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingEvents.length,
      itemBuilder: (context, index) {
        return _buildEventCard(_upcomingEvents[index], index);
      },
    );
  }

  Widget _buildEventCard(DebateEvent event, int index) {
    final category = EventCategory.values.firstWhere(
      (c) => c.name == event.category,
      orElse: () => EventCategory.otros,
    );

    return GestureDetector(
      onTap: () => _navigateToEvent(event),
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
            // Header del evento
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.event_rounded,
                    color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000),
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
                          color: Color(int.parse(category.color.substring(1), radix: 16) + 0xFF000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        event.organizer,
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
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Título del evento
            Text(
              event.title,
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
              event.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Información del evento
            Row(
              children: [
                _buildEventInfo(
                  icon: Icons.access_time_rounded,
                  text: '${event.formattedTime} - ${event.formattedDuration}',
                  color: const Color(0xFF6C5CE7),
                ),
                const SizedBox(width: 16),
                _buildEventInfo(
                  icon: event.isOnline ? Icons.videocam_rounded : Icons.location_on_rounded,
                  text: event.isOnline ? 'Online' : event.location,
                  color: event.isOnline ? const Color(0xFF00B894) : const Color(0xFFE17055),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Participantes y precio
            Row(
              children: [
                _buildEventInfo(
                  icon: Icons.people_rounded,
                  text: '${event.currentParticipants}/${event.maxParticipants}',
                  color: const Color(0xFF00B4DB),
                ),
                const Spacer(),
                if (event.price != null && event.price! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '\$${event.price!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00B894),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Gratis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Botón de registro
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: event.isFull ? null : () => _registerForEvent(event),
                style: FilledButton.styleFrom(
                  backgroundColor: event.isFull 
                      ? const Color(0xFF636E72)
                      : const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  event.isFull ? Icons.block_rounded : Icons.event_available_rounded,
                  size: 18,
                ),
                label: Text(
                  event.isFull ? 'Lleno' : 'Registrarse',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100).ms)
      .fadeIn(duration: 400.ms)
      .slideX(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildEventInfo({
    required IconData icon,
    required String text,
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
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _navigateToEvent(DebateEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: event),
      ),
    );
  }

  void _registerForEvent(DebateEvent event) {
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
              'Registrarse',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Confirmas tu registro para:',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C5CE7),
              ),
            ),
            const SizedBox(height: 16),
            if (event.price != null && event.price! > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD93D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFFD93D).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.payment_rounded,
                      color: Color(0xFFFFD93D),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Costo: \$${event.price!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
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
              _showRegistrationSuccess();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showRegistrationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Registro exitoso!'),
          ],
        ),
        backgroundColor: const Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Crear nuevo evento',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          '¿Qué tipo de evento quieres crear?',
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
                  builder: (context) => const CreateEventPage(),
                ),
              );
            },
            child: const Text('Crear evento'),
          ),
        ],
      ),
    );
  }
}