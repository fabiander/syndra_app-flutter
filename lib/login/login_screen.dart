import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/botones_base/boton_fantasma.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';


//import 'package:syndra_app/login/registro.dart';
// Para navegar desde el botón

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Liberar recursos
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(163, 217, 207, 1.0)),

        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img_media.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              //   alinacion sube
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Container(
                    width: 340,
                    height: 700,
                    margin: EdgeInsets.only(top: 95),
                    //padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Color.fromRGBO(63, 140, 112, 1.0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //  ESTE ES EL LOGO
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/images/login_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                        Container(
                          width: 300,
                          // caja de email y contraseña
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              cajastexto(
                                icon: Icons.email,
                                'Correo electrónico',
                                controller: emailController,
                              ),

                              SizedBox(height: 10),

                              Container(
                                child: cajastexto(
                                  icon: Icons.lock,
                                  'Contraseña',
                                  controller: passwordController,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonElevado(
                                label: 'Ingresar',
                                onPressed: () async {
                                  final email = emailController.text.trim();
                                  final contrasena =
                                      passwordController.text.trim();

                                  // Validar campos vacíos
                                  if (email.isEmpty || contrasena.isEmpty) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Icons.warning_amber_rounded,
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
                                                emailController.clear();
                                                passwordController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  final user = await MongoDatabase.findUser(
                                    email,
                                    contrasena,
                                  );

                                  if (user != null) {
                                    // Usuario encontrado, navega a la siguiente pantalla
                                    Navigator.pushReplacementNamed(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      '/menu',
                                    );
                                  } else {
                                    // Usuario no encontrado, mostrar AlertDialog
                                    await showDialog(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Icons.person_off,
                                                color: Colors.redAccent,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Usuario no encontrado'),
                                            ],
                                          ),
                                          content: const Text(
                                            'Usuario no registrado. Por favor regístrate.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                emailController.clear();
                                                passwordController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),

                              SizedBox(height: 20),

                              BotonFantasma(
                                label: 'Registro',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/registro');
                                },
                              ),
                            ],
                          ),
                        ),
                        // Aquí puedes agregar más containers o widgets
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
