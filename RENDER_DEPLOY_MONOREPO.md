# 🚀 Deploy a Render - Monorepo (Backend + Frontend en un solo repo)

## ✅ Configuración Actual

Tu proyecto tiene esta estructura (monorepo):
```
argumenta/ (repo git)
├── .git/
├── backend/          ← FastAPI aquí
│   ├── main.py
│   ├── requirements.txt
│   └── ...
├── lib/              ← Flutter aquí
├── pubspec.yaml
└── ...
```

**Esto es perfecto y totalmente soportado por Render** ✅

---

## 🎯 Deploy Paso a Paso

### **Paso 1: Asegurar que todo está en Git**

```bash
# Verificar status
git status

# Si hay cambios nuevos, hacer commit
git add .
git commit -m "feat: Backend FastAPI + ChatGPT integration"
git push origin master
```

### **Paso 2: Crear Web Service en Render**

1. Ve a https://dashboard.render.com/
2. Click **"New +"** → **"Web Service"**
3. Click **"Connect account"** (si no lo has hecho)
4. Selecciona tu repositorio: **argumenta**

### **Paso 3: Configuración del Service**

#### **Settings:**

| Campo | Valor |
|-------|-------|
| **Name** | `argumenta-api` |
| **Region** | Oregon (o el más cercano) |
| **Branch** | `master` (o `main`) |
| **Root Directory** | `backend` ⚠️ **MUY IMPORTANTE** |
| **Runtime** | Python 3 |
| **Build Command** | `pip install -r requirements.txt` |
| **Start Command** | `uvicorn main:app --host 0.0.0.0 --port $PORT` |

**Screenshot de configuración:**
```
┌─────────────────────────────────────────────┐
│ Root Directory: backend                     │  ← Render entrará aquí
│ Build Command: pip install -r requirements.txt
│ Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
└─────────────────────────────────────────────┘
```

### **Paso 4: Variables de Entorno**

En la sección **"Environment Variables"**, agrega:

| Key | Value |
|-----|-------|
| `XAI_API_KEY` | `your-xai-api-key-here` |

