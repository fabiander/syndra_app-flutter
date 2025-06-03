import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syndra_app/login/login_screen.dart';
import 'package:syndra_app/texto/tipoletra.dart'; //

class Intro3 extends StatefulWidget {
  const Intro3({super.key});

  @override
  State<Intro3> createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0), // entrada desde la izquierda
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Espera un poco antes de mostrar la caja
    Future.delayed(const Duration(milliseconds: 700), () {
      _controller.forward();
    });

    // Navega al login
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const LoginScreen(),
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
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/im_gafas.jpg', // ✅ tu fondo aquí
            fit: BoxFit.cover,
          ),

          SlideTransition(
            position: _textAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(right: 45, bottom: 100),
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(163, 217, 207, 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  'Tu bienestar emocional, ahora más cerca que nunca.',
                  style: counterTitleStyle.copyWith(
                    fontSize: 26
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
