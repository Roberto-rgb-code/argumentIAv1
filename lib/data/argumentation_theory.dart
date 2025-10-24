import '../models/content_models.dart';

class ArgumentationTheory {
  // === TEORÍA DE LA ARGUMENTACIÓN ===
  
  static const List<TheorySection> argumentationTheory = [
    TheorySection(
      id: 'arg_001',
      title: 'Fundamentos de la Argumentación',
      description: 'Conceptos básicos y estructura de un argumento',
      content: '''
# Fundamentos de la Argumentación

## ¿Qué es un argumento?
Un argumento es una serie de afirmaciones donde una (la conclusión) se deriva de otras (las premisas) mediante reglas de inferencia.

## Estructura básica:
1. **Premisa**: Afirmación que apoya la conclusión
2. **Conclusión**: La afirmación que se quiere defender
3. **Inferencia**: La conexión lógica entre premisas y conclusión

## Ejemplo:
- **Premisa 1**: Todos los humanos son mortales
- **Premisa 2**: Sócrates es humano
- **Conclusión**: Por tanto, Sócrates es mortal

## Elementos clave:
- **Validez**: La forma lógica es correcta
- **Solidez**: Las premisas son verdaderas
- **Relevancia**: Las premisas apoyan la conclusión
- **Suficiencia**: Hay suficientes premisas para la conclusión
''',
      difficulty: 'beginner',
      category: 'Teoría',
      estimatedTime: 15,
    ),
    
    TheorySection(
      id: 'arg_002',
      title: 'Tipos de Argumentos',
      description: 'Clasificación de argumentos según su estructura',
      content: '''
# Tipos de Argumentos

## 1. Argumentos Deductivos
**Definición**: La conclusión se sigue necesariamente de las premisas.

**Ejemplo**:
- Si llueve, la calle se moja
- Está lloviendo
- Por tanto, la calle está mojada

## 2. Argumentos Inductivos
**Definición**: La conclusión es probable basada en las premisas.

**Ejemplo**:
- El sol ha salido todos los días
- Por tanto, probablemente saldrá mañana

## 3. Argumentos Abductivos
**Definición**: La mejor explicación para un fenómeno observado.

**Ejemplo**:
- La hierba está mojada
- La mejor explicación es que llovió
- Por tanto, probablemente llovió

## 4. Argumentos Analógicos
**Definición**: Comparación entre casos similares.

**Ejemplo**:
- Los estudiantes necesitan descanso
- Los trabajadores también necesitan descanso
- Por tanto, los trabajadores merecen vacaciones como los estudiantes
''',
      difficulty: 'intermediate',
      category: 'Teoría',
      estimatedTime: 20,
    ),
    
    TheorySection(
      id: 'arg_003',
      title: 'Estructura AREAL',
      description: 'Metodología para construir argumentos sólidos',
      content: '''
# Estructura AREAL

## A - Afirmación (Assertion)
**Definición**: La tesis o posición que defiendes.

**Ejemplo**: "El gobierno debe implementar un salario mínimo universal"

## R - Razón (Reason)
**Definición**: Por qué tu afirmación es correcta.

**Ejemplo**: "Porque garantiza un nivel básico de vida digna para todos los ciudadanos"

## E - Evidencia (Evidence)
**Definición**: Datos, estadísticas, estudios que apoyan tu razón.

**Ejemplo**: "Según la OIT, 1.4 mil millones de trabajadores ganan menos de $2 USD diarios"

## A - Análisis (Analysis)
**Definición**: Explicación de cómo la evidencia apoya tu razón.

**Ejemplo**: "Esto significa que millones de personas viven en pobreza extrema, lo que justifica la intervención estatal"

## L - Limitaciones (Limitations)
**Definición**: Reconocimiento de posibles objeciones o limitaciones.

**Ejemplo**: "Aunque esto podría aumentar la inflación, los beneficios sociales superan los costos económicos"

## Ejemplo completo:
**Afirmación**: El gobierno debe implementar un salario mínimo universal
**Razón**: Porque garantiza un nivel básico de vida digna
**Evidencia**: 1.4 mil millones ganan menos de $2 USD diarios (OIT)
**Análisis**: Esto significa pobreza extrema que justifica intervención estatal
**Limitaciones**: Podría aumentar inflación, pero beneficios superan costos
''',
      difficulty: 'intermediate',
      category: 'Metodología',
      estimatedTime: 25,
    ),
  ];

