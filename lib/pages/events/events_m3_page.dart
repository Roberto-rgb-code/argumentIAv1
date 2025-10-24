import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/m3/dialecta_m3_components.dart';
import '../../theme/app_theme.dart';
import '../../models/event_models.dart';

class EventsM3Page extends StatefulWidget {
  const EventsM3Page({super.key});

  @override
  State<EventsM3Page> createState() => _EventsM3PageState();
}

class _EventsM3PageState extends State<EventsM3Page> with TickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Event> _events = [
    Event(
      id: '1',
      title: 'Torneo Nacional de Debate',
      description: 'Competencia de debate para estudiantes universitarios',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Universidad Central',
      maxParticipants: 50,
      organizerId: 'org1',
      organizerName: 'Asociación de Debate',
      participants: [],
      prizes: [
        Prize(
          position: 1,
          title: 'Primer Lugar',
          description: 'Beca completa + Trofeo',
          value: 'Beca completa',
        ),
      ],
      rules: ['Edad mínima 18 años', 'Preparación previa requerida'],
      status: EventStatus.upcoming,
    ),
    Event(
      id: '2',
      title: 'Workshop de Pensamiento Crítico',
      description: 'Taller práctico sobre técnicas de argumentación',
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'Centro Cultural',
      maxParticipants: 30,
      organizerId: 'org2',
      organizerName: 'Instituto Dialecta',
      participants: [],
      prizes: [],
      rules: ['Inscripción gratuita', 'Material incluido'],
      status: EventStatus.upcoming,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Eventos',
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
              // Crear evento
              _createEvent();
            },
            icon: const Icon(Icons.add_rounded),
            color: AppTheme.primaryBlue,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Lista',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Calendario',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          indicatorColor: AppTheme.primaryBlue,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.charcoalBlack.withOpacity(0.6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(),
          _buildCalendarView(),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DialectaM3Components.card(
            onTap: () {
              _navigateToEventDetail(event);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del evento
                Row(
                  children: [
                    // Icono del evento
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event_rounded,
                        color: AppTheme.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.charcoalBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 16,
                                color: AppTheme.primaryBlue.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.location,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.primaryBlue.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Chip de estado
                    DialectaM3Components.chip(
                      label: _getStatusText(event.status),
                      selected: event.status == EventStatus.upcoming,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Descripción
                Text(
                  event.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.charcoalBlack.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Información del evento
                Row(
                  children: [
                    // Fecha
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(event.date),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.primaryBlue.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Participantes
                    Icon(
                      Icons.people_rounded,
                      size: 16,
                      color: AppTheme.primaryBlue.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.participants.length}/${event.maxParticipants}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.primaryBlue.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Premios
                if (event.prizes.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 16,
                        color: AppTheme.primaryBlue.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${event.prizes.length} premio${event.prizes.length > 1 ? 's' : ''}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.primaryBlue.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Acciones
                Row(
                  children: [
                    Expanded(
                      child: DialectaM3Components.outlinedButton(
                        text: 'Ver Detalles',
                        onPressed: () {
                          _navigateToEventDetail(event);
                        },
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DialectaM3Components.filledButton(
                        text: 'Registrarse',
                        onPressed: () {
                          _registerForEvent(event);
                        },
                        icon: Icons.person_add_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        // Calendario
        DialectaM3Components.card(
          margin: const EdgeInsets.all(16),
          child: TableCalendar<Event>(
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
            eventLoader: (day) {
              return _events.where((event) {
                return isSameDay(event.date, day);
              }).toList();
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              defaultTextStyle: GoogleFonts.inter(
                color: AppTheme.charcoalBlack,
              ),
              selectedTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              todayTextStyle: GoogleFonts.inter(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              formatButtonTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              titleTextStyle: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.charcoalBlack,
              ),
            ),
          ),
        ),

        // Eventos del día seleccionado
        if (_selectedDay != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Eventos del ${_formatDate(_selectedDay!)}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.charcoalBlack,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getEventsForDay(_selectedDay!).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay!)[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DialectaM3Components.listTile(
                    title: event.title,
                    subtitle: '${event.location} • ${_formatTime(event.date)}',
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.event_rounded,
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                    ),
                    trailing: DialectaM3Components.filledButton(
                      text: 'Ver',
                      onPressed: () {
                        _navigateToEventDetail(event);
                      },
                    ),
                    onTap: () {
                      _navigateToEventDetail(event);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  void _navigateToEventDetail(Event event) {
    // Navegar al detalle del evento
    Navigator.pushNamed(context, '/event-detail', arguments: event);
  }

  void _registerForEvent(Event event) {
    // Implementar registro
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Te registraste en "${event.title}"'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _createEvent() {
    // Navegar a crear evento
    Navigator.pushNamed(context, '/create-event');
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'Próximo';
      case EventStatus.ongoing:
        return 'En curso';
      case EventStatus.completed:
        return 'Finalizado';
      case EventStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
