import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_page.dart';
import 'dart:math';

class TelefericoPage extends StatefulWidget {
  const TelefericoPage({super.key});

  @override
  State<TelefericoPage> createState() => _TelefericoPageState();
}

class _TelefericoPageState extends State<TelefericoPage> {
  final List<String> _telefericoTips = [
    "El Teleférico opera de 6:00 AM a 10:00 PM de lunes a domingo",
    "Utiliza la misma tarjeta del metro para viajar en el Teleférico",
    "Disfruta de las vistas panorámicas de la ciudad durante el recorrido",
    "Mantén la calma durante el viaje, es un transporte muy seguro",
    "Respeta el aforo máximo de cada cabina para tu comodidad",
    "El Teleférico conecta perfectamente con las estaciones del metro",
    "Viaja ligero para mayor comodidad en las cabinas",
    "Aprovecha el sistema integrado de transporte con un solo pasaje",
    "En días lluviosos, el servicio puede operar con precaución",
    "Las cabinas están equipadas con sistemas de seguridad avanzados"
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
    return _telefericoTips[random.nextInt(_telefericoTips.length)];
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
                  Icon(Icons.cable, color: Color(0xFF4CAF50)),
                  SizedBox(width: 8),
                  Text(
                    'Consejo Teleférico',
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
                      color: Color(0xFF4CAF50),
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
          'Rutas Teleférico',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cable, color: Color(0xFF4CAF50)),
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
                  hintText: 'Buscar estación...',
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
                _buildFilterChip('Línea Principal', true),
                const SizedBox(width: 12),
                _buildFilterChip('Estaciones', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de rutas Teleférico
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

                  // Ruta Completa
                  _buildRouteCard(
                    context,
                    'Línea Completa: Villa Mella - Teleférico',
                    '6:00 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.cable,
                  ),

                  const SizedBox(height: 12),

                  // Estación Máximo Gómez
                  _buildRouteCard(
                    context,
                    'Estación: Máximo Gómez',
                    '6:00 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.location_on,
                  ),

                  const SizedBox(height: 12),

                  // Estación Sabana Perdida
                  _buildRouteCard(
                    context,
                    'Estación: Sabana Perdida',
                    '6:00 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.location_on,
                  ),

                  const SizedBox(height: 12),

                  // Estación Villa Mella
                  _buildRouteCard(
                    context,
                    'Estación: Villa Mella',
                    '6:00 AM - 10:00 PM',
                    'Ver en Mapa',
                    Icons.location_on,
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
        color: isSelected ? Color(0xFF4CAF50) : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Color(0xFF4CAF50) : AppColors.gray,
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
              color: Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0xFF4CAF50),
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
                    transportType: 'Teleférico',
                  ),
                ),
              );
            },
            child: const Text(
              'Ver en Mapa',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}