  // === TÉCNICAS DE REFUTACIÓN ===
  
  static const List<TheorySection> refutationTechniques = [
    TheorySection(
      id: 'ref_001',
      title: 'Estrategias de Refutación',
      description: 'Cómo atacar argumentos del oponente',
      content: '''
# Estrategias de Refutación

## 1. Atacar la Premisa
**Definición**: Demostrar que las premisas del oponente son falsas.

**Ejemplo**:
- **Oponente**: "El capitalismo siempre beneficia a todos"
- **Refutación**: "Falso, el capitalismo ha creado desigualdad extrema: el 1% más rico posee el 50% de la riqueza mundial"

## 2. Atacar la Inferencia
**Definición**: Demostrar que la conclusión no se sigue de las premisas.

**Ejemplo**:
- **Oponente**: "Los inmigrantes toman trabajos, por tanto debemos deportarlos"
- **Refutación**: "Los inmigrantes también crean empleos y pagan impuestos, tu conclusión no se sigue"

## 3. Atacar la Relevancia
**Definición**: Demostrar que las premisas no son relevantes para la conclusión.

**Ejemplo**:
- **Oponente**: "Este político es corrupto, por tanto su política económica es mala"
- **Refutación**: "La corrupción personal no invalida automáticamente las políticas económicas"

## 4. Reductio ad Absurdum
**Definición**: Llevar el argumento del oponente a una conclusión absurda.

**Ejemplo**:
- **Oponente**: "Debemos prohibir todo lo que es peligroso"
- **Refutación**: "Entonces deberíamos prohibir los automóviles, los cuchillos de cocina, y hasta las escaleras"

## 5. Contra-ejemplo
**Definición**: Presentar un caso que contradice la generalización del oponente.

**Ejemplo**:
- **Oponente**: "Los gobiernos socialistas siempre fallan"
- **Refutación**: "Dinamarca, Noruega y Suecia tienen gobiernos socialistas y están entre los países más prósperos del mundo"
''',
      difficulty: 'intermediate',
      category: 'Refutación',
      estimatedTime: 30,
    ),
    
    TheorySection(
      id: 'ref_002',
      title: 'Refutación por Categorías',
      description: 'Atacar argumentos según su tipo',
      content: '''
# Refutación por Categorías

## Argumentos de Autoridad
**Cómo refutar**: Cuestionar la credibilidad de la fuente.

**Ejemplo**:
- **Oponente**: "El Dr. X dice que el cambio climático es falso"
- **Refutación**: "El Dr. X es financiado por la industria petrolera y no es climatólogo"

## Argumentos de Consecuencia
**Cómo refutar**: Mostrar que las consecuencias no son inevitables o son exageradas.

**Ejemplo**:
- **Oponente**: "Si legalizamos las drogas, todos se volverán adictos"
- **Refutación**: "Portugal legalizó las drogas en 2001 y las tasas de adicción disminuyeron"

## Argumentos de Analogía
**Cómo refutar**: Mostrar que los casos no son realmente similares.

**Ejemplo**:
- **Oponente**: "El matrimonio gay es como casarse con un animal"
- **Refutación**: "Los humanos y los animales no pueden consentir al matrimonio, pero dos adultos sí pueden"

## Argumentos de Causa-Efecto
**Cómo refutar**: Mostrar que la correlación no implica causalidad.

**Ejemplo**:
- **Oponente**: "Los videojuegos causan violencia"
- **Refutación**: "Japón tiene los videojuegos más violentos y una de las tasas de crimen más bajas del mundo"
''',
      difficulty: 'advanced',
      category: 'Refutación',
      estimatedTime: 25,
    ),
  ];

