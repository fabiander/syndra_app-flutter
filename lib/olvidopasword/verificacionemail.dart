import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores_espacios/espacios.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';

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
      await showCustomAlertDialog(
        context: context,
        icon: Icons.email_outlined, // Icono para advertencia
        message: 'Por favor, ingresa un correo electronico.',
        buttonColor: Colors.deepPurple,
        borderColor: Colors.deepPurple,
      );
    }

    //  método findUserByEmail de MongoDatabase
    final user = await MongoDatabase.findUserByEmail(email);

    if (user != null) {
      Navigator.pushReplacementNamed(
        // ignore: use_build_context_synchronously
        context,
        '/cambio_password',
        arguments: {'email': email}, // Ruta para la siguiente pantalla
      );
    } else {
      await showCustomAlertDialog(
        // ignore: use_build_context_synchronously
        context: context,
        icon: Icons.error_outline, // Icono para error
        message: 'El correo electrónico no está registrado.',
        buttonColor: Colors.redAccent,
        borderColor: Colors.redAccent,
      );
    }
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
                      bottom: keyboardHeight + (isKeyboardVisible ? 20.0 : 0.0),
                      top: isKeyboardVisible ? 20.0 : 0.0,
                    ),

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
                                top: 130,
                                right: 20,
                                left: 20,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: ColoresApp.texto1, // Color del borde
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
                                      style: counterTitleStyle.copyWith(
                                        color: ColoresApp.iconColor.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  Espacios.espacio10,

                                  Text(
                                    'Ingresa el correo electrónico asociado a tu cuenta para restablecer tu contraseña.',
                                    style: menuSectionTitleStyle.copyWith(
                                      color: ColoresApp.iconColor.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  Espacios.espacio30,

                                  cajastexto(
                                    icon: Icons.email,
                                    hint: 'Correo electrónico',
                                    controller: emailController,
                                  ),

                                  Espacios.espacio30,

                                  BotonElevado(
                                    label: 'Verificar',
                                    onPressed: _verificarEmail,
                                  ),

                                  Espacios.espacio15,

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      ); // Vuelve a la pantalla de login
                                    },
                                    child: Text(
                                      'Volver',
                                      style: menuSectionTitleStyle,
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
