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

class ChatbotPageV2 extends StatefulWidget {
  const ChatbotPageV2({super.key});

  @override
  State<ChatbotPageV2> createState() => _ChatbotPageV2State();
}

class _ChatbotPageV2State extends State<ChatbotPageV2>
    with TickerProviderStateMixin {
  final _xaiService = XAIService.instance;
  final _statsService = UserStatsService.instance;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _pulseController;
  late AnimationController _motionController;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    _motionController.dispose();
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
      _motionController.forward();
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
    _motionController.reset();
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
            Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.coralRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text(
          'Debate con IA',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isTyping && _currentStage == DebateStage.motionDisplay
          ? _buildLoadingState()
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildCurrentStage(),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DialectaAnimations.loadingAnimation(
            width: 80,
            height: 80,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 24),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Generando moción de debate...',
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.charcoalBlack,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            repeatForever: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStage() {
    switch (_currentStage) {
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
        return _buildTopicSelection();
    }
  }

  Widget _buildTopicSelection() {
    return DialectaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.topic_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecciona un tema',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.charcoalBlack,
                      ),
                    ),
                    Text(
                      'Elige el tema que quieres debatir',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.charcoalBlack.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedTopic,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 24),
          DialectaButton(
            text: 'Iniciar debate',
            type: DialectaButtonType.primary,
            size: DialectaButtonSize.large,
            isFullWidth: true,
            icon: Icons.play_arrow_rounded,
            onPressed: _startDebate,
          ),
        ],
      ),
    );
  }

  Widget _buildMotionDisplay() {
    return Column(
      children: [
        DialectaGradientCard(
          gradient: AppTheme.primaryGradient,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moción de debate',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Aquí tienes el dilema:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _motionController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _motionController.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _motionController.value)),
                        child: Text(
                          _currentMotion,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        DialectaCard(
          child: Column(
            children: [
              Text(
                '¿Cuál es tu postura?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.charcoalBlack,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDebateInterface() {
    return Column(
      children: [
        DialectaCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _userStance == UserStance.pros 
                      ? AppTheme.mintGreen
                      : AppTheme.coralRed,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _userStance == UserStance.pros 
                            ? AppTheme.mintGreen
                            : AppTheme.coralRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Turno: $_turnCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.charcoalBlack.withOpacity(0.7),
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
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return DialectaAnimations.typingAnimation();
              }
              return _buildMessageBubble(_messages[index], index);
            },
          ),
        ),
        _buildMessageInput(),
      ],
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
              'Has participado en 5 turnos de debate exitosamente.',
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
              onPressed: _resetDebate,
            ),
          ],
        ),
      ),
    );
  }

  void _showDebateCompleted() {
    // Implementar diálogo de completado
  }
}
