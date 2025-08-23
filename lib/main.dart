import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_colors.dart';
import 'core/widgets/main_scaffold.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga .env solo fuera de Web
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {}
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transporte Futura RD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.dark,
          foregroundColor: AppColors.white,
        ),
      ),
      // Inicia en el Splash y luego navega a MainScaffold desde el propio SplashScreen
      home: const SplashScreen(),
      // Si prefieres rutas nombradas, puedes habilitar esto:
      // routes: {
      //   '/home': (_) => const MainScaffold(),
      //   '/splash': (_) => const SplashScreen(),
      // },
      // initialRoute: '/splash',
    );
  }
}
