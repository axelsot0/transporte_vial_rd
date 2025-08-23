import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'digital_ticket_page.dart';

class PurchaseTicketPage extends StatefulWidget {
  final String routeName;
  final String transportType;

  const PurchaseTicketPage({
    super.key,
    required this.routeName,
    required this.transportType,
  });

  @override
  State<PurchaseTicketPage> createState() => _PurchaseTicketPageState();
}

class _PurchaseTicketPageState extends State<PurchaseTicketPage> {
  // --------- Estado principal ----------
  String selectedTransport = 'Metro';
  String? selectedRoute; // usar null cuando no hay selección
  int passengers = 1;

  // Pago
  String selectedPayment = 'Tarjeta de Crédito';
  final TextEditingController cardNameCtrl = TextEditingController();
  final TextEditingController cardNumberCtrl = TextEditingController();
  final TextEditingController cardExpiryCtrl = TextEditingController();
  final TextEditingController cardCvvCtrl = TextEditingController();

  // Descuento
  final TextEditingController discountCtrl = TextEditingController();
  String appliedCoupon = '';
  double appliedDiscountRD = 0.0;

  // Hora pico mock (si es hora pico, +10%)
  bool peakHour = false;

  // Rutas mock
  final Map<String, List<String>> routesByTransport = {
    'Metro': [
      'L1: Centro de los Héroes ↔ Mamá Tingó',
      'L2: María Montez ↔ Eduardo Brito',
      'L2B: Eduardo Brito ↔ Concepción Bona'
    ],
    'Bus': [
      'OMSA: Kennedy – Churchill',
      'OMSA: 27 de Febrero – Máximo Gómez',
      'Corredor: Núñez de Cáceres'
    ],
    'Taxi': [
      'EcoTaxi Zona Colonial → Ágora Mall',
      'Taxi SDQ Centro → Aeropuerto',
      'Taxi Piantini → Naco'
    ],
  };

  // Precio base por transporte (por pasajero)
  final Map<String, double> baseFareRD = {
    'Metro': 20.0,
    'Bus': 25.0,
    'Taxi': 250.0,
  };

  @override
  void initState() {
    super.initState();
    // Iniciar con datos que llegan de la ruta anterior
    selectedTransport = widget.transportType.isNotEmpty ? widget.transportType : 'Metro';
    // Si routeName llega con valor real, úsalo como preselección
    if (widget.routeName.isNotEmpty) {
      selectedRoute = widget.routeName;
    }
    // Mock: detectar hora pico (7–9 AM o 5–7 PM)
    final now = TimeOfDay.now();
    peakHour = ((now.hour >= 7 && now.hour < 9) || (now.hour >= 17 && now.hour < 19));
  }

  @override
  void dispose() {
    cardNameCtrl.dispose();
    cardNumberCtrl.dispose();
    cardExpiryCtrl.dispose();
    cardCvvCtrl.dispose();
    discountCtrl.dispose();
    super.dispose();
  }

  // --------- Lógica de precios ----------
  double _calcSubtotalRD() {
    final base = baseFareRD[selectedTransport] ?? 0.0;
    double subtotal = base * passengers;

    // Ajuste por hora pico (mock +10%)
    if (peakHour && selectedTransport != 'Taxi') {
      subtotal *= 1.10;
    }

    // Ajuste por distancia/ruta (mock): si hay ruta elegida que parezca "larga" sumamos +5 RD por pax
    if ((selectedRoute ?? '').toLowerCase().contains('aeropuerto') ||
        (selectedRoute ?? '').toLowerCase().contains('↔')) {
      subtotal += 5.0 * passengers;
    }

    return subtotal;
  }

  double _calcDiscountRD(double subtotal) {
    // Si ya hay cupón aplicado, respetarlo
    if (appliedCoupon.isEmpty) return 0.0;
    // Descuentos ya calculados y guardados cuando se aplicó el cupón
    return appliedDiscountRD.clamp(0.0, subtotal);
  }

  double _calcTotalRD() {
    final sub = _calcSubtotalRD();
    final disc = _calcDiscountRD(sub);
    return (sub - disc).clamp(0.0, double.infinity);
  }

  // --------- Aplicación de cupones ----------
  void _applyCoupon() {
    final code = discountCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      _snack('Ingresa un código de descuento.');
      return;
    }
    final subtotal = _calcSubtotalRD();
    double discount = 0.0;

    // Ejemplos de cupones:
    // STUDENT20: 20% descuento (para simular estudiantes)
    // WELCOME10: RD$10 fijo
    // WEEKEND5: 5% descuento fines de semana
    switch (code) {
      case 'STUDENT20':
        discount = subtotal * 0.20;
        break;
      case 'WELCOME10':
        discount = 10.0;
        break;
      case 'WEEKEND5':
        final now = DateTime.now();
        final isWeekend = now.weekday == 6 || now.weekday == 7;
        if (isWeekend) {
          discount = subtotal * 0.05;
        } else {
          _snack('WEEKEND5 solo aplica fines de semana.');
          return;
        }
        break;
      default:
        _snack('Código no válido.');
        return;
    }

