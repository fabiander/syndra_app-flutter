import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores/tonoscolores.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';


class CambioPasswordScreen extends StatefulWidget {
  final String email; // Recibir el email de la pantalla anterior
  const CambioPasswordScreen({super.key, required this.email});

  @override
  State<CambioPasswordScreen> createState() => _CambioPasswordScreenState();
}

class _CambioPasswordScreenState extends State<CambioPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _cambiarContrasena() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();


    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      await showCustomAlertDialog(// <--- Usamos la nueva función
        context: context,
        icon: Icons.warning_amber_rounded, // Icono para advertencia
        message: 'Por favor, ingresa y confirma tu nueva contraseña.',
        buttonColor: Colors.orange, // Puedes cambiar el color para advertencias
      );
      return;
    }

    if (newPassword != confirmPassword) {
      await showCustomAlertDialog(// <--- Usamos la nueva función
        context: context,
        icon: Icons.error_outline, // Icono para error
        message: 'Las contraseñas no coinciden.',
        buttonColor: const Color.fromRGBO(
          255,
          99,
          71,
          1.0,
        ), // Rojo para errores
      );
      return;
    }

    if (newPassword.length < 5) {// Deja o modifica este número según tu necesidad
      await showCustomAlertDialog(// <--- Usamos la nueva función
        context: context,
        icon: Icons.info_outline, // Icono para información/advertencia
        message: 'La contraseña debe tener al menos 6 caracteres.',
        buttonColor: Colors.blueAccent, // Color diferente para este tipo de mensaje
      );
      return;
    }

    // Lógica para actualizar la contraseña en la base de datos
    final success = await MongoDatabase.updateUserPassword(
      widget.email,
      newPassword,
    );

    if (success) {
      await showCustomAlertDialog( // <--- Usamos la nueva función
        context: context,
        icon: Icons.check_circle_outline, // Icono para éxito
        message:'Tu contraseña ha sido actualizada. Ahora puedes iniciar sesión.',
        buttonColor: Colors.green, // Verde para éxito
      );
      // Navegar de vuelta al login y eliminar todas las rutas anteriores
      // Ya que el diálogo es asíncrono, puedes navegar después de que se cierre.
      if (mounted) {
        // <--- Es buena práctica verificar si el widget sigue montado
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      await showCustomAlertDialog(
        // <--- Usamos la nueva función
        context: context,
        icon: Icons.error_outline, // Icono para error
        message: 'No se pudo actualizar la contraseña. Intenta de nuevo.',
        buttonColor: const Color.fromRGBO(
          255,
          99,
          71,
          1.0,
        ), // Rojo para errores
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
                                      'Nueva Contraseña',
                                      style: TextStyle(
                                        color: ColoresApp.texto1,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),



                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    'Ingresa tu nueva contraseña y confírmala para ${widget.email}.',
                                    style: TextStyle(
                                      color: ColoresApp.texto1
                                          .withOpacity(0.8),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 25),
                                  cajastexto(
                                    icon: Icons.lock_outline,
                                    hint: 'Nueva Contraseña',
                                    controller: newPasswordController,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 15),

                                  cajastexto(
                                    icon: Icons.lock_reset,
                                    hint: 'Confirmar Contraseña',
                                    controller: confirmPasswordController,
                                    isPassword: true,

                                  ),
                                  const SizedBox(height: 30),

                                  BotonElevado(
                                    label: 'Restablecer',
                                    onPressed: _cambiarContrasena,
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/login',
                                        (route) => false,
                                      ); // Vuelve al login y limpia el stack
                                    },
                                    child: const Text(
                                      'Cancelar y Volver al Login',
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
