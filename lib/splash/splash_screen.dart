import 'package:flutter/material.dart';
import 'dart:async';
import 'package:syndra_app/intros/intro1.dart'; // Asegúrate de importar tu Intro1

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
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset(0.0, 3.0), // desde abajo
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textAnimation = Tween<Offset>(
      begin: Offset(0.0, 3.0), // desde abajo
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Navegar a Intro1 con SlideTransition
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const Intro1(),
          transitionsBuilder: (_, animation, __, child) {
            // Deslizamiento desde la derecha
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
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
      backgroundColor: const Color(0xFFA5DBD7),
      body: Stack(
        children: [
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
          Center(
            child: SlideTransition(
              position: _textAnimation,
              child: const Padding(
                padding: EdgeInsets.only(top: 260.0),
                child: Text(
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
