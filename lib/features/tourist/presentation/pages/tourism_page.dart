import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';

class TourismPage extends StatefulWidget {
  const TourismPage({super.key});

  @override
  State<TourismPage> createState() => _TourismPageState();
}

class _TourismPageState extends State<TourismPage> {
  PageController pageController = PageController();
  int currentStep = 0;
  bool isGenerating = false;
  String? generatedTour;
  
  // Respuestas del usuario
  Map<String, dynamic> userPreferences = {
    'interests': <String>[],
    'time': '',
    'pace': '',
    'budget': '',
    'groupType': '',
  };

  // API Key de OpenAI - REEMPLAZA CON TU API KEY REAL
  final String apiKey = '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'; // ⚠️ CAMBIAR ESTA LÍNEA

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
          'Planifica tu Viaje',
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
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: index <= currentStep ? AppColors.primary : AppColors.gray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildInterestsStep(),
                  _buildTimeStep(),
                  _buildPaceStep(),
                  _buildGenerateStep(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInterestsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '¿Qué te interesa?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona todas las opciones que te llamen la atención',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.brown,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildInterestCard('Sitios Históricos', Icons.account_balance, 'historical'),
                _buildInterestCard('Naturaleza & Aire Libre', Icons.nature, 'nature'),
                _buildInterestCard('Comida & Bebida', Icons.restaurant, 'food'),
                _buildInterestCard('Compras', Icons.shopping_bag, 'shopping'),
                _buildInterestCard('Vida Nocturna', Icons.nightlife, 'nightlife'),
                _buildInterestCard('Arte & Cultura', Icons.palette, 'culture'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: userPreferences['interests'].isNotEmpty ? () {
                setState(() {
                  currentStep = 1;
                });
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.gray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInterestCard(String title, IconData icon, String value) {
    final isSelected = userPreferences['interests'].contains(value);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            userPreferences['interests'].remove(value);
          } else {
            userPreferences['interests'].add(value);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.brown,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '¿Cuánto tiempo tienes?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Esto nos ayuda a crear el itinerario perfecto',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.brown,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: Column(
              children: [
                _buildTimeOption('Medio Día', '4 horas', 'half-day'),
                const SizedBox(height: 16),
                _buildTimeOption('Día Completo', '8 horas', 'full-day'),
                const SizedBox(height: 16),
                _buildTimeOption('Fin de Semana', '2-3 días', 'weekend'),
                const SizedBox(height: 16),
                _buildTimeOption('Flexible', 'Tengo tiempo libre', 'flexible'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStep = 0;
                    });
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    side: const BorderSide(color: AppColors.gray),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Atrás'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: userPreferences['time'].isNotEmpty ? () {
                    setState(() {
                      currentStep = 2;
                    });
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.gray,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeOption(String title, String subtitle, String value) {
    final isSelected = userPreferences['time'] == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          userPreferences['time'] = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? AppColors.primary.withOpacity(0.7) : AppColors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaceStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '¿Cuál es tu ritmo?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Esto determina la intensidad de tu itinerario',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.brown,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: Column(
              children: [
                _buildPaceOption('Relajado', 'Pocas actividades, más tiempo en cada lugar', 'relaxed', Icons.self_improvement),
                const SizedBox(height: 16),
                _buildPaceOption('Moderado', 'Balance entre actividades y descanso', 'moderate', Icons.directions_walk),
                const SizedBox(height: 16),
                _buildPaceOption('Intenso', 'Ver todo lo posible en el tiempo disponible', 'fast-paced', Icons.directions_run),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStep = 1;
                    });
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    side: const BorderSide(color: AppColors.gray),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Atrás'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: userPreferences['pace'].isNotEmpty ? () {
                    setState(() {
                      currentStep = 3;
                    });
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.gray,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Generar Tour'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaceOption(String title, String description, String value, IconData icon) {
    final isSelected = userPreferences['pace'] == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          userPreferences['pace'] = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.brown,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? AppColors.primary.withOpacity(0.7) : AppColors.brown,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGenerateStep() {
    if (isGenerating) {
      return _buildLoadingView();
    }
    
    if (generatedTour != null) {
      return _buildTourResult();
    }
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 64,
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Todo listo!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nuestra IA creará un itinerario personalizado basado en tus preferencias.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.brown,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _generateTour,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generar Mi Tour',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 3,
                ),
                SizedBox(height: 24),
                Text(
                  'Generando tu tour personalizado...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'La IA está analizando tus preferencias',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTourResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '¡Tu tour personalizado está listo!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
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
                  'Tu Itinerario Personalizado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  generatedTour ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.dark,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      generatedTour = null;
                      currentStep = 0;
                      userPreferences = {
                        'interests': <String>[],
                        'time': '',
                        'pace': '',
                        'budget': '',
                        'groupType': '',
                      };
                    });
                    pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    side: const BorderSide(color: AppColors.gray),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Nuevo Tour'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar Tour'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Future<void> _generateTour() async {
    setState(() {
      isGenerating = true;
    });
    
    // Verificar si tenemos API key válida
    if (apiKey == 'TU_API_KEY_AQUI' || apiKey.isEmpty) {
      print('⚠️ API key no configurada, usando fallback personalizado');
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        generatedTour = _getPersonalizedTour();
        isGenerating = false;
      });
      return;
    }
    
    try {
      String prompt = _buildPrompt();
      print('🤖 Enviando prompt a ChatGPT: $prompt');
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Eres un guía turístico experto de Santo Domingo, República Dominicana. Crea itinerarios detallados, prácticos y personalizados. Incluye horarios específicos, precios en pesos dominicanos (RD\$), y consejos locales útiles. Mantén un tono amigable y entusiasta.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 800,
          'temperature': 0.7,
        }),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tour = data['choices'][0]['message']['content'];
        
        setState(() {
          generatedTour = '🤖 **Generado con IA Real** \n\n$tour';
          isGenerating = false;
        });
        print('✅ Tour generado exitosamente con ChatGPT');
      } else {
        print('❌ Error API: ${response.statusCode} - ${response.body}');
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error al llamar ChatGPT: $e');
      print('🔄 Usando fallback personalizado');
      
      // Fallback personalizado si falla la API
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        generatedTour = _getPersonalizedTour();
        isGenerating = false;
      });
    }
  }
  
  String _buildPrompt() {
    String interests = userPreferences['interests'].join(', ');
    String timeText = _getTimeText();
    String paceText = _getPaceText();
    
    return '''
Crea un itinerario turístico personalizado para Santo Domingo, República Dominicana:

PREFERENCIAS:
- Intereses: $interests
- Tiempo disponible: $timeText
- Ritmo preferido: $paceText

REQUISITOS:
1. Incluye lugares específicos de Santo Domingo
2. Horarios detallados y realistas
3. Precios en pesos dominicanos (RD\$)
4. Opciones de transporte (Metro, OMSA, taxis)
5. Consejos locales prácticos
6. Comida típica dominicana

Organiza el itinerario de forma clara con emojis y secciones. Sé específico con nombres de lugares, calles y precios reales.
''';
  }
  
  String _getTimeText() {
    switch (userPreferences['time']) {
      case 'half-day': return '4 horas (medio día)';
      case 'full-day': return '8 horas (día completo)';
      case 'weekend': return '2-3 días (fin de semana)';
      case 'flexible': return 'Tiempo flexible';
      default: return 'No especificado';
      }
 }
 
 String _getPaceText() {
   switch (userPreferences['pace']) {
     case 'relaxed': return 'Relajado - tiempo para disfrutar cada lugar';
     case 'moderate': return 'Moderado - balance entre actividades y descanso';
     case 'fast-paced': return 'Intenso - ver la mayor cantidad de lugares posible';
     default: return 'No especificado';
   }
 }
 
 String _getPersonalizedTour() {
   String interests = userPreferences['interests'].join(', ');
   String time = userPreferences['time'];
   String pace = userPreferences['pace'];
   
   String tour = '🎯 **Tour Personalizado con IA** \n\n';
   
   // Encabezado personalizado basado en tiempo
   if (time == 'half-day') {
     tour += '⏰ **Itinerario de Medio Día (4 horas)** \n\n';
   } else if (time == 'full-day') {
     tour += '⏰ **Itinerario de Día Completo (8 horas)** \n\n';
   } else if (time == 'weekend') {
     tour += '⏰ **Itinerario de Fin de Semana (2-3 días)** \n\n';
   } else {
     tour += '⏰ **Itinerario Flexible** \n\n';
   }
   
   // Contenido basado en intereses seleccionados
   if (userPreferences['interests'].contains('historical')) {
     tour += '''**9:00 AM - Zona Colonial 🏛️**
- **Catedral Primada de América** - Primera catedral del Nuevo Mundo
- **Calle Las Damas** - Primera calle pavimentada de América
- **Tiempo sugerido:** 1.5 horas
- **Entrada:** Gratuita

**10:30 AM - Alcázar de Colón 🏰**
- Residencia de Diego Colón, hijo de Cristóbal Colón
- Arquitectura colonial impresionante
- **Entrada:** RD\$100
- **Tiempo sugerido:** 1 hora

''';
   }
   
   if (userPreferences['interests'].contains('culture')) {
     tour += '''**12:00 PM - Museo de las Casas Reales 🎨**
- Historia colonial y arte dominicano
- Tesoros arqueológicos únicos
- **Entrada:** RD\$150
- **Tiempo sugerido:** 1.5 horas

''';
   }
   
   if (userPreferences['interests'].contains('food')) {
     tour += '''**1:30 PM - Almuerzo Típico Dominicano 🍽️**
- **Restaurante recomendado:** "El Conuco" (Zona Colonial)
- **Platos imperdibles:** Mangú, pollo guisado, tostones, yuca hervida
- **Bebida:** Morir Soñando o Chinola
- **Costo promedio:** RD\$800-1,200 por persona

''';
   }
   
   if (userPreferences['interests'].contains('nature')) {
     tour += '''**3:30 PM - Jardín Botánico Nacional 🌿**
- El más grande del Caribe (2 km²)
- Más de 300 especies de plantas
- Perfecto para relajarse y conectar con la naturaleza
- **Entrada:** RD\$50
- **Transporte interno:** Tren turístico RD\$30

''';
   }
   
   if (userPreferences['interests'].contains('shopping')) {
     tour += '''**5:00 PM - Mercado Modelo 🛍️**
- Artesanías locales auténticas
- Souvenirs típicos dominicanos
- **Productos recomendados:** Ámbar, larimar, café dominicano
- **Consejo:** Siempre regatea los precios

''';
   }
   
   if (userPreferences['interests'].contains('nightlife')) {
     tour += '''**7:00 PM - Zona Rosa (Noche) 🌃**
- Vida nocturna vibrante
- **Bares recomendados:** Montecristo, Jet Set
- **Música:** Merengue, bachata y salsa en vivo
- **Costo promedio bebidas:** RD\$200-400

''';
   }
   
   // Sección de transporte personalizada
   tour += '''
**🚇 Guía de Transporte:**
- **Metro Línea 1:** Conecta centro con principales destinos (RD\$20)
- **OMSA:** Autobuses públicos económicos (RD\$25)
- **Taxis/Uber:** Para distancias cortas (RD\$150-300)
- **Caminatas:** Zona Colonial es perfecta para caminar

''';
   
   // Personalización según ritmo elegido
   if (pace == 'relaxed') {
     tour += '''**⏰ Ritmo Relajado - Consejos Especiales:**
- Tómate 30-45 minutos extra en cada lugar
- Incluye paradas para café dominicano
- Disfruta las vistas sin prisa
- Siéntate en las plazas a observar la vida local

''';
   } else if (pace == 'moderate') {
     tour += '''**⏰ Ritmo Moderado - Consejos Especiales:**
- Balance perfecto entre ver sitios y descansar
- Incluye tiempo para almuerzo relajado
- Toma fotos sin apuro
- Interactúa con locales amigables

''';
   } else if (pace == 'fast-paced') {
     tour += '''**⏰ Ritmo Intenso - Consejos Especiales:**
- Lleva snacks y agua para maximizar tiempo
- Usa transporte público para moverte rápido
- Toma fotos rápidas pero no te pierdas detalles
- Reserva energía para todo el día

''';
   }
   
   // Consejos finales personalizados
   tour += '''**💡 Consejos Personalizados:**
- **Clima:** Lleva protector solar (SPF 30+) y sombrero
- **Calzado:** Zapatos cómodos para caminar en adoquines
- **Dinero:** Ten efectivo, algunos lugares no aceptan tarjetas
- **Seguridad:** Guarda copias digitales de documentos
- **Hidratación:** Bebe agua constantemente (clima tropical)

**💰 Presupuesto Total Estimado:**
''';

   // Cálculo de presupuesto basado en selecciones
   int minCost = 500, maxCost = 800;
   if (userPreferences['interests'].contains('food')) {
     minCost += 800; maxCost += 1200;
   }
   if (userPreferences['interests'].contains('shopping')) {
     minCost += 1000; maxCost += 3000;
   }
   if (userPreferences['interests'].contains('nightlife')) {
     minCost += 800; maxCost += 1500;
   }
   
   tour += '• **RD\$${minCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} - RD\$${maxCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}** por persona\n\n';
   
   tour += '''**🇩🇴 ¡Que disfrutes tu aventura en Santo Domingo!**
La capital más antigua del Nuevo Mundo te espera con historia, cultura y sabores únicos. ¡Buen viaje! ✨''';
   
   return tour;
 }
}