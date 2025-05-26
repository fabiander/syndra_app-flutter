// lib/barfondo/barfondo.dart

import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;  // se llama  cuando se hace click
  final Function(int) onTap;



  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color.fromRGBO(120, 190, 180, 1.0,), // El fondo de la barra 
      selectedItemColor: Color.fromRGBO( 33, 78, 62, 1.0), // Ítem seleccionado en verde
      unselectedItemColor: Colors.white, // Ítem no seleccionado en blanco
      type: BottomNavigationBarType.fixed, // Asegura que todos los ítems se muestren con sus etiquetas
      items: const <BottomNavigationBarItem>[
        // Home
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

        // Estadísticas
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart), // Icono para estadísticas
          label: 'Estadísticas',
        ),


        // Donaciones (ahora un icono normal en la mitad)
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money), // Icono para donaciones
          label: 'Donaciones',
        ),


        // Llamar Padrino
        BottomNavigationBarItem(
          icon: Icon(Icons.phone), // Icono para llamar padrino
          label: 'Padrino',
        ),


        // Perfil
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),

      ],
      currentIndex: currentIndex,
      onTap: onTap, // La función que se llama cuando se toca un ítem
    );
  }
}
