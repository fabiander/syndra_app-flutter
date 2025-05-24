// lib/mainmenu/animated_info_box.dart
import 'package:flutter/material.dart';

class AnimatedInfoBox extends StatefulWidget {
  const AnimatedInfoBox({super.key});

  @override
  State<AnimatedInfoBox> createState() => _AnimatedInfoBoxState();
}

class _AnimatedInfoBoxState extends State<AnimatedInfoBox>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final DecorationTween _decorationTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Duración de la animación
    )..repeat(reverse: true); // Repite la animación de ida y vuelta

    // Definición de las decoraciones de inicio y fin para la animación
    final beginDecoration = BoxDecoration(
      color: const Color.fromRGBO(63, 140, 112, 1.0),
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.20),
          offset: Offset(0, 6),
          blurRadius: 8,
          spreadRadius: -4,
        ),
      ],
    );

    final endDecoration = BoxDecoration(
      color: const Color.fromRGBO(160, 25, 205, 0.60),
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(50, 100, 80, 0.5),
          offset: Offset(0, 8),
          blurRadius: 10,
          spreadRadius: -3,
        ),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
    );

    _decorationTween = DecorationTween(
      begin: beginDecoration,
      end: endDecoration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: _decorationTween.animate(_animationController),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        height: 250, // <--- ALTURA DEL WIDGET PRINCIPAL (AnimatedInfoBox)


        child: Column(
          mainAxisAlignment:MainAxisAlignment.center, // centrado verticall
          crossAxisAlignment: CrossAxisAlignment.center, //centrado horizontal
          children: [

            const SizedBox(height: 8), // espacio

            // --- IMAGEN PNG ---
            SizedBox(
              width: 120, // Ancho de la caja
              height: 120, // Altura de la caja
              child: Image.asset(
                'assets/images/paso1.png', // Asegúrate de que esta ruta sea correcta
                width: 42, // Ancho de la imagen (puede ser igual al contenedor)
                height:42, // Altura de la imagen (puede ser igual al contenedor)
                fit: BoxFit.contain, // Ajusta la imagen dentro de la caja sin recortar
              ),
            ),


            
            const SizedBox(height: 12),


            const Text(
              '"No puedo, Dios puede, y dejaré que lo haga."',
              textAlign: TextAlign.center,
              style: TextStyle(
                // <-- Esto es un TextStyle normal, no una asignación de variable
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize:
                    18, // <-- Es buena práctica mantener el fontSize, si no, tomará el predeterminado
                fontStyle:
                    FontStyle.italic, // <-- Si quieres que siga siendo itálica
              ),
            ),


          ],
        ),
      ),
    );
  }
}
