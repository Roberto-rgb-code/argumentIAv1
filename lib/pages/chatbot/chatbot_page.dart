import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/chat_models.dart';
import '../../services/xai_service.dart';
import '../../services/user_stats_service.dart';
import '../../widgets/message_bubble.dart';

enum DebateStage {
  topicSelection,
  motionDisplay,
  stanceSelection,
  debateActive,
  debateCompleted,
}

enum UserStance {
  pros,
  contras,
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _xaiService = XAIService.instance;
  final _statsService = UserStatsService.instance;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final _topics = const [
    'Renta básica universal',
    'Prohibición de apps corta-videos en escuelas',
    'Impuesto a la riqueza',
    'Energía nuclear vs renovables',
    'Regulación de IA',
    'Uniformes escolares obligatorios',
    'Legalización de la marihuana',
    'Trabajo remoto vs presencial',
    'Educación pública gratuita',
    'Control de armas',
  ];

  String _selectedTopic = 'Renta básica universal';
  String _currentMotion = '';
  UserStance? _userStance;
  DebateStage _currentStage = DebateStage.topicSelection;
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  int _turnCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startDebate() async {
    setState(() {
      _isTyping = true;
      _currentStage = DebateStage.motionDisplay;
    });

    try {
      final motion = await _xaiService.startDebate(_selectedTopic);
      setState(() {
        _currentMotion = motion;
        _isTyping = false;
      });
    } catch (e) {
      setState(() => _isTyping = false);
      _showError('Error al generar moción: $e');
    }
  }

  void _selectStance(UserStance stance) {
    setState(() {
      _userStance = stance;
      _currentStage = DebateStage.debateActive;
    });
    
    // Iniciar el debate con la postura seleccionada
    _sendInitialArgument();
  }

  Future<void> _sendInitialArgument() async {
    final stanceText = _userStance == UserStance.pros ? 'A favor' : 'En contra';
    
    final initialMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: 'He elegido estar $stanceText de la moción: "$_currentMotion". ¡Empecemos el debate!',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(initialMessage);
      _isTyping = true;
      _turnCount++;
    });

    _scrollToBottom();

    try {
      final response = await _xaiService.sendMessage(
        messages: _messages,
        topic: _selectedTopic,
      );

      setState(() {
        _messages.add(response);
        _isTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() => _isTyping = false);
      _showError('Error: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
      _turnCount++;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _xaiService.sendMessage(
        messages: _messages,
        topic: _selectedTopic,
      );

      setState(() {
        _messages.add(response);
        _isTyping = false;
      });

      _scrollToBottom();

      // Verificar si el debate debe terminar
      final userTurns = _messages.where((m) => m.role == MessageRole.user).length;
      if (userTurns >= 5) {
        _completeDebate();
      }
    } catch (e) {
      setState(() => _isTyping = false);
      _showError('Error: $e');
    }
  }

  Future<void> _completeDebate() async {
    await _statsService.rewardDebateCompleted(score: 85);
    
    setState(() {
      _currentStage = DebateStage.debateCompleted;
    });
    
    _showDebateCompleted();
  }

  void _resetDebate() {
    setState(() {
      _currentStage = DebateStage.topicSelection;
      _currentMotion = '';
      _userStance = null;
      _messages = [];
      _turnCount = 0;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _showDebateCompleted() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              '¡Debate completado!',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Has participado en 5 turnos de debate.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text(
                    '🎉 Recompensas obtenidas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• +15 Tokens\n• +50 XP\n• Racha actualizada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetDebate();
            },
            child: const Text('Nuevo debate'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicSelection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.topic_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Selecciona un tema',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedTopic,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: _topics
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTopic = v!),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _startDebate,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Iniciar debate',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotionDisplay() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Moción de debate',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8F9FF), Color(0xFFE8F2FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6C5CE7).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              _currentMotion,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¿Cuál es tu postura?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF636E72),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStanceButton(
                  stance: UserStance.pros,
                  icon: Icons.thumb_up_rounded,
                  color: const Color(0xFF00B894),
                  text: 'PROS',
                  subtitle: 'A favor',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStanceButton(
                  stance: UserStance.contras,
                  icon: Icons.thumb_down_rounded,
                  color: const Color(0xFFE17055),
                  text: 'CONTRAS',
                  subtitle: 'En contra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStanceButton({
    required UserStance stance,
    required IconData icon,
    required Color color,
    required String text,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () => _selectStance(stance),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebateInterface() {
    return Column(
      children: [
        // Header del debate
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _userStance == UserStance.pros 
                    ? const Color(0xFF00B894).withOpacity(0.1)
                    : const Color(0xFFE17055).withOpacity(0.1),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _userStance == UserStance.pros 
                  ? const Color(0xFF00B894).withOpacity(0.3)
                  : const Color(0xFFE17055).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _userStance == UserStance.pros 
                      ? const Color(0xFF00B894)
                      : const Color(0xFFE17055),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _userStance == UserStance.pros 
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_down_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Postura: ${_userStance == UserStance.pros ? 'PROS' : 'CONTRAS'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _userStance == UserStance.pros 
                            ? const Color(0xFF00B894)
                            : const Color(0xFFE17055),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Turno: $_turnCount',
                      style: const TextStyle(
                        color: Color(0xFF636E72),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _resetDebate,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Reiniciar debate',
              ),
            ],
          ),
        ),

        // Lista de mensajes
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return const TypingIndicator();
              }
              return MessageBubble(message: _messages[index]);
            },
          ),
        ),

        // Input de mensaje
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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
                    onSubmitted: (_) => _sendMessage(),
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
                    onPressed: _isTyping ? null : _sendMessage,
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Debate con IA',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isTyping && _currentStage == DebateStage.motionDisplay
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF6C5CE7),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Generando moción...',
                    style: TextStyle(
                      color: Color(0xFF636E72),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentStage == DebateStage.topicSelection
                  ? _buildTopicSelection()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOut)
                  : _currentStage == DebateStage.motionDisplay
                      ? _buildMotionDisplay()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, curve: Curves.easeOut)
                      : _buildDebateInterface(),
            ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF00B4DB)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'IA está escribiendo...',
            style: TextStyle(
              color: Color(0xFF636E72),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: const Color(0xFF6C5CE7).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}