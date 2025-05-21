// lib/mainmenu/menu.dart
import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario para BackdropFilter

// Importa el nuevo widget de la encuesta
import 'package:syndra_app/survey/survey_overlay.dart';
// Importa el nuevo widget de contadores
import 'package:syndra_app/contadores/counters_carousel.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<Menu> {
  bool _isSurveyActive = false;
  bool _hasCompletedSurvey = false;
  bool _showCountersScreen = false;

  // Altura estimada del carrusel de contadores.
  // Ajusta este valor si el diseño real de tu carrusel es diferente.
  final double _countersHeight = 350.0;
  // Altura del AppBar y del padding superior (barra de estado)
  double _appBarAndPaddingHeight = 0.0;

  // Controlador para el SingleChildScrollView
  final ScrollController _scrollController =
      ScrollController(); // movimento  con el dedo hacia arriba  logica

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appBarAndPaddingHeight =
          MediaQuery.of(context).padding.top + AppBar().preferredSize.height;

      if (!_hasCompletedSurvey) {
        _showSurveyInitialDialog(); //logica  de inicio de la encuesta, y mostrar contadores
      } else {
        setState(() {
          _showCountersScreen = true;
        });
      }

      _scrollController.addListener(() {
        // Puedes añadir lógica aquí para, por ejemplo, cambiar la opacidad
        // de elementos cuando el scroll avanza, o hacer efectos parallax.
        // print('Scroll Offset: ${_scrollController.offset}');
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // incio para el desplazamiento
    super.dispose();
  }

  void _showSurveyInitialDialog() {
    // inicio encuesta
    if (_hasCompletedSurvey) {
      return;
    }

    setState(() {
      _isSurveyActive = true;
    }); // logica  para mostrar la encuesta

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(
        63,
        140,
        112,
        0.5,
      ), // COLOR DEL DESENFOQUE  CUANDO  SE HACE LA  ENCUESTA
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return SurveyOverlay(
          onSurveyCompleted: () {
            Navigator.of(context).pop();
            setState(() {
              _isSurveyActive = false;
              _hasCompletedSurvey = true;
              _showCountersScreen = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              //barra pequeña  de encuesta completada
              const SnackBar(content: Text('¡Encuesta completada!')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomNavBarHeight =
        kBottomNavigationBarHeight; // Altura estándar de la BottomNavigationBar

    // La altura del "carril" superior donde queremos que se muestren los contadores.
    // Esto es la mitad superior de la pantalla, menos el AppBar.
    final double topHalfScreenHeight =
        (screenHeight * 0.5) - _appBarAndPaddingHeight;

    // Calculamos el espacio inicial que debe tener el SizedBox antes de los contadores.
    // Si los contadores deben ocupar 'topHalfScreenHeight', y ellos mismos tienen '_countersHeight',
    // entonces el SizedBox debe ser la diferencia.
    final double initialSizedBoxHeight = topHalfScreenHeight - _countersHeight;

    // Aseguramos que el SizedBox no tenga una altura negativa si topHalfScreenHeight es menor que _countersHeight.
    // Aunque idealmente topHalfScreenHeight debería ser suficiente para _countersHeight.
    final double finalInitialSizedBoxHeight =
        initialSizedBoxHeight > 0 ? initialSizedBoxHeight : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(163, 217, 207, 1.0), // fondo app bar
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromRGBO(33, 78, 62, 1.0),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text(
          //  texto app bar top
          'Marihuana',
          style: TextStyle(
            color: Color.fromRGBO(33, 78, 62, 1.0),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Color.fromRGBO(33, 78, 62, 1.0),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil presionado')),
              );
            },
          ),
        ],
      ),

      drawer: const Drawer(child: Center(child: Text('Menú Lateral (Drawer)'))),

      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color.fromRGBO(
                163,
                217,
                207,
                1.0,
              ), // <-- Este es el color de fondo
            ),
          ), // Color de fondo principal
          // 1. Imagen de fondo principal (img_media.png)
          //Positioned.fill(
          // child: Image.asset(
          // 'assets/img_media.png', // Asegúrate de que esta imagen esté en tu carpeta assets
          // fit: BoxFit.cover,
          //  ),
          //),

          // 2. El único SingleChildScrollView que contendrá todo
          Positioned.fill(
            top:
                _appBarAndPaddingHeight, // El scrollable comienza justo debajo del AppBar
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Este SizedBox empuja el contenido hacia abajo para que los contadores
                  // comiencen en la parte superior de la mitad de la pantalla (justo debajo del AppBar)
                  // y ocupen su altura asignada (_countersHeight).
                  if (_showCountersScreen)
                    SizedBox(height: finalInitialSizedBoxHeight),

                  // Los Contadores (solo se muestran si la encuesta está completa)
                  if (_showCountersScreen)
                    SizedBox(
                      height: _countersHeight, // Altura fija para el carrusel
                      child: const CountersCarousel(),
                    ),

                  // El Contenedor blanco del menú, que ahora está DENTRO del SingleChildScrollView
                  Container(
                    width: double.infinity, // Ocupa todo el ancho
                    // El padding vertical se mantiene para el contenido interno
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.white, // Color blanco para el fondo del menú
                      borderRadius:
                          _showCountersScreen
                              ? const BorderRadius.vertical(
                                top: Radius.circular(30),
                              ) // Borde redondeado
                              : BorderRadius.zero,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Por qué estoy haciendo esto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildLargeTextButton(
                          text: 'Por mi madre',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Botón "Por mi madre" presionado',
                                ),
                              ),
                            );
                          },
                          backgroundColor: const Color(0xFF6B45A8),
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 25.0,
                            horizontal: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B45A8),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/paso_01.png', // <--- Imagen del "Paso 01"
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '"No puedo, Dios puede, y dejaré que lo haga."',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildMenuButton(
                          text: 'Admitir que tienes un problema',
                          onPressed: () {
                            if (!_hasCompletedSurvey) {
                              _showSurveyInitialDialog();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ya has completado la encuesta.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          text: 'Reconoce tu problema',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Reconoce tu problema presionado',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          text: 'Aceptar la adicción',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aceptar la adicción presionado'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildMenuButton(
                          text: 'Vamos a la práctica',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vamos a la práctica presionado'),
                              ),
                            );
                          },
                        ),
                        // Espacio extra al final para que el menú sea más largo verticalmente.
                        // Esto asegura que el contenido sea lo suficientemente largo para que
                        // el usuario pueda desplazar el menú blanco hasta la parte superior
                        // y revelar los contadores por completo, y luego ocultarlos.
                        // Ajusta '300' para controlar cuánto más se puede desplazar hacia arriba
                        // una vez que los contadores están completamente visibles.
                        SizedBox(
                          height:
                              screenHeight -
                              _appBarAndPaddingHeight -
                              bottomNavBarHeight -
                              _countersHeight -
                              300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BackdropFilter para el desenfoque (se mantiene igual, se superpone a todo)
          if (_isSurveyActive)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6B45A8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Diario'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Comunidad'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: 0,
        onTap: (index) {
          String item = '';
          switch (index) {
            case 0:
              item = 'Home';
              break;
            case 1:
              item = 'Diario';
              break;
            case 2:
              item = 'Progreso';
              break;
            case 3:
              item = 'Comunidad';
              break;
            case 4:
              item = 'Perfil';
              break;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bottom Nav: $item presionado')),
          );
        },
      ),
    );
  }

  Widget _buildLargeTextButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6B45A8),
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
