import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tickets/presentation/pages/purchase_ticket_page.dart';

class RouteDetailsPage extends StatefulWidget {
  final String routeName;
  final String transportType;

  const RouteDetailsPage({
    super.key,
    required this.routeName,
    required this.transportType,
  });

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  // Estados UI
  bool isFavorite = false;
  bool isReturn = false; // sentido ida/vuelta
  bool departNow = true; // ahora o programado
  DateTime? scheduledDate;

  // Ticket
  final List<String> ticketTypes = ['Sencillo', 'Ida y vuelta', 'Estudiante'];
  String selectedTicket = 'Sencillo';
  int passengers = 1;

  // Costos mock
  final Map<String, int> ticketBasePrice = {
    'Sencillo': 35,
    'Ida y vuelta': 60,
    'Estudiante': 20,
  };

  // Datos mock de segmentos y paradas
  final List<_RouteLeg> legs = [
    _RouteLeg(
      mode: 'Bus',
      color: const Color(0xFF4CAF50),
      icon: Icons.directions_bus,
      title: 'Bus → Estación Juan Pablo Duarte',
      subtitle: 'Línea alimentadora',
      durationMin: 12,
      stops: [
        _Stop('Palacio Nacional', 'Punto de partida'),
        _Stop('Av. México', 'Parada intermedia'),
        _Stop('Est. Juan Pablo Duarte', 'Conexión con Metro L1/L2'),
      ],
    ),
    _RouteLeg(
      mode: 'Metro',
      color: AppColors.primary,
      icon: Icons.train,
      title: 'Metro L1 → Est. Juan Bosch',
      subtitle: 'Dirección: Mamá Tingó ↔ Centro de los Héroes',
      durationMin: 18,
      stops: [
        _Stop('Juan Pablo Duarte', 'Transbordo L1/L2'),
        _Stop('Máximo Gómez', 'Dirección Sur'),
        _Stop('Juan Bosch', 'Bajar aquí'),
      ],
    ),
    _RouteLeg(
      mode: 'Bus',
      color: AppColors.secondary,
      icon: Icons.directions_bus_filled,
      title: 'Bus → Ágora Mall',
      subtitle: 'Corredor Winston Churchill',
      durationMin: 10,
      stops: [
        _Stop('Av. 27 de Febrero', 'Parada frente a Downtown Center'),
        _Stop('Ágora Mall', 'Destino final'),
      ],
    ),
  ];

  int _calcTotalMinutes() =>
      legs.fold<int>(0, (sum, l) => sum + l.durationMin) + 5; // +5 de transfer

