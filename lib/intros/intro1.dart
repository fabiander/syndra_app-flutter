import 'dart:async';
import 'package:flutter/material.dart';
import 'intro2.dart';

class Intro1 extends StatefulWidget {
  const Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textAnimation;
  late Animation<double> _imageFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _imageFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // ✅ Espera a que se dibuje el primer frame antes de animar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // ✅ Cambio a la siguiente pantalla después de 6 segundos
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const Intro2(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
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
      backgroundColor: Colors.transparent, // ✅ fondo transparente
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Imagen con Fade
          FadeTransition(
            opacity: _imageFadeAnimation,
            child: Image.asset('assets/images/im_manos.jpg', fit: BoxFit.cover),
          ),

          // ✅ Caja animada con Slide
          SlideTransition(
            position: _textAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(right: 45, top: 90),
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(163, 217, 207, 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Apoyo emocional a un toque de distancia',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ralleway',
                    color: Color.fromRGBO(33, 78, 62, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
