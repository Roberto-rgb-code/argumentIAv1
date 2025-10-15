# 🚀 Guía de Deployment - Argumenta

## 📋 Tabla de Contenido
1. [Backend FastAPI en Render](#backend-fastapi-en-render)
2. [Configurar Flutter App](#configurar-flutter-app)
3. [Testing Local](#testing-local)
4. [Troubleshooting](#troubleshooting)

---

## 🔧 Backend FastAPI en Render

### Paso 1: Preparar el repositorio
1. Asegúrate de que el código esté en GitHub
2. La carpeta `backend/` debe estar en la raíz del proyecto

### Paso 2: Crear Web Service en Render
1. Ve a [Render Dashboard](https://dashboard.render.com/)
2. Click en **"New +"** → **"Web Service"**
3. Conecta tu repositorio de GitHub
4. Configura:

```yaml
Name: argumenta-api
Root Directory: backend
Environment: Python 3
Build Command: pip install -r requirements.txt
Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
```

### Paso 3: Variables de entorno
Agrega esta variable de entorno en Render:

```
XAI_API_KEY = your-xai-api-key-here
```

⚠️ **IMPORTANTE**: Reemplaza `your-xai-api-key-here` con tu clave API real de xAI (obtenida desde https://console.x.ai/)

### Paso 4: Deploy
1. Click en **"Create Web Service"**
2. Espera 3-5 minutos a que se despliegue
3. Obtendrás una URL como: `https://argumenta-api.onrender.com`

### Paso 5: Verificar
Prueba que funciona:
```bash
curl https://argumenta-api.onrender.com/health
```

Deberías recibir:
```json
{"status": "healthy", "timestamp": "2025-10-15T..."}
```

---

## 📱 Configurar Flutter App

### Actualizar URL del backend

Edita `lib/services/xai_service.dart`:

```dart
// ANTES (desarrollo local)
static const String _baseUrl = 'http://localhost:8000';

// DESPUÉS (producción)
static const String _baseUrl = 'https://argumenta-api.onrender.com';
```

**IMPORTANTE**: 
- Para desarrollo local, usa `http://localhost:8000`
- Para producción (APK/iOS), usa la URL de Render
- Puedes usar una variable de entorno para cambiar automáticamente

### Opción: Usar entorno dinámico

Crea `lib/config/environment.dart`:
```dart
class Environment {
  static const bool isDev = bool.fromEnvironment('DEV', defaultValue: false);
  
  static String get baseUrl => isDev
      ? 'http://localhost:8000'
      : 'https://argumenta-api.onrender.com';
}
```

Luego en `xai_service.dart`:
```dart
import '../config/environment.dart';

static String get _baseUrl => Environment.baseUrl;
```

Y ejecuta:
```bash
# Desarrollo
flutter run --dart-define=DEV=true

# Producción
flutter build apk
```

---

## 🧪 Testing Local

### 1. Correr backend localmente

```bash
cd backend
pip install -r requirements.txt
python main.py
```

El servidor correrá en `http://localhost:8000`

### 2. Probar endpoints

**Health check:**
```bash
curl http://localhost:8000/health
```

**Iniciar debate:**
```bash
curl -X POST http://localhost:8000/start-debate?topic=Renta%20básica%20universal
```

**Chat:**
```bash
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "Creo que la renta básica es necesaria porque reduce pobreza"}
    ],
    "topic": "Renta básica universal"
  }'
```

### 3. Correr app Flutter

En otra terminal:
```bash
flutter pub get
flutter run
```

---

## 🔧 Configuración de emulador Android

Si usas el emulador de Android, `localhost` no funcionará. Usa:

```dart
// Para emulador Android
static const String _baseUrl = 'http://10.0.2.2:8000';
```

`10.0.2.2` es el localhost del host desde el emulador.

---

## 🐛 Troubleshooting

### Error: "Connection refused"
- **Causa**: Backend no está corriendo o URL incorrecta
- **Solución**: 
  1. Verifica que el backend esté corriendo
  2. Revisa la URL en `xai_service.dart`
  3. Si usas emulador, usa `10.0.2.2:8000`

### Error: "TimeoutException"
- **Causa**: Render en plan gratuito se duerme después de inactividad
- **Solución**: 
  1. El primer request puede tardar 30-60 segundos
  2. Aumenta el timeout en `xai_service.dart`
  3. Considera usar un servicio de "keep alive"

### Error: "401 Unauthorized" de xAI
- **Causa**: API key inválida o vencida
- **Solución**: 
  1. Verifica la variable de entorno en Render
  2. Revisa que la key sea correcta

### Error de CORS
- **Causa**: Configuración de CORS en FastAPI
- **Solución**: Ya está configurado en `main.py` con `allow_origins=["*"]`

### Render plan gratuito se duerme
- **Problema**: Después de 15 min de inactividad, el servicio se suspende
- **Solución temporal**: Primer request será lento (30-60s)
- **Solución permanente**: Upgrade a plan paid o usar UptimeRobot

---

## 📊 Monitoreo

### Logs en Render
1. Ve al Dashboard de Render
2. Click en tu servicio
3. Tab **"Logs"**
4. Verás todos los requests y errores

### Métricas
- Tab **"Metrics"** muestra uso de CPU, memoria, requests

---

## 🔐 Seguridad

### Proteger API Key
**NUNCA** hagas commit de `.env` con la API key. El archivo actual tiene:

```
backend/.env  (añadir a .gitignore)
```

### Rate Limiting (futuro)
Considera agregar rate limiting en FastAPI:
```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@app.post("/chat")
@limiter.limit("10/minute")
async def chat(request: Request, ...):
    ...
```

---

## ✅ Checklist de Deploy

- [ ] Backend desplegado en Render
- [ ] Variables de entorno configuradas
- [ ] URL de producción actualizada en Flutter
- [ ] Probado endpoint `/health`
- [ ] Probado chat desde la app
- [ ] Logs de Render revisados
- [ ] App compilada y probada en dispositivo físico

---

## 🎯 Next Steps

1. **Implementar persistencia**: Guardar historial de debates en Firestore
2. **Analytics**: Agregar Firebase Analytics para seguimiento
3. **Caché**: Implementar caché de respuestas comunes
4. **Notificaciones**: Push notifications para recordatorios
5. **Testing**: Agregar tests unitarios y de integración

---

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs en Render
2. Verifica que la API de xAI esté funcionando
3. Prueba los endpoints con curl/Postman
4. Revisa la consola de Flutter para errores

**Dashboard de Render**: https://dashboard.render.com/
**Documentación xAI**: https://docs.x.ai/