  int _calcTotalCostRD() {
    final base = ticketBasePrice[selectedTicket] ?? 35;
    // supongamos que el metro RD$20 + 2 buses RD$15 c/u → básico incluido en base
    return base * passengers;
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  void _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      initialDate: now,
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 15))),
    );
    if (time == null) return;
    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      scheduledDate = dt;
      departNow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalMin = _calcTotalMinutes();
    final arrival = (departNow ? DateTime.now() : (scheduledDate ?? DateTime.now()))
        .add(Duration(minutes: totalMin));

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.routeName,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Compartir',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartido (mock)')),
              );
            },
            icon: const Icon(Icons.ios_share, color: AppColors.white),
          ),
          IconButton(
            tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
            onPressed: () => setState(() => isFavorite = !isFavorite),
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_outline,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Cover / Mapa simulado
              _coverHeader(),

              // Contenido
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _routeSummary(totalMin, arrival),
                        const SizedBox(height: 16),
                        _directionAndTimeSelectors(),
                        const SizedBox(height: 16),
                        _legsList(),
                        const SizedBox(height: 16),
                        _timelineCard(totalMin, arrival),
                        const SizedBox(height: 16),
                        _ticketSelector(),
                        const SizedBox(height: 8),
                        _passengerSelector(),
                        const SizedBox(height: 16),
                        _tipsCard(),
                        const SizedBox(height: 8),
                        _disclaimerCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom bar sticky
          _bottomPurchaseBar(),
        ],
      ),
    );
  }

  // ------------------ Widgets UI ------------------

  Widget _coverHeader() {
    return Container(
      height: 230,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/metro.png'), // tu placeholder
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.35)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                _roundIcon(Icons.place, AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${widget.transportType} • Santo Domingo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _pill('Tránsitos: 2'),
                const SizedBox(width: 6),
                _pill('Paradas: 15'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _routeSummary(int totalMin, DateTime arrival) {
    return _card(
      child: Row(
        children: [
          _roundIcon(Icons.route, AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumen del viaje',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.dark,
                    )),
                const SizedBox(height: 6),
                Text(
                  isReturn
                      ? 'Desde: Ágora Mall  •  Hasta: Palacio Nacional'
                      : 'Desde: Palacio Nacional  •  Hasta: Ágora Mall',
                  style: const TextStyle(color: AppColors.brown, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chipIcon(Icons.schedule, '$totalMin min aprox.'),
                    _chipIcon(Icons.access_time_filled, 'Llegas: ${_fmtTime(arrival)}'),
                    _chipIcon(Icons.attach_money, 'Costo desde RD\$${ticketBasePrice[selectedTicket]}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _directionAndTimeSelectors() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preferencias de viaje',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.dark,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _segmented(
                  label: 'Sentido',
                  options: const ['Ida', 'Vuelta'],
                  selectedIndex: isReturn ? 1 : 0,
                  onChanged: (i) => setState(() => isReturn = i == 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _segmented(
                  label: 'Salida',
                  options: const ['Ahora', 'Programar'],
                  selectedIndex: departNow ? 0 : 1,
                  onChanged: (i) {
                    if (i == 0) {
                      setState(() {
                        departNow = true;
                        scheduledDate = null;
                      });
                    } else {
                      _pickDateTime();
                    }
                  },
                ),
              ),
            ],
          ),
          if (!departNow && scheduledDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event, size: 18, color: AppColors.brown),
                const SizedBox(width: 6),
                Text(
                  'Programado: ${scheduledDate!.day}/${scheduledDate!.month}/${scheduledDate!.year} ${_fmtTime(scheduledDate!)}',
                  style: const TextStyle(color: AppColors.brown),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Cambiar'),
                )
              ],
            )
          ],
        ],
      ),
    );
  }

  Widget _legsList() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Segmentos del viaje',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.dark,
              )),
          const SizedBox(height: 8),
          ...legs.map((leg) => _legTile(leg)).toList(),
        ],
      ),
    );
  }

  Widget _legTile(_RouteLeg leg) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: _roundIcon(leg.icon, leg.color),
          title: Text(leg.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.dark)),
          subtitle: Text('${leg.subtitle} • ${leg.durationMin} min',
              style: const TextStyle(color: AppColors.brown)),
          children: [
            Column(
              children: leg.stops
                  .map((s) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 6),
                          Column(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: leg.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 26,
                                color: leg.color.withOpacity(0.4),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.dark)),
                                  if (s.note != null && s.note!.isNotEmpty)
                                    Text(s.note!,
                                        style: const TextStyle(
                                            color: AppColors.brown)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineCard(int totalMin, DateTime arrival) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Itinerario (timeline)',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.dark,
              )),
          const SizedBox(height: 12),
          _timelineRow(Icons.play_arrow, AppColors.primary,
              'Salida', departNow ? 'Ahora' : _fmtTime(scheduledDate!)),
          const SizedBox(height: 8),
          _timelineRow(Icons.sync_alt, const Color(0xFF4CAF50),
              'Transferencias', '2 (Juan Pablo Duarte / Juan Bosch)'),
          const SizedBox(height: 8),
          _timelineRow(Icons.flag, AppColors.secondary, 'Llegada',
              _fmtTime(arrival)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _pill('Distancia estimada: 8.5 km'),
              _pill('Paradas totales: 15'),
            ],
          )
        ],
      ),
    );
  }

  Widget _ticketSelector() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tipo de ticket',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.dark,
              )),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ticketTypes.map((t) {
              final selected = t == selectedTicket;
              return GestureDetector(
                onTap: () => setState(() => selectedTicket = t),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.gray.withOpacity(0.3),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? Icons.radio_button_checked : Icons.radio_button_off,
                        size: 18,
                        color: selected ? AppColors.primary : AppColors.brown,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? AppColors.primary : AppColors.dark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _pill('RD\$${ticketBasePrice[t]}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _passengerSelector() {
    return _card(
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Pasajeros',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.dark),
            ),
          ),
          _roundIconBtn(Icons.remove, onTap: () {
            if (passengers > 1) {
              setState(() => passengers--);
            }
          }),
          const SizedBox(width: 10),
          Text(
            '$passengers',
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.dark),
          ),
          const SizedBox(width: 10),
          _roundIconBtn(Icons.add, onTap: () {
            setState(() => passengers++);
          }),
        ],
      ),
    );
  }

  Widget _tipsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Consejos',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.dark)),
          SizedBox(height: 8),
          _Bullet('Llega 5–10 minutos antes a las transferencias.'),
          _Bullet('Ten efectivo por si alguna ruta no acepta tarjeta.'),
          _Bullet('Evita horas pico (7–9 AM y 5–7 PM) si puedes.'),
        ],
      ),
    );
  }

  Widget _disclaimerCard() {
    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: AppColors.brown),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Los tiempos y costos son estimados y pueden variar según el tránsito y la demanda.',
              style: TextStyle(color: AppColors.brown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomPurchaseBar() {
    final total = _calcTotalCostRD();
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, -4),
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(color: AppColors.brown)),
                  const SizedBox(height: 2),
                  Text(
                    'RD\$$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchaseTicketPage(
                        routeName: widget.routeName,
                        transportType: widget.transportType,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  'Comprar Ticket',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Helpers UI ------------------

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
      child: child,
    );
  }

  Widget _roundIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _roundIconBtn(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.gray.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 20, color: AppColors.dark),
      ),
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

  Widget _chipIcon(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.brown),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _segmented({
    required String label,
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.brown, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray.withOpacity(0.25)),
          ),
          child: Row(
            children: List.generate(options.length, (i) {
              final selected = i == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      options[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? AppColors.primary : AppColors.dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _timelineRow(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        _roundIcon(icon, color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.dark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: AppColors.brown)),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------ Modelos Mock ------------------

class _RouteLeg {
  final String mode;
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final int durationMin;
  final List<_Stop> stops;
  _RouteLeg({
    required this.mode,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.durationMin,
    required this.stops,
  });
}

class _Stop {
  final String name;
  final String? note;
  _Stop(this.name, [this.note]);
}

// ------------------ Widgets simples ------------------

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppColors.dark),
            ),
          ),
        ],
      ),
    );
  }
}
