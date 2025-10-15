import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/lesson_models.dart';

class ExercisePage extends StatefulWidget {
  final Lesson lesson;
  final int exerciseIndex;
  final Function(int) onExerciseCompleted;
  final VoidCallback onLessonCompleted;

  const ExercisePage({
    super.key,
    required this.lesson,
    required this.exerciseIndex,
    required this.onExerciseCompleted,
    required this.onLessonCompleted,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late Exercise _currentExercise;
  List<String> _userAnswers = [];
  bool _showHint = false;
  bool _showResult = false;
  bool _isCorrect = false;
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentExercise = widget.lesson.exercises[widget.exerciseIndex];
  }

  void _submitAnswer() {
    setState(() {
      _showResult = true;
      _isCorrect = _checkAnswer();
    });

    // Mostrar resultado por 2 segundos antes de continuar
    Future.delayed(const Duration(seconds: 2), () {
      if (widget.exerciseIndex < widget.lesson.exercises.length - 1) {
        widget.onExerciseCompleted(widget.exerciseIndex);
        Navigator.of(context).pop();
      } else {
        widget.onLessonCompleted();
        Navigator.of(context).pop();
      }
    });
  }

  bool _checkAnswer() {
    if (_currentExercise.type == ExerciseType.multipleChoice) {
      if (_userAnswers.isEmpty) return false;
      return _currentExercise.correctAnswers.contains(_userAnswers.first);
    } else if (_currentExercise.type == ExerciseType.textInput) {
      if (_userAnswers.isEmpty) return false;
      final userAnswer = _userAnswers.first.toLowerCase().trim();
      return _currentExercise.correctAnswers.any((correct) =>
          correct.toLowerCase().trim() == userAnswer);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.exerciseIndex + 1) / widget.lesson.exercises.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Ejercicio ${widget.exerciseIndex + 1} de ${widget.lesson.exercises.length}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (_currentExercise.hint != null)
            IconButton(
              onPressed: () => setState(() => _showHint = !_showHint),
              icon: Icon(
                _showHint ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                color: _showHint ? const Color(0xFFFFD93D) : const Color(0xFF636E72),
              ),
              tooltip: 'Mostrar pista',
            ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progreso
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF636E72),
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE9ECEF),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000),
                  ),
                  minHeight: 6,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header del ejercicio
                  Container(
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.lesson.type.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.lesson.type.displayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _currentExercise.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D3436),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B894).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_currentExercise.points} pts',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF00B894),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentExercise.instruction,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF636E72),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pista (si está disponible)
                  if (_showHint && _currentExercise.hint != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD93D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD93D).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: const Color(0xFFFFD93D),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _currentExercise.hint!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2D3436),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_showHint && _currentExercise.hint != null)
                    const SizedBox(height: 16),

                  // Contenido del ejercicio
                  _buildExerciseContent(),

                  const SizedBox(height: 24),

                  // Botón de enviar
                  if (!_showResult)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _userAnswers.isNotEmpty ? _submitAnswer : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text(
                          'Enviar respuesta',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  // Resultado
                  if (_showResult) _buildResult(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent() {
    switch (_currentExercise.type) {
      case ExerciseType.multipleChoice:
        return _buildMultipleChoice();
      case ExerciseType.textInput:
        return _buildTextInput();
      default:
        return const Text('Tipo de ejercicio no soportado');
    }
  }

  Widget _buildMultipleChoice() {
    final options = _currentExercise.content['options'] as List<String>? ?? [];
    final question = _currentExercise.content['question'] as String? ?? '';
    final argument = _currentExercise.content['argument'] as String?;

    return Container(
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
          if (argument != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE9ECEF),
                ),
              ),
              child: Text(
                'Argumento: $argument',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF636E72),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _userAnswers.contains(index.toString());

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _userAnswers = [index.toString()];
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000)
                          : const Color(0xFFE9ECEF),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000)
                                : const Color(0xFF636E72),
                            width: 2,
                          ),
                          color: isSelected
                              ? Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Color(int.parse(widget.lesson.type.color.substring(1), radix: 16) + 0xFF000000)
                                : const Color(0xFF2D3436),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
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
          const Text(
            'Tu respuesta:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Escribe tu respuesta aquí...',
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              setState(() {
                _userAnswers = [value];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final timeSpent = DateTime.now().difference(_startTime);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isCorrect 
            ? const Color(0xFF00B894).withOpacity(0.1)
            : const Color(0xFFE17055).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isCorrect 
              ? const Color(0xFF00B894)
              : const Color(0xFFE17055),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: _isCorrect ? const Color(0xFF00B894) : const Color(0xFFE17055),
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCorrect ? '¡Correcto!' : 'Incorrecto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _isCorrect ? const Color(0xFF00B894) : const Color(0xFFE17055),
                      ),
                    ),
                    Text(
                      'Tiempo: ${timeSpent.inSeconds}s',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isCorrect 
                      ? const Color(0xFF00B894).withOpacity(0.2)
                      : const Color(0xFFE17055).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isCorrect ? '+${_currentExercise.points} pts' : '0 pts',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isCorrect ? const Color(0xFF00B894) : const Color(0xFFE17055),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_currentExercise.explanation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: const Color(0xFFFFD93D),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentExercise.explanation!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3436),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
