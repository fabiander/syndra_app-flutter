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
                                  var data = {
                                    'nombre': nombreController.text.trim(),
                                    'edad':
                                        int.tryParse(
                                          edadController.text.trim(),
                                        ) ??
                                        0, // <-- conversión a int
                                    'email': emailController.text.trim(),
                                    'usuario': usuarioController.text.trim(),
                                    'contrasena':
                                        contrasenaController.text.trim(),
                                  };

                                  try {
                                    print('Intentando insertar: $data');
                                    await MongoDatabase.insert(data);
                                    print('Insert exitoso');
                                    nombreController.clear();
                                    edadController.clear();
                                    emailController.clear();
                                    usuarioController.clear();
                                    contrasenaController.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Registro guardado'),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Error al insertar: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al guardar: $e'),
                                      ),
                                    );
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
