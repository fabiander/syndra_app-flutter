import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'dart:async';
import 'intro3.dart';

class Intro2 extends StatefulWidget {
  const Intro2({super.key});

  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> with SingleTickerProviderStateMixin {
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
      begin: const Offset(1.5, 0), // entrada desde la derecha
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Espera un poco antes de mostrar la caja
    Future.delayed(const Duration(milliseconds: 600), () {
      _controller.forward();
    });


    _controller.forward();

    // Navegación con FadeTransition
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const Intro3(),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/im_subir.jpg', fit: BoxFit.cover),

          SlideTransition(
            position: _textAnimation,
            child: Align(
              alignment: Alignment.topCenter,

              child: Container(
                margin: const EdgeInsets.only(left: 45, top: 350),
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(163, 217, 207, 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  'Estamos aquí para escucharte y guiarte.',
                  style: counterTitleStyle.copyWith(
                    fontSize: 26,
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