  // === TIPOS DE MOCIONES ===
  
  static const List<TheorySection> motionTypes = [
    TheorySection(
      id: 'mot_001',
      title: 'Clasificación de Mociones',
      description: 'Tipos de mociones en debate parlamentario',
      content: '''
# Clasificación de Mociones

## 1. Mociones de Política (Policy)
**Definición**: Proponen una acción específica que debe tomarse.

**Estructura**: "Esta Casa debería..."

**Ejemplos**:
- "Esta Casa debería implementar un salario mínimo universal"
- "Esta Casa debería legalizar la marihuana"
- "Esta Casa debería crear un estado palestino"

**Características**:
- Requieren plan de implementación
- Evalúan necesidad, viabilidad y beneficios
- Consideran alternativas

## 2. Mociones de Valor (Value)
**Definición**: Evalúan la moralidad o importancia de algo.

**Estructura**: "Esta Casa cree que..."

**Ejemplos**:
- "Esta Casa cree que el arte es más importante que la ciencia"
- "Esta Casa cree que la privacidad es más valiosa que la seguridad"
- "Esta Casa cree que el individualismo es superior al colectivismo"

**Características**:
- Establecen criterios de evaluación
- Comparan valores en conflicto
- Consideran principios universales

## 3. Mociones de Hecho (Fact)
**Definición**: Afirman la verdad de una proposición factual.

**Estructura**: "Esta Casa cree que [hecho] es verdadero"

**Ejemplos**:
- "Esta Casa cree que el cambio climático es causado por humanos"
- "Esta Casa cree que la globalización ha reducido la pobreza"
- "Esta Casa cree que la inteligencia artificial superará a la humana"

**Características**:
- Requieren evidencia empírica
- Evalúan credibilidad de fuentes
- Consideran evidencia contradictoria
''',
      difficulty: 'beginner',
      category: 'Mociones',
      estimatedTime: 20,
    ),
    
    TheorySection(
      id: 'mot_002',
      title: 'Estrategias por Tipo de Moción',
      description: 'Cómo abordar cada tipo de moción',
      content: '''
# Estrategias por Tipo de Moción

## Mociones de Política

### Para el Gobierno (A favor):
1. **Problema**: Demostrar que existe un problema serio
2. **Solución**: Explicar cómo tu política resuelve el problema
3. **Beneficios**: Mostrar las ventajas de implementar la política
4. **Viabilidad**: Demostrar que es factible implementarla

### Para la Oposición (En contra):
1. **No hay problema**: Demostrar que el problema no existe o es exagerado
2. **Solución inadecuada**: Mostrar que la política no resuelve el problema
3. **Costos**: Demostrar que los costos superan los beneficios
4. **Alternativas**: Proponer soluciones mejores

## Mociones de Valor

### Para el Gobierno:
1. **Criterios**: Establecer criterios para evaluar el valor
2. **Aplicación**: Mostrar cómo tu valor cumple mejor los criterios
3. **Comparación**: Demostrar que tu valor es superior al alternativo
4. **Principios**: Apelar a principios universales o morales

### Para la Oposición:
1. **Criterios diferentes**: Proponer criterios alternativos de evaluación
2. **Aplicación**: Mostrar que el valor opuesto cumple mejor los criterios
3. **Limitaciones**: Demostrar las limitaciones del valor propuesto
4. **Balance**: Mostrar que se necesita equilibrio entre valores

## Mociones de Hecho

### Para el Gobierno:
1. **Evidencia**: Presentar evidencia que apoya tu posición
2. **Credibilidad**: Demostrar que tus fuentes son confiables
3. **Consistencia**: Mostrar que la evidencia es consistente
4. **Causalidad**: Establecer relaciones causa-efecto

### Para la Oposición:
1. **Evidencia contradictoria**: Presentar evidencia que contradice
2. **Credibilidad**: Cuestionar la confiabilidad de las fuentes
3. **Interpretación**: Ofrecer interpretaciones alternativas
4. **Incertidumbre**: Demostrar que la evidencia es insuficiente
''',
      difficulty: 'intermediate',
      category: 'Mociones',
      estimatedTime: 30,
    ),
  ];

