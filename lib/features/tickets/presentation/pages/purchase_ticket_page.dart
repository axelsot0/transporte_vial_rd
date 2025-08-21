import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'digital_ticket_page.dart';  // Agregar esta línea

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
  String selectedTransport = 'Metro';
  String selectedRoute = 'Elegir';
  String discountCode = '';
  String selectedPayment = 'Tarjeta de Crédito';
  
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleccionar tipo de transporte
            const Text(
              'Seleccionar Tipo de Transporte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildTransportChip('Metro', selectedTransport == 'Metro'),
                const SizedBox(width: 12),
                _buildTransportChip('Bus', selectedTransport == 'Bus'),
                const SizedBox(width: 12),
                _buildTransportChip('Taxi', selectedTransport == 'Taxi'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seleccionar ruta
            const Text(
              'Seleccionar Ruta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray),
              ),
              child: Row(
                children: [
                  Text(
                    selectedRoute,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.dark,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.brown,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Aplicar código de descuento
            const Text(
              'Aplicar Código de Descuento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Ingresa código',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintStyle: TextStyle(color: AppColors.brown),
                ),
                onChanged: (value) {
                  setState(() {
                    discountCode = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Método de pago
            const Text(
              'Método de Pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildPaymentChip('Tarjeta de Crédito', selectedPayment == 'Tarjeta de Crédito'),
                const SizedBox(width: 12),
                _buildPaymentChip('tPago', selectedPayment == 'tPago'),
                const SizedBox(width: 12),
                _buildPaymentChip('PayPal', selectedPayment == 'PayPal'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Precio total
            Container(
              width: double.infinity,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precio Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$2.50',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (discountCode.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Descuento aplicado: -\$0.50',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botón Comprar Ticket
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                    // Generar número de ticket aleatorio
                    final ticketNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DigitalTicketPage(
                          routeName: widget.routeName,
                          transportType: widget.transportType,
                          ticketNumber: ticketNumber,
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
                ),
                child: const Text(
                  'Comprar Ticket',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 100), // Espacio para el navbar
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransportChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransport = label;
        });
      },
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
  
  Widget _buildPaymentChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.gray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.dark,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}