"""
Script de prueba rápida para el API de Argumenta
Verifica que la conexión con xAI funcione correctamente
"""

import httpx
import asyncio
from main import XAI_API_KEY, XAI_API_URL, MODEL

async def test_xai_connection():
    """Prueba la conexión con xAI"""
    print("🧪 Probando conexión con xAI...")
    print(f"📋 Modelo: {MODEL}")
    print(f"🔗 URL: {XAI_API_URL}")
    
    messages = [
        {"role": "system", "content": "Eres un asistente de prueba."},
        {"role": "user", "content": "Di 'Hola mundo' y nada más."}
    ]
    
    try:
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
                    "temperature": 0
                }
            )
            
            if response.status_code == 200:
                data = response.json()
                content = data["choices"][0]["message"]["content"]
                tokens = data.get("usage", {}).get("total_tokens", 0)
                
                print("✅ ¡Conexión exitosa!")
                print(f"📝 Respuesta: {content}")
                print(f"🔢 Tokens usados: {tokens}")
                return True
            else:
                print(f"❌ Error {response.status_code}: {response.text}")
                return False
                
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 TEST DE CONEXIÓN xAI - Argumenta API")
    print("=" * 60)
    print()
    
    success = asyncio.run(test_xai_connection())
    
    print()
    if success:
        print("✅ El backend está listo para deploy!")
    else:
        print("⚠️ Revisa la configuración antes de deployar")
    print("=" * 60)