  // === TIPOS DE FALACIAS ===
  
  static const List<TheorySection> fallacyTypes = [
    TheorySection(
      id: 'fal_001',
      title: 'Falacias Lógicas',
      description: 'Errores en el razonamiento lógico',
      content: '''
# Falacias Lógicas

## 1. Ad Hominem
**Definición**: Atacar a la persona en lugar de su argumento.

**Ejemplo**: "No puedes confiar en su opinión sobre economía porque es comunista"

**Refutación**: "Mi ideología política no invalida mis argumentos económicos"

## 2. Straw Man
**Definición**: Distorsionar el argumento del oponente para atacarlo más fácilmente.

**Ejemplo**: "Quieren legalizar todas las drogas, incluso para niños"

**Refutación**: "Nadie propone dar drogas a niños, hablamos de adultos"

## 3. Slippery Slope
**Definición**: Afirmar que un pequeño cambio llevará a consecuencias extremas.

**Ejemplo**: "Si permitimos el matrimonio gay, pronto permitiremos casarse con animales"

**Refutación**: "No hay conexión lógica entre ambos casos"

## 4. Falsa Dicotomía
**Definición**: Presentar solo dos opciones cuando hay más.

**Ejemplo**: "O estás con nosotros o contra nosotros"

**Refutación**: "Hay posiciones intermedias y matices"

## 5. Post Hoc Ergo Propter Hoc
**Definición**: Asumir causalidad solo por secuencia temporal.

**Ejemplo**: "Después de que se legalizó la marihuana, aumentó el crimen"

**Refutación**: "Correlación no implica causalidad"
''',
      difficulty: 'beginner',
      category: 'Falacias',
      estimatedTime: 25,
    ),
    
    TheorySection(
      id: 'fal_002',
      title: 'Falacias de Evidencia',
      description: 'Errores en el uso de evidencia',
      content: '''
# Falacias de Evidencia

## 1. Cherry Picking
**Definición**: Seleccionar solo evidencia que apoya tu posición.

**Ejemplo**: "Los estudios muestran que el azúcar no es dañino" (ignorando 100 estudios que dicen lo contrario)

**Refutación**: "Presentas evidencia sesgada, la mayoría de estudios muestran lo contrario"

## 2. Anecdotal Evidence
**Definición**: Usar casos individuales para generalizar.

**Ejemplo**: "Mi abuelo fumó toda su vida y vivió 90 años, por tanto fumar no es dañino"

**Refutación**: "Un caso individual no invalida estadísticas de millones de personas"

## 3. Appeal to Authority
**Definición**: Usar autoridad inapropiada o no experta.

**Ejemplo**: "El actor X dice que las vacunas son peligrosas"

**Refutación**: "Los actores no son expertos en medicina"

## 4. Appeal to Emotion
**Definición**: Usar emociones en lugar de evidencia.

**Ejemplo**: "Piensa en los niños que sufren"

**Refutación**: "Las emociones no reemplazan la evidencia"

## 5. Hasty Generalization
**Definición**: Generalizar basándose en muestra insuficiente.

**Ejemplo**: "Los tres inmigrantes que conocí son criminales, por tanto todos los inmigrantes son criminales"

**Refutación**: "Tres casos no representan a millones de personas"
''',
      difficulty: 'intermediate',
      category: 'Falacias',
      estimatedTime: 20,
    ),
  ];

  // === MOCIONES DE ENTRENAMIENTO ===
  
