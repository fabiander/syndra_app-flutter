import 'package:flutter/material.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';
import 'dart:async';
import 'package:syndra_app/intros/intro1.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // Asegúrate de importar tu Intro1

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;

  // Duración total de la SplashScreen antes de navegar
  final int _splashDurationSeconds = 7; // Aumentado a 7 segundos para que se vea más

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Animación de 4 segundos
      vsync: this,
    );

    // Animación del Logo: se eleva desde abajo con un efecto elástico
    _logoAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 2.0), // Comienza desde abajo
          end: const Offset(0.0, -0.2), // Termina en su posición central
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve:
                Curves.elasticOut, // Un efecto más elástico y dinámico al final
          ),
        );

    // Animación del Texto "Syndra": aparece después del logo con un efecto de rebote
    _textAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 2.0), // También desde abajo
          end: const Offset(0.0, -0.1),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.3, // Comienza al 40% de la duración del controlador (después del logo)
              1.0, // Termina con el controlador
              curve: Curves.bounceOut, // Un efecto de rebote para el texto
            ),
          ),
        );

    // Inicia la animación de los elementos de la splash screen
    _controller.forward();

    // Temporizador para la navegación a la siguiente pantalla
    Timer(Duration(seconds: _splashDurationSeconds), () {
      // Usamos `if (mounted)` para evitar errores si el widget se desmonta antes de que termine el timer
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(
              milliseconds: 1300,
            ), // Duración de la transición a Intro1
            pageBuilder: (_, __, ___) => const Intro1(),
            transitionsBuilder: (_, animation, __, child) {
              // Define el inicio y fin del desplazamiento para la nueva pantalla (Intro1)
              const begin = Offset(1.0, 0.0); // Desliza Intro1 desde la derecha
              const end = Offset.zero;

              // Crea el Tween para la posición
              final tween = Tween(begin: begin, end: end);

              // 1. Aplica la curva a la animación base (Animation<double>)
              final curvedAnimation = CurvedAnimation(
                parent: animation, // La animación original de PageRouteBuilder
                curve: Curves.easeOutCubic, // Curva suave para la transición
              );

              // 2. Anima el Tween de Offset usando la CurvedAnimation
              final offsetAnimation = tween.animate(curvedAnimation);

              // Retorna el SlideTransition con la animación de Offset corregida
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.backgroundColor, // Color de fondo de tu SplashScreen
      body: Stack(
        children: [
          // Centro del logo animado
          Center(
            child: SlideTransition(
              position: _logoAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 220, // Un poco más grande para que se vea mejor
                height: 220, // Un poco más grande
              ),
            ),
          ),
          // Centro del texto "Syndra" animado, posicionado debajo del logo
          
          Align(
            alignment: Alignment.center,

            child: SlideTransition( 
              position: _textAnimation,
              child:  Padding(
                // Ajusta este padding para controlar la distancia del texto respecto al logo.
                padding: EdgeInsets.only(top: 300.0,), // Ajuste para el texto debajo del logo
                
              child: Text(
                  'Syndra',
                  style: counterTitleStyle.copyWith(
                  fontSize: 38, // Tamaño del texto más grande
                 ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