⚠️ **IMPORTANTE**: Reemplaza `your-xai-api-key-here` con tu clave API real de xAI (obtenida desde https://console.x.ai/)

### **Paso 5: Deploy**

1. Click **"Create Web Service"**
2. Espera 3-5 minutos
3. Verás logs en tiempo real
4. Cuando termine, obtendrás una URL: `https://argumenta-api.onrender.com`

### **Paso 6: Verificar**

Prueba tu API:
```bash
curl https://argumenta-api.onrender.com/health
```

Deberías recibir:
```json
{"status": "healthy", "timestamp": "2025-..."}
```

---

## 🔧 Configurar Flutter App

Una vez deployado, actualiza la URL en tu app:

**Archivo:** `lib/services/xai_service.dart`

```dart
class XAIService {
  XAIService._();
  static final XAIService instance = XAIService._();

  // CAMBIAR ESTA LÍNEA:
  static const String _baseUrl = 'https://argumenta-api.onrender.com';
  // (en lugar de 'http://localhost:8000')
  
  // ...
}
```

---

## 📝 Notas Importantes

### ⚠️ **Root Directory es CRUCIAL**

Sin `Root Directory: backend`, Render intentará ejecutar desde la raíz del proyecto y fallará porque:
- No hay `requirements.txt` en la raíz
- No hay `main.py` en la raíz

Con `Root Directory: backend`, Render:
✅ Entra a la carpeta `backend/`
✅ Ejecuta `pip install -r requirements.txt`
✅ Corre `uvicorn main:app`

### 🆓 Plan Gratuito de Render

**Limitaciones:**
- El servicio se duerme después de 15 min de inactividad
- Primera petición tras dormir: 30-60 segundos
- 750 horas gratis por mes

**Soluciones:**
1. Esperar en primera petición
2. Usar un "keep-alive" service
3. Upgrade a plan paid ($7/mes)

### 🔄 Auto-Deploy

Render automáticamente re-deploya cuando:
- Haces push a `master`/`main`
- Detecta cambios en `backend/`

**Para desactivar auto-deploy:**
Settings → Build & Deploy → Manual Deploy Only

---

## 🐛 Troubleshooting

### Error: "No such file requirements.txt"

**Causa:** Root Directory no configurado
**Solución:** 
1. Settings → Build & Deploy
2. Root Directory: `backend`
3. Save changes
4. Manual Deploy

### Error: "ModuleNotFoundError: No module named 'fastapi'"

**Causa:** Build command incorrecto
**Solución:**
Build Command: `pip install -r requirements.txt`

### Error: "Port 8000 already in use"

**Causa:** Start command usa puerto fijo
**Solución:**
Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`
(Render inyecta `$PORT` automáticamente)

---

## 📊 Monitoreo

### **Logs en vivo**
Dashboard → Tu servicio → **"Logs"** tab

### **Métricas**
Dashboard → Tu servicio → **"Metrics"** tab
- CPU usage
- Memory usage
- Request count

### **Shell access**
Dashboard → Tu servicio → **"Shell"** tab
```bash
# Puedes correr comandos directamente
python -c "print('Hello from Render')"
pip list
```

---

## 🎯 Estructura Recomendada (Lo que ya tienes)

```
argumenta/ (repo único)
├── .git/
├── .gitignore
├── README.md
├── DEPLOYMENT.md
│
├── backend/              ← Backend FastAPI
│   ├── main.py
│   ├── requirements.txt
│   ├── README.md
│   └── render.yaml      ← Config opcional
│
├── lib/                  ← Flutter app
│   ├── main.dart
│   ├── models/
│   ├── services/
│   └── pages/
│
├── android/              ← Android config
├── ios/                  ← iOS config
├── pubspec.yaml          ← Flutter deps
└── ...
```

**Ventajas de esta estructura:**
✅ Un solo repo
✅ Versionado unificado
✅ Fácil de clonar
✅ Deploy independiente de backend
✅ Flutter puede compilar APK/iOS sin backend

---

## 🚀 Deploy con GitHub Actions (Opcional)

Si quieres automatizar más, puedes usar GitHub Actions:

**.github/workflows/deploy-backend.yml**
```yaml
name: Deploy Backend to Render

on:
  push:
    branches: [master]
    paths:
      - 'backend/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Trigger Render Deploy
        run: |
          curl -X POST ${{ secrets.RENDER_DEPLOY_HOOK }}
```

Pero Render ya hace esto automáticamente, así que no es necesario.

---

## ✅ Checklist de Deploy

- [ ] Código en GitHub (repo `argumenta`)
- [ ] Carpeta `backend/` con `main.py` y `requirements.txt`
- [ ] Cuenta en Render creada
- [ ] Web Service creado
- [ ] Root Directory: `backend` configurado
- [ ] Variable `XAI_API_KEY` agregada
- [ ] Deploy completado sin errores
- [ ] Health check funciona: `/health` responde OK
- [ ] Flutter app actualizada con nueva URL
- [ ] Probado chatbot desde app

---

## 🎉 Conclusión

**Monorepo = Mejor opción para tu caso** ✅

Razones:
1. ✅ Solo un repo que gestionar
2. ✅ Backend y frontend versionados juntos
3. ✅ Render soporta subdirectorios perfectamente
4. ✅ Más simple de mantener
5. ✅ Deploys independientes (backend en Render, APK por tu cuenta)

**Tu configuración actual es perfecta. Solo falta deployar.** 🚀

---

## 📞 Soporte

Si tienes problemas:
1. Revisa logs en Render Dashboard
2. Verifica Root Directory
3. Confirma que `requirements.txt` existe en `backend/`
4. Prueba build localmente: `cd backend && pip install -r requirements.txt`

**Dashboard Render:** https://dashboard.render.com/