  static const List<DebateMotion> trainingMotions = [
    DebateMotion(
      id: 'motion_001',
      title: 'Esta Casa cree que el gobierno debería implementar un salario mínimo universal',
      description: 'Debate sobre políticas de salario mínimo y sus implicaciones económicas',
      category: 'Política',
      difficulty: 'intermediate',
      type: 'Policy',
      context: 'En un contexto de desigualdad económica creciente',
      keyArguments: [
        'Garantiza nivel básico de vida digna',
        'Reduce desigualdad económica',
        'Estimula consumo y crecimiento',
        'Podría aumentar inflación',
        'Podría reducir empleo',
        'Alternativas como renta básica universal'
      ],
      evidence: [
        'Estudios de la OIT sobre salarios mínimos',
        'Experiencias en países como Alemania y Reino Unido',
        'Impacto en pequeñas empresas',
        'Efectos en inflación histórica'
      ],
    ),
    
    DebateMotion(
      id: 'motion_002',
      title: 'Esta Casa cree que la privacidad es más valiosa que la seguridad',
      description: 'Debate sobre el balance entre privacidad individual y seguridad nacional',
      category: 'Valor',
      difficulty: 'advanced',
      type: 'Value',
      context: 'En la era de la vigilancia digital y el terrorismo',
      keyArguments: [
        'Derecho fundamental a la privacidad',
        'Prevención de abusos gubernamentales',
        'Necesidad de seguridad nacional',
        'Protección contra amenazas reales',
        'Balance entre derechos individuales y colectivos'
      ],
      evidence: [
        'Caso Snowden y vigilancia masiva',
        'Estadísticas de ataques terroristas prevenidos',
        'Jurisprudencia sobre privacidad',
        'Tecnologías de vigilancia actuales'
      ],
    ),
    
    DebateMotion(
      id: 'motion_003',
      title: 'Esta Casa cree que el cambio climático es causado principalmente por la actividad humana',
      description: 'Debate sobre las causas del cambio climático',
      category: 'Ciencia',
      difficulty: 'beginner',
      type: 'Fact',
      context: 'Consenso científico vs. escepticismo',
      keyArguments: [
        'Consenso del 97% de científicos climáticos',
        'Correlación entre emisiones CO2 y temperatura',
        'Variabilidad natural del clima',
        'Incertidumbre en modelos climáticos',
        'Evidencia paleoclimática'
      ],
      evidence: [
        'Informes del IPCC',
        'Datos de temperatura histórica',
        'Concentraciones de CO2 atmosférico',
        'Estudios de variabilidad solar'
      ],
    ),
    
    DebateMotion(
      id: 'motion_004',
      title: 'Esta Casa cree que la inteligencia artificial superará a la humana en todas las tareas cognitivas',
      description: 'Debate sobre el futuro de la IA y sus capacidades',
      category: 'Tecnología',
      difficulty: 'advanced',
      type: 'Fact',
      context: 'Rápido desarrollo de IA y sus implicaciones',
      keyArguments: [
        'Progreso exponencial en IA',
        'Capacidades únicas humanas (creatividad, empatía)',
        'Limitaciones fundamentales de la IA',
        'Singularidad tecnológica',
        'Diferencias entre procesamiento y comprensión'
      ],
      evidence: [
        'Avances en GPT, AlphaFold, etc.',
        'Estudios sobre creatividad humana',
        'Limitaciones de algoritmos actuales',
        'Predicciones de expertos en IA'
      ],
    ),
    
    DebateMotion(
      id: 'motion_005',
      title: 'Esta Casa cree que el individualismo es superior al colectivismo',
      description: 'Debate sobre filosofías sociales y sus méritos',
      category: 'Filosofía',
      difficulty: 'intermediate',
      type: 'Value',
      context: 'Tensiones entre derechos individuales y bien común',
      keyArguments: [
        'Libertad individual como valor fundamental',
        'Innovación y progreso personal',
        'Importancia de la solidaridad social',
        'Eficiencia de sistemas colectivos',
        'Balance entre autonomía y comunidad'
      ],
      evidence: [
        'Países con diferentes enfoques (EE.UU. vs. países nórdicos)',
        'Estudios sobre felicidad y bienestar',
        'Innovación en sociedades individualistas',
        'Cohesión social en sociedades colectivistas'
      ],
    ),
  ];

