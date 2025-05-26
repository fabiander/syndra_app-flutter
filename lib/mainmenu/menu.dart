import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:syndra_app/bar_abajo/home.dart';
import 'package:syndra_app/bar_abajo/estadisticas.dart';
import 'package:syndra_app/bar_abajo/donaciones.dart';
import 'package:syndra_app/bar_abajo/llamado.dart';
import 'package:syndra_app/bar_abajo/perfil.dart';
import 'package:syndra_app/bar_abajo/barfondo.dart';
import 'package:syndra_app/bar_arrriba/arriba.dart'; // <--- Asegúrate de que esta ruta sea correcta
import 'package:syndra_app/encuesta/preguntas.dart';
import 'package:syndra_app/contadores/counters_carousel.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/mainmenu/animacioncaja.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/botones_base/boton_fantasma.dart';
import 'package:syndra_app/tarjetas/admitirproblema.dart';
import 'package:syndra_app/tarjetas/reconocimiento.dart';

// Importa tu clase MongoDatabase (descomenta cuando uses MongoDB real)
// import 'package:syndra_app/data/connection.dart'; // <--- Asegúrate de que esta ruta sea correcta

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<Menu> {
  bool _isSurveyActive = false;
  bool _hasCompletedSurvey = false;
  bool _showCountersScreen = false;
  final double _countersHeight = 350.0;
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  final String _loggedInUserName = "Fabian"; // Nombre de usuario de ejemplo
  String _surveyInfoText = "Cargando..."; // Valor inicial para la AppBar

  final fondoBoton = const Color.fromRGBO(163, 217, 207, 1.0);
  final textoBoton = const Color.fromRGBO(33, 78, 62, 1.0);
  final double anchoBoton = 315;

  final List<Widget> _screens = [
    Container(), // Placeholder para el índice 0: Home/tu menú principal
    const StatsScreen(),
    const DonationsScreen(),
    const LlamadoScreen(),
    const PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Llamamos a la función para cargar datos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasCompletedSurvey) {
        _showSurveyInitialDialog();
      } else {
        setState(() {
          _showCountersScreen = true;
          _selectedTabIndex = 0;
        });
      }
      _scrollController.addListener(() {
        // Lógica de scroll si la necesitas
      });
    });
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(seconds: 2));
    String dataFromDatabase = "Marihuana"; // Dato simulado de la BD
    setState(() {
      _surveyInfoText = dataFromDatabase;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // MongoDatabase.close(); // Descomenta si usas MongoDB y cierras la conexión
    super.dispose();
  }

  void _showSurveyInitialDialog() {
    if (_hasCompletedSurvey) {
      return;
    }
    setState(() {
      _isSurveyActive = true;
    });
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(63, 140, 112, 0.5),
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
              _selectedTabIndex = 0;
            });
          },
        );
      },
    );
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  // --- NUEVA FUNCIÓN: Maneja la acción de salir de la aplicación ---
  void _onLogout() {
    // Aquí puedes añadir la lógica para cerrar sesión (ej. borrar token, etc.)
    // Y luego navegar a la pantalla de inicio de sesión o cerrar la aplicación.

    // Ejemplo: Mostrar un SnackBar y luego cerrar la aplicación (no recomendado sin un inicio de sesión)
    // En una aplicación real, probablemente navegarías a una pantalla de inicio de sesión.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cerrando sesión...')));

    // Para cerrar la aplicación completamente (no siempre deseable en Flutter)
    // import 'dart:io'; // Necesitas importar esto al inicio del archivo
    // exit(0);

    // Más comúnmente, navegarías a la pantalla de login/bienvenida
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    ); // Vuelve a la primera ruta (ej. LoginScreen)
    // O navega a una pantalla específica:
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => const LoginScreen()), // Reemplaza LoginScreen con tu pantalla de inicio de sesión
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final double totalAppBarAreaHeight = statusBarHeight + appBarHeight;
    final double bottomNavBarHeight = kBottomNavigationBarHeight;

    final Widget homeScreenContent = Stack(
      children: [
        Positioned.fill(
          child: Container(color: const Color.fromRGBO(163, 217, 207, 1.0)),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: totalAppBarAreaHeight,
            bottom: bottomNavBarHeight,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_showCountersScreen)
                  SizedBox(
                    height: _countersHeight,
                    child: const CountersCarousel(),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        _showCountersScreen
                            ? const BorderRadius.vertical(
                              top: Radius.circular(30),
                            )
                            : BorderRadius.zero,
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Por qué estoy haciendo esto',
                        textAlign: TextAlign.center,
                        style: menuSectionTitleStyle,
                      ),
                      const SizedBox(height: 15),

                      BotonFantasma(
                        label: 'Por mi madre',
                        borderColor: Color.fromRGBO(120, 190, 180, 1.0),
                        onPressed: null,
                        width: anchoBoton,
                      ),

                      const SizedBox(height: 30),
                      const AnimatedInfoBox(),
                      const SizedBox(height: 40),

                      BotonElevado(
                        label: 'Admitir un problema',
                        backgroundColor: fondoBoton,
                        textColor: textoBoton,
                        width: anchoBoton,
                        onPressed: () {
                          if (!_hasCompletedSurvey) {
                            _showSurveyInitialDialog();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AdmitirProblemaScreen(
                                      onProblemAdmitted: () {},
                                    ),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      BotonElevado(
                        label: 'Reconoce tu problema',
                        backgroundColor: fondoBoton,
                        textColor: textoBoton,
                        width: anchoBoton,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Reconocimiento(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      BotonElevado(
                        label: 'Aceptar la adicción',
                        backgroundColor: fondoBoton,
                        textColor: textoBoton,
                        width: anchoBoton,
                        onPressed: () {},
                      ),

                      const SizedBox(height: 30),

                      BotonElevado(
                        label: 'Vamos a la práctica',
                        backgroundColor: fondoBoton,
                        textColor: textoBoton,
                        width: anchoBoton,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vamos a la práctica presionado'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isSurveyActive)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
      ],
    );

    _screens[0] = _hasCompletedSurvey ? homeScreenContent : const HomeScreen();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBarWidget(
        userName: _loggedInUserName,
        surveyDataText: _surveyInfoText,
        onLogoutPressed: _onLogout, // <--- Conectamos el callback aquí
      ),

      drawer: const Drawer(child: Center(child: Text('Menú Lateral (Drawer)'))),

      body: IndexedStack(index: _selectedTabIndex, children: _screens),

      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedTabIndex,
        onTap: _onBottomNavItemTapped,
      ),
    );
  }
}