    setState(() {
      appliedCoupon = code;
      appliedDiscountRD = discount;
    });
    _snack('Descuento aplicado: ${_fmtRD(discount)}');
  }

  // --------- Validaciones de pago ----------
  bool _validateCard() {
    if (selectedPayment != 'Tarjeta de Crédito') return true;
    if (cardNameCtrl.text.trim().length < 4) {
      _snack('Nombre en la tarjeta inválido.');
      return false;
    }
    if (cardNumberCtrl.text.replaceAll(' ', '').length < 16) {
      _snack('Número de tarjeta inválido.');
      return false;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(cardExpiryCtrl.text.trim())) {
      _snack('Fecha de expiración inválida. Usa MM/AA.');
      return false;
    }
    if (cardCvvCtrl.text.trim().length < 3) {
      _snack('CVV inválido.');
      return false;
    }
    return true;
  }

  // --------- UI principal ----------
  @override
  Widget build(BuildContext context) {
    final subtotal = _calcSubtotalRD();
    final discount = _calcDiscountRD(subtotal);
    final total = _calcTotalRD();

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comprar Ticket',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Seleccionar Tipo de Transporte'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _transportChip('Metro'),
                    _transportChip('Bus'),
                    _transportChip('Taxi'),
                  ],
                ),

                const SizedBox(height: 24),
                _sectionTitle('Seleccionar Ruta'),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _openRoutePicker(),
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedRoute ?? 'Elegir',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: AppColors.brown),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (peakHour)
                  Row(
                    children: const [
                      Icon(Icons.bolt, size: 18, color: Colors.orange),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Hora pico detectada: puede aplicar un recargo del 10% (mock).',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),
                _sectionTitle('Pasajeros'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _roundIconBtn(Icons.remove, onTap: () {
                      if (passengers > 1) setState(() => passengers--);
                    }),
                    const SizedBox(width: 12),
                    Text(
                      '$passengers',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _roundIconBtn(Icons.add, onTap: () => setState(() => passengers++)),
                    const Spacer(),
                    _pill('RD\$${(baseFareRD[selectedTransport] ?? 0).toInt()} por pax'),
                  ],
                ),

                const SizedBox(height: 24),
                _sectionTitle('Aplicar Código de Descuento'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.gray.withOpacity(0.5)),
                        ),
                        child: TextField(
                          controller: discountCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa código (p.ej. STUDENT20)',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            hintStyle: TextStyle(color: AppColors.brown),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
                if (appliedCoupon.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.sell, size: 18, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 6),
                      Text(
                        'Cupón aplicado: $appliedCoupon (${_fmtRD(appliedDiscountRD)})',
                        style: const TextStyle(color: Color(0xFF4CAF50)),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            appliedCoupon = '';
                            appliedDiscountRD = 0.0;
                            discountCtrl.clear();
                          });
                        },
                        child: const Text('Quitar'),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
                _sectionTitle('Método de Pago'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _paymentChip('Tarjeta de Crédito'),
                    _paymentChip('tPago'),
                    _paymentChip('PayPal'),
                  ],
                ),
                const SizedBox(height: 12),

                if (selectedPayment == 'Tarjeta de Crédito') _cardForm(),

                const SizedBox(height: 24),
                _sectionTitle('Resumen'),
                const SizedBox(height: 12),
                _summaryCard(subtotal, discount, total),

                const SizedBox(height: 8),
                _disclaimer(),
              ],
            ),
          ),

          // ---- Barra inferior sticky ----
          Positioned(
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
                        const Text('Total a pagar', style: TextStyle(color: AppColors.brown)),
                        const SizedBox(height: 2),
                        Text(
                          _fmtRD(total),
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
                      onPressed: _onPurchase,
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
          ),
        ],
      ),
    );
  }

  // --------- Acciones ----------
  void _onPurchase() {
    if (selectedRoute == null || selectedRoute!.isEmpty || selectedRoute == 'Elegir') {
      _snack('Selecciona una ruta para continuar.');
      return;
    }
    if (!_validateCard()) return;

    // Generar número de ticket pseudo-aleatorio
    final ticketNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalTicketPage(
          routeName: selectedRoute ?? widget.routeName,
          transportType: selectedTransport,
          ticketNumber: ticketNumber,
        ),
      ),
    );
  }

  Future<void> _openRoutePicker() async {
    final items = routesByTransport[selectedTransport] ?? [];
    final chosen = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _RoutePickerSheet(
        title: 'Elige tu ruta - $selectedTransport',
        options: items,
      ),
    );
    if (chosen != null && chosen.isNotEmpty) {
      setState(() {
        selectedRoute = chosen;
      });
    }
  }

  // --------- Widgets atómicos ----------
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }

  Widget _transportChip(String label) {
    final isSelected = selectedTransport == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransport = label;
          // reset de ruta aplicada si cambia el transporte
          selectedRoute = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              label == 'Metro'
                  ? Icons.train
                  : label == 'Bus'
                      ? Icons.directions_bus
                      : Icons.local_taxi,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.dark,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentChip(String label) {
    final isSelected = selectedPayment == label;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.gray.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              label == 'Tarjeta de Crédito'
                  ? Icons.credit_card
                  : label == 'tPago'
                      ? Icons.phone_iphone
                      : Icons.account_balance_wallet_outlined,
              size: 16,
              color: isSelected ? AppColors.white : AppColors.dark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.dark,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
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

  // --------- Formularios / Cards ----------
  Widget _cardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.4)),
      ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detalles de la tarjeta',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.dark)),
          const SizedBox(height: 10),
          _input(
            controller: cardNameCtrl,
            hint: 'Nombre en la tarjeta',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 10),
          _input(
            controller: cardNumberCtrl,
            hint: 'Número de tarjeta (16 dígitos)',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            formatter: (s) => s.replaceAll(RegExp(r'\D'), '').replaceAllMapped(
              RegExp(r".{1,4}"), (match) => "${match.group(0)} ",
            ).trim(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _input(
                  controller: cardExpiryCtrl,
                  hint: 'MM/AA',
                  icon: Icons.date_range,
                  keyboardType: TextInputType.number,
                  formatter: (s) {
                    final nums = s.replaceAll(RegExp(r'\D'), '');
                    if (nums.length <= 2) return nums;
                    return '${nums.substring(0, 2)}/${nums.substring(2, nums.length.clamp(2, 4))}';
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _input(
                  controller: cardCvvCtrl,
                  hint: 'CVV',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(double subtotal, double discount, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            const Icon(Icons.receipt_long, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Detalle de pago',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark),
            ),
            const Spacer(),
            if (selectedRoute != null)
              _pill(selectedRoute!.length > 24
                  ? '${selectedRoute!.substring(0, 24)}…'
                  : selectedRoute!),
          ],
        ),
        const SizedBox(height: 10),
        _rowKV('Transporte', selectedTransport),
        _rowKV('Pasajeros', '$passengers'),
        _rowKV('Subtotal', _fmtRD(subtotal)),
        if (appliedCoupon.isNotEmpty) _rowKV('Cupón $appliedCoupon', '- ${_fmtRD(discount)}'),
        if (peakHour) _rowKV('Recargo hora pico', '+10% (incluido en subtotal)'),
        const Divider(height: 20),
        _rowKV('Total', _fmtRD(total), bold: true),
      ]),
    );
  }

  Widget _disclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(Icons.info_outline, color: AppColors.brown),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Los precios son estimados en RD\$ y pueden variar por demanda, horario y operador.',
            style: TextStyle(color: AppColors.brown),
          ),
        ),
      ],
    );
  }

  // --------- Inputs helpers ----------
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String Function(String)? formatter,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: (value) {
          if (formatter != null) {
            final cursorPos = controller.selection.baseOffset;
            final formatted = formatter(value);
            controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(
                offset: (cursorPos > formatted.length) ? formatted.length : cursorPos,
              ),
            );
          }
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintStyle: const TextStyle(color: AppColors.brown),
          prefixIcon: Icon(icon, color: AppColors.brown),
        ),
      ),
    );
  }

  // --------- Layout helpers ----------
  Widget _rowKV(String k, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(
                color: AppColors.dark,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --------- Util ----------
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _fmtRD(double n) {
    // RD$ con separadores simples
    final intPart = n.floor();
    final dec = ((n - intPart) * 100).round().toString().padLeft(2, '0');
    final s = intPart.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'RD\$$s.$dec';
  }
}

// ------------------ BottomSheet para elegir ruta ------------------

class _RoutePickerSheet extends StatefulWidget {
  final String title;
  final List<String> options;

  const _RoutePickerSheet({
    required this.title,
    required this.options,
  });

  @override
  State<_RoutePickerSheet> createState() => _RoutePickerSheetState();
}

class _RoutePickerSheetState extends State<_RoutePickerSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<String> filtered;

  @override
  void initState() {
    super.initState();
    filtered = List<String>.from(widget.options);
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.toLowerCase();
      setState(() {
        filtered = widget.options
            .where((e) => e.toLowerCase().contains(q))
            .toList(growable: false);
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.dark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray.withOpacity(0.4)),
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Buscar ruta…',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(color: AppColors.gray.withOpacity(0.2)),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    return ListTile(
                      title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600)),
                      leading: const Icon(Icons.place, color: AppColors.primary),
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
