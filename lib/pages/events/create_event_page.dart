import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/event_models.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizerController = TextEditingController();
  final _topicController = TextEditingController();
  
  EventCategory _selectedCategory = EventCategory.debatePublico;
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  int _maxParticipants = 50;
  double? _price;
  bool _isOnline = false;
  List<String> _topics = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _selectedStartTime = time;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2),
    );
    
    if (time != null) {
      setState(() {
        _selectedEndTime = time;
      });
    }
  }

  void _addTopic() {
    final topic = _topicController.text.trim();
    if (topic.isNotEmpty && !_topics.contains(topic)) {
      setState(() {
        _topics.add(topic);
        _topicController.clear();
      });
    }
  }

  void _removeTopic(String topic) {
    setState(() {
      _topics.remove(topic);
    });
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedStartTime == null || _selectedEndTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona fecha y horarios'),
            backgroundColor: Color(0xFFE17055),
          ),
        );
        return;
      }

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
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
              '¡Evento creado!',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: const Text(
          'Tu evento ha sido publicado exitosamente. Los usuarios ya pueden registrarse.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar dialog
              Navigator.of(context).pop(); // Volver a eventos
            },
            child: const Text('Ver evento'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Crear Evento',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _createEvent,
            child: const Text(
              'Publicar',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF6C5CE7),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del evento
              _buildSection(
                title: 'Título del evento',
                subtitle: 'Escribe un título claro y atractivo',
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Ej: Debate sobre el futuro de la educación',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es obligatorio';
                    }
                    if (value.trim().length < 10) {
                      return 'El título debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Categoría
              _buildSection(
                title: 'Categoría',
                subtitle: 'Selecciona el tipo de evento',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<EventCategory>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: EventCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Text(category.emoji, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 12),
                            Text(
                              category.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Fecha y hora
              _buildSection(
                title: 'Fecha y horario',
                subtitle: 'Selecciona cuándo se realizará el evento',
                child: Column(
                  children: [
                    // Fecha
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: const Color(0xFF6C5CE7),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDate != null 
                                    ? const Color(0xFF2D3436)
                                    : const Color(0xFF636E72),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _selectDate,
                            child: const Text('Seleccionar'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horarios
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: const Color(0xFF00B4DB),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedStartTime != null
                                        ? _selectedStartTime!.format(context)
                                        : 'Inicio',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedStartTime != null 
                                          ? const Color(0xFF2D3436)
                                          : const Color(0xFF636E72),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _selectStartTime,
                                  child: const Text('Inicio'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  color: const Color(0xFFE17055),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedEndTime != null
                                        ? _selectedEndTime!.format(context)
                                        : 'Fin',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedEndTime != null 
                                          ? const Color(0xFF2D3436)
                                          : const Color(0xFF636E72),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _selectEndTime,
                                  child: const Text('Fin'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Modalidad
              _buildSection(
                title: 'Modalidad',
                subtitle: '¿El evento será presencial u online?',
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isOnline = false),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isOnline ? Colors.white : const Color(0xFF6C5CE7).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isOnline ? const Color(0xFFE9ECEF) : const Color(0xFF6C5CE7),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: _isOnline ? const Color(0xFF636E72) : const Color(0xFF6C5CE7),
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Presencial',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isOnline ? const Color(0xFF636E72) : const Color(0xFF6C5CE7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isOnline = true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isOnline ? const Color(0xFF00B894).withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isOnline ? const Color(0xFF00B894) : const Color(0xFFE9ECEF),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.videocam_rounded,
                                color: _isOnline ? const Color(0xFF00B894) : const Color(0xFF636E72),
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Online',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isOnline ? const Color(0xFF00B894) : const Color(0xFF636E72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ubicación/Enlace
              _buildSection(
                title: _isOnline ? 'Enlace de la reunión' : 'Ubicación',
                subtitle: _isOnline ? 'URL de la videollamada' : 'Dirección del evento',
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: _isOnline 
                        ? 'https://meet.google.com/abc-defg-hij'
                        : 'Universidad de Guadalajara, Centro Histórico',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Descripción
              _buildSection(
                title: 'Descripción',
                subtitle: 'Explica los detalles del evento',
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe el evento, objetivos, formato, y cualquier información relevante...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    if (value.trim().length < 50) {
                      return 'La descripción debe tener al menos 50 caracteres';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Organizador
              _buildSection(
                title: 'Organizador',
                subtitle: '¿Quién organiza este evento?',
                child: TextFormField(
                  controller: _organizerController,
                  decoration: InputDecoration(
                    hintText: 'Ej: Club de Debate UDG',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El organizador es obligatorio';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Participantes máximos
              _buildSection(
                title: 'Participantes máximos',
                subtitle: '¿Cuántas personas pueden asistir?',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_rounded,
                            color: const Color(0xFF00B4DB),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Máximo de participantes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        value: _maxParticipants.toDouble(),
                        min: 10,
                        max: 500,
                        divisions: 49,
                        label: _maxParticipants.toString(),
                        onChanged: (value) {
                          setState(() {
                            _maxParticipants = value.round();
                          });
                        },
                        activeColor: const Color(0xFF00B4DB),
                      ),
                      Text(
                        '$_maxParticipants participantes',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Precio
              _buildSection(
                title: 'Precio',
                subtitle: '¿El evento tiene costo? (opcional)',
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$ ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    _price = double.tryParse(value);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Botón de crear
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _createEvent,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.event_rounded),
                  label: const Text(
                    'Crear Evento',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF636E72),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
