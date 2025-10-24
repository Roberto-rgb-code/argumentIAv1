import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;
  static FirebaseAuth? _auth;

  // Inicializar Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    _auth = FirebaseAuth.instance;
  }

  // Getters para las instancias
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Firebase no inicializado. Llama a FirebaseConfig.initialize() primero.');
    }
    return _firestore!;
  }

  static FirebaseStorage get storage {
    if (_storage == null) {
      throw Exception('Firebase no inicializado. Llama a FirebaseConfig.initialize() primero.');
    }
    return _storage!;
  }

  static FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception('Firebase no inicializado. Llama a FirebaseConfig.initialize() primero.');
    }
    return _auth!;
  }

  // Configuración de Firestore
  static void configureFirestore() {
    // Configurar settings para desarrollo
    _firestore?.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Configurar reglas de seguridad (para desarrollo)
  static Map<String, dynamic> getSecurityRules() {
    return {
      'rules': {
        'users': {
          '\$uid': {
            '.read': 'auth != null && auth.uid == \$uid',
            '.write': 'auth != null && auth.uid == \$uid',
          }
        },
        'debates': {
          '.read': 'auth != null',
          '.write': 'auth != null',
        },
        'events': {
          '.read': 'auth != null',
          '.write': 'auth != null',
        },
        'comments': {
          '.read': 'auth != null',
          '.write': 'auth != null',
        },
        'votes': {
          '.read': 'auth != null',
          '.write': 'auth != null',
        }
      }
    };
  }
}
