import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'dart:ui';
import 'package:syndra_app/bar_abajo/estadisticas.dart';
import 'package:syndra_app/bar_abajo/donaciones.dart';
import 'package:syndra_app/bar_abajo/llamado.dart';
import 'package:syndra_app/menu_lateral/perfil.dart';
import 'package:syndra_app/bar_abajo/barfondo.dart';
import 'package:syndra_app/bar_arrriba/arriba.dart';
import 'package:syndra_app/contadores/counters_carousel.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/mainmenu/animacioncaja.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/botones_base/boton_fantasma.dart';
import 'package:syndra_app/tarjetas/admitirproblema.dart';
import 'package:syndra_app/tarjetas/reconocimiento.dart';
import 'package:syndra_app/tarjetas/aceptar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syndra_app/login/login_screen.dart';
import 'package:syndra_app/tarjetas/chat.dart';
import 'package:syndra_app/menu_lateral/software.dart';
// IMPORTANTE: importa tu encuesta aquí
import 'package:syndra_app/encuesta/preguntas.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<Menu> {
  // ignore: prefer_final_fields
  bool _showCountersScreen = true;
  final double _countersHeight = 350.0;
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  String _surveyInfoText = "Cargando...";
  String _username = 'Cargando...';
  String _freeTextAnswer = 'Por mi madre';
  String _userIdString = '';

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
    _loadInitialData();
    _loadUsername();
    _loadUserId();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUsername');
    if (username != null && username.isNotEmpty) {
      setState(() {
        _username = username;
      });
    } else {
      setState(() {
        _username = 'Usuario';
      });
    }
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userIdString = prefs.getString('loggedInUserId') ?? '';
    });
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(seconds: 2));
    String dataFromDatabase = "Marihuana";
    setState(() {
      _surveyInfoText = dataFromDatabase;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await prefs.remove('loggedInUserEmail');
    await prefs.remove('loggedInUsername');

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final double totalAppBarAreaHeight = statusBarHeight + appBarHeight;
    final double bottomNavBarHeight = 5.0;

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
                    child: _userIdString.isNotEmpty
                        ? CountersCarousel(userId: _userIdString)
                        : const SizedBox.shrink(),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _showCountersScreen
                        ? const BorderRadius.vertical(top: Radius.circular(30))
                        : BorderRadius.zero,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Por qué estoy haciendo esto',
                        textAlign: TextAlign.center,
                        style: menuSectionTitleStyle,
                      ),
                      const SizedBox(height: 15),
                      BotonFantasma(
                        label: _freeTextAnswer,
                        borderColor: const Color.fromRGBO(120, 190, 180, 1.0),
                        width: anchoBoton,
                        onPressed: () async {
                          // Abre la encuesta en la pregunta 5 (índice 4)
                          final nuevoTexto = await Navigator.of(context)
                              .push<String>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SurveyOverlay(
                                        initialPage: 4,
                                        onSurveyCompleted: (result) {
                                          // Maneja el resultado de la encuesta aquí si es necesario
                                        },
                                        onExitSurvey: () {
                                          // Maneja la salida de la encuesta aquí si es necesario
                                        },
                                      ),
                                ),
                              );
                          if (nuevoTexto != null && nuevoTexto.isNotEmpty) {
                            setState(() {
                              _freeTextAnswer = nuevoTexto;
                            });
                          }
                        },
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdmitirProblemaScreen(
                                onProblemAdmitted: () {},
                              ),
                            ),
                          );
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
                              builder: (context) =>
                                  ReconocerProblema(onProblemAdmitted: () {}),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AceptarProblemaScreen(
                                onProblemAdmitted: () {},
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      BotonElevado(
                        label: 'Vamos a la práctica',
                        backgroundColor: fondoBoton,
                        textColor: textoBoton,
                        width: anchoBoton,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
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
      ],
    );

    _screens[0] = homeScreenContent;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBarWidget(
        userName: _username,
        surveyDataText: _surveyInfoText,
        onLogoutPressed: _logout,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hola, $_username',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Bienvenido a Syndra App',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Especificaciones del Software'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SoftwareSpecsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuración presionado')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda y Preguntas Frecuentes'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ayuda presionado')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedTabIndex, children: _screens),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedTabIndex,
        onTap: _onBottomNavItemTapped,
      ),
    );
  }
}
