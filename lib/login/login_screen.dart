import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/olvidopasword/cambiopasword.dart';
import 'package:syndra_app/olvidopasword/verificacionemail.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Widget espacio05 = SizedBox(height: 5);
  final Widget espacio15 = SizedBox(height: 15);

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
      // Esta propiedad es esencial para que el Scaffold se redimensione
      // automáticamente cuando el teclado aparece, evitando desbordamientos.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ColoresApp.backgroundColor, // color de fondo de la pantalla
          ),
          child: Stack(
            children: [
              // Imagen de fondo que ocupa toda la pantalla
              Positioned.fill(
                child: Image.asset(
                  'assets/images/img_media.png',
                  fit: BoxFit.cover,
                ),
              ),
              LayoutBuilder(
                // toma las medidas completas de toda la pantalla, espacio completo
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    // se estira y se encoge toda la pantalla, objetos puestos que coloquemos
                    // ConstrainedBox: Fuerza al contenido a tener una altura mínima.
                    // Esto asegura que, cuando el contenido es más corto que la pantalla,
                    // el SingleChildScrollView se estire para ocupar todo el espacio,
                    // eliminando la franja blanca.
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // minHeight: La altura mínima del contenido es la altura máxima
                        // disponible para el SingleChildScrollView desde el LayoutBuilder.
                        minHeight: constraints.maxHeight - keyboardHeight,
                      ),
                      // IntrinsicHeight: Permite que su hijo (la Column) determine su altura
                      // "natural" basándose en el tamaño de sus propios hijos.
                      // Esto es necesario para que el Spacer funcione correctamente dentro
                      // de un entorno con minHeight.
                      child: IntrinsicHeight(
                        child: Column(
                          // mainAxisAlignment.center: Centra verticalmente el contenido
                          // (el formulario) dentro de la altura forzada por ConstrainedBox.
                          // Esto ayuda a que el diseño se vea bien centrado en pantallas más grandes.
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // -------------------------------------------------------------
                            // Este es el contenedor principal de tu formulario de login (el de la línea verde)
                            // --------------------------------------------------------
                            Container(
                              //width: 410,
                              margin: const EdgeInsets.only(
                                top: 125,
                                right: 35,
                                left: 35,
                              ),
                              padding: const EdgeInsets.all(
                                20,
                              ), // Padding dentro del contenedor verde
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Fondo transparente para que se vea la imagen
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                    63,
                                    140,
                                    112,
                                    1.0,
                                  ),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // LOGO
                                  // Usar Padding es preferible a Container para solo aplicar espaciado
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

                                  espacio05,

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
                                        espacio15, 
                                        
                                        // Espacio entre campos
                                        cajastexto(
                                          icon: Icons.lock,
                                          hint: 'Contraseña',
                                          controller: passwordController,
                                          isPassword: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  espacio05,
                                  // Botones (Ingresar y Registro)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 30,
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
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .warning_amber_rounded,
                                                          color: Colors.orange,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text('Campos vacíos'),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                      'Por favor ingresa correo y contraseña.',
                                                    ),

                                                    
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          emailController
                                                              .clear();
                                                          passwordController
                                                              .clear();
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: const Text(
                                                          'Aceptar',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }

                                            final user =
                                                await MongoDatabase.findUser(
                                                  email,
                                                  contrasena,
                                                );

                                            if (user != null) {
                                              // Navega a la pantalla de menú si el usuario es encontrado
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacementNamed(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                '/menu',
                                              );
                                            } else {
                                              // Muestra un diálogo si el usuario no es encontrado
                                              // ignore: use_build_context_synchronously
                                              await showDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person_off,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Usuario no encontrado',
                                                        ),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                      'Usuario no registrado. Por favor regístrate.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          emailController
                                                              .clear();
                                                          passwordController
                                                              .clear();
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: const Text(
                                                          'Aceptar',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ), 

                                        // --- BOTÓN "OLVIDASTE TU CONTRASEÑA?" ---
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/verificacionemail', // Ruta a la nueva pantalla
                                            );
                                          },
                                          child: const Text(
                                            '¿Olvidaste tu contraseña?',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                63,
                                                140,
                                                112,
                                                1.0,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 10),
                                        
                                        
                                        
                                        // Espacio entre botones
                                        // Texto con estilo de botón para el registro (más ligero visualmente)
                                        TextButton(
                                          // Cambiado de BotonFantasma a TextButton si solo es un enlace
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/registro',
                                            );
                                          },
                                          child: const Text(
                                            '¿No tienes una cuenta? Regístrate aquí',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                63,
                                                140,
                                                112,
                                                1.0,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // -------------------------------------------------------------
                            // Spacer condicional:
                            // Este es el widget que rellena el espacio restante en la parte inferior
                            // cuando el teclado NO está visible.
                            // Si el teclado está visible, no se añade, permitiendo el desplazamiento.
                            // -------------------------------------------------------------
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
