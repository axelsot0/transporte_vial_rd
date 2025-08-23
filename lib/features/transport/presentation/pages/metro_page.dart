import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'route_details_page.dart';
import 'map_page.dart';
import 'dart:math';

class MetroPage extends StatefulWidget {
  const MetroPage({super.key});

  @override
  State<MetroPage> createState() => _MetroPageState();
}

class _MetroPageState extends State<MetroPage> {
  // Estaciones reales por línea (puedes reutilizarlas en RouteDetailsPage/MapPage)
  static const List<String> _linea1Stations = [
    'Mamá Tingó',
    'Gregorio Urbano Gilbert',
    'Gregorio Luperón',
    'José Francisco Peña Gómez',
    'Hermanas Mirabal',
    'Generalísimo Máximo Gómez',
    'Los Taínos',
    'Pedro Livio Cedeño',
    'Manuel Arturo Peña Batlle',
    'Juan Pablo Duarte (conexión L1–L2)',
    'Prof. Juan Bosch',
    'Casandra Damirón',
    'Joaquín Balaguer',
    'Amín Abel Hasbún',
    'Francisco Alberto Caamaño Deñó',
    'Centro de los Héroes'
  ];

  static const List<String> _linea2Stations = [
    'María Montez',
    'Pedro Francisco Bonó',
    'Francisco Gregorio Billini',
    'Ulises Francisco Espaillat',
    'Pedro Mir',
    'Freddy Beras Goico',
    'Juan Ulises García Saleta',
    'Juan Pablo Duarte (conexión L1–L2)',
    'Coronel Rafael Tomás Fernández Domínguez',
    'Mauricio Báez',
    'Ramón Cáceres',
    'Horacio Vásquez',
    'Manuel de Jesús Galván',
    'Eduardo Brito (conexión Teleférico L1)',
    'Ercilia Pepín',
    'Rosa Duarte',
    'Trina de Moya de Vásquez',
    'Concepción Bona'
  ];

  final List<String> _metroTips = [
    "Usa tu tarjeta recargable para agilizar el acceso por los torniquetes.",
    "El Metro opera L–S de 5:30 AM a 10:30 PM y los domingos de 6:00 AM a 10:00 PM.",
    "Evita horas pico (7–9 AM y 5–7 PM) para viajar más cómodo.",
    "Respeta los asientos preferenciales y las zonas de acceso.",
    "Al abordar, deja salir antes de entrar y evita bloquear las puertas.",
    "En Juan Pablo Duarte puedes hacer trasbordo entre L1 y L2.",
    "Eduardo Brito conecta con el Teleférico (Línea 1).",
    "Mantén tu tarjeta cerca del lector para validar rápidamente."
  ];

  bool _showTip = true;
  late String _randomTip;

  @override
  void initState() {
    super.initState();
    _randomTip = _getRandomTip();
    _showTipDialog();
  }

  String _getRandomTip() {
    final random = Random();
    return _metroTips[random.nextInt(_metroTips.length)];
  }

  void _showTipDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_showTip && mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.dark,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Consejo del Día',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                _randomTip,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _showTip = false;
                    });
                  },
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _randomTip = _getRandomTip();
                      _showTipDialog();
                    });
                  },
                  child: const Text(
                    'Otro consejo',
                    style: TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }

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
          'Rutas del Metro SD',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: AppColors.primary),
            onPressed: () {
              setState(() {
                _randomTip = _getRandomTip();
                _showTip = true;
                _showTipDialog();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar estación o línea...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.brown),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  hintStyle: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                ),
              ),
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip('L–S 5:30–22:30', true),
                const SizedBox(width: 12),
                _buildFilterChip('D 6:00–22:00', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de rutas reales (solo 2 líneas actualmente)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 8),

                  // LÍNEA 1
                  _buildRouteCard(
                    context,
                    title: 'Línea 1: Mamá Tingó ↔ Centro de los Héroes',
                    time:
                    'L–S 5:30 AM – 10:30 PM · D 6:00 AM – 10:00 PM · 16 estaciones',
                    action: 'Ver en Mapa',
                    icon: Icons.train,
                    lineColor: AppColors.primary,
                    stations: _linea1Stations,
                    lineCode: 'L1',
                  ),

                  const SizedBox(height: 12),

                  // LÍNEA 2
                  _buildRouteCard(
                    context,
                    title: 'Línea 2: María Montez ↔ Concepción Bona',
                    time:
                    'L–S 5:30 AM – 10:30 PM · D 6:00 AM – 10:00 PM · 18 estaciones',
                    action: 'Ver en Mapa',
                    icon: Icons.train,
                    lineColor: AppColors.secondary,
                    stations: _linea2Stations,
                    lineCode: 'L2',
                  ),

                  const SizedBox(height: 100), // espacio extra para navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.dark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRouteCard(
      BuildContext context, {
        required String title,
        required String time,
        required String action,
        required IconData icon,
        required Color lineColor,
        required List<String> stations,
        required String lineCode,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
              color: lineColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: lineColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {
                // (Opcional) Llevar a un detalle con las estaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteDetailsPage(
                      routeName: title,
                      transportType: 'Metro',
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(
                    routeName: title,
                    transportType: 'Metro',
                    // Si tu MapPage admite estaciones/lineas, pásalas aquí también
                    // stations: stations,
                    // lineCode: lineCode,
                  ),
                ),
              );
            },
            child: Text(
              action,
              style: TextStyle(
                color: lineColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
