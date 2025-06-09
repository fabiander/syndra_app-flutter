// lib/menu_lateral/software_specs_screen.dart

import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // Asegúrate de que esta ruta sea correcta

class SoftwareSpecsScreen extends StatelessWidget {
  const SoftwareSpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Especificaciones del Software',
          // Como no proporcionaste un estilo específico para el título de la AppBar
          // en el tipoletra.dart que enviaste, se usará el estilo por defecto de Flutter
          // o puedes definir uno si lo necesitas.
          // Si tienes un appbarTitleStyle en tu archivo completo, úsalo aquí.
          // Ejemplo: style: appbarTitleStyle,
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor, // Puedes ajustar esto a tu color de AppBar
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Color del icono de retroceso en la AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Todas las líneas de texto usarán menuSectionTitleStyle
            // ya que es el estilo más apropiado proporcionado para texto de contenido.
            Text('Nombre de la Aplicación:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text(
              'Syndra App',
              style: menuSectionTitleStyle,
            ), // Usando el estilo de título de sección
            const SizedBox(height: 15),

            Text('Versión:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text('1.0.0 (Beta)', style: menuSectionTitleStyle),
            const SizedBox(height: 15),

            Text('Fecha de Lanzamiento:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text('Junio 2025', style: menuSectionTitleStyle),
            const SizedBox(height: 15),

            Text('Propósito:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text(
              'Esta aplicación está diseñada para brindar apoyo y herramientas a individuos en su proceso de recuperación y bienestar, fomentando la conciencia y la superación personal.',
              style: menuSectionTitleStyle,
            ),
            const SizedBox(height: 15),

            Text('Tecnologías Utilizadas:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text(
              'Flutter (Framework UI), Dart (Lenguaje de Programación), SharedPreferences (Almacenamiento Local), [Tu Base de Datos, ej. MongoDB], etc.',
              style: menuSectionTitleStyle,
            ),
            const SizedBox(height: 15),

            Text('Desarrollador:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text('Equipo Syndra App', style: menuSectionTitleStyle),
            const SizedBox(height: 15),

            Text('Licencia:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text(
              'Propiedad de [Tu Organización/Nombre]. Todos los derechos reservados.',
              style: menuSectionTitleStyle,
            ),
            const SizedBox(height: 15),

            Text('Agradecimientos:', style: menuSectionTitleStyle),
            const SizedBox(height: 5),
            Text(
              'A todos los que contribuyeron al desarrollo de esta aplicación y a la comunidad de usuarios que buscan el camino de la recuperación.',
              style: menuSectionTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
