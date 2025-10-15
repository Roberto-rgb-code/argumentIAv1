# 🚀 Quick Start - Argumenta

## ⚡ Inicio Rápido (5 minutos)

### 1️⃣ Instalar dependencias

```bash
# Flutter
flutter pub get

# Backend Python
cd backend
pip install -r requirements.txt
cd ..
```

### 2️⃣ Correr backend

En una terminal:
```bash
cd backend
python main.py
```

Deberías ver:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### 3️⃣ Correr app Flutter

En otra terminal:
```bash
flutter run
```

### 4️⃣ Probar funcionalidades

1. **Login/Registro**
   - Crea una cuenta con email y contraseña
   - O usa una cuenta existente

2. **Chatbot** 💬
   - Ve al tab "Chatbot"
   - Selecciona un tema (ej: "Renta básica universal")
   - Click "Iniciar debate"
   - Escribe tu argumento
   - ¡Recibe respuesta de la IA!

3. **Perfil** 👤
   - Ve al tab "Perfil"
   - Verás tus estadísticas:
     - Racha, tokens, lecciones, debates
   - Gráfica de actividad semanal
   - Logros desbloqueados

4. **Lecciones** 🎓
   - Ve al tab "Inicio"
   - Click "Iniciar lección" o "Continuar"
   - Completa ejercicios
   - ¡Gana +10 tokens y +20 XP!

---

## 🔧 Configuración Rápida

### Si usas emulador Android

Edita `lib/services/xai_service.dart`:

```dart
// Cambia esta línea
static const String _baseUrl = 'http://localhost:8000';

// Por esta
static const String _baseUrl = 'http://10.0.2.2:8000';
```

### Si desplegaste en Render

```dart
// Cambia a tu URL de Render
static const String _baseUrl = 'https://tu-app.onrender.com';
```

---

## 📱 Probarlo

### Crear cuenta nueva
1. Abre la app
2. Click "Crear cuenta gratis"
3. Ingresa email y contraseña
4. ¡Listo!

### Probar chatbot
1. Tab "Chatbot"
2. Selecciona: "Renta básica universal"
3. Click "Iniciar debate"
4. Escribe: "Creo que la renta básica es necesaria porque reduce la pobreza y da seguridad económica"
5. Espera respuesta (5-10 segundos)
6. ¡La IA te responderá con un contra-argumento!

### Ver progreso
1. Tab "Perfil"
2. Verás:
   - Tu nivel y XP
   - Racha actual
   - Tokens ganados
   - Gráfica semanal
   - Logros

---

## ❓ Troubleshooting Rápido

### "Connection refused"
- ✅ Verifica que el backend esté corriendo
- ✅ Revisa la URL en `xai_service.dart`
- ✅ Si usas emulador, usa `10.0.2.2:8000`

### "TimeoutException"
- ✅ El backend puede tardar ~30s en primera llamada
- ✅ Espera un poco más
- ✅ Verifica tu conexión a internet

### Backend no inicia
```bash
cd backend
pip install -r requirements.txt
python main.py
```

### App no compila
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📚 Archivos Importantes

### Configuración
- `lib/services/xai_service.dart` - URL del backend
- `backend/main.py` - API key de xAI

### Páginas principales
- `lib/pages/home_page.dart` - Inicio con lecciones
- `lib/pages/chatbot/chatbot_page.dart` - Chatbot de debate
- `lib/pages/profile/profile_page.dart` - Perfil del usuario

### Servicios
- `lib/services/xai_service.dart` - Comunicación con backend
- `lib/services/user_stats_service.dart` - Estadísticas del usuario
- `lib/services/auth_service.dart` - Autenticación

---

## 🎯 Flujo Típico de Usuario

```
1. 📧 Login
    ↓
2. 🏠 Home (ver lecciones disponibles)
    ↓
3. 🎓 Completar lección
    ↓
   +10 tokens, +20 XP, racha actualizada
    ↓
4. 💬 Ir a Chatbot
    ↓
5. 🗣️ Debatir con IA (5 turnos)
    ↓
   +12 tokens, +45 XP
    ↓
6. 👤 Ver Perfil
    ↓
   Ver stats, gráfica, logros desbloqueados
    ↓
7. 🏆 ¡Seguir aprendiendo!
```

---

## ✨ Features Destacadas

### Chatbot
- ✅ IA real (Grok de xAI)
- ✅ 5 temas de debate
- ✅ Evaluación de argumentos
- ✅ Framework AREL

### Perfil
- ✅ Stats en tiempo real
- ✅ Gráfica semanal
- ✅ 8 logros desbloqueables
- ✅ Sistema de niveles

### Gamificación
- ✅ Tokens por actividades
- ✅ XP y niveles (100 XP/nivel)
- ✅ Racha diaria
- ✅ Logros automáticos

---

## 📞 Más Información

- **Deployment completo:** Ver `DEPLOYMENT.md`
- **Features detalladas:** Ver `FEATURES.md`
- **Resumen técnico:** Ver `IMPLEMENTATION_SUMMARY.md`

---

## 🎉 ¡Listo!

Ahora tienes:
- ✅ Backend corriendo en `http://localhost:8000`
- ✅ App Flutter funcionando
- ✅ Chatbot con IA real operativo
- ✅ Sistema de gamificación activo

**¡A debatir! 💬🧠**

