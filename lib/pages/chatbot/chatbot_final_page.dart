import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../models/chat_models.dart';
import '../../services/xai_service.dart';
import '../../services/user_stats_service.dart';
import '../../widgets/common/dialecta_card.dart';
import '../../widgets/common/dialecta_button.dart';
import '../../widgets/common/dialecta_animations.dart';
import '../../theme/app_theme.dart';

enum DebateStage {
  welcome,
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

class ChatbotFinalPage extends StatefulWidget {
  const ChatbotFinalPage({super.key});

  @override
  State<ChatbotFinalPage> createState() => _ChatbotFinalPageState();
}

class _ChatbotFinalPageState extends State<ChatbotFinalPage>
    with TickerProviderStateMixin {
  final _xaiService = XAIService.instance;
  final _statsService = UserStatsService.instance;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _pulseController;
  late AnimationController _motionController;
  late AnimationController _timerController;

  final _topics = const [
    'Uniformes escolares obligatorios',
    'Renta básica universal',
    'Prohibición de apps corta-videos en escuelas',
    'Impuesto a la riqueza',
    'Energía nuclear vs renovables',
    'Regulación de IA',
    'Legalización de la marihuana',
    'Trabajo remoto vs presencial',
    'Educación pública gratuita',
    'Control de armas',
  ];

  String _selectedTopic = 'Uniformes escolares obligatorios';
  String _currentMotion = '';
  UserStance? _userStance;
  DebateStage _currentStage = DebateStage.welcome;
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  int _turnCount = 0;
  int _streak = 0;
  int _totalXP = 0;
  int _timeRemaining = 300; // 5 minutos en segundos
  bool _isUserTurn = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _motionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: const Duration(seconds: 300),
      vsync: this,
    );
    
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    _motionController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.forward();
    _timerController.addListener(() {
      setState(() {
        _timeRemaining = (300 * (1 - _timerController.value)).round();
      });
    });
  }

  void _startDebate() async {
    setState(() {
      _isTyping = true;
      _currentStage = DebateStage.motionDisplay;
    });

    // Simular generación de moción
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _currentMotion = '¿Deberían ser obligatorios los uniformes escolares?';
      _isTyping = false;
    });
    
    _motionController.forward();
  }

  void _selectStance(UserStance stance) {
    setState(() {
      _userStance = stance;
      _currentStage = DebateStage.debateActive;
      _isUserTurn = true;
    });
    
    _addMessage('¡Debate iniciado!', isSystem: true);
  }

  void _addMessage(String content, {bool isSystem = false}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: isSystem ? MessageRole.assistant : MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _addMessage(text);
    _controller.clear();
    
    setState(() {
      _isUserTurn = false;
      _isTyping = true;
    });

    // Simular respuesta de IA
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isTyping = false;
      _isUserTurn = true;
      _turnCount++;
    });

    _addMessage('Esa es una perspectiva interesante. Sin embargo, consideremos el impacto en la individualidad de los estudiantes...', isSystem: true);
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Debate con IA'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: _buildCurrentStage(),
    );
  }

  Widget _buildCurrentStage() {
    switch (_currentStage) {
      case DebateStage.welcome:
        return _buildWelcomeStage();
      case DebateStage.topicSelection:
        return _buildTopicSelection();
      case DebateStage.motionDisplay:
        return _buildMotionDisplay();
      case DebateStage.stanceSelection:
        return _buildStanceSelection();
      case DebateStage.debateActive:
        return _buildDebateInterface();
      case DebateStage.debateCompleted:
        return _buildCompletedState();
      default:
        return _buildWelcomeStage();
    }
  }

  Widget _buildWelcomeStage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '¡Bienvenido al Debate con IA!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.charcoalBlack,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Desarrolla tus habilidades argumentativas debatiendo con inteligencia artificial',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.charcoalBlack.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            DialectaButton(
              text: '¡Sí, empecemos!',
              type: DialectaButtonType.primary,
              size: DialectaButtonSize.large,
              isFullWidth: true,
              onPressed: () {
                setState(() {
                  _currentStage = DebateStage.topicSelection;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige un tema de debate',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.charcoalBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                final isSelected = topic == _selectedTopic;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTopic = topic;
                      });
                    },
                    child: DialectaCard(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected ? Border.all(color: AppTheme.primaryBlue, width: 2) : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: isSelected ? AppTheme.primaryBlue : AppTheme.charcoalBlack.withOpacity(0.5),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                topic,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: isSelected ? AppTheme.primaryBlue : AppTheme.charcoalBlack,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          DialectaButton(
            text: 'Continuar',
            type: DialectaButtonType.primary,
            size: DialectaButtonSize.large,
            isFullWidth: true,
            onPressed: _startDebate,
          ),
        ],
      ),
    );
  }

  Widget _buildMotionDisplay() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isTyping) ...[
                  DialectaAnimations.loadingAnimation(
                    width: 60,
                    height: 60,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(height: 24),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Generando dilema...',
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoalBlack,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.gavel_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aquí tienes el dilema:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _motionController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _motionController.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _motionController.value)),
                                child: Text(
                                  _currentMotion,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!_isTyping) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: DialectaDebateButton(
                    text: 'PROS',
                    subtitle: 'A favor',
                    icon: Icons.thumb_up_rounded,
                    isPro: true,
                    onPressed: () => _selectStance(UserStance.pros),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DialectaDebateButton(
                    text: 'CONTRAS',
                    subtitle: 'En contra',
                    icon: Icons.thumb_down_rounded,
                    isPro: false,
                    onPressed: () => _selectStance(UserStance.contras),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver Pros',
                      style: TextStyle(
                        color: AppTheme.charcoalBlack.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver Contras',
                      style: TextStyle(
                        color: AppTheme.charcoalBlack.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStanceSelection() {
    return _buildMotionDisplay();
  }

  Widget _buildDebateInterface() {
    return Column(
      children: [
        _buildDebateHeader(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[index], index);
            },
          ),
        ),
        if (_isUserTurn) _buildMessageInput(),
      ],
    );
  }

  Widget _buildDebateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.charcoalBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Text(
              '¡Debate iniciado!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.charcoalBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildParticipantCard(
                    name: 'Tú',
                    isUser: true,
                    isActive: _isUserTurn,
                    status: _isUserTurn ? 'Tu turno' : 'Esperando',
                  ),
                ),
                const SizedBox(width: 16),
                _buildTimer(),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildParticipantCard(
                    name: 'IA',
                    isUser: false,
                    isActive: !_isUserTurn,
                    status: _isUserTurn ? 'Esperando' : 'Pensando...',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCard({
    required String name,
    required bool isUser,
    required bool isActive,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: AppTheme.primaryBlue, width: 2) : null,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isUser ? AppTheme.mintGreen : AppTheme.primaryBlue,
            child: Icon(
              isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.charcoalBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isActive ? AppTheme.primaryBlue : AppTheme.charcoalBlack.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.brightOrange,
        shape: BoxShape.circle,
      ),
      child: Text(
        _formatTime(_timeRemaining),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadow,
            ),
            child: DialectaAnimations.typingAnimation(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.role == MessageRole.user;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isUser 
                    ? AppTheme.primaryGradient
                    : null,
                color: isUser 
                    ? null
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.charcoalBlack,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.mintGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    ).animate(delay: (index * 100).ms)
        .fadeIn(duration: 400.ms)
        .slideX(
          begin: isUser ? 0.3 : -0.3,
          end: 0,
          curve: Curves.easeOut,
        );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.charcoalBlack.withOpacity(0.05),
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
                  fillColor: AppTheme.lightGray,
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
            DialectaButton(
              text: '',
              type: DialectaButtonType.primary,
              size: DialectaButtonSize.medium,
              icon: Icons.send_rounded,
              onPressed: _isTyping ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DialectaCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialectaAnimations.successAnimation(),
              const SizedBox(height: 24),
              Text(
                '¡Debate completado!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.charcoalBlack,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Has participado en un debate exitoso. ¡Bien hecho!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.charcoalBlack.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DialectaButton(
                text: 'Nuevo debate',
                type: DialectaButtonType.primary,
                size: DialectaButtonSize.large,
                isFullWidth: true,
                onPressed: () {
                  setState(() {
                    _currentStage = DebateStage.welcome;
                    _messages.clear();
                    _turnCount = 0;
                    _timeRemaining = 300;
                    _isUserTurn = true;
                  });
                  _timerController.reset();
                  _motionController.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
