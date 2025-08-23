import 'package:flutter/material.dart';
import 'package:transporte_vial_rd/features/transport/presentation/pages/route_details_page.dart';
import 'package:transporte_vial_rd/features/transport/presentation/pages/favorites_page.dart';
import '../constants/app_colors.dart';
import '../../features/transport/presentation/pages/home_page.dart';
import '../../features/education/presentation/pages/traffic_challenges_page.dart';
import '../../features/tourist/presentation/pages/tourism_page.dart';
import '../../features/documentation/presentation/pages/documents_page.dart';

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
      backgroundColor: AppColors.dark,
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: ClipRRect(
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
      onTap: () => setState(() => _selectedIndex = index),
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

// ---------------- Location (sin cambios funcionales mayores) ----------------

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
                      _buildFeatureCard(
                        context,
                        'Mapa de Transporte',
                        'Ver todas las rutas de transporte público',
                        Icons.map,
                        AppColors.secondary,
                        () {
                          // Integración futura de mapa
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mapa de transporte próximamente.')),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureCard(
                        context,
                        'Lugares Guardados',
                        'Tus destinos y rutas favoritas',
                        Icons.bookmark,
                        AppColors.brown,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesPage(),
                            ),
                          );
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
              child: Icon(icon, color: color, size: 32),
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
            const Icon(Icons.arrow_forward_ios, color: AppColors.gray, size: 16),
          ],
        ),
      ),
    );
  }
}

// ----------------------- Modelo simple para Tickets -----------------------

class Ticket {
  final String id;
  final String transport; // Metro/OMSA/Teleférico/Corredor
  final String route;
  final DateTime date;
  final double priceRD;
  final TicketState state; // activo, usado, sinUsar (para reportes)
  final bool hasQR;

  Ticket({
    required this.id,
    required this.transport,
    required this.route,
    required this.date,
    required this.priceRD,
    required this.state,
    this.hasQR = true,
  });
}

enum TicketState { activo, usado, sinUsar }

