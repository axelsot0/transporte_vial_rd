import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_page.dart';

class OMSAPage extends StatelessWidget {
  const OMSAPage({super.key});

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