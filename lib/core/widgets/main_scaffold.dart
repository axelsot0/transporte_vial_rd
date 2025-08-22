import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../features/transport/presentation/pages/home_page.dart';
import '../../features/education/presentation/pages/traffic_challenges_page.dart'; // Agregar esta línea
import '../../features/tourist/presentation/pages/tourism_page.dart'; // Agregar esta línea
import '../../features/documentation/presentation/pages/documents_page.dart'; // Agregar esta línea

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LocationPage(),
    const TicketsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark, // 1) Fondo del Scaffold oscuro
      extendBody: true, // opcional: el body puede extenderse bajo el nav
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        // 3) Maneja el área segura inferior
        top: false,
        child: ClipRRect(
          // 2) Recorta verdaderamente las esquinas
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            height: 80,
            color: AppColors.dark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 0, 'Inicio'),
                _buildNavItem(Icons.location_on, 1, 'Mapa'),
                _buildNavItem(Icons.receipt, 2, 'Tickets'),
                _buildNavItem(Icons.person, 3, 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.white : AppColors.gray,
          size: 24,
        ),
      ),
    );
  }
}

// Páginas temporales hasta que las creemos
class LocationPage extends StatelessWidget {
  const LocationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explora Santo Domingo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Descubre los mejores lugares con IA',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 32),
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
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Planificar tour con IA
                      _buildFeatureCard(
                        context,
                        'Planificar Tour con IA',
                        'Crea un itinerario personalizado usando inteligencia artificial',
                        Icons.auto_awesome,
                        AppColors.primary,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TourismPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Mapa público
                      _buildFeatureCard(
                        context,
                        'Mapa de Transporte',
                        'Ver todas las rutas de transporte público',
                        Icons.map,
                        AppColors.secondary,
                        () {
                          print('Mapa público pressed');
                        },
                      ),

                      const SizedBox(height: 16),

                      // Lugares favoritos
                      _buildFeatureCard(
                        context,
                        'Lugares Guardados',
                        'Tus destinos y rutas favoritas',
                        Icons.bookmark,
                        AppColors.brown,
                        () {
                          print('Favoritos pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.brown,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.gray,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Column(
          children: [
            // Header personalizado
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis Tickets',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Gestiona tus viajes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Botón agregar ticket
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Estadísticas rápidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: _buildStatCard('8', 'Activos', AppColors.primary,
                          Icons.confirmation_number)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard('15', 'Usados',
                          const Color(0xFF4CAF50), Icons.check_circle)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard('RD\$575', 'Total',
                          AppColors.secondary, Icons.account_balance_wallet)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contenido principal con tabs
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Tab bar
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.gray,
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Activos'),
                          Tab(text: 'Usados'),
                          Tab(text: 'Historial'),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildActiveTickets(),
                          _buildUsedTickets(),
                          _buildHistoryTickets(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTickets() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Mensaje informativo
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF4CAF50), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tickets listos para usar. Muestra el QR al conductor.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tickets activos
        _buildTicketCard(
          '#TK001829',
          'Metro - Línea 1',
          'Centro - Mama Tingó',
          'Válido hasta: 25 Jul 2025',
          'RD\$25.00',
          'ACTIVO',
          AppColors.primary,
          true,
        ),

        _buildTicketCard(
          '#TK001830',
          'OMSA - Ruta Principal',
          'Kennedy - Churchill',
          'Válido hasta: 25 Jul 2025',
          'RD\$25.00',
          'ACTIVO',
          AppColors.primary,
          true,
        ),

        _buildTicketCard(
          '#TK001831',
          'Teleférico',
          'Villa Mella - Centro',
          'Válido hasta: 26 Jul 2025',
          'RD\$30.00',
          'ACTIVO',
          AppColors.primary,
          true,
        ),

        _buildTicketCard(
          '#TK001832',
          'Metro - Línea 2',
          'Santiago Centro',
          'Válido hasta: 26 Jul 2025',
          'RD\$25.00',
          'ACTIVO',
          AppColors.primary,
          true,
        ),
      ],
    );
  }

  Widget _buildUsedTickets() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Tickets usados recientes
        _buildTicketCard(
          '#TK001828',
          'Metro - Línea 1',
          'Mama Tingó - Centro',
          'Usado: 24 Jul 2025, 2:30 PM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        _buildTicketCard(
          '#TK001827',
          'OMSA - Ruta Kennedy',
          'Plaza de la Cultura - Kennedy',
          'Usado: 24 Jul 2025, 10:15 AM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        _buildTicketCard(
          '#TK001826',
          'Corredor - Duarte',
          'Villa Mella - Centro',
          'Usado: 23 Jul 2025, 8:45 AM',
          'RD\$30.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        _buildTicketCard(
          '#TK001825',
          'Metro - Línea 1',
          'Centro - Villa Mella',
          'Usado: 23 Jul 2025, 6:20 PM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),
      ],
    );
  }

