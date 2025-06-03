import 'package:flutter/material.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/intros/intro1.dart';
import 'package:syndra_app/intros/intro2.dart';
import 'package:syndra_app/intros/intro3.dart';
import 'package:syndra_app/login/login_screen.dart';
import 'package:syndra_app/login/registro.dart';
import 'package:syndra_app/mainmenu/menu.dart';
import 'package:syndra_app/olvidopasword/verificacionemail.dart';
import 'package:syndra_app/olvidopasword/cambiopasword.dart';
import 'package:syndra_app/splash/splash_screen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect(); // conecta con la base
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syndra App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),

      routes: {
        '/intro1': (context) => const Intro1(),
        '/intro2': (context) => const Intro2(),
        '/intro3': (context) => const Intro3(),
        '/registro': (context) => const RegistroScreen(),
        '/login': (context) => const LoginScreen(),
        '/menu': (context) => const Menu(),

        // --- Nuevas rutas para el flujo de recuperación de contraseña ---
        // Ruta para la pantalla de verificación de email (primera etapa)
        '/verificacionemail': (context) => const VerificacionEmailScreen(),

        // Ruta para la pantalla de cambio de contraseña (segunda etapa)
        // Aquí necesitamos extraer el email que se pasa como argumento
        '/cambio_password': (context) {
          // Extrae los argumentos de la ruta. Esperamos un Map<String, dynamic>
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          // Intenta obtener el 'email' del mapa de argumentos.
          // Si 'args' es nulo o no contiene 'email', 'email' será nulo.
          final email = args?['email'] as String?;

          // Si el email no se pasó correctamente o es nulo/vacío,
          // puedes redirigir al usuario de vuelta a la pantalla de verificación de email
          // o mostrar un error. En este caso, lo redirigimos para que ingrese el email.
          if (email == null || email.isEmpty) {
            // Puedes mostrar un SnackBar o un Dialog aquí si lo deseas,
            // pero redirigir es una buena práctica para flujos incompletos.
            return const VerificacionEmailScreen();
          }

          // Si el email es válido, construye y retorna CambioPasswordScreen
          // pasándole el email requerido.
          return CambioPasswordScreen(email: email);
        },






      },
    );
  }
}
