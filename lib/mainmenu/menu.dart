// lib/mainmenu/menu.dart
import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario para BackdropFilter

// Importa el nuevo widget de la encuesta
import 'package:syndra_app/survey/survey_overlay.dart';
// Importa el nuevo widget de contadores
import 'package:syndra_app/contadores/counters_carousel.dart';
import 'package:syndra_app/mainmenu/stylestexto.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/mainmenu/cajaaviso.dart';
// Importa el nuevo widget de la animación
import 'package:syndra_app/mainmenu/animacioncaja.dart'; // <--- ¡Nuevo import!

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<Menu> {
  // Ya NO necesitamos TickerProviderStateMixin aquí, porque AnimatedInfoBox lo maneja

  bool _isSurveyActive = false;
  bool _hasCompletedSurvey = false;
  bool _showCountersScreen = false;

  final double _countersHeight = 350.0;
  double _appBarAndPaddingHeight = 0.0;

  final ScrollController _scrollController = ScrollController();

  // --- LAS PROPIEDADES DE ANIMACIÓN HAN SIDO MOVIDAS A AnimatedInfoBox ---
  // late final AnimationController _animationController;
  // late final DecorationTween _decorationTween;
  // --- FIN PROPIEDADES DE ANIMACIÓN ---

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appBarAndPaddingHeight =
          MediaQuery.of(context).padding.top + AppBar().preferredSize.height;

      if (!_hasCompletedSurvey) {
        _showSurveyInitialDialog();
      } else {
        setState(() {
          _showCountersScreen = true;
        });
      }

      _scrollController.addListener(() {
        // Lógica de scroll
      });
    });

    // --- LA INICIALIZACIÓN DEL CONTROLADOR Y EL TWEEN DE ANIMACIÓN SE HA MOVIDO ---
    // _animationController = AnimationController(...);
    // final beginDecoration = BoxDecoration(...);
    // final endDecoration = BoxDecoration(...);
    // _decorationTween = DecorationTween(...);
    // --- FIN INICIALIZACIÓN ---
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _animationController.dispose(); // ¡Ya NO se necesita liberar aquí!
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
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomNavBarHeight = kBottomNavigationBarHeight;

    final double topHalfScreenHeight =
        (screenHeight * 0.5) - _appBarAndPaddingHeight;

    final double initialSizedBoxHeight = topHalfScreenHeight - _countersHeight;

    final double finalInitialSizedBoxHeight =
        initialSizedBoxHeight > 0 ? initialSizedBoxHeight : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(163, 217, 207, 1.0),
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
            child: Container(color: const Color.fromRGBO(163, 217, 207, 1.0)),
          ),
          Positioned.fill(
            top: _appBarAndPaddingHeight,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  if (_showCountersScreen)
                    SizedBox(height: finalInitialSizedBoxHeight),
                  if (_showCountersScreen)
                    SizedBox(
                      height: _countersHeight,
                      child: const CountersCarousel(),
                    ),
                  Container(
                    width: double.infinity,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Por qué estoy haciendo esto',
                          textAlign: TextAlign.center,
                          style: menuSectionTitleStyle,
                        ),
                        const SizedBox(height: 15),

                        CajaAvisoEstiloBoton(
                          text: 'Por mi madre',
                          backgroundColor: const Color.fromRGBO(
                            163,
                            217,
                            207,
                            1.0,
                          ),
                          textColor: const Color.fromRGBO(33, 78, 62, 1.0),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.20),
                              offset: Offset(0, 6),
                              blurRadius: 8,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // --- CONTAINER ANIMADO AHORA ES UN WIDGET SEPARADO ---
                        const AnimatedInfoBox(), // ¡Aquí lo usamos!

                        // --- FIN CONTAINER ANIMADO ---
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
