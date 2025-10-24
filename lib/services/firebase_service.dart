import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/forum_models.dart';
import '../models/event_models.dart';
import '../models/university_user.dart';
import '../config/firebase_config.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Usar la configuración centralizada
  FirebaseFirestore get _firestore => FirebaseConfig.firestore;
  FirebaseStorage get _storage => FirebaseConfig.storage;
  FirebaseAuth get _auth => FirebaseConfig.auth;

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

  // === USUARIOS UNIVERSITARIOS ===

  // Crear usuario universitario
  Future<String> createUniversityUser({
    required String email,
    required String displayName,
    required String university,
    required String career,
    required String studentId,
    required int semester,
    List<String>? interests,
    String? bio,
    String? linkedinUrl,
    String? githubUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final universityUser = UniversityUser(
        id: user.uid,
        email: email,
        displayName: displayName,
        university: university,
        career: career,
        studentId: studentId,
        semester: semester,
        interests: interests ?? [],
        bio: bio,
        linkedinUrl: linkedinUrl,
        githubUrl: githubUrl,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        stats: {
          'totalDebates': 0,
          'totalEvents': 0,
          'totalVotes': 0,
          'totalComments': 0,
          'xp': 0,
          'streak': 0,
        },
      );

      await _firestore.collection('users').doc(user.uid).set(
        universityUser.toFirestore(),
      );

      return user.uid;
    } catch (e) {
      throw Exception('Error al crear usuario universitario: $e');
    }
  }

  // Obtener usuario universitario
  Future<UniversityUser?> getUniversityUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UniversityUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  // Obtener usuario actual
  Future<UniversityUser?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return await getUniversityUser(user.uid);
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }

  // Actualizar perfil universitario
  Future<void> updateUniversityProfile({
    String? displayName,
    String? university,
    String? career,
    String? studentId,
    int? semester,
    List<String>? interests,
    String? bio,
    String? linkedinUrl,
    String? githubUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (university != null) updateData['university'] = university;
      if (career != null) updateData['career'] = career;
      if (studentId != null) updateData['studentId'] = studentId;
      if (semester != null) updateData['semester'] = semester;
      if (interests != null) updateData['interests'] = interests;
      if (bio != null) updateData['bio'] = bio;
      if (linkedinUrl != null) updateData['linkedinUrl'] = linkedinUrl;
      if (githubUrl != null) updateData['githubUrl'] = githubUrl;

      updateData['lastActive'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.uid).update(updateData);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  // Subir imagen de perfil
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Actualizar URL en el perfil
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
        'lastActive': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir imagen de perfil: $e');
    }
  }

  // Actualizar estadísticas del usuario
  Future<void> updateUserStats({
    int? totalDebates,
    int? totalEvents,
    int? totalVotes,
    int? totalComments,
    int? xp,
    int? streak,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final updateData = <String, dynamic>{};
      if (totalDebates != null) updateData['stats.totalDebates'] = FieldValue.increment(totalDebates);
      if (totalEvents != null) updateData['stats.totalEvents'] = FieldValue.increment(totalEvents);
      if (totalVotes != null) updateData['stats.totalVotes'] = FieldValue.increment(totalVotes);
      if (totalComments != null) updateData['stats.totalComments'] = FieldValue.increment(totalComments);
      if (xp != null) updateData['stats.xp'] = FieldValue.increment(xp);
      if (streak != null) updateData['stats.streak'] = streak;

      updateData['lastActive'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.uid).update(updateData);
    } catch (e) {
      throw Exception('Error al actualizar estadísticas: $e');
    }
  }

  // Obtener ranking de usuarios
  Stream<List<UniversityUser>> getUsersRanking({int limit = 10}) {
    return _firestore
        .collection('users')
        .orderBy('stats.xp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UniversityUser.fromFirestore(doc)).toList();
    });
  }

  // Buscar usuarios por universidad
  Stream<List<UniversityUser>> getUsersByUniversity(String university) {
    return _firestore
        .collection('users')
        .where('university', isEqualTo: university)
        .orderBy('stats.xp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UniversityUser.fromFirestore(doc)).toList();
    });
  }

  // Buscar usuarios por carrera
  Stream<List<UniversityUser>> getUsersByCareer(String career) {
    return _firestore
        .collection('users')
        .where('career', isEqualTo: career)
        .orderBy('stats.xp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UniversityUser.fromFirestore(doc)).toList();
    });
  }

  // Verificar si el usuario existe
  Future<bool> userExists(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Eliminar usuario
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      // Eliminar datos del usuario
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Eliminar imagen de perfil si existe
      try {
        final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
        await ref.delete();
      } catch (e) {
        // La imagen puede no existir
      }

      // Eliminar cuenta de Firebase Auth
      await user.delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }
}

