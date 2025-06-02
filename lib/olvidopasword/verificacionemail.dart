import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart'; 
import 'package:syndra_app/texto/tipoletra.dart';


class VerificacionEmailScreen extends StatefulWidget {
  const VerificacionEmailScreen({super.key});

  @override
  State<VerificacionEmailScreen> createState() =>
      _VerificacionEmailScreenState();
}

class _VerificacionEmailScreenState extends State<VerificacionEmailScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _verificarEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      // ignore: use_build_context_synchronously
      _mostrarAlerta(
        context,
        'Advertencia',
        'Por favor, ingresa tu correo electrónico.',
      );
      return;
    }

    // Usamos el nuevo método findUserByEmail de MongoDatabase
    final user = await MongoDatabase.findUserByEmail(email);

    if (user != null) {
      // Si el email existe, navega a la pantalla de cambio de contraseña
      // Le pasamos el email para que la siguiente pantalla sepa de qué usuario se trata
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        '/cambio_password', // Ruta para la siguiente pantalla
        arguments: {'email': email},
      );
    } else {
      // ignore: use_build_context_synchronously
      _mostrarAlerta(
        context,
        'Error',
        'El correo electrónico no está registrado.',
      );
    }
  }

  void _mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;

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
                    padding: EdgeInsets.only(
                      bottom:
                          keyboardHeight +
                          MediaQuery.of(context).padding.bottom +
                          (isKeyboardVisible ? 20.0 : 0.0),
                      top: isKeyboardVisible ? 20.0 : 0.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            (isKeyboardVisible ? 20.0 : 0.0) -
                            keyboardHeight -
                            50.0,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 130,
                                right: 35,
                                left: 35,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
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
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      'Verificar Correo',
                                      style: TextStyle(
                                        color: ColoresApp.texto1,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),


                                  Text(
                                    'Ingresa el correo electrónico asociado a tu cuenta para restablecer tu contraseña.',
                                    style: TextStyle(
                                      color: ColoresApp.texto1
                                          .withOpacity(0.8),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 25),
                                  
                                  cajastexto(
                                    icon: Icons.email,
                                    hint: 'Correo electrónico',
                                    controller: emailController,
                                    //keyboardType: TextInputType.emailAddress,
                                  ),


                                  const SizedBox(height: 30),

                                  BotonElevado(
                                    label: 'Verificar',
                                    onPressed: _verificarEmail,
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      ); // Vuelve a la pantalla de login
                                    },
                                    child: const Text(
                                      'Volver',
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
                            if (!isKeyboardVisible) const Spacer(),
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