// ----------------------------- Tickets Page -----------------------------

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Saldo y funcionalidades (c y d)
  double walletBalanceRD = 150.0;

  // Mock de tickets
  final List<Ticket> _tickets = [
    Ticket(
      id: '#TK001829',
      transport: 'Metro',
      route: 'L1: Centro - Mamá Tingó',
      date: DateTime(2025, 7, 25, 17, 30),
      priceRD: 25.0,
      state: TicketState.activo,
    ),
    Ticket(
      id: '#TK001830',
      transport: 'OMSA',
      route: 'Kennedy - Churchill',
      date: DateTime(2025, 7, 25, 9, 10),
      priceRD: 25.0,
      state: TicketState.activo,
    ),
    Ticket(
      id: '#TK001831',
      transport: 'Teleférico',
      route: 'Villa Mella - Centro',
      date: DateTime(2025, 7, 26, 14, 05),
      priceRD: 30.0,
      state: TicketState.activo,
    ),
    Ticket(
      id: '#TK001832',
      transport: 'Corredor',
      route: 'Núñez de Cáceres',
      date: DateTime(2025, 7, 26, 10, 45),
      priceRD: 30.0,
      state: TicketState.activo,
    ),
    // Usados
    Ticket(
      id: '#TK001828',
      transport: 'Metro',
      route: 'Mamá Tingó - Centro',
      date: DateTime(2025, 7, 24, 14, 30),
      priceRD: 25.0,
      state: TicketState.usado,
      hasQR: false,
    ),
    Ticket(
      id: '#TK001827',
      transport: 'OMSA',
      route: 'Plaza - Kennedy',
      date: DateTime(2025, 7, 24, 10, 15),
      priceRD: 25.0,
      state: TicketState.usado,
      hasQR: false,
    ),
    Ticket(
      id: '#TK001826',
      transport: 'Corredor',
      route: 'Villa Mella - Centro',
      date: DateTime(2025, 7, 23, 8, 45),
      priceRD: 30.0,
      state: TicketState.usado,
      hasQR: false,
    ),
    Ticket(
      id: '#TK001825',
      transport: 'Metro',
      route: 'Centro - Villa Mella',
      date: DateTime(2025, 7, 23, 18, 20),
      priceRD: 25.0,
      state: TicketState.usado,
      hasQR: false,
    ),
    // Sin usar (para dashboard)
    Ticket(
      id: '#TK001824',
      transport: 'OMSA',
      route: '27 de Febrero – Máximo Gómez',
      date: DateTime(2025, 7, 28, 9, 20),
      priceRD: 25.0,
      state: TicketState.sinUsar,
    ),
  ];

  // Filtros (b) y (e)
  String transportFilter = 'Todos'; // Todos/Metro/OMSA/Teleférico/Corredor
  String routeFilterQuery = '';
  final TextEditingController _routeSearchCtrl = TextEditingController();

  // Tabs: Activos, Usados, Dashboard
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _routeSearchCtrl.addListener(() {
      setState(() {
        routeFilterQuery = _routeSearchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _routeSearchCtrl.dispose();
    super.dispose();
  }

  List<Ticket> _applyFilters(List<Ticket> input, {TicketState? onlyState}) {
    return input.where((t) {
      final byState = onlyState == null ? true : t.state == onlyState;
      final byTransport = transportFilter == 'Todos' ? true : t.transport == transportFilter;
      final byRoute = routeFilterQuery.isEmpty
          ? true
          : (t.route.toLowerCase().contains(routeFilterQuery) || t.id.toLowerCase().contains(routeFilterQuery));
      return byState && byTransport && byRoute;
    }).toList();
  }

  // ----------------------- UI principal -----------------------

  @override
  Widget build(BuildContext context) {
    final activos = _applyFilters(_tickets, onlyState: TicketState.activo);
    final usados = _applyFilters(_tickets, onlyState: TicketState.usado);
    final sinUsar = _applyFilters(_tickets, onlyState: TicketState.sinUsar); // para dashboard

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mis Tickets',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const Text(
                          'Gestiona tus viajes',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.gray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Saldo y acciones rápidas (c, d)
                        Row(
                          children: [
                            _pill('Saldo: ${_fmtRD(walletBalanceRD)}'),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _openTopUpSheet,
                              child: _miniBtn(icon: Icons.add_card, label: 'Recargar'),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _openTapToPay,
                              child: _miniBtn(icon: Icons.nfc, label: 'Pasar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Botón agregar ticket → RouteDetailsPage
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RouteDetailsPage(
                            routeName: "Ruta Metro SD",
                            transportType: "Metro",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add, color: AppColors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // Filtros (b): transporte + ruta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Chips transporte
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _transportChip('Todos'),
                        const SizedBox(width: 8),
                        _transportChip('Metro'),
                        const SizedBox(width: 8),
                        _transportChip('OMSA'),
                        const SizedBox(width: 8),
                        _transportChip('Teleférico'),
                        const SizedBox(width: 8),
                        _transportChip('Corredor'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Buscador por ruta
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _routeSearchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Filtrar por ruta o ticket (#)...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Estadísticas rápidas (se afectan por filtros)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard('${activos.length}', 'Activos', AppColors.primary, Icons.confirmation_number)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('${usados.length}', 'Usados', const Color(0xFF4CAF50), Icons.check_circle)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      _fmtRD(_sumRD(_applyFilters(_tickets))),
                      'Total',
                      AppColors.secondary,
                      Icons.account_balance_wallet,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tabs
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
                          Tab(text: 'Dashboard'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTicketsList(_applyFilters(_tickets, onlyState: TicketState.activo), showActions: true),
                          _buildTicketsList(_applyFilters(_tickets, onlyState: TicketState.usado)),
                          _buildHistorySection(),
                          _buildDashboard(activos: activos, usados: usados, sinUsar: sinUsar),
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

  // ------------------------ Widgets de soporte Tickets ------------------------

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _miniBtn({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        border: Border.all(color: AppColors.gray.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppColors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _transportChip(String label) {
    final sel = transportFilter == label;
    return GestureDetector(
      onTap: () => setState(() => transportFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? AppColors.primary : AppColors.gray.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              label == 'Todos'
                  ? Icons.select_all
                  : label == 'Metro'
                      ? Icons.train
                      : label == 'OMSA'
                          ? Icons.directions_bus
                          : label == 'Teleférico'
                              ? Icons.tram
                              : Icons.directions_transit,
              size: 16,
              color: sel ? AppColors.white : AppColors.dark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: sel ? AppColors.white : AppColors.dark,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color, IconData icon) {
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
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.7))),
        ],
      ),
    );
  }

  double _sumRD(List<Ticket> list) => list.fold(0.0, (a, b) => a + b.priceRD);

  Widget _buildTicketsList(List<Ticket> list, {bool showActions = false}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No hay tickets para los filtros seleccionados.',
            style: TextStyle(color: AppColors.brown.withOpacity(0.9)),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];
        final status = t.state == TicketState.activo ? 'ACTIVO' : 'USADO';
        final statusColor = t.state == TicketState.activo ? AppColors.primary : const Color(0xFF4CAF50);
        return _ticketCard(
          ticket: t,
          status: status,
          statusColor: statusColor,
          showActions: showActions && t.state == TicketState.activo,
        );
      },
    );
  }

  Widget _ticketCard({
    required Ticket ticket,
    required String status,
    required Color statusColor,
    required bool showActions,
  }) {
    return GestureDetector(
      onTap: () {
        if (showActions) _showTicketDetails(ticket);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: showActions ? statusColor.withOpacity(0.3) : AppColors.gray.withOpacity(0.2),
            width: showActions ? 2 : 1,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getTransportIcon(ticket.transport), color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(ticket.id,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.dark)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ticket.transport} – ${ticket.route}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.dark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _fmtDate(ticket.date),
                        style: TextStyle(fontSize: 12, color: AppColors.gray.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_fmtRD(ticket.priceRD),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                    if (showActions && ticket.hasQR) ...[
                      const SizedBox(height: 4),
                      const Icon(Icons.qr_code, color: AppColors.primary, size: 20),
                    ],
                  ],
                ),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.gray, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _ticketAction('Pasar', Icons.nfc, () => _openTapToPay(ticketId: ticket.id))),
                  _vDivider(),
                  Expanded(child: _ticketAction('Ver QR', Icons.qr_code_scanner, () => _showQRCode(ticket.id))),
                  _vDivider(),
                  Expanded(child: _ticketAction('Detalles', Icons.info_outline, () => _showTicketDetails(ticket))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ticketAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 20, color: AppColors.gray);

  // ----------------------------- Historial -----------------------------

  Widget _buildHistorySection() {
    // Tomamos todos los tickets (según filtros) y agrupamos por fecha (día)
    final filtered = _applyFilters(_tickets);
    final byDay = <String, List<Ticket>>{};
    for (final t in filtered) {
      final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []).add(t);
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a)); // desc

    if (days.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No hay historial para los filtros.', style: TextStyle(color: AppColors.brown.withOpacity(0.9))),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Resumen del mes (mock simple)
        _monthSummary(filtered),
        const SizedBox(height: 16),
        for (final d in days) ...[
          _dateHeader(d),
          const SizedBox(height: 8),
          for (final t in byDay[d]!) _ticketCard(
            ticket: t,
            status: t.state == TicketState.activo ? 'ACTIVO' : 'USADO',
            statusColor: t.state == TicketState.activo ? AppColors.primary : const Color(0xFF4CAF50),
            showActions: t.state == TicketState.activo,
          ),
          const SizedBox(height: 16),
        ],
        Center(
          child: OutlinedButton(
            onPressed: () => _snack('Cargando historial completo...'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Ver Historial Completo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _monthSummary(List<Ticket> list) {
    final total = _sumRD(list);
    final viajes = list.length;
    final fav = _favoriteTransport(list);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          _monthYear(DateTime.now()),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _historyStat('$viajes', 'Viajes')),
            Expanded(child: _historyStat(_fmtRD(total), 'Gastado')),
            Expanded(child: _historyStat(fav, 'Favorito')),
          ],
        ),
      ]),
    );
  }

  String _favoriteTransport(List<Ticket> list) {
    final counts = <String, int>{};
    for (final t in list) {
      counts[t.transport] = (counts[t.transport] ?? 0) + 1;
    }
    if (counts.isEmpty) return '-';
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  Widget _historyStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.brown)),
      ],
    );
  }

  Widget _dateHeader(String isoDay) {
    final parts = isoDay.split('-');
    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    return Text(
      _humanDay(date),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark),
    );
  }

  // ----------------------------- Dashboard (e) -----------------------------

  Widget _buildDashboard({
    required List<Ticket> activos,
    required List<Ticket> usados,
    required List<Ticket> sinUsar,
  }) {
    // Totales
    final totalGasto = _sumRD(_applyFilters(_tickets)); // aplica filtros globales
    final gastoUsados = _sumRD(usados);
    final gastoActivos = _sumRD(activos);
    final gastoSinUsar = _sumRD(sinUsar);

    // Por medio de transporte
    final byTransport = <String, double>{};
    for (final t in _applyFilters(_tickets)) {
      byTransport[t.transport] = (byTransport[t.transport] ?? 0) + t.priceRD;
    }

    // Por ruta
    final byRoute = <String, double>{};
    for (final t in _applyFilters(_tickets)) {
      byRoute[t.route] = (byRoute[t.route] ?? 0) + t.priceRD;
    }
    final topRoutes = byRoute.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final showTop = topRoutes.take(5).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Filtros de dashboard reutilizan los de arriba: chips + buscador ya aplican
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resumen por categoría', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.dark)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _summaryTile('Gastado (Total)', _fmtRD(totalGasto))),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryTile('Usados', _fmtRD(gastoUsados))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _summaryTile('Activos', _fmtRD(gastoActivos))),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryTile('Sin usar', _fmtRD(gastoSinUsar))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Barras por medio de transporte
        _sectionTitle('Gasto por medio de transporte'),
        const SizedBox(height: 8),
        if (byTransport.isEmpty)
          _emptyHint('No hay datos para los filtros.')
        else
          _barList(byTransport),

        const SizedBox(height: 16),

        // Top rutas
        _sectionTitle('Top rutas por gasto'),
        const SizedBox(height: 8),
        if (showTop.isEmpty)
          _emptyHint('No hay datos para los filtros.')
        else
          _topRoutesList(showTop),
      ],
    );
  }

  Widget _summaryTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.brown, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _barList(Map<String, double> map) {
    final maxVal = map.values.isEmpty ? 1 : map.values.reduce((a, b) => a > b ? a : b);
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      children: [
        for (final e in entries) ...[
          _barRow(label: e.key, value: e.value, max: maxVal.toDouble()),
          const SizedBox(height: 8),
        ]
      ],
    );
  }

  Widget _barRow({required String label, required double value, required double max}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark)),
              const SizedBox(height: 6),
              LayoutBuilder(
                builder: (_, c) {
                  final w = (value / max) * c.maxWidth;
                  return Stack(
                    children: [
                      Container(
                        height: 10,
                        width: c.maxWidth,
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        height: 10,
                        width: w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ]),
          ),
          const SizedBox(width: 12),
          Text(_fmtRD(value), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _topRoutesList(List<MapEntry<String, double>> items) {
    return Column(
      children: [
        for (final e in items) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.route, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark)),
                ),
                Text(_fmtRD(e.value), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.dark)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _emptyHint(String msg) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(msg, style: const TextStyle(color: AppColors.brown)),
      );

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.dark),
      );

  // ----------------------------- Acciones (c, d) -----------------------------

  void _openTopUpSheet() {
    final amountCtrl = TextEditingController(text: '200');
    String payment = 'Tarjeta';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 12),
              const Text('Recargar tarjeta', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gray.withOpacity(0.4)),
                      ),
                      child: TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Monto RD\$',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 6,
                    children: [100, 200, 300].map((v) {
                      return GestureDetector(
                        onTap: () => amountCtrl.text = v.toString(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.light,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.gray.withOpacity(0.3)),
                          ),
                          child: Text('RD\$$v', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _payChip('Tarjeta', payment == 'Tarjeta', onTap: () => setState(() {})),
                  const SizedBox(width: 8),
                  _payChip('tPago', payment == 'tPago', onTap: () => setState(() {})),
                  const SizedBox(width: 8),
                  _payChip('PayPal', payment == 'PayPal', onTap: () => setState(() {})),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final val = double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0.0;
                    if (val <= 0) {
                      Navigator.pop(context);
                      _snack('Monto inválido');
                      return;
                    }
                    setState(() => walletBalanceRD += val);
                    Navigator.pop(context);
                    _snack('Recarga exitosa: ${_fmtRD(val)}');
                  },
                  icon: const Icon(Icons.add_card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  label: const Text('Recargar ahora'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _payChip(String label, bool isSel, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSel ? AppColors.secondary : AppColors.gray.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(
              label == 'Tarjeta'
                  ? Icons.credit_card
                  : label == 'tPago'
                      ? Icons.phone_iphone
                      : Icons.account_balance_wallet_outlined,
              size: 16,
              color: isSel ? AppColors.white : AppColors.dark,
            ),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSel ? AppColors.white : AppColors.dark, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _openTapToPay({String? ticketId}) {
    bool nfcEnabled = true;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSB) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.nfc, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(ticketId == null ? 'Pasar con el teléfono' : 'Pasar Ticket $ticketId'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('NFC habilitado'),
                  value: nfcEnabled,
                  onChanged: (v) => setStateSB(() => nfcEnabled = v),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gray.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Icon(Icons.qr_code, size: 120, color: AppColors.dark),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acerca el teléfono al lector o muestra el QR.',
                  style: TextStyle(color: AppColors.brown),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _snack('Acceso concedido ✅');
                },
                icon: const Icon(Icons.check_circle),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                label: const Text('Simular acceso'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------------------- Detalles / QR -----------------------------

  void _showQRCode(String ticketId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code - $ticketId'),
        content: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray),
          ),
          child: const Icon(Icons.qr_code, size: 160, color: AppColors.dark),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _snack('QR guardado en la galería (mock).');
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showTicketDetails(Ticket t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Detalles del Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark)),
          const SizedBox(height: 20),
          _detailRow('Número:', t.id),
          _detailRow('Transporte:', t.transport),
          _detailRow('Ruta:', t.route),
          _detailRow('Fecha:', _fmtDate(t.date)),
          _detailRow('Precio:', _fmtRD(t.priceRD)),
          _detailRow('Estado:', t.state == TicketState.activo ? 'Activo' : (t.state == TicketState.usado ? 'Usado' : 'Sin usar')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Cerrar'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brown)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.dark))),
      ]),
    );
  }

  // ----------------------------- Utilidades -----------------------------

  IconData _getTransportIcon(String transport) {
    switch (transport) {
      case 'Metro':
        return Icons.train;
      case 'OMSA':
        return Icons.directions_bus;
      case 'Teleférico':
        return Icons.tram;
      case 'Corredor':
        return Icons.directions_transit;
      default:
        return Icons.confirmation_number;
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _fmtRD(double n) {
    final intPart = n.floor();
    final dec = ((n - intPart) * 100).round().toString().padLeft(2, '0');
    final s = intPart.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return 'RD\$$s.$dec';
    // Si no quieres decimales usa: return 'RD\$${n.toStringAsFixed(0)}';
  }

  String _fmtDate(DateTime d) {
    final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $hh:$mm';
  }

  String _humanDay(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return 'Hoy - ${_dayMonth(d)}';
    if (diff == -1) return 'Ayer - ${_dayMonth(d)}';
    return _dayMonth(d);
  }

  String _dayMonth(DateTime d) {
    final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _monthYear(DateTime d) {
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${months[d.month - 1]} ${d.year}';
  }
}

// ----------------------------- Profile Page -----------------------------

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: const Text('S', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sofia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
                        Text('Ciudadana', style: TextStyle(fontSize: 16, color: AppColors.gray)),
                        Text('1200 puntos',
                            style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _profileOption(
                        context,
                        'Desafíos de Tráfico',
                        'Pon a prueba tus conocimientos',
                        Icons.quiz,
                        AppColors.primary,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TrafficChallengesPage()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _profileOption(
                        context,
                        'Mis Documentos',
                        'Licencia, seguros y multas',
                        Icons.description,
                        AppColors.secondary,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DocumentsPage()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _profileOption(
                        context,
                        'Historial de Tickets',
                        'Ver tickets anteriores',
                        Icons.receipt_long,
                        AppColors.brown,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Historial desde perfil próximamente.')),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _profileOption(
                        context,
                        'Configuración',
                        'Ajustes de la aplicación',
                        Icons.settings,
                        AppColors.gray,
                        () {},
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

  Widget _profileOption(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.brown)),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.gray, size: 16),
          ],
        ),
      ),
    );
  }
}
