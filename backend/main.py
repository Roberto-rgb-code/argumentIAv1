from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import httpx
import os
from typing import List, Optional
from datetime import datetime

app = FastAPI(title="Argumenta API", version="1.0.0")

# CORS para permitir peticiones desde Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configuración xAI
XAI_API_KEY = os.getenv("XAI_API_KEY")
if not XAI_API_KEY:
    raise ValueError("XAI_API_KEY environment variable is required")

XAI_API_URL = "https://api.x.ai/v1/chat/completions"
MODEL = "grok-4-fast-reasoning"  # Modelo rápido optimizado para razonamiento

# System prompts
DEBATE_COACH_PROMPT = """Eres un coach experto en debate y pensamiento crítico que ayuda a estudiantes a mejorar sus habilidades argumentativas.

TU OBJETIVO:
- Presentar contra-argumentos desafiantes pero respetuosos
- Evaluar argumentos usando el framework AREL (Afirmación, Razón, Evidencia, Limitaciones)
- Identificar falacias lógicas
- Dar feedback constructivo y educativo

REGLAS:
1. Mantén un tono profesional pero amigable
2. Desafía ideas, no personas
3. Cita evidencia cuando sea posible
4. Reconoce buenos argumentos
5. Señala falacias de forma educativa

Responde en español de forma concisa (máximo 150 palabras por turno)."""

EVALUATOR_PROMPT = """Eres un evaluador experto de argumentos académicos.

Analiza el argumento según estos criterios:
1. Claridad de la tesis (20%)
2. Calidad de razones (30%)
3. Evidencia presentada (30%)
4. Reconocimiento de limitaciones (20%)

Detecta falacias comunes: ad hominem, falsa dicotomía, pendiente resbaladiza, 
argumento de autoridad, generalización apresurada, hombre de paja.

Responde SOLO con un JSON válido en este formato:
{
  "score": 0-100,
  "structure": "Completo|Parcial|Básico",
  "fallacies": ["falacia1", "falacia2"] o [],
  "strengths": ["fortaleza1", "fortaleza2"],
  "improvements": ["mejora1", "mejora2"],
  "tokens_earned": 0-10,
  "feedback": "Resumen en 1-2 oraciones"
}"""

# Modelos Pydantic
class Message(BaseModel):
    role: str  # "user" | "assistant" | "system"
    content: str

class ChatRequest(BaseModel):
    messages: List[Message]
    topic: Optional[str] = None
    temperature: float = 0.7
    max_tokens: int = 500

class EvaluateRequest(BaseModel):
    argument: str
    topic: Optional[str] = None

class ChatResponse(BaseModel):
    response: str
    tokens_used: int
    timestamp: str

class EvaluationResponse(BaseModel):
    score: int
    structure: str
    fallacies: List[str]
    strengths: List[str]
    improvements: List[str]
    tokens_earned: int
    feedback: str

# Endpoints
@app.get("/")
async def root():
    return {
        "message": "Argumenta API - Chatbot de Debate",
        "version": "1.0.0",
        "endpoints": ["/chat", "/evaluate", "/health"]
    }

@app.get("/health")
async def health():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Endpoint principal para debate con IA.
    Recibe historial de mensajes y devuelve respuesta de Grok.
    """
    try:
        # Preparar mensajes con system prompt
        messages = [{"role": "system", "content": DEBATE_COACH_PROMPT}]
        
        # Agregar contexto del tema si existe
        if request.topic:
            messages.append({
                "role": "system", 
                "content": f"Tema del debate: {request.topic}"
            })
        
        # Agregar mensajes del usuario
        messages.extend([{"role": m.role, "content": m.content} for m in request.messages])
        
        # Llamar a xAI
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                XAI_API_URL,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {XAI_API_KEY}"
                },
                json={
                    "messages": messages,
                    "model": MODEL,
                    "stream": False,
                    "temperature": request.temperature,
                    "max_tokens": request.max_tokens
                }
            )
            
            if response.status_code != 200:
                raise HTTPException(
                    status_code=response.status_code,
                    detail=f"Error de xAI: {response.text}"
                )
            
            data = response.json()
            
            return ChatResponse(
                response=data["choices"][0]["message"]["content"],
                tokens_used=data.get("usage", {}).get("total_tokens", 0),
                timestamp=datetime.now().isoformat()
            )
            
    except httpx.TimeoutException:
        raise HTTPException(status_code=504, detail="Timeout al conectar con xAI")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")

@app.post("/evaluate", response_model=EvaluationResponse)
async def evaluate_argument(request: EvaluateRequest):
    """
    Evalúa un argumento y devuelve feedback estructurado.
    """
    try:
        messages = [
            {"role": "system", "content": EVALUATOR_PROMPT},
            {"role": "user", "content": f"Evalúa este argumento: {request.argument}"}
        ]
        
        if request.topic:
            messages.insert(1, {
                "role": "system",
                "content": f"Contexto del tema: {request.topic}"
            })
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                XAI_API_URL,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {XAI_API_KEY}"
                },
                json={
                    "messages": messages,
                    "model": MODEL,
                    "stream": False,
                    "temperature": 0.3  # Más determinista para evaluaciones
                }
            )
            
            if response.status_code != 200:
                raise HTTPException(
                    status_code=response.status_code,
                    detail=f"Error de xAI: {response.text}"
                )
            
            data = response.json()
            content = data["choices"][0]["message"]["content"]
            
            # Intentar parsear JSON de la respuesta
            import json
            # Buscar JSON en la respuesta
            start = content.find("{")
            end = content.rfind("}") + 1
            if start != -1 and end > start:
                json_str = content[start:end]
                evaluation = json.loads(json_str)
                
                return EvaluationResponse(
                    score=evaluation.get("score", 50),
                    structure=evaluation.get("structure", "Básico"),
                    fallacies=evaluation.get("fallacies", []),
                    strengths=evaluation.get("strengths", []),
                    improvements=evaluation.get("improvements", []),
                    tokens_earned=evaluation.get("tokens_earned", 0),
                    feedback=evaluation.get("feedback", "Argumento recibido.")
                )
            else:
                # Fallback si no hay JSON válido
                return EvaluationResponse(
                    score=50,
                    structure="Básico",
                    fallacies=[],
                    strengths=["Argumento presentado"],
                    improvements=["Agregar más evidencia"],
                    tokens_earned=3,
                    feedback=content[:100]
                )
                
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error al evaluar: {str(e)}")

@app.post("/start-debate")
async def start_debate(topic: str):
    """
    Inicia un nuevo debate con un argumento inicial de la IA.
    """
    try:
        messages = [
            {"role": "system", "content": DEBATE_COACH_PROMPT},
            {"role": "user", "content": f"Inicia un debate sobre: {topic}. Presenta un argumento inicial de postura contraria (en contra) de forma clara y concisa."}
        ]
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                XAI_API_URL,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {XAI_API_KEY}"
                },
                json={
                    "messages": messages,
                    "model": MODEL,
                    "stream": False,
                    "temperature": 0.8
                }
            )
            
            if response.status_code != 200:
                raise HTTPException(status_code=response.status_code, detail="Error xAI")
            
            data = response.json()
            
            return {
                "opening_argument": data["choices"][0]["message"]["content"],
                "topic": topic,
                "timestamp": datetime.now().isoformat()
            }
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

