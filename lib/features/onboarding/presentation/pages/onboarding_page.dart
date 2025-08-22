import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Logo MUCHO MÁS GRANDE sin background
              SizedBox(
                width: 350,
                height: 250,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              const Spacer(),
              
              // Título principal en español
              const Text(
                'Tu viaje,\nsimplificado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtítulo en español
              const Text(
                'Navega el transporte público de República Dominicana con facilidad. Planifica rutas, rastrea autobuses y paga pasajes, todo en una app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.brown,
                  height: 1.5,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Botón Comenzar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    print('Comenzar pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botón Soy Turista
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    print('Modo turista pressed');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.gray),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Soy Turista",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Language selector
              const Text(
                'Idioma: Español | English',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.brown,
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}