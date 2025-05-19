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

                                  if (email.isEmpty || contrasena.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Por favor ingrese correo y contraseña',
                                        ),
                                      ),
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
                                      context,
                                      '/intro1',
                                    ); // Cambia '/home' por tu ruta real
                                  } else {
                                    // Usuario no encontrado, muestra aviso
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Usuario no registrado. Por favor regístrese.',
                                        ),
                                      ),
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