  Widget _buildHistoryTickets() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Resumen del mes
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
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
                'julio 2025',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildHistoryStat('23', 'Viajes')),
                  Expanded(child: _buildHistoryStat('RD\$575', 'Gastado')),
                  Expanded(child: _buildHistoryStat('Metro', 'Favorito')),
                ],
              ),
            ],
          ),
        ),

        // Historial por fechas
        _buildDateSection('Hoy - 24 Jul'),
        _buildTicketCard(
          '#TK001828',
          'Metro - Línea 1',
          'Mama Tingó - Centro',
          '2:30 PM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        const SizedBox(height: 16),
        _buildDateSection('Ayer - 23 Jul'),
        _buildTicketCard(
          '#TK001827',
          'OMSA - Ruta Kennedy',
          'Plaza - Kennedy',
          '10:15 AM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),
        _buildTicketCard(
          '#TK001826',
          'Corredor - Duarte',
          'Villa Mella - Centro',
          '8:45 AM',
          'RD\$30.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        const SizedBox(height: 16),
        _buildDateSection('22 Jul 2025'),
        _buildTicketCard(
          '#TK001825',
          'Metro - Línea 1',
          'Centro - Villa Mella',
          '6:20 PM',
          'RD\$25.00',
          'USADO',
          const Color(0xFF4CAF50),
          false,
        ),

        // Botón ver más
        const SizedBox(height: 20),
        Center(
          child: OutlinedButton(
            onPressed: () {
              _showFullHistory();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ver Historial Completo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
      String ticketId,
      String transport,
      String route,
      String dateTime,
      String price,
      String status,
      Color statusColor,
      bool isActive) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          _showTicketDetails(ticketId, transport, route, price);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? statusColor.withOpacity(0.3)
                : AppColors.gray.withOpacity(0.2),
            width: isActive ? 2 : 1,
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
          children: [
            Row(
              children: [
                // Icono de transporte
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTransportIcon(transport),
                    color: statusColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Información del ticket
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ticketId,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transport,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        route,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.brown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Precio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.qr_code,
                        color: statusColor,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Acciones para tickets activos
            if (isActive) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.gray, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTicketAction(
                      'Ver QR',
                      Icons.qr_code_scanner,
                      () => _showQRCode(ticketId),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.gray,
                  ),
                  Expanded(
                    child: _buildTicketAction(
                      'Compartir',
                      Icons.share,
                      () => _shareTicket(ticketId),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.gray,
                  ),
                  Expanded(
                    child: _buildTicketAction(
                      'Detalles',
                      Icons.info_outline,
                      () =>
                          _showTicketDetails(ticketId, transport, route, price),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
        ),
      ),
    );
  }

  Widget _buildHistoryStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }

  IconData _getTransportIcon(String transport) {
    if (transport.contains('Metro')) return Icons.train;
    if (transport.contains('OMSA')) return Icons.directions_bus;
    if (transport.contains('Teleférico')) return Icons.tram;
    if (transport.contains('Corredor')) return Icons.directions_transit;
    return Icons.confirmation_number;
  }

  void _showQRCode(String ticketId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code - $ticketId'),
        content: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: const Icon(
            Icons.qr_code,
            size: 150,
            color: AppColors.dark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _shareTicket(String ticketId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo ticket $ticketId'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showTicketDetails(
      String ticketId, String transport, String route, String price) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detalles del Ticket',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Número:', ticketId),
            _buildDetailRow('Transporte:', transport),
            _buildDetailRow('Ruta:', route),
            _buildDetailRow('Precio:', price),
            _buildDetailRow('Estado:', 'Activo'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cargando historial completo...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'S',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sofia',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Ciudadana',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.gray,
                          ),
                        ),
                        Text(
                          '1200 puntos',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Menú de opciones
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
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildProfileOption(
                        context,
                        'Desafíos de Tráfico',
                        'Pon a prueba tus conocimientos',
                        Icons.quiz,
                        AppColors.primary,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TrafficChallengesPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileOption(
                        context,
                        'Mis Documentos',
                        'Licencia, seguros y multas',
                        Icons.description,
                        AppColors.secondary,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DocumentsPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileOption(
                        context,
                        'Historial de Tickets',
                        'Ver tickets anteriores',
                        Icons.receipt_long,
                        AppColors.brown,
                        () {
                          print('Historial pressed');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileOption(
                        context,
                        'Configuración',
                        'Ajustes de la aplicación',
                        Icons.settings,
                        AppColors.gray,
                        () {
                          print('Configuración pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title,
      String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
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
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.gray,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
