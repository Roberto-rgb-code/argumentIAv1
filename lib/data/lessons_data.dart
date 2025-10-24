import '../models/lesson_models.dart';
import 'argumentation_theory.dart';

class LessonsData {
  static List<Lesson> getAllLessons() {
    return [
      // === FUNDAMENTOS AREAL ===
      ..._getArealLessons(),
      // === FALACIAS LÓGICAS ===
      ..._getFalaciasLessons(),
      // === FORTALECER ARGUMENTOS ===
      ..._getFortalecerLessons(),
      // === COMPLETAR ARGUMENTOS ===
      ..._getCompletarLessons(),
      // === REFUTACIÓN ===
      ..._getRefutacionLessons(),
      // === EVIDENCIA ===
      ..._getEvidenciaLessons(),
      // === RAZONAMIENTO ===
      ..._getRazonamientoLessons(),
      // === LIMITACIONES ===
      ..._getLimitacionesLessons(),
    ];
  }

  static List<Lesson> _getArealLessons() {
    return [
      Lesson(
        id: 'areal-1',
        title: 'Introducción a AREAL',
        description: 'Aprende los fundamentos del método AREAL para estructurar argumentos sólidos.',
        type: LessonType.areal,
        difficulty: Difficulty.basico,
        estimatedMinutes: 15,
        tags: ['AREAL', 'Estructura', 'Argumentación'],
        pointsReward: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        exercises: [
          Exercise(
            id: 'areal-1-1',
            title: 'Componentes AREAL',
            instruction: 'Identifica los 4 componentes del método AREAL',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '¿Cuáles son los componentes de AREAL?',
              'options': [
                'Afirmación, Razonamiento, Evidencia, Limitaciones',
                'Argumento, Razón, Ejemplo, Límite',
                'Análisis, Reflexión, Evaluación, Lógica',
              ],
            },
            correctAnswers: ['0'],
            points: 25,
            hint: 'AREAL es un acrónimo que representa la estructura de un argumento.',
            explanation: 'AREAL significa: Afirmación (tesis principal), Razonamiento (por qué), Evidencia (pruebas), Limitaciones (reconocimiento de debilidades).',
          ),
          Exercise(
            id: 'areal-1-2',
            title: 'Orden AREAL',
            instruction: 'Ordena los componentes AREAL en la secuencia correcta',
            type: ExerciseType.dragAndDrop,
            content: {
              'question': 'Ordena los pasos del método AREAL:',
              'items': ['Afirmación', 'Razonamiento', 'Evidencia', 'Limitaciones'],
            },
            correctAnswers: ['0', '1', '2', '3'],
            points: 30,
            hint: 'La afirmación va primero, seguida del razonamiento.',
            explanation: 'El orden correcto es: Afirmación → Razonamiento → Evidencia → Limitaciones.',
          ),
        ],
      ),
      Lesson(
        id: 'areal-2',
        title: 'Construyendo Afirmaciones',
        description: 'Domina el arte de crear afirmaciones claras y específicas.',
        type: LessonType.areal,
        difficulty: Difficulty.basico,
        estimatedMinutes: 12,
        tags: ['Afirmación', 'Tesis', 'Claridad'],
        pointsReward: 80,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        exercises: [
          Exercise(
            id: 'areal-2-1',
            title: 'Afirmación Clara',
            instruction: 'Selecciona la afirmación más clara y específica',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '¿Cuál es la mejor afirmación?',
              'options': [
                'La educación es importante para el desarrollo de un país.',
                'La educación pública gratuita y de calidad es fundamental para el desarrollo económico y social de un país.',
                'Todos deberían ir a la escuela.',
              ],
            },
            correctAnswers: ['1'],
            points: 25,
            hint: 'Busca afirmaciones específicas y bien definidas.',
            explanation: 'La segunda opción es más específica, clara y proporciona contexto sobre el tipo de educación y sus beneficios.',
          ),
          Exercise(
            id: 'areal-2-2',
            title: 'Completar Afirmación',
            instruction: 'Completa la afirmación de manera clara y específica',
            type: ExerciseType.textInput,
            content: {
              'question': 'Completa: "La implementación de energías renovables es..."',
              'placeholder': 'Escribe tu completado aquí',
            },
            correctAnswers: ['necesaria', 'importante', 'crucial', 'esencial'],
            points: 30,
            hint: 'Usa adjetivos que expresen importancia o necesidad.',
            explanation: 'Las afirmaciones deben ser claras y expresar una posición definida.',
          ),
        ],
      ),
      Lesson(
        id: 'areal-3',
        title: 'Desarrollando Razonamientos',
        description: 'Aprende a construir razonamientos lógicos y convincentes.',
        type: LessonType.areal,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 18,
        tags: ['Razonamiento', 'Lógica', 'Causa-Efecto'],
        pointsReward: 120,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        exercises: [
          Exercise(
            id: 'areal-3-1',
            title: 'Razonamiento Lógico',
            instruction: 'Identifica el mejor razonamiento para la afirmación',
            type: ExerciseType.multipleChoice,
            content: {
              'affirmation': 'La implementación de trabajo remoto mejora la productividad.',
              'question': '¿Cuál es el mejor razonamiento?',
              'options': [
                'Porque es más cómodo trabajar desde casa.',
                'Porque reduce el tiempo de desplazamiento, permite mayor flexibilidad horaria y disminuye las distracciones del entorno laboral.',
                'Porque a todo el mundo le gusta.',
              ],
            },
            correctAnswers: ['1'],
            points: 35,
            hint: 'Busca razonamientos que conecten directamente con la afirmación.',
            explanation: 'El segundo razonamiento proporciona múltiples causas lógicas que apoyan la afirmación sobre productividad.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getFalaciasLessons() {
    return [
      Lesson(
        id: 'falacias-1',
        title: 'Falacias Comunes',
        description: 'Identifica y evita las falacias lógicas más frecuentes en debates.',
        type: LessonType.falacias,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 20,
        tags: ['Falacias', 'Lógica', 'Errores'],
        pointsReward: 150,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        exercises: [
          Exercise(
            id: 'falacias-1-1',
            title: 'Identificar Falacias',
            instruction: 'Identifica la falacia lógica en el siguiente argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '"Si no apoyas esta política, entonces estás en contra del progreso y quieres que la sociedad retroceda."',
              'options': [
                'Falso dilema',
                'Ad hominem',
                'Apelación a la autoridad',
                'Hombre de paja',
              ],
            },
            correctAnswers: ['0'],
            points: 30,
            hint: 'Esta falacia presenta solo dos opciones cuando hay más posibilidades.',
            explanation: 'El falso dilema presenta una situación como si solo tuviera dos opciones, cuando en realidad hay más alternativas.',
          ),
          Exercise(
            id: 'falacias-1-2',
            title: 'Ad Hominem',
            instruction: 'Identifica el ataque personal en el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '"Tu propuesta no tiene sentido porque eres demasiado joven para entender estos temas."',
              'options': [
                'Ad hominem',
                'Falso dilema',
                'Apelación a la autoridad',
                'Falacia del hombre de paja',
              ],
            },
            correctAnswers: ['0'],
            points: 30,
            hint: 'Busca ataques a la persona en lugar del argumento.',
            explanation: 'Ad hominem ataca a la persona que hace el argumento en lugar de refutar el argumento mismo.',
          ),
        ],
      ),
      Lesson(
        id: 'falacias-2',
        title: 'Falacia del Hombre de Paja',
        description: 'Aprende a identificar cuando alguien distorsiona tu argumento.',
        type: LessonType.falacias,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 15,
        tags: ['Hombre de paja', 'Distorsión', 'Refutación'],
        pointsReward: 120,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        exercises: [
          Exercise(
            id: 'falacias-2-1',
            title: 'Detectar Hombre de Paja',
            instruction: 'Identifica la distorsión del argumento original',
            type: ExerciseType.multipleChoice,
            content: {
              'original': 'Creo que deberíamos reducir el uso de plásticos para proteger el medio ambiente.',
              'distorted': 'Entonces quieres que eliminemos todos los productos de plástico y volvamos a la edad de piedra.',
              'question': '¿Qué falacia se está cometiendo?',
              'options': [
                'Hombre de paja',
                'Ad hominem',
                'Falso dilema',
                'Apelación a la autoridad',
              ],
            },
            correctAnswers: ['0'],
            points: 35,
            hint: 'El argumento distorsionado es una versión exagerada del original.',
            explanation: 'La falacia del hombre de paja distorsiona o exagera el argumento del oponente para hacerlo más fácil de refutar.',
          ),
        ],
      ),
      Lesson(
        id: 'falacias-3',
        title: 'Falacia de Apelación a la Autoridad',
        description: 'Identifica cuando se usa incorrectamente la autoridad como prueba.',
        type: LessonType.falacias,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 18,
        tags: ['Autoridad', 'Credibilidad', 'Evidencia'],
        pointsReward: 140,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        exercises: [
          Exercise(
            id: 'falacias-3-1',
            title: 'Autoridad Inapropiada',
            instruction: 'Identifica el uso incorrecto de la autoridad',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '"El Dr. García, que es médico, dice que esta dieta es la mejor para todos."',
              'options': [
                'Apelación a la autoridad inapropiada',
                'Argumento válido',
                'Ad hominem',
                'Falso dilema',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Considera si la autoridad es relevante para el tema.',
            explanation: 'Aunque el Dr. García es médico, eso no lo hace experto en nutrición. La autoridad debe ser relevante al tema.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getFortalecerLessons() {
    return [
      Lesson(
        id: 'fortalecer-1',
        title: 'Fortaleciendo Argumentos',
        description: 'Aprende técnicas para hacer tus argumentos más convincentes.',
        type: LessonType.fortalecerArgumento,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 22,
        tags: ['Fortalecer', 'Convicción', 'Técnicas'],
        pointsReward: 160,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        exercises: [
          Exercise(
            id: 'fortalecer-1-1',
            title: 'Mejor Evidencia',
            instruction: 'Selecciona la mejor evidencia para fortalecer el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La inversión en energías renovables es crucial para un futuro sostenible.',
              'question': '¿Cuál es la mejor evidencia para apoyar este argumento?',
              'options': [
                'Un informe del IPCC confirma que las renovables pueden mitigar drásticamente las emisiones de CO2.',
                'Los coches eléctricos son cada vez más populares entre los consumidores.',
                'El costo de los paneles solares ha disminuido un 10% en el último año.',
              ],
            },
            correctAnswers: ['0'],
            points: 35,
            hint: 'Busca evidencia que conecte directamente con la sostenibilidad y el impacto ambiental.',
            explanation: 'El informe del IPCC es evidencia científica sólida que conecta directamente las energías renovables con la sostenibilidad ambiental.',
          ),
          Exercise(
            id: 'fortalecer-1-2',
            title: 'Agregar Estadísticas',
            instruction: 'Selecciona la estadística más relevante para el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La educación temprana es fundamental para el desarrollo cognitivo.',
              'question': '¿Qué estadística fortalece mejor este argumento?',
              'options': [
                'Los niños que reciben educación temprana tienen 40% más probabilidades de graduarse de la universidad.',
                'El 85% de los padres cree que la educación es importante.',
                'Las escuelas primarias tienen más estudiantes que las secundarias.',
              ],
            },
            correctAnswers: ['0'],
            points: 35,
            hint: 'Busca estadísticas que muestren resultados concretos y medibles.',
            explanation: 'La primera estadística muestra un resultado específico y medible del impacto de la educación temprana.',
          ),
        ],
      ),
      Lesson(
        id: 'fortalecer-2',
        title: 'Usando Analogías',
        description: 'Aprende a usar analogías efectivas para fortalecer argumentos.',
        type: LessonType.fortalecerArgumento,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 20,
        tags: ['Analogías', 'Comparaciones', 'Claridad'],
        pointsReward: 150,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        exercises: [
          Exercise(
            id: 'fortalecer-2-1',
            title: 'Analogía Efectiva',
            instruction: 'Selecciona la analogía más efectiva para el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La diversidad en equipos de trabajo mejora la innovación.',
              'question': '¿Cuál es la mejor analogía?',
              'options': [
                'Como un jardín con diferentes tipos de flores, la diversidad en equipos crea un ecosistema más rico y productivo.',
                'Los equipos diversos son como equipos de fútbol con jugadores de diferentes posiciones.',
                'La diversidad es buena porque todos somos diferentes.',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Busca analogías que conecten claramente con el beneficio del argumento.',
            explanation: 'La analogía del jardín conecta directamente la diversidad con la riqueza y productividad, reforzando el argumento.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getCompletarLessons() {
    return [
      Lesson(
        id: 'completar-1',
        title: 'Completar Argumentos',
        description: 'Practica completando argumentos usando la estructura AREAL.',
        type: LessonType.completarArgumento,
        difficulty: Difficulty.basico,
        estimatedMinutes: 15,
        tags: ['Completar', 'AREAL', 'Práctica'],
        pointsReward: 100,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        exercises: [
          Exercise(
            id: 'completar-1-1',
            title: 'Completar Afirmación',
            instruction: 'Completa la afirmación de manera clara',
            type: ExerciseType.textInput,
            content: {
              'question': 'Completa: "La implementación de políticas de trabajo remoto..."',
              'placeholder': 'Escribe tu afirmación aquí',
            },
            correctAnswers: ['mejora la productividad', 'aumenta la satisfacción laboral', 'reduce costos operativos', 'permite mayor flexibilidad'],
            points: 30,
            hint: 'Considera los beneficios del trabajo remoto.',
            explanation: 'Las afirmaciones deben ser claras y expresar un beneficio o resultado específico.',
          ),
          Exercise(
            id: 'completar-1-2',
            title: 'Completar Razonamiento',
            instruction: 'Completa el razonamiento para la afirmación',
            type: ExerciseType.textInput,
            content: {
              'affirmation': 'La educación en programación debe ser obligatoria en las escuelas.',
              'question': '¿Por qué? Completa el razonamiento:',
              'placeholder': 'Escribe tu razonamiento aquí',
            },
            correctAnswers: ['porque desarrolla el pensamiento lógico', 'porque prepara para el futuro digital', 'porque mejora las habilidades de resolución de problemas'],
            points: 35,
            hint: 'Piensa en los beneficios de aprender programación.',
            explanation: 'El razonamiento debe explicar por qué la afirmación es válida, conectando causa y efecto.',
          ),
        ],
      ),
      Lesson(
        id: 'completar-2',
        title: 'Completar con Evidencia',
        description: 'Aprende a agregar evidencia sólida a tus argumentos.',
        type: LessonType.completarArgumento,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 18,
        tags: ['Evidencia', 'Datos', 'Pruebas'],
        pointsReward: 130,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        exercises: [
          Exercise(
            id: 'completar-2-1',
            title: 'Agregar Evidencia',
            instruction: 'Selecciona la mejor evidencia para completar el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La implementación de energías renovables es económicamente viable.',
              'question': '¿Qué evidencia completa mejor este argumento?',
              'options': [
                'Según la Agencia Internacional de Energía, el costo de la energía solar ha disminuido un 85% en la última década.',
                'Muchas personas prefieren las energías renovables.',
                'Los paneles solares se ven bien en los techos.',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Busca evidencia que demuestre la viabilidad económica con datos específicos.',
            explanation: 'La evidencia de la AIE proporciona datos concretos sobre la reducción de costos, demostrando viabilidad económica.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getRefutacionLessons() {
    return [
      Lesson(
        id: 'refutacion-1',
        title: 'Arte de la Refutación',
        description: 'Desarrolla habilidades para refutar argumentos de manera efectiva y respetuosa.',
        type: LessonType.refutacion,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 30,
        tags: ['Refutación', 'Contraargumentos', 'Debate'],
        pointsReward: 200,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        exercises: [
          Exercise(
            id: 'refutacion-1-1',
            title: 'Refutación Respetuosa',
            instruction: 'Selecciona la mejor refutación para el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'opponent': 'La inteligencia artificial va a reemplazar todos los trabajos humanos.',
              'question': '¿Cuál es la mejor refutación?',
              'options': [
                'Eso es ridículo, no sabes de lo que hablas.',
                'Aunque la IA puede automatizar ciertas tareas, también creará nuevos tipos de empleos que requieren habilidades humanas únicas como creatividad y empatía.',
                'La IA nunca podrá hacer lo que hacen los humanos.',
              ],
            },
            correctAnswers: ['1'],
            points: 50,
            hint: 'Busca refutaciones que reconozcan parcialmente el punto del oponente pero presenten una perspectiva más matizada.',
            explanation: 'La mejor refutación reconoce la validez parcial del argumento pero presenta evidencia contraria de manera respetuosa.',
          ),
          Exercise(
            id: 'refutacion-1-2',
            title: 'Identificar Debilidades',
            instruction: 'Identifica la debilidad principal en el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'Todos los políticos son corruptos porque he visto varios casos de corrupción en las noticias.',
              'question': '¿Cuál es la debilidad principal?',
              'options': [
                'Generalización excesiva',
                'Falta de evidencia',
                'Ataque personal',
                'Falso dilema',
              ],
            },
            correctAnswers: ['0'],
            points: 45,
            hint: 'Considera si el argumento hace una afirmación demasiado amplia basada en evidencia limitada.',
            explanation: 'El argumento comete una generalización excesiva al afirmar que "todos" los políticos son corruptos basándose en casos específicos.',
          ),
        ],
      ),
      Lesson(
        id: 'refutacion-2',
        title: 'Refutación con Evidencia',
        description: 'Aprende a refutar usando datos y evidencia contraria.',
        type: LessonType.refutacion,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 25,
        tags: ['Evidencia', 'Datos', 'Contraargumentos'],
        pointsReward: 180,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        exercises: [
          Exercise(
            id: 'refutacion-2-1',
            title: 'Refutación con Datos',
            instruction: 'Selecciona la mejor refutación basada en evidencia',
            type: ExerciseType.multipleChoice,
            content: {
              'opponent': 'La educación en línea es menos efectiva que la presencial.',
              'question': '¿Cuál es la mejor refutación con evidencia?',
              'options': [
                'Estudios de la Universidad de Stanford muestran que los estudiantes en línea tienen tasas de retención 15% más altas que los presenciales.',
                'La educación en línea es igual de buena.',
                'Todo el mundo prefiere la educación presencial.',
              ],
            },
            correctAnswers: ['0'],
            points: 50,
            hint: 'Busca refutaciones que usen evidencia específica y medible.',
            explanation: 'La refutación con datos específicos de Stanford proporciona evidencia concreta que contradice la afirmación del oponente.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getEvidenciaLessons() {
    return [
      Lesson(
        id: 'evidencia-1',
        title: 'Evaluación de Evidencia',
        description: 'Aprende a evaluar la calidad y relevancia de la evidencia presentada.',
        type: LessonType.evidencia,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 22,
        tags: ['Evidencia', 'Evaluación', 'Calidad'],
        pointsReward: 160,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        exercises: [
          Exercise(
            id: 'evidencia-1-1',
            title: 'Calidad de Evidencia',
            instruction: 'Evalúa la calidad de la evidencia presentada',
            type: ExerciseType.multipleChoice,
            content: {
              'evidence': 'Un estudio de 2023 con 10,000 participantes muestra que el ejercicio regular reduce el riesgo de enfermedades cardíacas en un 30%.',
              'question': '¿Qué hace que esta evidencia sea de alta calidad?',
              'options': [
                'Tamaño de muestra grande y resultado específico',
                'Es de 2023, por lo tanto es actual',
                'Menciona enfermedades cardíacas',
                'Usa porcentajes',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Considera el tamaño de la muestra y la especificidad del resultado.',
            explanation: 'Una muestra grande (10,000) y un resultado específico y medible (30% de reducción) indican evidencia de alta calidad.',
          ),
          Exercise(
            id: 'evidencia-1-2',
            title: 'Relevancia de Evidencia',
            instruction: 'Determina si la evidencia es relevante para el argumento',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La implementación de políticas de trabajo remoto mejora la productividad empresarial.',
              'evidence': 'Un estudio muestra que los empleados remotos reportan mayor satisfacción laboral.',
              'question': '¿Es esta evidencia relevante?',
              'options': [
                'Sí, porque la satisfacción laboral puede relacionarse con la productividad',
                'No, porque no mide directamente la productividad',
                'Parcialmente, pero necesita más conexión',
              ],
            },
            correctAnswers: ['2'],
            points: 35,
            hint: 'Considera si la evidencia se conecta directamente con la afirmación del argumento.',
            explanation: 'La evidencia es parcialmente relevante pero necesita una conexión más directa entre satisfacción laboral y productividad.',
          ),
        ],
      ),
      Lesson(
        id: 'evidencia-2',
        title: 'Tipos de Evidencia',
        description: 'Aprende a distinguir entre diferentes tipos de evidencia y su valor.',
        type: LessonType.evidencia,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 20,
        tags: ['Tipos', 'Credibilidad', 'Fuentes'],
        pointsReward: 150,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        exercises: [
          Exercise(
            id: 'evidencia-2-1',
            title: 'Evidencia Científica vs Anecdótica',
            instruction: 'Identifica el tipo de evidencia presentada',
            type: ExerciseType.multipleChoice,
            content: {
              'evidence': 'Mi vecino cambió a una dieta vegana y perdió 10 kilos en un mes.',
              'question': '¿Qué tipo de evidencia es esta?',
              'options': [
                'Evidencia anecdótica',
                'Evidencia científica',
                'Evidencia estadística',
                'Evidencia experimental',
              ],
            },
            correctAnswers: ['0'],
            points: 30,
            hint: 'Considera si la evidencia se basa en una experiencia individual o en datos sistemáticos.',
            explanation: 'Esta es evidencia anecdótica porque se basa en la experiencia individual de una persona, no en datos sistemáticos.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getRazonamientoLessons() {
    return [
      Lesson(
        id: 'razonamiento-1',
        title: 'Razonamiento Inductivo',
        description: 'Aprende a construir argumentos basados en patrones y generalizaciones.',
        type: LessonType.razonamiento,
        difficulty: Difficulty.intermedio,
        estimatedMinutes: 20,
        tags: ['Inductivo', 'Patrones', 'Generalizaciones'],
        pointsReward: 140,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        exercises: [
          Exercise(
            id: 'razonamiento-1-1',
            title: 'Razonamiento Inductivo Válido',
            instruction: 'Identifica el razonamiento inductivo más sólido',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '¿Cuál es el mejor ejemplo de razonamiento inductivo?',
              'options': [
                'En las últimas 5 elecciones, el candidato con más publicidad ha ganado. Por tanto, el candidato con más publicidad ganará la próxima elección.',
                'Todos los cisnes que he visto son blancos, por tanto todos los cisnes son blancos.',
                'Mi amigo aprobó el examen estudiando 2 horas diarias, por tanto yo también aprobaré estudiando 2 horas diarias.',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Busca razonamientos que se basen en patrones observados y sean razonablemente generalizables.',
            explanation: 'El primer ejemplo muestra un patrón observado en múltiples casos y hace una predicción razonable basada en ese patrón.',
          ),
        ],
      ),
      Lesson(
        id: 'razonamiento-2',
        title: 'Razonamiento Deductivo',
        description: 'Domina la lógica deductiva para construir argumentos sólidos.',
        type: LessonType.razonamiento,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 25,
        tags: ['Deductivo', 'Lógica', 'Silogismos'],
        pointsReward: 170,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
        exercises: [
          Exercise(
            id: 'razonamiento-2-1',
            title: 'Silogismo Válido',
            instruction: 'Identifica el silogismo lógicamente válido',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '¿Cuál es un silogismo válido?',
              'options': [
                'Todos los mamíferos son animales. Los perros son mamíferos. Por tanto, los perros son animales.',
                'Algunos estudiantes son inteligentes. Juan es estudiante. Por tanto, Juan es inteligente.',
                'Todos los pájaros vuelan. Los pingüinos son pájaros. Por tanto, los pingüinos vuelan.',
              ],
            },
            correctAnswers: ['0'],
            points: 45,
            hint: 'Busca silogismos donde las premisas sean verdaderas y la conclusión se siga lógicamente.',
            explanation: 'El primer silogismo es válido porque las premisas son verdaderas y la conclusión se sigue lógicamente de ellas.',
          ),
        ],
      ),
    ];
  }

  static List<Lesson> _getLimitacionesLessons() {
    return [
      Lesson(
        id: 'limitaciones-1',
        title: 'Reconociendo Limitaciones',
        description: 'Aprende a reconocer y comunicar las limitaciones de tus argumentos.',
        type: LessonType.limitaciones,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 18,
        tags: ['Limitaciones', 'Honestidad', 'Credibilidad'],
        pointsReward: 160,
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        exercises: [
          Exercise(
            id: 'limitaciones-1-1',
            title: 'Reconocer Limitaciones',
            instruction: 'Identifica la mejor manera de reconocer limitaciones',
            type: ExerciseType.multipleChoice,
            content: {
              'argument': 'La implementación de energías renovables reducirá significativamente las emisiones de CO2.',
              'question': '¿Cuál es la mejor manera de reconocer limitaciones?',
              'options': [
                'Sin embargo, es importante reconocer que la transición requerirá inversiones significativas y tiempo para implementarse completamente.',
                'Este argumento es perfecto y no tiene limitaciones.',
                'Aunque hay algunas limitaciones, no son importantes.',
              ],
            },
            correctAnswers: ['0'],
            points: 40,
            hint: 'Busca reconocimientos honestos y específicos de limitaciones reales.',
            explanation: 'Reconocer limitaciones específicas y reales fortalece la credibilidad del argumento y muestra honestidad intelectual.',
          ),
        ],
      ),
      Lesson(
        id: 'limitaciones-2',
        title: 'Limitaciones como Fortaleza',
        description: 'Aprende a usar el reconocimiento de limitaciones para fortalecer tu argumento.',
        type: LessonType.limitaciones,
        difficulty: Difficulty.avanzado,
        estimatedMinutes: 20,
        tags: ['Credibilidad', 'Honestidad', 'Fortaleza'],
        pointsReward: 150,
        createdAt: DateTime.now(),
        exercises: [
          Exercise(
            id: 'limitaciones-2-1',
            title: 'Limitaciones Constructivas',
            instruction: 'Selecciona la mejor manera de presentar limitaciones',
            type: ExerciseType.multipleChoice,
            content: {
              'question': '¿Cómo presentarías las limitaciones de manera constructiva?',
              'options': [
                'Aunque este estudio tiene limitaciones en su alcance geográfico, sus hallazgos proporcionan una base sólida para futuras investigaciones.',
                'Este estudio tiene muchas limitaciones pero aún así es válido.',
                'Las limitaciones no importan porque el resultado es correcto.',
              ],
            },
            correctAnswers: ['0'],
            points: 45,
            hint: 'Busca presentaciones que reconozcan limitaciones pero también destaquen el valor del argumento.',
            explanation: 'Presentar limitaciones de manera constructiva muestra honestidad intelectual y puede fortalecer la credibilidad del argumento.',
          ),
        ],
      ),
    ];
  }

  // === TEORÍA DE ARGUMENTACIÓN ===
  static List<Lesson> _getArgumentationTheoryLessons() {
    return ArgumentationTheory.argumentationTheory.map((theory) {
      return Lesson(
        id: theory.id,
        title: theory.title,
        description: theory.description,
        category: theory.category,
        difficulty: theory.difficulty,
        estimatedTime: theory.estimatedTime,
        xpReward: _getXpReward(theory.difficulty),
        exercises: _convertTheoryToExercises(theory),
      );
    }).toList();
  }

  // === TÉCNICAS DE REFUTACIÓN ===
  static List<Lesson> _getRefutationLessons() {
    return ArgumentationTheory.refutationTechniques.map((theory) {
      return Lesson(
        id: theory.id,
        title: theory.title,
        description: theory.description,
        category: theory.category,
        difficulty: theory.difficulty,
        estimatedTime: theory.estimatedTime,
        xpReward: _getXpReward(theory.difficulty),
        exercises: _convertTheoryToExercises(theory),
      );
    }).toList();
  }

  // === TIPOS DE MOCIONES ===
  static List<Lesson> _getMotionTypesLessons() {
    return ArgumentationTheory.motionTypes.map((theory) {
      return Lesson(
        id: theory.id,
        title: theory.title,
        description: theory.description,
        category: theory.category,
        difficulty: theory.difficulty,
        estimatedTime: theory.estimatedTime,
        xpReward: _getXpReward(theory.difficulty),
        exercises: _convertTheoryToExercises(theory),
      );
    }).toList();
  }

  // === TIPOS DE FALACIAS ===
  static List<Lesson> _getFallacyTypesLessons() {
    return ArgumentationTheory.fallacyTypes.map((theory) {
      return Lesson(
        id: theory.id,
        title: theory.title,
        description: theory.description,
        category: theory.category,
        difficulty: theory.difficulty,
        estimatedTime: theory.estimatedTime,
        xpReward: _getXpReward(theory.difficulty),
        exercises: _convertTheoryToExercises(theory),
      );
    }).toList();
  }

  // === MÉTODOS AUXILIARES ===
  
  static int _getXpReward(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner': return 25;
      case 'intermediate': return 50;
      case 'advanced': return 75;
      default: return 25;
    }
  }

  static List<Exercise> _convertTheoryToExercises(TheorySection theory) {
    return [
      Exercise(
        id: '${theory.id}_ex_001',
        title: 'Comprensión de ${theory.title}',
        description: 'Ejercicio de comprensión sobre ${theory.title}',
        type: 'comprehension',
        difficulty: theory.difficulty,
        content: '''
# ${theory.title}

${theory.content}

## Pregunta de Comprensión:
Basándote en el contenido anterior, responde la siguiente pregunta:

¿Cuál es el concepto principal de ${theory.title}?

## Opciones:
A) Un concepto básico de argumentación
B) Una técnica avanzada de debate
C) Un tipo de falacia común
D) Una metodología de refutación
''',
        answers: ['A'],
        points: _getXpReward(theory.difficulty),
        hint: 'Revisa cuidadosamente el contenido teórico para identificar el concepto principal.',
        explanation: 'El concepto principal se encuentra en la definición y explicación del contenido teórico.',
      ),
    ];
  }
}
