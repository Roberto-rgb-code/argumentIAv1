import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/forum_models.dart';
import '../models/event_models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // === FOROS ===
  
  // Crear nuevo debate
  Future<String> createDebate(DebateTopic debate) async {
    try {
      final docRef = await _firestore.collection('debates').add({
        'title': debate.title,
        'description': debate.description,
        'category': debate.category,
        'authorId': debate.authorId,
        'authorName': debate.authorName,
        'votes': debate.votes,
        'comments': debate.comments,
        'createdAt': debate.createdAt.toIso8601String(),
        'tags': debate.tags,
        'isActive': debate.isActive,
        'participants': [],
        'lastActivity': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear debate: $e');
    }
  }

  // Obtener debates
  Stream<List<DebateTopic>> getDebates({String? category}) {
    Query query = _firestore.collection('debates')
        .where('isActive', isEqualTo: true)
        .orderBy('lastActivity', descending: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DebateTopic(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          votes: data['votes'] ?? 0,
          comments: data['comments'] ?? 0,
          createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
          authorId: data['authorId'] ?? '',
          authorName: data['authorName'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
          isActive: data['isActive'] ?? true,
        );
      }).toList();
    });
  }

  // Votar en debate
  Future<void> voteDebate(String debateId, bool isUpvote) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final debateRef = _firestore.collection('debates').doc(debateId);
      final voteRef = _firestore.collection('votes').doc('${user.uid}_$debateId');

      await _firestore.runTransaction((transaction) async {
        final voteDoc = await transaction.get(voteRef);
        final debateDoc = await transaction.get(debateRef);

        if (!debateDoc.exists) throw Exception('Debate no encontrado');

        int voteChange = 0;
        if (voteDoc.exists) {
          final existingVote = voteDoc.data()!['isUpvote'] as bool;
          if (existingVote == isUpvote) {
            // Mismo voto, eliminar
            transaction.delete(voteRef);
            voteChange = existingVote ? -1 : 1;
          } else {
            // Voto diferente, cambiar
            transaction.set(voteRef, {
              'userId': user.uid,
              'debateId': debateId,
              'isUpvote': isUpvote,
              'timestamp': FieldValue.serverTimestamp(),
            });
            voteChange = isUpvote ? 2 : -2;
          }
        } else {
          // Nuevo voto
          transaction.set(voteRef, {
            'userId': user.uid,
            'debateId': debateId,
            'isUpvote': isUpvote,
            'timestamp': FieldValue.serverTimestamp(),
          });
          voteChange = isUpvote ? 1 : -1;
        }

        final currentVotes = (debateDoc.data()!['votes'] as int) ?? 0;
        transaction.update(debateRef, {
          'votes': currentVotes + voteChange,
          'lastActivity': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw Exception('Error al votar: $e');
    }
  }

  // Comentar en debate
  Future<void> addComment(String debateId, String content) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      await _firestore.collection('comments').add({
        'debateId': debateId,
        'userId': user.uid,
        'userName': user.displayName ?? 'Usuario',
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar contador de comentarios
      await _firestore.collection('debates').doc(debateId).update({
        'comments': FieldValue.increment(1),
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al comentar: $e');
    }
  }

  // === EVENTOS ===

  // Crear evento
  Future<String> createEvent(Event event) async {
    try {
      final docRef = await _firestore.collection('events').add({
        'title': event.title,
        'description': event.description,
        'date': event.date.toIso8601String(),
        'location': event.location,
        'maxParticipants': event.maxParticipants,
        'organizerId': event.organizerId,
        'organizerName': event.organizerName,
        'participants': [],
        'prizes': event.prizes.map((p) => p.toMap()).toList(),
        'rules': event.rules,
        'status': event.status.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  // Obtener eventos
  Stream<List<Event>> getEvents({EventStatus? status}) {
    Query query = _firestore.collection('events')
        .orderBy('date', descending: false);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
          location: data['location'] ?? '',
          maxParticipants: data['maxParticipants'] ?? 0,
          organizerId: data['organizerId'] ?? '',
          organizerName: data['organizerName'] ?? '',
          participants: List<Participant>.from(
            (data['participants'] ?? []).map((p) => Participant.fromMap(p))
          ),
          prizes: List<Prize>.from(
            (data['prizes'] ?? []).map((p) => Prize.fromMap(p))
          ),
          rules: List<String>.from(data['rules'] ?? []),
          status: EventStatus.values.firstWhere(
            (s) => s.name == data['status'],
            orElse: () => EventStatus.upcoming,
          ),
        );
      }).toList();
    });
  }

  // Registrarse en evento
  Future<void> registerForEvent(String eventId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final eventRef = _firestore.collection('events').doc(eventId);
      
      await _firestore.runTransaction((transaction) async {
        final eventDoc = await transaction.get(eventRef);
        if (!eventDoc.exists) throw Exception('Evento no encontrado');

        final participants = List<Map<String, dynamic>>.from(
          eventDoc.data()!['participants'] ?? []
        );

        // Verificar si ya está registrado
        if (participants.any((p) => p['userId'] == user.uid)) {
          throw Exception('Ya estás registrado en este evento');
        }

        // Verificar capacidad
        final maxParticipants = eventDoc.data()!['maxParticipants'] as int;
        if (participants.length >= maxParticipants) {
          throw Exception('Evento lleno');
        }

        // Agregar participante
        participants.add({
          'userId': user.uid,
          'userName': user.displayName ?? 'Usuario',
          'registeredAt': FieldValue.serverTimestamp(),
        });

        transaction.update(eventRef, {
          'participants': participants,
        });
      });
    } catch (e) {
      throw Exception('Error al registrarse: $e');
    }
  }

  // === USUARIOS ===

  // Actualizar perfil de usuario
  Future<void> updateUserProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final userData = <String, dynamic>{};
      if (displayName != null) userData['displayName'] = displayName;
      if (bio != null) userData['bio'] = bio;
      if (avatarUrl != null) userData['avatarUrl'] = avatarUrl;

      userData['lastUpdated'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  // Obtener perfil de usuario
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // === STORAGE ===

  // Subir imagen
  Future<String> uploadImage(String path, List<int> imageBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  // Eliminar imagen
  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Error al eliminar imagen: $e');
    }
  }
}

