import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_page.dart';
import 'dart:math';

class CorredorPage extends StatefulWidget {
  const CorredorPage({super.key});

  @override
  State<CorredorPage> createState() => _CorredorPageState();
}

class _CorredorPageState extends State<CorredorPage> {
  final List<String> _corredorTips = [
    "Los corredores express tienen paradas limitadas para mayor rapidez",
    "Verifica los horarios de los corredores ya que varían por ruta",
    "Los corredores suelen tener mayor frecuencia en horas pico",
    "Mantén tu tarjeta de transporte lista para un abordaje rápido",
    "Los corredores tienen carriles exclusivos para evitar tráfico",
    "Identifica las paradas oficiales de los corredores express",
    "Aprovecha la velocidad de los corredores para trayectos largos",
    "Los corredores suelen tener unidades más modernas y cómodas",
    "Consulta las rutas integradas con metro y teleférico",
    "Respeta las filas en las paradas para un abordaje ordenado"
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
    return _corredorTips[random.nextInt(_corredorTips.length)];
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
                  Icon(Icons.directions_bus_filled, color: AppColors.brown),
                  SizedBox(width: 8),
                  Text(
                    'Consejo Corredor',
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
                      color: AppColors.brown,
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
          'Rutas Corredor',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions_bus_filled, color: AppColors.brown),
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
                  hintText: 'Buscar corredor...',
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
                _buildFilterChip('Rutas Rápidas', true),
                const SizedBox(width: 12),
                _buildFilterChip('Express', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de rutas Corredor
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

                  // Corredor Duarte
                  _buildRouteCard(
                    context,
                    'Corredor Duarte Express',
                    '5:00 AM - 11:00 PM',
                    'Ver en Mapa',
                    Icons.directions_bus_filled,
                  ),

                  const SizedBox(height: 12),

                  // Corredor Kennedy
                  _buildRouteCard(
                    context,
                    'Corredor Kennedy',
                    '5:30 AM - 10:30 PM',
                    'Ver en Mapa',
                    Icons.directions_bus_filled,
                  ),

                  const SizedBox(height: 12),

                  // Corredor Isabela
                  _buildRouteCard(
                    context,
                    'Corredor Av. Isabela Católica',
                    '6:00 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.directions_bus_filled,
                  ),

                  const SizedBox(height: 12),

                  // Corredor Las Américas
                  _buildRouteCard(
                    context,
                    'Corredor Las Américas',
                    '5:30 AM - 11:30 PM',
                    'Ver en Mapa',
                    Icons.directions_bus_filled,
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
        color: isSelected ? AppColors.brown : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.brown : AppColors.gray,
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
              color: AppColors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.brown,
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
                    transportType: 'Corredor',
                  ),
                ),
              );
            },
            child: const Text(
              'Ver en Mapa',
              style: TextStyle(
                color: AppColors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}