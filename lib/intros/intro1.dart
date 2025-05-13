import 'dart:async';
import 'package:flutter/material.dart';

class Intro1 extends StatefulWidget {
  const Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> with SingleTickerProviderStateMixin {
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

    _controller.forward();

    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/intro2');
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
          Image.asset('assets/images/im_manos.jpg', fit: BoxFit.cover),

          SlideTransition(
            position: _textAnimation,
            child: Align(
              alignment: Alignment.topCenter,

              child: Container(
                margin: const EdgeInsets.only(right: 45, top: 90),
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(163, 217, 207, 0.3),
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
