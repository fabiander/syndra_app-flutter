// lib/tarjetas/admitirproblema.dart
import 'package:flutter/material.dart';

class Reconocimiento extends StatelessWidget {
  // O el nombre que le hayas dado a tu clase
  const Reconocimiento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admitir Problema'),
        backgroundColor: const Color.fromRGBO(163, 217, 207, 1.0),
      ),
      body: const Center(
        child: Text('Contenido de la pantalla Admitir Problema'),
      ),
    );
  }
}
