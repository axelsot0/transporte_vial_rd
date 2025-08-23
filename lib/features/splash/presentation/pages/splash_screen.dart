import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../transport/presentation/pages/favorites_page.dart'; // opcional si quieres deep-link
import '../../../../core/widgets/main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.goToFavorites = false});

  /// Si quieres probar deep-link al módulo de favoritos
  final bool goToFavorites;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(const AssetImage('assets/icons/transport.png'), context);
}


  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _ctrl.forward();

    // Simula inicialización (tokens, prefs, etc.)
    Timer(const Duration(milliseconds: 1600), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    final next = widget.goToFavorites
        ? const FavoritesPage()
        : const MainScaffold(); // tu home
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con gradiente sutil
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.dark,
                    AppColors.dark.withOpacity(0.92),
                  ],
                ),
              ),
            ),

            // Contenido central
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
  scale: _scale,
  child: Image.asset(
    'assets/icons/transport.png',
    width: 200,
    height: 200,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
  ),
),

                  const SizedBox(height: 18),
                  FadeTransition(
                    opacity: _fade,
                    child: const Text(
                      'Transporte Futura RD',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _fade,
                    child: Text(
                      'Movilidad • Educación Vial • Datos',
                      style: TextStyle(
                        color: AppColors.brown.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Indicador de carga estilizado
                  FadeTransition(
                    opacity: _fade,
                    child: Container(
                      width: 180,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedBuilder(
                            animation: _ctrl,
                            builder: (_, __) {
                              final w =
                                  (constraints.maxWidth * (_ctrl.value.clamp(0.2, 1.0)));
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: w,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Marca/versión abajo
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fade,
                child: const Center(
                  child: Text(
                    'v0.1.0 • MVP',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
