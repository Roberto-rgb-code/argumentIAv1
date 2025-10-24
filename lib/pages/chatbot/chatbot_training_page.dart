import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/m3/dialecta_m3_components.dart';
import '../../theme/app_theme.dart';
import '../../data/argumentation_theory.dart';
import '../../models/content_models.dart';

class ChatbotTrainingPage extends StatefulWidget {
  const ChatbotTrainingPage({super.key});

  @override
  State<ChatbotTrainingPage> createState() => _ChatbotTrainingPageState();
}

class _ChatbotTrainingPageState extends State<ChatbotTrainingPage> {
  int _selectedDifficulty = 0;
  String _selectedCategory = 'Todas';
  String _selectedType = 'Todas';
  List<DebateMotion> _filteredMotions = [];
  DebateMotion? _currentMotion;
  bool _isDebating = false;
  String _userStance = '';
  List<String> _userArguments = [];
  List<String> _botArguments = [];

  final List<String> _difficulties = ['Principiante', 'Intermedio', 'Avanzado'];
  final List<String> _categories = [
    'Todas', 'Política', 'Tecnología', 'Ciencia', 'Filosofía', 'Economía', 'Social'
  ];
  final List<String> _types = ['Todas', 'Policy', 'Value', 'Fact'];

  @override
  void initState() {
    super.initState();
    _filteredMotions = ArgumentationTheory.trainingMotions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Entrenamiento de Debate',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppTheme.primaryBlue,
        actions: [
          IconButton(
            onPressed: _showTheory,
            icon: const Icon(Icons.book_rounded),
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
      body: _isDebating ? _buildDebateInterface() : _buildMotionSelection(),
    );
  }

  Widget _buildMotionSelection() {
    return Column(
      children: [
        // Filtros
        _buildFilters(),
        
        // Lista de mociones
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredMotions.length,
            itemBuilder: (context, index) {
              final motion = _filteredMotions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DialectaM3Components.card(
                  onTap: () => _startDebate(motion),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header de la moción
                      Row(
                        children: [
                          // Tipo de moción
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getTypeColor(motion.type),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              motion.type,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Dificultad
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(motion.difficulty),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              motion.difficulty,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Categoría
                          Text(
                            motion.category,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Título de la moción
                      Text(
                        motion.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.charcoalBlack,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Descripción
                      Text(
                        motion.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.charcoalBlack.withOpacity(0.7),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Contexto
                      if (motion.context.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_rounded,
                                size: 16,
                                color: AppTheme.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  motion.context,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      // Argumentos clave
                      Text(
                        'Argumentos clave:',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoalBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: motion.keyArguments.take(3).map((arg) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGray,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              arg,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppTheme.charcoalBlack.withOpacity(0.7),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Dificultad
          Row(
            children: [
              Text(
                'Dificultad:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.charcoalBlack,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DialectaM3Components.segmentedControl(
                  options: _difficulties,
                  selectedIndex: _selectedDifficulty,
                  onSelectionChanged: (index) {
                    setState(() {
                      _selectedDifficulty = index;
                      _applyFilters();
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Categoría y Tipo
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                      _applyFilters();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      _applyFilters();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebateInterface() {
    return Column(
      children: [
        // Header del debate
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isDebating = false;
                        _currentMotion = null;
                        _userStance = '';
                        _userArguments.clear();
                        _botArguments.clear();
                      });
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppTheme.primaryBlue,
                  ),
                  Expanded(
                    child: Text(
                      'Debate en Curso',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.charcoalBlack,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentMotion?.title ?? '',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.charcoalBlack.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Selección de postura
        if (_userStance.isEmpty) _buildStanceSelection(),
        
        // Interface de debate
        if (_userStance.isNotEmpty) _buildDebateChat(),
      ],
    );
  }

  Widget _buildStanceSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Selecciona tu postura:',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoalBlack,
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: DialectaM3Components.filledButton(
                  text: 'A FAVOR',
                  onPressed: () {
                    setState(() {
                      _userStance = 'A FAVOR';
                      _botArguments = _generateBotArguments('EN CONTRA');
                    });
                    _startDebateChat();
                  }),
                  backgroundColor: AppTheme.mintGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DialectaM3Components.filledButton(
                  text: 'EN CONTRA',
                  onPressed: () {
                    setState(() {
                      _userStance = 'EN CONTRA';
                      _botArguments = _generateBotArguments('A FAVOR');
                    });
                    _startDebateChat();
                  }),
                  backgroundColor: AppTheme.coralRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebateChat() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Información del debate
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tu postura: $_userStance | Bot: ${_userStance == 'A FAVOR' ? 'EN CONTRA' : 'A FAVOR'}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Chat del debate
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    // Header del chat
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_rounded,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Debate en Tiempo Real',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Mensajes del debate
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _userArguments.length + _botArguments.length,
                        itemBuilder: (context, index) {
                          if (index < _userArguments.length) {
                            return _buildUserMessage(_userArguments[index]);
                          } else {
                            return _buildBotMessage(_botArguments[index - _userArguments.length]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: DialectaM3Components.outlinedButton(
                    text: 'Nuevo Argumento',
                    onPressed: _addNewArgument,
                    icon: Icons.add_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DialectaM3Components.filledButton(
                    text: 'Finalizar Debate',
                    onPressed: _endDebate,
                    icon: Icons.check_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.charcoalBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredMotions = ArgumentationTheory.trainingMotions.where((motion) {
        bool difficultyMatch = _selectedDifficulty == 0 || 
          _difficulties[_selectedDifficulty].toLowerCase() == motion.difficulty.toLowerCase();
        bool categoryMatch = _selectedCategory == 'Todas' || motion.category == _selectedCategory;
        bool typeMatch = _selectedType == 'Todas' || motion.type == _selectedType;
        
        return difficultyMatch && categoryMatch && typeMatch;
      }).toList();
    });
  }

  void _startDebate(DebateMotion motion) {
    setState(() {
      _currentMotion = motion;
      _isDebating = true;
      _userStance = '';
      _userArguments.clear();
      _botArguments.clear();
    });
  }

  void _startDebateChat() {
    // Agregar mensaje inicial del bot
    _botArguments.add('Hola! Estoy listo para debatir. ¿Cuál es tu primer argumento?');
  }

  List<String> _generateBotArguments(String stance) {
    if (_currentMotion == null) return [];
    
    List<String> arguments = [];
    
    if (stance == 'A FAVOR') {
      arguments.addAll(_currentMotion!.keyArguments.take(3));
    } else {
      // Generar argumentos en contra basados en los argumentos a favor
      arguments.add('Hay evidencia contradictoria que no se está considerando');
      arguments.add('Los costos superan los beneficios propuestos');
      arguments.add('Existen alternativas más efectivas');
    }
    
    return arguments;
  }

  void _addNewArgument() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Nuevo Argumento',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        content: DialectaM3Components.textField(
          label: 'Tu argumento',
          hint: 'Escribe tu argumento aquí...',
          controller: TextEditingController(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              // Agregar argumento del usuario
              _userArguments.add('Argumento del usuario');
              // Agregar respuesta del bot
              _botArguments.add('Interesante punto. Sin embargo, considero que...');
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _endDebate() {
    showDialog(
      context: context,
      builder: (context) => DialectaM3Components.alertDialog(
        title: 'Finalizar Debate',
        content: '¿Estás seguro de que quieres finalizar este debate?',
        confirmText: 'Sí, finalizar',
        cancelText: 'Continuar',
        onConfirm: () {
          Navigator.pop(context);
          setState(() {
            _isDebating = false;
            _currentMotion = null;
            _userStance = '';
            _userArguments.clear();
            _botArguments.clear();
          });
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showTheory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Teoría de Argumentación',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.charcoalBlack,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTheorySection('Fundamentos', ArgumentationTheory.argumentationTheory),
              _buildTheorySection('Refutación', ArgumentationTheory.refutationTechniques),
              _buildTheorySection('Mociones', ArgumentationTheory.motionTypes),
              _buildTheorySection('Falacias', ArgumentationTheory.fallacyTypes),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTheorySection(String title, List<TheorySection> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        ...sections.map((section) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '• ${section.title}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.charcoalBlack,
            ),
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Policy': return AppTheme.primaryBlue;
      case 'Value': return AppTheme.mintGreen;
      case 'Fact': return AppTheme.brightOrange;
      default: return AppTheme.lightGray;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return AppTheme.mintGreen;
      case 'intermediate': return AppTheme.brightOrange;
      case 'advanced': return AppTheme.coralRed;
      default: return AppTheme.lightGray;
    }
  }
}
