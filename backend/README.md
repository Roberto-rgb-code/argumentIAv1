# Argumenta Backend API

API backend para el chatbot de debate usando xAI (Grok).

**Modelo:** `grok-4-fast-reasoning` - Optimizado para razonamiento rápido y debates.

## Instalación local

```bash
cd backend
pip install -r requirements.txt
python main.py
```

La API correrá en `http://localhost:8000`

## Endpoints

### GET /
Info general de la API

### GET /health
Health check

### POST /chat
Debate con IA
```json
{
  "messages": [
    {"role": "user", "content": "Tu argumento aquí"}
  ],
  "topic": "Renta básica universal",
  "temperature": 0.7
}
```

### POST /evaluate
Evalúa un argumento
```json
{
  "argument": "La renta básica universal reducirá la pobreza porque...",
  "topic": "Renta básica universal"
}
```

### POST /start-debate
Inicia debate con argumento de la IA
```json
{
  "topic": "Impuesto a la riqueza"
}
```

## Deploy en Render

1. Crea un nuevo Web Service en Render
2. Conecta tu repositorio de GitHub
3. Configura:
   - **Build Command:** `pip install -r backend/requirements.txt`
   - **Start Command:** `uvicorn backend.main:app --host 0.0.0.0 --port $PORT`
   - **Environment Variables:** 
     - `XAI_API_KEY` = tu API key de xAI
4. Deploy!

La URL será algo como: `https://argumenta-api.onrender.com`

