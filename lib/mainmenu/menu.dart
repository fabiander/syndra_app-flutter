import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:syndra_app/bar_abajo/home.dart';
import 'package:syndra_app/bar_abajo/estadisticas.dart';
import 'package:syndra_app/bar_abajo/donaciones.dart';
import 'package:syndra_app/bar_abajo/llamado.dart';
import 'package:syndra_app/menu_lateral/perfil.dart';
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
import 'package:syndra_app/tarjetas/aceptar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syndra_app/login/login_screen.dart';
import 'package:syndra_app/tarjetas/chat.dart';
import 'package:syndra_app/menu_lateral/software.dart';
import 'package:syndra_app/menu_lateral/perfil.dart';

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

  //final String _loggedInUserName = "Fabian"; // Nombre de usuario de ejemplo
  String _surveyInfoText = "Cargando..."; // Valor inicial para la AppBar
  String _username = 'Cargando...';
  String _freeTextAnswer = 'Por mi madre'; // Valor por defecto

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

    _loadUsername(); //  iniciacion del metodo
  }

  //  METODO  PAR ACRAGAR USUARIOO
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(
      'loggedInUsername',
    ); //  aqui llama el logged que contiene el usario y lo guara en la variable username
    if (username != null && username.isNotEmpty) {
      setState(() {
        _username = username; // Actualiza el estado con el nombre de usuario
      });
    } else {
      setState(() {
        _username = 'Usuario'; // Valor por defecto si no se encuentra
      });
    }
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
    _scrollController.dispose(); // cierra  la  conexion
    super.dispose();
  }

  void _showSurveyInitialDialog({String? initialFreeText, int? initialPage}) {
    if (_hasCompletedSurvey && initialFreeText == null && initialPage == null) return;
    setState(() {
      _isSurveyActive = true;
    });

    showGeneralDialog( 
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(63, 140, 112, 0.5),
      transitionDuration: const Duration(milliseconds: 300),

      pageBuilder:
          (
            BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation,
          ) {


            return SurveyOverlay(
              onSurveyCompleted: (String freeText) {
                Navigator.of(context).pop();
                setState(() {
                  _isSurveyActive = false;
                  _hasCompletedSurvey = true;
                  _showCountersScreen = true;
                  _selectedTabIndex = 0;
                  _freeTextAnswer = freeText;
                });
              },



              onExitSurvey: () {
                Navigator.of(context).pop(); //  cierra el diálogo
                setState(() {
                  _isSurveyActive = false;
                });
              },
              initialFreeText: initialFreeText,
              initialPage: initialPage,
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
  Future<void> _logout() async {
    // 1. Clear SharedPreferences data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await prefs.remove('loggedInUserEmail');
    await prefs.remove('loggedInUsername');

    if (mounted) {
      // It's good practice to check if the widget is still mounted before using context for navigation
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) =>
            false, // This condition removes all routes from the stack
      );
    }
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
                    borderRadius: _showCountersScreen
                        ? const BorderRadius.vertical(top: Radius.circular(30))
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
                        label: _freeTextAnswer,
                        borderColor: Color.fromRGBO(120, 190, 180, 1.0),
                        width: anchoBoton,
                        onPressed: (){
                          _showSurveyInitialDialog(
                            initialFreeText: _freeTextAnswer,initialPage: 4 /* índice de la pregunta de propósito, ej. 0 o 4 */,
                            );
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
                          if (!_hasCompletedSurvey) {
                            _showSurveyInitialDialog();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdmitirProblemaScreen(
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
                              builder: (context) => ReconocerProblema( onProblemAdmitted: () {},
                              ),
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
                              builder: (context) =>
                              AceptarProblemaScreen(onProblemAdmitted: () {}),
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
                          // Reemplaza el SnackBar por la navegación al ChatScreen
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

        if (_isSurveyActive)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
      ],
    );

    _screens[0] = _hasCompletedSurvey ? homeScreenContent : const HomeScreen();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBarWidget(
        userName: _username,
        surveyDataText: _surveyInfoText,
        onLogoutPressed: _logout, // <--- Conectamos el callback aquí
      ),

      // <--- ¡NUEVO! Implementación del Menú Lateral (Drawer) --->
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Encabezado del Drawer (Información de usuario)
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // Usa tu color primario
              ),
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
            // Opción: Mi Perfil
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerfilScreen(),
                  ),
                );
              },
            ),
            // Opción: Especificaciones del Software
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Especificaciones del Software'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SoftwareSpecsScreen(),
                  ),
                );
              },
            ),
            // Separador (Opcional)
            const Divider(),
            // Opción: Configuración
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuración presionado')),
                );
                // Aquí podrías navegar a una pantalla de Configuración
              },
            ),
            // Opción: Ayuda y Preguntas Frecuentes
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda y Preguntas Frecuentes'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ayuda presionado')),
                );
                // Aquí podrías navegar a una pantalla de Ayuda
              },
            ),
            // <--- Botón de Cerrar Sesión (Logout) --->
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(
                  context,
                ); // Cierra el Drawer antes de cerrar sesión
                _logout(); // Llama a tu función de cerrar sesión
              },
            ),
          ],
        ),
      ),

      // <--- FIN: Implementación del Menú Lateral (Drawer) --->

      body: IndexedStack(index: _selectedTabIndex, children: _screens),

      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedTabIndex,
        onTap: _onBottomNavItemTapped,
      ),
    );
  }
}
