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

  // Resultado en dos formatos posibles
  String? generatedTourText; // Texto bruto (si no llega JSON)
  Map<String, dynamic>? generatedTourJson; // JSON estructurado preferido

  // Respuestas del usuario
  Map<String, dynamic> userPreferences = {
    'interests': <String>[],
    'time': '',
    'pace': '',
    'budget': '',
    'groupType': '',
  };

  /// ⚠️ Reemplaza esto por una variable segura (dotenv, secure storage, remote config, etc.)
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

  // -------------------- PASO 1: INTERESES --------------------
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
              onPressed: userPreferences['interests'].isNotEmpty
                  ? () {
                      setState(() {
                        currentStep = 1;
                      });
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
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

  // -------------------- PASO 2: TIEMPO --------------------
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
                  onPressed: userPreferences['time'].isNotEmpty
                      ? () {
                          setState(() {
                            currentStep = 2;
                          });
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
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

  // -------------------- PASO 3: RITMO --------------------
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
                  onPressed: userPreferences['pace'].isNotEmpty
                      ? () {
                          setState(() {
                            currentStep = 3;
                          });
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
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

  // -------------------- PASO 4: GENERAR --------------------
  Widget _buildGenerateStep() {
    if (isGenerating) {
      return _buildLoadingView();
    }

    if (generatedTourJson != null || generatedTourText != null) {
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

  // -------------------- RESULTADO --------------------
  Widget _buildTourResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
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
                Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
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

          if (generatedTourJson != null) ...[
            // Resumen
            if ((generatedTourJson!['resumen'] ?? '').toString().trim().isNotEmpty)
              _buildCard(
                title: 'Resumen',
                icon: Icons.summarize,
                child: Text(
                  generatedTourJson!['resumen'],
                  style: const TextStyle(fontSize: 16, color: AppColors.dark, height: 1.5),
                ),
              ),
            const SizedBox(height: 16),

            // Horarios (timeline)
            if (generatedTourJson!['horarios'] is List && (generatedTourJson!['horarios'] as List).isNotEmpty)
              _buildCard(
                title: 'Horarios',
                icon: Icons.schedule,
                child: Column(
                  children: (generatedTourJson!['horarios'] as List).map((h) {
                    final hora = (h['hora'] ?? '') as String;
                    final actividad = (h['actividad'] ?? '') as String;
                    final lugar = (h['lugar'] ?? '') as String;
                    final dur = (h['duracion_min'] ?? 0).toString();
                    final detalle = (h['detalle'] ?? '') as String;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Punto de timeline
                          Column(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 36,
                                color: AppColors.gray.withOpacity(0.4),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    _pill(hora),
                                    if (dur != '0') _pill('$dur min'),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  actividad,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.dark),
                                ),
                                if (lugar.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.place, size: 16, color: AppColors.brown),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            lugar,
                                            style: const TextStyle(color: AppColors.brown, fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (detalle.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      detalle,
                                      style: const TextStyle(fontSize: 14, color: AppColors.dark),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Paradas (chips)
            if (generatedTourJson!['paradas'] is List && (generatedTourJson!['paradas'] as List).isNotEmpty)
              _buildCard(
                title: 'Paradas',
                icon: Icons.flag,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (generatedTourJson!['paradas'] as List).map((p) {
                    final nombre = (p['nombre'] ?? '') as String;
                    final tipo = (p['tipo'] ?? '') as String;
                    return _chip(nombre.isNotEmpty ? nombre : tipo);
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Lugares destacados (cards)
            if (generatedTourJson!['lugares_destacados'] is List && (generatedTourJson!['lugares_destacados'] as List).isNotEmpty)
              _buildCard(
                title: 'Lugares destacados',
                icon: Icons.star,
                child: Column(
                  children: (generatedTourJson!['lugares_destacados'] as List).map((l) {
                    final nombre = (l['nombre'] ?? '') as String;
                    final descripcion = (l['descripcion'] ?? '') as String;
                    final precio = l['precio_est_rd'];
                    final tiempo = l['tiempo_sugerido_min'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gray.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.dark)),
                          if (descripcion.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(descripcion, style: const TextStyle(fontSize: 14, color: AppColors.dark)),
                            ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (precio != null) _pill('RD\$${precio.toString()}'),
                              if (tiempo != null) _pill('${tiempo.toString()} min'),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Transporte
            if (generatedTourJson!['transporte'] is List && (generatedTourJson!['transporte'] as List).isNotEmpty)
              _buildCard(
                title: 'Transporte',
                icon: Icons.directions_transit,
                child: Column(
                  children: (generatedTourJson!['transporte'] as List).map((t) {
                    final medio = (t['medio'] ?? '') as String;
                    final linea = (t['linea'] ?? '')?.toString() ?? '';
                    final paradas = (t['paradas'] ?? '')?.toString() ?? '';
                    final costo = (t['costo_rd'] ?? '')?.toString() ?? '';
                    final notas = (t['notas'] ?? '') as String? ?? '';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.train, color: AppColors.primary),
                      title: Text(
                        medio.isNotEmpty ? medio : 'Transporte',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (linea.isNotEmpty) Text('Línea: $linea'),
                          if (paradas.isNotEmpty) Text('Paradas: $paradas'),
                          if (costo.isNotEmpty) Text('Costo: RD\$$costo'),
                          if (notas.isNotEmpty) Text('Notas: $notas'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Comida recomendada
            if (generatedTourJson!['comida_recomendada'] is List && (generatedTourJson!['comida_recomendada'] as List).isNotEmpty)
              _buildCard(
                title: 'Comida recomendada',
                icon: Icons.restaurant_menu,
                child: Column(
                  children: (generatedTourJson!['comida_recomendada'] as List).map((c) {
                    final nombre = (c['nombre'] ?? '') as String;
                    final lugar = (c['lugar'] ?? '') as String;
                    final precio = c['precio_est_rd'];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_dining, color: AppColors.primary),
                      title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (lugar.isNotEmpty) Text('Lugar: $lugar'),
                          if (precio != null) Text('Precio estimado: RD\$$precio'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Consejos
            if (generatedTourJson!['consejos'] is List && (generatedTourJson!['consejos'] as List).isNotEmpty)
              _buildCard(
                title: 'Consejos',
                icon: Icons.tips_and_updates,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (generatedTourJson!['consejos'] as List).map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  ', style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Text(c.toString(), style: const TextStyle(fontSize: 14, color: AppColors.dark)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // Presupuesto
            if (generatedTourJson!['presupuesto'] is Map && (generatedTourJson!['presupuesto'] as Map).isNotEmpty)
              _buildCard(
                title: 'Presupuesto estimado',
                icon: Icons.payments,
                child: Builder(
                  builder: (_) {
                    final p = generatedTourJson!['presupuesto'] as Map;
                    final min = p['min_rd'];
                    final max = p['max_rd'];
                    return Row(
                      children: [
                        _pill('Mín: RD\$${_fmtInt(min)}'),
                        const SizedBox(width: 8),
                        _pill('Máx: RD\$${_fmtInt(max)}'),
                      ],
                    );
                  },
                ),
              ),
          ] else ...[
            // Modo texto (fallback)
            _buildCard(
              title: 'Tu Itinerario Personalizado',
              icon: Icons.map,
              child: Text(
                generatedTourText ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.dark,
                  height: 1.5,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      generatedTourText = null;
                      generatedTourJson = null;
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

  // -------------------- LÓGICA IA --------------------
  Future<void> _generateTour() async {
    setState(() {
      isGenerating = true;
      generatedTourText = null;
      generatedTourJson = null;
    });

    

    // Si no hay apiKey, usar fallback
    if (apiKey.isEmpty || apiKey == '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') {
      await Future.delayed(const Duration(seconds: 2));
      final fallback = _getStructuredFallback();
      setState(() {
        generatedTourJson = fallback;
        isGenerating = false;
      });
      return;
    }

    try {
      final prompt = _buildPromptJSON();
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          // Puedes usar 'gpt-4o-mini' si tu cuenta lo soporta; aquí se deja uno común.
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Eres un guía turístico experto de Santo Domingo, República Dominicana. Devuelve SIEMPRE un JSON válido y estricto siguiendo el esquema solicitado.'
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 1200,
          'temperature': 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String? ?? '';

        // Intentar parsear JSON puro; si viene con texto extra, intentar limpiar
        final jsonString = _extractFirstJsonObject(content);
        if (jsonString != null) {
          final parsed = jsonDecode(jsonString) as Map<String, dynamic>;
          setState(() {
            generatedTourJson = parsed;
            isGenerating = false;
          });
        } else {
          // Si no pudimos obtener JSON, mostramos el texto
          setState(() {
            generatedTourText = '🤖 Generado por IA\n\n$content';
            isGenerating = false;
          });
        }
      } else {
        // Fallback
        await Future.delayed(const Duration(milliseconds: 500));
        final fallback = _getStructuredFallback();
        setState(() {
          generatedTourJson = fallback;
          isGenerating = false;
        });
      }
    } catch (e) {
      // Fallback
      await Future.delayed(const Duration(milliseconds: 500));
      final fallback = _getStructuredFallback();
      setState(() {
        generatedTourJson = fallback;
        isGenerating = false;
      });
    }
  }

  /// Prompt refinado: exige JSON con secciones clave.
  String _buildPromptJSON() {
    final interests = userPreferences['interests'].join(', ');
    final timeText = _getTimeText();
    final paceText = _getPaceText();

    return """
Genera un plan de tour personalizado para Santo Domingo, República Dominicana, DEVOLVIENDO EXCLUSIVAMENTE UN JSON VÁLIDO (sin explicaciones) con el SIGUIENTE ESQUEMA EXACTO y llaves en minúsculas:

{
  "resumen": "string corto con el objetivo del tour",
  "horarios": [
    {
      "hora": "HH:MM AM/PM",
      "actividad": "string",
      "lugar": "string",
      "duracion_min": 0,
      "detalle": "string"
    }
  ],
  "paradas": [
    {
      "nombre": "string",
      "tipo": "parada|museo|parque|restaurante|bar|tienda|otro",
      "direccion": "string",
      "coordenadas": {"lat": 0.0, "lng": 0.0}
    }
  ],
  "lugares_destacados": [
    {
      "nombre": "string",
      "descripcion": "string",
      "precio_est_rd": 0,
      "tiempo_sugerido_min": 0
    }
  ],
  "comida_recomendada": [
    {
      "nombre": "string (plato o experiencia)",
      "lugar": "string",
      "precio_est_rd": 0
    }
  ],
  "transporte": [
    {
      "medio": "metro|omsa|taxi|uber|a_pie|otro",
      "linea": "string (si aplica)",
      "paradas": "string (ej: 'Máximo Gómez -> Centro de los Héroes')",
      "costo_rd": 0,
      "notas": "string"
    }
  ],
  "consejos": ["string", "string"],
  "presupuesto": {"min_rd": 0, "max_rd": 0}
}

REGLAS:
* Rellena todos los campos con valores realistas de Santo Domingo (nombres de lugares, calles, costos en RD\$).
* Adecua cantidades y duración al tiempo disponible y ritmo.
* No incluyas texto fuera del JSON. No uses Markdown. No uses comillas simples.
* Si algún dato es incierto, estima de forma razonable.
* Devuelve solo el JSON final.

PREFERENCIAS DEL USUARIO:
- Intereses: $interests
- Tiempo disponible: $timeText
- Ritmo preferido: $paceText
""";
  }

  // -------------------- HELPERS --------------------
  String _getTimeText() {
    switch (userPreferences['time']) {
      case 'half-day':
        return '4 horas (medio día)';
      case 'full-day':
        return '8 horas (día completo)';
      case 'weekend':
        return '2-3 días (fin de semana)';
      case 'flexible':
        return 'Tiempo flexible';
      default:
        return 'No especificado';
    }
  }

  String _getPaceText() {
    switch (userPreferences['pace']) {
      case 'relaxed':
        return 'Relajado - tiempo para disfrutar cada lugar';
      case 'moderate':
        return 'Moderado - balance entre actividades y descanso';
      case 'fast-paced':
        return 'Intenso - ver la mayor cantidad de lugares posible';
      default:
        return 'No especificado';
    }
  }

  /// Extrae el primer objeto JSON válido contenido en un texto
  String? _extractFirstJsonObject(String text) {
    // Busca el primer "{" y el matching "}" más externo
    final start = text.indexOf('{');
    if (start == -1) return null;

    int braceCount = 0;
    for (int i = start; i < text.length; i++) {
      if (text[i] == '{') braceCount++;
      if (text[i] == '}') braceCount--;
      if (braceCount == 0) {
        return text.substring(start, i + 1);
      }
    }
    return null;
    }

  // Fallback estructurado si no hay API o falla
  Map<String, dynamic> _getStructuredFallback() {
    // Basado en selecciones del usuario, crea un ejemplo razonable
    return {
      "resumen": "Ruta curada para explorar historia, comida y puntos icónicos de Santo Domingo con traslados sencillos.",
      "horarios": [
        {
          "hora": "09:00 AM",
          "actividad": "Paseo por la Zona Colonial",
          "lugar": "Parque Colón, Catedral Primada",
          "duracion_min": 90,
          "detalle": "Recorrido a pie por calles emblemáticas y fotos en la Catedral."
        },
        {
          "hora": "10:45 AM",
          "actividad": "Visita museo",
          "lugar": "Alcázar de Colón",
          "duracion_min": 60,
          "detalle": "Historia colonial y vistas a la Plaza de España."
        },
        {
          "hora": "12:00 PM",
          "actividad": "Almuerzo típico",
          "lugar": "El Conuco (o similar)",
          "duracion_min": 75,
          "detalle": "Mangú, chicharrón de pollo, tostones, morir soñando."
        },
        {
          "hora": "02:00 PM",
          "actividad": "Naturaleza y relajación",
          "lugar": "Jardín Botánico Nacional",
          "duracion_min": 90,
          "detalle": "Trencito interno y paseo por jardines."
        }
      ],
      "paradas": [
        {
          "nombre": "Parque Colón",
          "tipo": "parque",
          "direccion": "Calle El Conde, Zona Colonial",
          "coordenadas": {"lat": 18.4721, "lng": -69.8826}
        },
        {
          "nombre": "Alcázar de Colón",
          "tipo": "museo",
          "direccion": "Plaza de España, Zona Colonial",
          "coordenadas": {"lat": 18.4779, "lng": -69.8839}
        },
        {
          "nombre": "Jardín Botánico Nacional",
          "tipo": "parque",
          "direccion": "Av. República de Colombia",
          "coordenadas": {"lat": 18.4969, "lng": -69.9587}
        }
      ],
      "lugares_destacados": [
        {
          "nombre": "Catedral Primada de América",
          "descripcion": "La primera catedral del Nuevo Mundo.",
          "precio_est_rd": 0,
          "tiempo_sugerido_min": 30
        },
        {
          "nombre": "Alcázar de Colón",
          "descripcion": "Museo en antigua residencia de Diego Colón.",
          "precio_est_rd": 150,
          "tiempo_sugerido_min": 60
        }
      ],
      "comida_recomendada": [
        {"nombre": "Mangú con los tres golpes", "lugar": "El Conuco", "precio_est_rd": 600},
        {"nombre": "Sancocho dominicano", "lugar": "Casa de Tostado (alrededores)", "precio_est_rd": 450}
      ],
      "transporte": [
        {
          "medio": "a_pie",
          "linea": "",
          "paradas": "Zona Colonial (recorrido corto)",
          "costo_rd": 0,
          "notas": "Calles adoquinadas, usar calzado cómodo."
        },
        {
          "medio": "taxi",
          "linea": "",
          "paradas": "Zona Colonial -> Jardín Botánico",
          "costo_rd": 300,
          "notas": "También puedes usar Uber según demanda."
        },
        {
          "medio": "omsa",
          "linea": "Rutas principales por Av. John F. Kennedy",
          "paradas": "Paradas cercanas según ubicación",
          "costo_rd": 25,
          "notas": "Económico pero más lento en hora pico."
        }
      ],
      "consejos": [
        "Hidrátate y usa bloqueador solar.",
        "Lleva efectivo: no todos aceptan tarjeta.",
        "Evita horas pico (7–9 AM y 5–7 PM).",
        "Pregunta por descuentos a estudiantes."
      ],
      "presupuesto": {"min_rd": 1200, "max_rd": 2500}
    };
  }

  // -------------------- UI HELPERS --------------------
  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child
      ]),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray.withOpacity(0.25)),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.w600)),
    );
  }

  String _fmtInt(dynamic n) {
    if (n == null) return '0';
    final i = (n is int) ? n : int.tryParse(n.toString()) ?? 0;
    final s = i.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '${m[1]},');
  }
}
