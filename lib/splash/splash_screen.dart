import 'package:flutter/material.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    ); // tiempo de animacion

    _logoAnimation = Tween<Offset>(
      begin: Offset(0.0, 3.0), // Fuera desde abajo
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textAnimation = Tween<Offset>(
      begin: Offset(0.0, 3.0), // Fuera desde abajo
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Navegación a la siguiente pantalla luego del splash
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/intro1');
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
      backgroundColor: Color(0xFFA5DBD7),
      body: Stack(
        children: [
          // Logo animado
          Center(
            child: SlideTransition(
              position: _logoAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            ),
          ),

          // Texto animado debajo del logo
          Center(
            child: SlideTransition(
              position: _textAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 260.0),
                child: const Text(
                  'Syndra',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                    color: Color.fromRGBO(33, 78, 62, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
