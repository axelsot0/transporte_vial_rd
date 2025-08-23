import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'map_page.dart';

class FavoriteRoute {
  final String title;
  final String transportType; // 'Metro' | 'OMSA' | 'Corredor' | 'Teleférico'
  final String schedule;
  final IconData icon;
  final Color color;

  FavoriteRoute({
    required this.title,
    required this.transportType,
    required this.schedule,
    required this.icon,
    required this.color,
  });
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _activeFilter = 'Todos';

  final List<String> _filters = const ['Todos', 'Metro', 'OMSA', 'Corredor', 'Teleférico'];

  final List<FavoriteRoute> _favorites = [
    FavoriteRoute(
      title: 'Línea 1: Mamá Tingó ↔ Centro de los Héroes',
      transportType: 'Metro',
      schedule: 'L–S 5:30–22:30 · D 6:00–22:00',
      icon: Icons.train,
      color: AppColors.primary,
    ),
    FavoriteRoute(
      title: 'Corredor Duarte Express',
      transportType: 'Corredor',
      schedule: '5:00–23:00 · Alta frecuencia',
      icon: Icons.directions_bus_filled,
      color: AppColors.brown,
    ),
    FavoriteRoute(
      title: 'OMSA – Kennedy',
      transportType: 'OMSA',
      schedule: '5:30–22:30 · Paradas oficiales',
      icon: Icons.directions_bus,
      color: AppColors.secondary,
    ),
    FavoriteRoute(
      title: 'Teleférico L1: Eduardo Brito ↔ Sabana Perdida',
      transportType: 'Teleférico',
      schedule: '6:00–22:00 · Conexión Metro',
      icon: Icons.cable,
      color: AppColors.primary,
    ),
  ];

  List<FavoriteRoute> get _filtered {
    return _favorites.where((f) {
      final byFilter = _activeFilter == 'Todos' || f.transportType == _activeFilter;
      final byQuery = _query.isEmpty || f.title.toLowerCase().contains(_query.toLowerCase());
      return byFilter && byQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
          'Rutas Favoritas',
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
          // Search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Buscar ruta favorita...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.brown),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  hintStyle: TextStyle(color: AppColors.brown.withOpacity(0.7)),
                ),
              ),
            ),
          ),

          // Chips de filtro
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => _buildFilterChip(_filters[i], _activeFilter == _filters[i]),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _filters.length,
            ),
          ),

          const SizedBox(height: 16),

          // Lista
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _filtered.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No hay rutas favoritas con ese filtro/búsqueda.',
                          style: TextStyle(color: AppColors.brown, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filtered.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _filtered.length) {
                          return const SizedBox(height: 100); // espacio para navbar
                        }
                        final item = _filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFavoriteCard(context, item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _activeFilter = label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, FavoriteRoute item) {
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
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {
                // Ir al mapa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      routeName: item.title,
                      transportType: item.transportType,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.transportType} · ${item.schedule}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Acción secundaria (mock): quitar de favoritos
          IconButton(
            tooltip: 'Quitar de favoritos',
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              // Mock de quitar: solo feedback visual
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quitado de favoritos: ${item.title}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
