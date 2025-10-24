# 🔥 Firebase Setup Guide - Dialecta

## 📋 **Configuración Completa de Firebase**

### ✅ **Lo que se ha implementado:**

1. **🔧 Configuración centralizada** - `FirebaseConfig`
2. **👤 Modelo de usuario universitario** - `UniversityUser`
3. **🔥 Servicio Firebase completo** - `FirebaseService`
4. **📝 Registro universitario** - `UniversityRegisterPage`
5. **💾 Persistencia de datos** - Firestore + Storage

## 🚀 **Pasos para configurar Firebase:**

### 1. **Crear proyecto en Firebase Console:**
```
1. Ve a https://console.firebase.google.com/
2. Crea un nuevo proyecto: "Dialecta"
3. Habilita Google Analytics (opcional)
```

### 2. **Configurar Authentication:**
```
1. Ve a Authentication > Sign-in method
2. Habilita "Email/Password"
3. Configura dominios autorizados si es necesario
```

### 3. **Configurar Firestore Database:**
```
1. Ve a Firestore Database
2. Crea base de datos en modo "test" (para desarrollo)
3. Selecciona ubicación (us-central1 recomendado)
```

### 4. **Configurar Storage:**
```
1. Ve a Storage
2. Inicia en modo "test"
3. Configura reglas de seguridad
```

### 5. **Reglas de seguridad Firestore:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios - solo pueden leer/escribir su propio documento
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Debates - todos los usuarios autenticados pueden leer/escribir
    match /debates/{debateId} {
      allow read, write: if request.auth != null;
    }
    
    // Eventos - todos los usuarios autenticados pueden leer/escribir
    match /events/{eventId} {
      allow read, write: if request.auth != null;
    }
    
    // Comentarios - todos los usuarios autenticados pueden leer/escribir
    match /comments/{commentId} {
      allow read, write: if request.auth != null;
    }
    
    // Votos - todos los usuarios autenticados pueden leer/escribir
    match /votes/{voteId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 6. **Reglas de seguridad Storage:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Imágenes de perfil de usuarios
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Imágenes de eventos
    match /events/{eventId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 📱 **Configuración en Flutter:**

### 1. **Agregar archivos de configuración:**
```
android/app/google-services.json (Android)
ios/Runner/GoogleService-Info.plist (iOS)
```

### 2. **Inicializar Firebase en main.dart:**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await FirebaseConfig.initialize();
  FirebaseConfig.configureFirestore();
  
  runApp(MyApp());
}
```

## 🗄️ **Estructura de datos en Firestore:**

### **Colección: users**
```json
{
  "email": "usuario@universidad.edu.co",
  "displayName": "Juan Pérez",
  "university": "Universidad Nacional",
  "career": "Ingeniería de Sistemas",
  "studentId": "2020123456",
  "semester": 5,
  "profileImageUrl": "https://...",
  "interests": ["Tecnología", "Ciencia"],
  "stats": {
    "totalDebates": 10,
    "totalEvents": 5,
    "totalVotes": 25,
    "totalComments": 15,
    "xp": 500,
    "streak": 7
  },
  "createdAt": "2024-01-15T10:30:00Z",
  "lastActive": "2024-01-20T15:45:00Z",
  "isVerified": true,
  "bio": "Estudiante apasionado por la tecnología...",
  "linkedinUrl": "https://linkedin.com/in/juan-perez",
  "githubUrl": "https://github.com/juan-perez"
}
```

### **Colección: debates**
```json
{
  "title": "¿La IA reemplazará a los humanos?",
  "description": "Debate sobre el futuro del trabajo...",
  "category": "Tecnología",
  "authorId": "user123",
  "authorName": "Juan Pérez",
  "votes": 42,
  "comments": 18,
  "createdAt": "2024-01-15T10:30:00Z",
  "tags": ["IA", "Futuro", "Trabajo"],
  "isActive": true,
  "participants": ["user123", "user456"],
  "lastActivity": "2024-01-20T15:45:00Z"
}
```

### **Colección: events**
```json
{
  "title": "Torneo Nacional de Debate",
  "description": "Competencia para estudiantes...",
  "date": "2024-02-15T09:00:00Z",
  "location": "Universidad Central",
  "maxParticipants": 50,
  "organizerId": "org123",
  "organizerName": "Asociación de Debate",
  "participants": [
    {
      "userId": "user123",
      "userName": "Juan Pérez",
      "registeredAt": "2024-01-15T10:30:00Z"
    }
  ],
  "prizes": [
    {
      "position": 1,
      "title": "Primer Lugar",
      "description": "Beca completa + Trofeo",
      "value": "Beca completa"
    }
  ],
  "rules": ["Edad mínima 18 años"],
  "status": "upcoming"
}
```

## 🔧 **Uso en la aplicación:**

### **Registro de usuario:**
```dart
final firebaseService = FirebaseService();

// Crear usuario universitario
await firebaseService.createUniversityUser(
  email: 'usuario@universidad.edu.co',
  displayName: 'Juan Pérez',
  university: 'Universidad Nacional',
  career: 'Ingeniería de Sistemas',
  studentId: '2020123456',
  semester: 5,
  interests: ['Tecnología', 'Ciencia'],
);
```

### **Obtener debates:**
```dart
// Stream de debates en tiempo real
Stream<List<DebateTopic>> debatesStream = firebaseService.getDebates();

// Escuchar cambios
debatesStream.listen((debates) {
  // Actualizar UI
});
```

### **Subir imagen de perfil:**
```dart
File imageFile = File('path/to/image.jpg');
String imageUrl = await firebaseService.uploadProfileImage(imageFile);
```

## 🎯 **Funcionalidades implementadas:**

### ✅ **Usuarios:**
- Registro universitario completo
- Perfil con información académica
- Estadísticas y ranking
- Imagen de perfil
- Búsqueda por universidad/carrera

### ✅ **Foros:**
- Crear debates
- Votar en debates
- Comentar
- Categorías y tags
- Tiempo real

### ✅ **Eventos:**
- Crear eventos
- Registrarse en eventos
- Calendario
- Premios y reglas
- Gestión de participantes

### ✅ **Storage:**
- Imágenes de perfil
- Imágenes de eventos
- Gestión automática de URLs

## 🚨 **Consideraciones de seguridad:**

1. **Validación en cliente y servidor**
2. **Reglas de seguridad estrictas**
3. **Autenticación requerida**
4. **Límites de tamaño de archivos**
5. **Validación de tipos de archivo**

## 📊 **Monitoreo y Analytics:**

1. **Firebase Analytics** - Métricas de uso
2. **Crashlytics** - Reportes de errores
3. **Performance** - Tiempos de carga
4. **Remote Config** - Configuración dinámica

## 🔄 **Próximos pasos:**

1. **Configurar Firebase Console**
2. **Agregar archivos de configuración**
3. **Probar registro de usuarios**
4. **Configurar reglas de seguridad**
5. **Implementar en producción**

¿Necesitas ayuda con algún paso específico de la configuración?
