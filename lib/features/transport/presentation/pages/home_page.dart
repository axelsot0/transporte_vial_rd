import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'metro_page.dart';
import 'omsa_page.dart';           // Agregar
import 'teleferico_page.dart';     // Agregar
import 'corredor_page.dart';       // Agregar


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Column(
          children: [
            // Header con saludo
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buenas tardes, Sofia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '¿A dónde vamos hoy?',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Avatar/Profile
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'S',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Lista de transportes
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
                  children: const [
                    SizedBox(height: 16),
                    
                    // Card Metro
                    TransportCard(
                      title: 'Metro',
                      subtitle: 'Rápido y eficiente',
                      description: 'Línea 1 & 2',
                      imagePath: 'assets/images/metro.png',
                      color: AppColors.secondary,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Card OMSA
                    TransportCard(
                      title: 'OMSA',
                      subtitle: 'Accesible y extenso',
                      description: 'Todas las rutas',
                      imagePath: 'assets/images/omsa.png',
                      color: AppColors.primary,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Card Teleférico
                    TransportCard(
                      title: 'Teleférico',
                      subtitle: 'Panorámico y elevado',
                      description: 'Cable Car',
                      imagePath: 'assets/images/teleferico.png',
                      color: Color(0xFF4CAF50),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Card Corredor
                    TransportCard(
                      title: 'Corredor',
                      subtitle: 'Conexiones rápidas',
                      description: 'Rutas principales',
                      imagePath: 'assets/images/corredor.png',
                      color: AppColors.brown,
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
}
class TransportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color color;
  
  const TransportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Metro') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MetroPage()),
          );
        } else if (title == 'OMSA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OMSAPage()),
          );
        } else if (title == 'Teleférico') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelefericoPage()),
          );
        } else if (title == 'Corredor') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CorredorPage()),
          );
        } else {
          print('Navegando a $title');
        }
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}