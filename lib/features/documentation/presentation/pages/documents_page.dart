import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mis Documentos',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.gray,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Licencia'),
            Tab(text: 'Seguro'),
            Tab(text: 'Multas'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLicenseTab(),
            _buildInsuranceTab(),
            _buildFinesTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLicenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado de la licencia
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Licencia Válida',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tu licencia está activa y al día',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Licencia digital
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Patrón de fondo
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.credit_card,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'REPÚBLICA DOMINICANA',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'LICENCIA DE CONDUCIR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Foto y datos
                      Row(
                        children: [
                          // Foto
                          Container(
                            width: 80,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Datos
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SOFIA MARTINEZ RODRIGUEZ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'No. 123-456-789-0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Categoría: B',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Vence: 08/15/2025',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // QR Code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expedida: 08/15/2020',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                'INTRANT - DGTT',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.qr_code,
                              color: AppColors.dark,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Acciones
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Renovar Licencia',
                  Icons.refresh,
                  AppColors.secondary,
                  () {
                    _showRenewalDialog();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Descargar PDF',
                  Icons.download,
                  AppColors.brown,
                  () {
                    _showDownloadDialog();
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Información adicional
          _buildInfoSection(
            'Información de la Licencia',
            [
              _buildInfoRow('Número de Licencia', '123-456-789-0'),
              _buildInfoRow('Categoría', 'B - Vehículos ligeros'),
              _buildInfoRow('Fecha de Expedición', '15 de Agosto, 2020'),
              _buildInfoRow('Fecha de Vencimiento', '15 de Agosto, 2025'),
              _buildInfoRow('Estado', 'Activa'),
              _buildInfoRow('Puntos Acumulados', '0 de 12'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInsuranceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado del seguro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.security,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seguro Activo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tu póliza está vigente hasta 12/31/2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tarjeta de seguro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary,
                  AppColors.secondary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del seguro
                const Row(
                  children: [
                    Icon(
                      Icons.shield,
                      color: AppColors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SEGUROS BANRESERVAS',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Póliza de Vehículo',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Información del vehículo
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VEHÍCULO ASEGURADO',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Toyota Corolla 2020',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Póliza No.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                'ABC123XYZ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vence',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                '31/12/2024',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Acciones
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Renovar Seguro',
                  Icons.autorenew,
                  AppColors.primary,
                  () {
                    _showInsuranceRenewalDialog();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Reportar Siniestro',
                  Icons.report_problem,
                  Colors.red,
                  () {
                    _showClaimDialog();
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Detalles de la póliza
          _buildInfoSection(
            'Detalles de la Póliza',
            [
              _buildInfoRow('Número de Póliza', 'ABC123XYZ'),
              _buildInfoRow('Aseguradora', 'Seguros Banreservas'),
              _buildInfoRow('Tipo de Cobertura', 'Todo Riesgo'),
              _buildInfoRow('Vigencia', '01/01/2024 - 31/12/2024'),
              _buildInfoRow('Prima Anual', 'RD\$28,000'),
              _buildInfoRow('Deducible', 'RD\$15,000'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFinesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado de multas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sin Multas Pendientes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'No tienes infracciones por pagar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Resumen de infracciones
          Container(
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
                  'Resumen de Infracciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildFinesStat('0', 'Pendientes', Colors.red),
                    ),
                    Expanded(
                      child: _buildFinesStat('2', 'Pagadas', const Color(0xFF4CAF50)),
                    ),
                    Expanded(
                      child: _buildFinesStat('0', 'Vencidas', Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Historial de multas
          const Text(
            'Historial de Infracciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Multa pagada ejemplo
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exceso de Velocidad',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        '15 de Octubre, 2024',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RD\$2,000',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      'PAGADA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Segunda multa ejemplo
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estacionamiento Prohibido',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        '3 de Septiembre, 2024',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RD\$1,500',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      'PAGADA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botón consultar nuevas multas
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                _showConsultFinesDialog();
              },
              icon: const Icon(Icons.search, size: 20),
              label: const Text(
                'Consultar Nuevas Infracciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen de tickets
          Container(
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
                  'Resumen de Tickets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildTicketStat('15', 'Total\nComprados', AppColors.primary),
                    ),
                    Expanded(
                      child: _buildTicketStat('12', 'Utilizados', const Color(0xFF4CAF50)),
                    ),
                    Expanded(
                      child: _buildTicketStat('RD\$375', 'Gastado\nTotal', AppColors.secondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Historial de tickets
          const Text(
            'Historial de Tickets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de tickets
          _buildTicketHistoryItem(
            '#145914',
            'Metro - Ruta 1: Santo Domingo',
            '23 Jul 2025, 10:30 AM',
            'RD\$2.50',
            true,
          ),
          
          _buildTicketHistoryItem(
            '#145890',
            'OMSA - Ruta Principal',
            '22 Jul 2025, 3:15 PM',
            'RD\$2.50',
            true,
          ),
          
          _buildTicketHistoryItem(
            '#145876',
            'Metro - Ruta 2: Santiago',
            '21 Jul 2025, 8:45 AM',
            'RD\$2.50',
            true,
          ),
          
          _buildTicketHistoryItem(
            '#145862',
            'Teleférico - Cable Car',
            '20 Jul 2025, 2:20 PM',
            'RD\$3.00',
            false,
          ),
          
          _buildTicketHistoryItem(
            '#145848',
            'Metro - Ruta 1: Santo Domingo',
            '19 Jul 2025, 7:30 AM',
            'RD\$2.50',
            true,
          ),
          
          const SizedBox(height: 24),
          
          // Botón ver más
          Center(
            child: OutlinedButton(
              onPressed: () {
                print('Ver más historial');
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
                style: TextStyle
                (
                 fontSize: 14,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ),
       ],
     ),
   );
 }
 
 Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
   return ElevatedButton.icon(
     onPressed: onPressed,
     icon: Icon(icon, size: 18),
     label: Text(
       text,
       style: const TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w600,
       ),
     ),
     style: ElevatedButton.styleFrom(
       backgroundColor: color,
       foregroundColor: AppColors.white,
       padding: const EdgeInsets.symmetric(vertical: 12),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
       ),
     ),
   );
 }
 
 Widget _buildInfoSection(String title, List<Widget> items) {
   return Container(
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
         Text(
           title,
           style: const TextStyle(
             fontSize: 18,
             fontWeight: FontWeight.bold,
             color: AppColors.dark,
           ),
         ),
         const SizedBox(height: 16),
         ...items,
       ],
     ),
   );
 }
 
 Widget _buildInfoRow(String label, String value) {
   return Padding(
     padding: const EdgeInsets.only(bottom: 12),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Expanded(
           flex: 2,
           child: Text(
             label,
             style: const TextStyle(
               fontSize: 14,
               color: AppColors.brown,
             ),
           ),
         ),
         Expanded(
           flex: 3,
           child: Text(
             value,
             style: const TextStyle(
               fontSize: 14,
               fontWeight: FontWeight.w600,
               color: AppColors.dark,
             ),
           ),
         ),
       ],
     ),
   );
 }
 
 Widget _buildFinesStat(String number, String label, Color color) {
   return Column(
     children: [
       Text(
         number,
         style: TextStyle(
           fontSize: 24,
           fontWeight: FontWeight.bold,
           color: color,
         ),
       ),
       const SizedBox(height: 4),
       Text(
         label,
         textAlign: TextAlign.center,
         style: const TextStyle(
           fontSize: 12,
           color: AppColors.brown,
         ),
       ),
     ],
   );
 }
 
 Widget _buildTicketStat(String number, String label, Color color) {
   return Column(
     children: [
       Text(
         number,
         style: TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.bold,
           color: color,
         ),
       ),
       const SizedBox(height: 4),
       Text(
         label,
         textAlign: TextAlign.center,
         style: const TextStyle(
           fontSize: 12,
           color: AppColors.brown,
         ),
       ),
     ],
   );
 }
 
 Widget _buildTicketHistoryItem(String ticketNumber, String route, String date, String price, bool used) {
   return Container(
     padding: const EdgeInsets.all(16),
     margin: const EdgeInsets.only(bottom: 12),
     decoration: BoxDecoration(
       color: AppColors.white,
       borderRadius: BorderRadius.circular(12),
       border: Border.all(color: AppColors.gray.withOpacity(0.3)),
       boxShadow: [
         BoxShadow(
           color: Colors.black.withOpacity(0.05),
           blurRadius: 4,
           offset: const Offset(0, 1),
         ),
       ],
     ),
     child: Row(
       children: [
         Container(
           padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             color: used ? const Color(0xFF4CAF50).withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
             borderRadius: BorderRadius.circular(8),
           ),
           child: Icon(
             used ? Icons.check_circle : Icons.confirmation_number,
             color: used ? const Color(0xFF4CAF50) : AppColors.primary,
             size: 20,
           ),
         ),
         
         const SizedBox(width: 12),
         
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 ticketNumber,
                 style: const TextStyle(
                   fontSize: 14,
                   fontWeight: FontWeight.bold,
                   color: AppColors.dark,
                 ),
               ),
               Text(
                 route,
                 style: const TextStyle(
                   fontSize: 13,
                   color: AppColors.dark,
                 ),
               ),
               Text(
                 date,
                 style: const TextStyle(
                   fontSize: 12,
                   color: AppColors.brown,
                 ),
               ),
             ],
           ),
         ),
         
         Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Text(
               price,
               style: const TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.bold,
                 color: AppColors.dark,
               ),
             ),
             Text(
               used ? 'USADO' : 'ACTIVO',
               style: TextStyle(
                 fontSize: 10,
                 color: used ? const Color(0xFF4CAF50) : AppColors.primary,
                 fontWeight: FontWeight.bold,
               ),
             ),
           ],
         ),
       ],
     ),
   );
 }
 
 // Diálogos
 void _showRenewalDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Renovar Licencia'),
         content: const Text(
           'Tu licencia vence el 15 de Agosto, 2025. ¿Deseas iniciar el proceso de renovación?',
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showRenewalProcess();
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
             child: const Text('Renovar'),
           ),
         ],
       );
     },
   );
 }
 
 void _showRenewalProcess() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Proceso de Renovación'),
         content: const Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text('Para renovar tu licencia necesitas:'),
             SizedBox(height: 12),
             Text('• Cédula de identidad vigente'),
             Text('• Certificado médico'),
             Text('• Pago de RD\$2,500'),
             Text('• Examen teórico actualizado'),
             SizedBox(height: 12),
             Text('¿Deseas agendar una cita en INTRANT?'),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Más Tarde'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showSuccessMessage('Cita agendada para el 5 de Agosto en INTRANT Centro');
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
             child: const Text('Agendar Cita'),
           ),
         ],
       );
     },
   );
 }
 
 void _showDownloadDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Descargar Licencia'),
         content: const Text(
           'Se descargará una copia digital de tu licencia en formato PDF.',
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showSuccessMessage('Licencia descargada exitosamente');
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.brown),
             child: const Text('Descargar'),
           ),
         ],
       );
     },
   );
 }
 
 void _showInsuranceRenewalDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Renovar Seguro'),
         content: const Text(
           'Tu póliza vence el 31 de Diciembre, 2024. Te conectaremos con Seguros Banreservas.',
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showSuccessMessage('Redirigiendo a Seguros Banreservas...');
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
             child: const Text('Continuar'),
           ),
         ],
       );
     },
   );
 }
 
 void _showClaimDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Reportar Siniestro'),
         content: const Text(
           '¿Has tenido un accidente? Te ayudaremos a reportarlo a tu aseguradora.',
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showSuccessMessage('Reporte iniciado. Te contactaremos en breve.');
             },
             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
             child: const Text('Reportar'),
           ),
         ],
       );
     },
   );
 }
 
 void _showConsultFinesDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Consultar Infracciones'),
         content: const Text(
           'Consultaremos en la base de datos de INTRANT si tienes nuevas infracciones.',
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text('Cancelar'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               _showSuccessMessage('No se encontraron nuevas infracciones');
             },
             style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
             child: const Text('Consultar'),
           ),
         ],
       );
     },
   );
 }
 
 void _showSuccessMessage(String message) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(message),
       backgroundColor: const Color(0xFF4CAF50),
       duration: const Duration(seconds: 3),
     ),
   );
 }
}