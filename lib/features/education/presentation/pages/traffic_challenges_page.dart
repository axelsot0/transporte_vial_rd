import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TrafficChallengesPage extends StatefulWidget {
  const TrafficChallengesPage({super.key});

  @override
  State<TrafficChallengesPage> createState() => _TrafficChallengesPageState();
}

class _TrafficChallengesPageState extends State<TrafficChallengesPage> {
  int currentLevel = 2;
  int currentXP = 60;
  int maxXP = 100;
  List<String> earnedBadges = ['Traffic Light Master', 'Stop Sign Expert'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Desafíos de Tráfico',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header con progreso
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar y nivel
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'S',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nivel $currentLevel: Principiante',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Barra de progreso
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$currentXP/$maxXP XP',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.gray.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: currentXP / maxXP,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges obtenidos
                    const Text(
                      'Insignias Obtenidas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildBadge('Traffic Light Master', Icons.traffic, AppColors.secondary, true),
                          const SizedBox(width: 12),
                          _buildBadge('Stop Sign Expert', Icons.stop, Colors.red, true),
                          const SizedBox(width: 12),
                          _buildBadge('Speed Limit Pro', Icons.speed, AppColors.brown, false),
                          const SizedBox(width: 12),
                          _buildBadge('Parking Expert', Icons.local_parking, Colors.purple, false),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Nuevo desafío
                    const Text(
                      'Comenzar Nuevo Desafío',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.quiz,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Desafío de Señales',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Pon a prueba tu conocimiento sobre las señales de tránsito en República Dominicana. Gana XP y badges al completar desafíos.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.brown,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QuizPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Comenzar Desafío',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Estadísticas
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tus Estadísticas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard('Desafíos\nCompletados', '12', Icons.check_circle, AppColors.secondary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard('Respuestas\nCorrectas', '89%', Icons.trending_up, AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard('Racha\nActual', '5', Icons.local_fire_department, Colors.orange),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Espacio para navbar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBadge(String title, IconData icon, Color color, bool earned) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? AppColors.white : AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? color : AppColors.gray.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: earned ? color.withOpacity(0.1) : AppColors.gray.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: earned ? color : AppColors.gray,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: earned ? AppColors.dark : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;
  bool showResult = false;
  bool quizCompleted = false;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Preguntas del quiz (simulando IA generativa)
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Si yo me voy en rojo porque los motoristas se fueron también...',
      'options': [
        'Me dan un premio por llegar de primero',
        'Es correcto porque yo no tengo licencia',
        'Me tienen que poner día a recoger basura por abusador.',
        'Está bien si no viene nadie'
      ],
      'correctAnswer': 2,
      'explanation': 'Es incorrecto saltarse un semáforo en rojo, independientemente de lo que hagan otros conductores. Esto puede resultar en multas y es peligroso.',
      'points': 10,
    },
    {
      'question': '¿Cuál es la velocidad máxima permitida en zonas urbanas de República Dominicana?',
      'options': [
        '35 km/h',
        '60 km/h', 
        '80 km/h',
        '100 km/h'
      ],
      'correctAnswer': 1,
      'explanation': 'En zonas urbanas, la velocidad máxima es 60 km/h según la Ley de Tránsito dominicana.',
      'points': 15,
    },
    {
      'question': '¿Qué significa una señal de PARE octagonal roja?',
      'options': [
        'Disminuir la velocidad',
        'Detenerse completamente y ceder el paso',
        'Tocar la bocina',
        'Acelerar para pasar rápido'
      ],
      'correctAnswer': 1,
      'explanation': 'La señal de PARE requiere que te detengas completamente y cedas el paso antes de continuar.',
      'points': 10,
    },
    {
      'question': '¿Cuándo es obligatorio usar cinturón de seguridad?',
      'options': [
        'Solo en autopistas',
        'Solo el conductor',
        'Siempre, todos los ocupantes',
        'Solo de noche'
      ],
      'correctAnswer': 2,
      'explanation': 'El uso del cinturón de seguridad es obligatorio para todos los ocupantes del vehículo en todo momento.',
      'points': 10,
    },
    {
      'question': '¿Está permitido usar el teléfono móvil mientras conduces?',
      'options': [
        'Sí, siempre',
        'Solo para llamadas importantes',
        'No, está prohibido',
        'Solo con manos libres'
      ],
      'correctAnswer': 3,
      'explanation': 'Se permite usar el teléfono solo con dispositivos de manos libres. Usar el teléfono manualmente mientras se conduce está prohibido.',
      'points': 15,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswer = questions[currentQuestionIndex]['options'][answerIndex];
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null) return;
    
    final currentQuestion = questions[currentQuestionIndex];
    final correctIndex = currentQuestion['correctAnswer'];
    final isCorrect = selectedAnswer == currentQuestion['options'][correctIndex];
    
    if (isCorrect) {
      score += currentQuestion['points'] as int;
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    
    setState(() {
      showResult = true;
    });
    
    // Mostrar resultado por 2 segundos, luego siguiente pregunta
    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswer = null;
          showResult = false;
        });
      } else {
        setState(() {
          quizCompleted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizCompleted) {
      return _buildCompletionScreen();
    }
    
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;
    
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pregunta ${currentQuestionIndex + 1} de ${questions.length}',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de progreso
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puntuación: $score',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.gray.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          
          // Contenido de la pregunta
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: showResult ? _buildResultView() : _buildQuestionView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestionView() {
    final currentQuestion = questions[currentQuestionIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pregunta
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            currentQuestion['question'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
              height: 1.4,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Opciones
        Expanded(
          child: ListView.builder(
            itemCount: currentQuestion['options'].length,
            itemBuilder: (context, index) {
              final option = currentQuestion['options'][index];
              final isSelected = selectedAnswer == option;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => selectAnswer(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.gray,
                              width: 2,
                            ),
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? AppColors.primary : AppColors.dark,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Botón responder
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: selectedAnswer != null ? submitAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.gray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Responder',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultView() {
    final currentQuestion = questions[currentQuestionIndex];
    final correctIndex = currentQuestion['correctAnswer'];
    final isCorrect = selectedAnswer == currentQuestion['options'][correctIndex];
    
    return Column(
      children: [
        // Resultado
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isCorrect ? _scaleAnimation.value : 1.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isCorrect ? const Color(0xFF4CAF50) : Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: AppColors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isCorrect ? '¡Correcto!' : 'Incorrecto',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    if (isCorrect) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+${currentQuestion['points']} puntos',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Explicación
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explicación:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentQuestion['explanation'],
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.brown,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompletionScreen() {
    final percentage = (score / questions.fold(0, (sum, q) => sum + (q['points'] as int))) * 100;
    final passed = percentage >= 70;
    
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Resultado final
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: passed ? const Color(0xFF4CAF50) : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      passed ? Icons.emoji_events : Icons.school,
                      color: AppColors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      passed ? '¡Felicidades!' : '¡Buen intento!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Puntuación: $score puntos',
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.round()}% correcto',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              if (passed) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.stars,
                        color: Colors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '¡Has desbloqueado una nueva insignia!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Volver'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex = 0;
                          score = 0;
                          selectedAnswer = null;
                          showResult = false;
                          quizCompleted = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Repetir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}