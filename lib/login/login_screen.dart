import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/colores_espacios/espacios.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:syndra_app/mainmenu/menu.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final contrasena = passwordController.text.trim();

    if (email.isEmpty || contrasena.isEmpty) {
      if (!mounted) return;
      await showCustomAlertDialog(
        context: context,
        icon: Icons.error,
        message: 'Por favor, ingrese email y contraseña.',
        buttonColor: Colors.redAccent,
        buttonText: 'Aceptar',
        borderColor: Colors.redAccent,
      );
      return;
    }

    try {
      final user = await MongoDatabase.findUser(email, contrasena);

      if (user != null) {
        final ObjectId userId = user['_id'] as ObjectId;
        // ignore: deprecated_member_use
        final String userIdString = userId.toHexString();
        final String? nombreUsuario = user['usuario'] as String?;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserId', userIdString);
        await prefs.setString('loggedInUserEmail', email);
        await prefs.setString(
          'loggedInUsername',
          (nombreUsuario != null && nombreUsuario.isNotEmpty)
              ? nombreUsuario
              : 'Usuario Genérico',
        );

        // --- LÓGICA DE LAS 48 HORAS ---
        final Map<String, dynamic>? currentUserData =
            await MongoDatabase.getUserById(userIdString);

        DateTime now = DateTime.now();
        DateTime? startDate = currentUserData?['startDate'] as DateTime?;
        Duration? difference;

        if (startDate != null) {
          difference = now.difference(startDate);

          if (difference.inHours > 48) {
            // Han pasado más de 48 horas: pregunta al usuario
            if (!mounted) return;
            final respuesta = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Han pasado más de 48 horas'),
                content: const Text(
                  '¿Quieres reiniciar tu progreso y volver a realizar la encuesta?\n\n'
                  'Si eliges "Sí", tu progreso se reiniciará y deberás completar la encuesta.\n'
                  'Si eliges "No", continuarás con tu progreso anterior.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'no'),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'si'),
                    child: const Text('Sí'),
                  ),
                ],
              ),
            );

            if (respuesta == 'si') {
              // Reinicia el startDate, guarda en Mongo y muestra encuesta
              await MongoDatabase.saveUserAbstinenceData(
                userIdString,
                now,
                now,
              );
              if (!mounted) return;
              await Navigator.of(context).pushReplacementNamed('/preguntas');
              return;
            } else if (respuesta == 'no') {
              // Continúa con el mismo startDate y va directo al menú
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Menu()),
                (Route<dynamic> route) => false,
              );
              return;
            }
          } else {
            // Menos de 48 horas: continúa con el startDate original
            if (!mounted) return;
            await showCustomAlertDialog(
              context: context,
              icon: Icons.check_circle,
              message:
                  '¡Bienvenido! Has mantenido tu progreso por ${difference.inMinutes} minutos.',
              buttonColor: ColoresApp.iconColor,
              borderColor: ColoresApp.iconColor,
              buttonText: 'Entendido',
            );
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Menu()),
              (Route<dynamic> route) => false,
            );
            return;
          }
        } else {
          // Usuario nuevo: guarda la fecha de inicio y pide completar la encuesta
          await MongoDatabase.saveUserAbstinenceData(userIdString, now, now);
          if (!mounted) return;
          await showCustomAlertDialog(
            context: context,
            icon: Icons.info,
            message:
                'Por favor completa la encuesta inicial para establecer tu fecha de inicio.',
            buttonColor: ColoresApp.iconColor,
            borderColor: ColoresApp.iconColor,
            buttonText: 'Completar Encuesta',
          );
          // ignore: use_build_context_synchronously
          await Navigator.of(context).pushReplacementNamed('/preguntas');
          return;
        }
        // --- FIN LÓGICA 48 HORAS ---
      } else {
        if (!mounted) return;
        await showCustomAlertDialog(
          context: context,
          icon: Icons.error,
          message: 'Correo electrónico o contraseña incorrectos.',
          buttonText: 'Aceptar',
          buttonColor: Colors.redAccent,
          borderColor: Colors.redAccent,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error en el login: $e');
      if (!mounted) return;
      await showCustomAlertDialog(
        context: context,
        icon: Icons.error,
        message:
            'Ocurrió un error al intentar iniciar sesión. Por favor, inténtalo de nuevo.',
        buttonText: 'Aceptar',
        buttonColor: Colors.redAccent,
        borderColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: ColoresApp.backgroundColor),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/img_media.png',
                  fit: BoxFit.cover,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - keyboardHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 100,
                                right: 20,
                                left: 20,
                              ),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: ColoresApp.texto1,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    child: Image.asset(
                                      'assets/images/login_logo.png',
                                      fit: BoxFit.cover,
                                      height: 120,
                                    ),
                                  ),
                                  Espacios.espacio15,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        cajastexto(
                                          icon: Icons.email,
                                          hint: 'Correo electrónico',
                                          controller: emailController,
                                        ),
                                        Espacios.espacio30,
                                        cajastexto(
                                          icon: Icons.lock,
                                          hint: 'Contraseña',
                                          controller: passwordController,
                                          isPassword: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Espacios.espacio15,
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 25,
                                      bottom: 20,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BotonElevado(
                                          label: 'Ingresar',
                                          onPressed: _handleLogin,
                                        ),
                                        Espacios.espacio20,
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/verificacionemail',
                                            );
                                          },
                                          child: Text(
                                            '¿Olvidaste tu contraseña?',
                                            style: menuSectionTitleStyle,
                                          ),
                                        ),
                                        Espacios.espacio05,
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/registro',
                                            );
                                          },
                                          child: Text(
                                            'Regístrate aquí',
                                            style: menuSectionTitleStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (keyboardHeight == 0) const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
