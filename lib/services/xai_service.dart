import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_models.dart';

class XAIService {
  XAIService._();
  static final XAIService instance = XAIService._();

  // IMPORTANTE: Cambia esta URL cuando despliegues en Render
  // Local: http://localhost:8000
  // Render: https://tu-app.onrender.com
  static const String _baseUrl = 'http://localhost:8000';
  
  // Timeout para peticiones
  static const Duration _timeout = Duration(seconds: 30);

  /// Envía mensaje al chatbot y recibe respuesta
  Future<ChatMessage> sendMessage({
    required List<ChatMessage> messages,
    String? topic,
    double temperature = 0.7,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/chat'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'messages': messages.map((m) => m.toApiMap()).toList(),
              'topic': topic,
              'temperature': temperature,
              'max_tokens': 500,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: data['response'],
          timestamp: DateTime.parse(data['timestamp']),
        );
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al enviar mensaje: $e');
    }
  }

  /// Evalúa un argumento y devuelve feedback estructurado
  Future<ArgumentEvaluation> evaluateArgument({
    required String argument,
    String? topic,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/evaluate'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'argument': argument,
              'topic': topic,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ArgumentEvaluation.fromMap(data);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al evaluar argumento: $e');
    }
  }

  /// Inicia un debate con argumento inicial de la IA
  Future<String> startDebate(String topic) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/start-debate?topic=${Uri.encodeComponent(topic)}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['opening_argument'];
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al iniciar debate: $e');
    }
  }

  /// Verifica si el backend está disponible
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