  // === EJERCICIOS PRÁCTICOS ===
  
  static const List<Exercise> practicalExercises = [
    Exercise(
      id: 'ex_001',
      title: 'Identificar Falacias',
      description: 'Reconoce las falacias en argumentos dados',
      type: 'identification',
      difficulty: 'beginner',
      content: '''
# Ejercicio: Identificar Falacias

## Instrucciones:
Lee cada argumento y identifica qué tipo de falacia contiene.

## Argumento 1:
"El Dr. Smith, que es dentista, dice que las vacunas causan autismo. Por tanto, las vacunas son peligrosas."

**Falacia**: Appeal to Authority (autoridad inapropiada)

## Argumento 2:
"Si permitimos que los estudiantes usen calculadoras, pronto querrán usar computadoras en todos los exámenes, y después no sabrán hacer matemáticas básicas."

**Falacia**: Slippery Slope

## Argumento 3:
"Mi vecino se mudó después de que se construyó la nueva fábrica, por tanto la fábrica lo obligó a mudarse."

**Falacia**: Post Hoc Ergo Propter Hoc

## Argumento 4:
"O estás con nosotros en la guerra contra el terrorismo, o estás con los terroristas."

**Falacia**: Falsa Dicotomía
''',
      answers: [
        'Appeal to Authority',
        'Slippery Slope', 
        'Post Hoc Ergo Propter Hoc',
        'Falsa Dicotomía'
      ],
    ),
    
    Exercise(
      id: 'ex_002',
      title: 'Construir Argumentos AREAL',
      description: 'Crea argumentos usando la estructura AREAL',
      type: 'construction',
      difficulty: 'intermediate',
      content: '''
# Ejercicio: Construir Argumentos AREAL

## Instrucciones:
Para la afirmación "El gobierno debería invertir más en educación pública", construye un argumento completo usando AREAL.

## Ejemplo de respuesta:

**A - Afirmación**: El gobierno debería invertir más en educación pública

**R - Razón**: Porque la educación es la base del desarrollo económico y social

**E - Evidencia**: 
- Países con mayor inversión en educación tienen mayor PIB per cápita
- Cada año adicional de educación aumenta ingresos en 10%
- Finlandia invierte 6.8% del PIB en educación vs. 4.2% en México

**A - Análisis**: La evidencia muestra que la educación genera retornos económicos claros y mejora la competitividad nacional

**L - Limitaciones**: Aunque requiere recursos significativos, los beneficios a largo plazo superan los costos
''',
      answers: [
        'Afirmación clara y específica',
        'Razón lógica y relevante',
        'Evidencia concreta y creíble',
        'Análisis que conecta evidencia con razón',
        'Reconocimiento de limitaciones'
      ],
    ),
  ];

  // === MÉTODOS DE ENTRENAMIENTO ===
  
  static const List<TrainingMethod> trainingMethods = [
    TrainingMethod(
      id: 'train_001',
      name: 'Debate Rápido',
      description: 'Debates de 3 minutos por lado',
      duration: 6,
      difficulty: 'beginner',
      focus: 'Estructura básica y tiempo',
    ),
    
    TrainingMethod(
      id: 'train_002',
      name: 'Refutación Dirigida',
      description: 'Enfocarse solo en técnicas de refutación',
      duration: 10,
      difficulty: 'intermediate',
      focus: 'Técnicas de refutación',
    ),
    
    TrainingMethod(
      id: 'train_003',
      name: 'Debate de Mociones de Valor',
      description: 'Práctica específica con mociones de valor',
      duration: 15,
      difficulty: 'advanced',
      focus: 'Criterios de evaluación y principios',
    ),
  ];
}
