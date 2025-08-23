import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_page.dart';
import 'dart:math';

class OMSAPage extends StatefulWidget {
  const OMSAPage({super.key});

  @override
  State<OMSAPage> createState() => _OMSAPageState();
}

class _OMSAPageState extends State<OMSAPage> {
  final List<String> _omsaTips = [
    "Las rutas OMSA operan de 5:00 AM a 11:30 PM según la ruta",
    "Recuerda tener tu tarjeta OMSA recargada antes de abordar",
    "Las horas pico son de 6:00-9:00 AM y 4:00-7:00 PM",
    "Las paradas oficiales están señalizadas con postes azules",
    "Da prioridad a adultos mayores y personas con discapacidad",
    "Mantén tu pasaje o tarjeta listo para agilizar el abordaje",
    "Consulta los horarios especiales en días festivos",
    "Las rutas troncales tienen mayor frecuencia de paso",
    "Verifica el destino final en el frente del autobús",
    "Conserva tu espacio personal durante el viaje"
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
    return _omsaTips[random.nextInt(_omsaTips.length)];
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
                  Icon(Icons.directions_bus, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Consejo OMSA',
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
          'Rutas OMSA',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_bus, color: AppColors.primary),
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
                  hintText: 'Buscar ruta OMSA...',
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
                _buildFilterChip('Rutas Principales', true),
                const SizedBox(width: 12),
                _buildFilterChip('Zona Norte', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de rutas OMSA
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

                  // Ruta Av. Kennedy
                  _buildRouteCard(
                    context,
                    'Ruta Kennedy',
                    '5:30 AM - 11:00 PM',
                    'Ver en Mapa',
                    Icons.directions_bus,
                  ),

                  const SizedBox(height: 12),

                  // Ruta Av. 27 de Febrero
                  _buildRouteCard(
                    context,
                    'Ruta 27 de Febrero',
                    '5:30 AM - 11:00 PM',
                    'Ver en Mapa',
                    Icons.directions_bus,
                  ),

                  const SizedBox(height: 12),

                  // Ruta Winston Churchill
                  _buildRouteCard(
                    context,
                    'Ruta Winston Churchill',
                    '6:00 AM - 10:30 PM',
                    'Ver en Mapa',
                    Icons.directions_bus,
                  ),

                  const SizedBox(height: 12),

                  // Ruta Duarte
                  _buildRouteCard(
                    context,
                    'Ruta Duarte',
                    '5:00 AM - 11:30 PM',
                    'Ver en Mapa',
                    Icons.directions_bus,
                  ),

                  const SizedBox(height: 12),

                  // Ruta Mella
                  _buildRouteCard(
                    context,
                    'Ruta Mella',
                    '5:30 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.directions_bus,
                  ),

                  // Espacio extra para el navbar
                  const SizedBox(height: 100),
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

  Widget _buildRouteCard(BuildContext context, String title, String time, String action, IconData icon) {
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
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

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(
                    routeName: title,
                    transportType: 'OMSA',
                  ),
                ),
              );
            },
            child: const Text(
              'Ver en Mapa',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}