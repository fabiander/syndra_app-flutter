import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/colores_espacios/espacios.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';
import 'package:syndra_app/texto/tipoletra.dart';

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

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(
      context,
    ).viewInsets.bottom; // altura del teclado

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ColoresApp.backgroundColor, // color de fondo de la pantalla
          ),

          child: Stack(
            children: [
              Positioned.fill(
                // Imagen de fondo que ocupa toda la pantalla
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
                              padding: const EdgeInsets.all(
                                15,
                              ), // Padding dentro del contenedor verde
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Fondo transparente de la imagen
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
                                      height:
                                          120, // Altura fija para el logo para consistencia
                                    ),
                                  ),

                                  Espacios.espacio15,

                                  // Cajas de texto (Email y Contraseña)
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
                                    ), // Espacio arriba y abajo de los botones
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BotonElevado(
                                          label: 'Ingresar',
                                          onPressed: () async {
                                            final email = emailController.text
                                                .trim();
                                            final contrasena =
                                                passwordController.text.trim();

                                            if (email.isEmpty ||
                                                contrasena.isEmpty) {
                                              await showCustomAlertDialog(
                                                context: context,
                                                icon: Icons
                                                    .warning, // Icono para advertencia
                                                message:
                                                    'Por favor, completa todos los campos.',
                                                buttonText: 'Aceptar',
                                                buttonColor: Colors.amberAccent,
                                                borderColor: Colors.amberAccent,
                                              );
                                              return;
                                            }
                                            final user =
                                                await MongoDatabase.findUser(
                                                  email,
                                                  contrasena,
                                                );

                                            if (user != null) {
                                              Navigator.pushReplacementNamed(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                '/menu',
                                              ); // Navega a la pantalla del menú
                                            } else {
                                              await showCustomAlertDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                icon: Icons.error,
                                                message:
                                                    'Correo electrónico o contraseña incorrectos.',
                                                buttonText: 'Aceptar',
                                                buttonColor: Colors.amberAccent,
                                                borderColor: Colors.amberAccent,
                                              );
                                            }
                                          },
                                        ),

                                        Espacios.espacio20,

                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/verificacionemail',
                                            );
                                          }, // ruta para la verificación de email

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
                            if (keyboardHeight ==
                                0) // Solo añade el Spacer si el teclado NO está visible
                              const Spacer(),
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
