import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/data/connection.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controladores para capturar el texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    emailController.dispose();
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(163, 217, 207, 1.0),
        ),

        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img_media.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                // Permite desplazamiento
                child: Container(
                  width: 340,
                  height: 700,
                  margin: const EdgeInsets.only(top: 95),

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromRGBO(63, 140, 112, 1.0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(10),

                        child: Column(
                          //  formulario de campos de texto
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            SizedBox(
                              width: 300,
                              child: cajastexto(
                                'Nombre',
                                icon: Icons.person,
                                controller: nombreController,
                              ),
                            ),
                            const SizedBox(height: 35),

                            SizedBox(
                              width: 300,
                              child: cajastexto(
                                'Edad',
                                icon: Icons.calendar_today,
                                controller: edadController,
                              ),
                            ),
                            const SizedBox(height: 35),

                            SizedBox(
                              width: 300,
                              child: cajastexto(
                                'Email',
                                icon: Icons.email,
                                controller: emailController,
                              ),
                            ),
                            const SizedBox(height: 35),
                            SizedBox(
                              width: 300,
                              child: cajastexto(
                                'Usuario',
                                icon: Icons.person,
                                controller: usuarioController,
                              ),
                            ),
                            const SizedBox(height: 35),
                            SizedBox(
                              width: 300,
                              child: cajastexto(
                                'Contraseña',
                                icon: Icons.lock,
                                controller: contrasenaController,
                                isPassword: true,
                              ),
                            ),
                            const SizedBox(height: 35),

                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              margin: const EdgeInsets.only(top: 25),

                              child: BotonElevado(
                                label: 'Guardar',

                                onPressed: () async {
                                  var nombre = nombreController.text.trim();
                                  var edadTexto = edadController.text.trim();
                                  var email = emailController.text.trim();
                                  var usuario = usuarioController.text.trim();
                                  var contrasena =
                                      contrasenaController.text.trim();
                                  // Validar campos vacíos

                                  if (nombre.isEmpty ||
                                      edadTexto.isEmpty ||
                                      email.isEmpty ||
                                      usuario.isEmpty ||
                                      contrasena.isEmpty) {
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
                                              Text('Espacios incompletos'),
                                            ],
                                          ),
                                          content: const Text(
                                            'Por favor, llena todos los campos antes de guardar.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Limpia las cajas y cierra la ventana
                                                nombreController.clear();
                                                edadController.clear();
                                                emailController.clear();
                                                usuarioController.clear();
                                                contrasenaController.clear();
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

                                  var data = {
                                    'nombre': nombre,
                                    'edad': int.tryParse(edadTexto) ?? 0,
                                    'email': email,
                                    'usuario': usuario,
                                    'contrasena': contrasena,
                                  };

                                  try {
                                    await MongoDatabase.insert(data);
                                    // Mostrar ventana de éxito con ícono
                                    await showDialog(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Registro guardado'),
                                            ],
                                          ),

                                          content: const Text(
                                            'Los datos se guardaron correctamente en la base de datos.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                nombreController.clear();
                                                edadController.clear();
                                                emailController.clear();
                                                usuarioController.clear();
                                                contrasenaController.clear();

                                                Navigator.of(context).pop();
                                              },

                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    // Puedes agregar otra ventana para errores de conexión o similares
                                    // ignore: avoid_print
                                    print('Error al insertar: $e');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
