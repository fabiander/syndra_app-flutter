import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/colores_espacios/espacios.dart';
import 'package:syndra_app/login/cajas.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';


class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controladores para capturar el texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController =
      TextEditingController(); // Para mostrar la fecha seleccionada
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  // Para mostrar la fecha seleccionada en el campo de edad
  DateTime? _selectedDate;

  // Función para mostrar el DatePicker y actualizar el campo de edad
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Fecha mínima
      lastDate: DateTime.now(), // Fecha máxima (no puedes nacer en el futuro)
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Calcula la edad aproximada y la muestra
        int age = DateTime.now().year - picked.year;
        if (DateTime.now().month < picked.month ||
            (DateTime.now().month == picked.month &&
                DateTime.now().day < picked.day)) {
          age--; // Si aún no ha sido su cumpleaños este año
        }
        edadController.text = age
            .toString(); // Actualiza el TextField con la edad calculada
      });
    }
  }

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
      resizeToAvoidBottomInset: true, // es el valor por defecto y ayuda con el teclado

      appBar: AppBar(
        backgroundColor: ColoresApp.barColor, // Transparente para que se vea el fondo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: ColoresApp.iconColor,size: 40.0,), // Icono de volver
          onPressed: () {
            Navigator.pop(context); // Vuelve a la pantalla anterior
          },
        ),
      ),

      extendBodyBehindAppBar: true, // Para que el body se extienda detrás de la AppBar transparente

      body: Container(
        decoration: BoxDecoration(color: ColoresApp.backgroundColor),

        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img_media.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              alignment:
                  Alignment.center, // Centrar el contenedor del formulario
              child: SingleChildScrollView(
                // Permite desplazamiento
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 40.0,
                ), // Padding

                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 360, // Ancho máximo
                  ),

                  decoration: BoxDecoration(
                    color: Colors.transparent, // Fondo
                    border: Border.all(
                      color: const Color.fromRGBO(63, 140, 112, 1.0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      right: 20,
                      left: 20,
                      bottom: 40,
                    ), // Padding interno

                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Ajusta la altura a su contenido
                      children: [
                        cajastexto(
                          hint: 'Nombre',
                          icon: Icons.person,
                          controller: nombreController,
                        ),

                        Espacios.espacio30,

                        GestureDetector(
                          onTap: () => _selectDate(
                            // funcion fecha
                            context,
                          ),

                          child: AbsorbPointer(
                            // clase paar que no aparesca teclado
                            child: cajastexto(
                              hint: 'Edad',
                              icon: Icons.calendar_today,
                              controller: edadController,
                            ),
                          ),
                        ),

                        Espacios.espacio30,

                        // Campo Email
                        cajastexto(
                          hint: 'Email',
                          icon: Icons.email,
                          controller: emailController,
                        ),

                        Espacios.espacio30,

                        // Campo Usuario
                        cajastexto(
                          hint: 'Usuario',
                          icon: Icons.person,
                          controller: usuarioController,
                        ),

                        Espacios.espacio30,

                        // Campo Contraseña
                        cajastexto(
                          hint: 'Contraseña',
                          icon: Icons.lock,
                          controller: contrasenaController,
                          isPassword: true,
                        ),

                        Espacios.espacio30,

                        BotonElevado(
                          label: 'Guardar',
                          onPressed: () async {
                            var nombre = nombreController.text.trim();
                            var edadTexto = edadController.text.trim();
                            var email = emailController.text.trim();
                            var usuario = usuarioController.text.trim();
                            var contrasena = contrasenaController.text.trim();

                            // Validar campos vacíos
                            if (nombre.isEmpty || edadTexto.isEmpty || email.isEmpty || usuario.isEmpty || contrasena.isEmpty) {
                              await showCustomAlertDialog(
                                context: context,
                                icon: Icons.warning_amber_rounded,
                                message:'Por favor, llena todos los campos antes de guardar.',
                                buttonColor: Colors.pinkAccent,
                                borderColor: Colors.pinkAccent,
                              );
                              return; // Detener la ejecución si hay campos vacíos
                            }

                            // Validar edad como número
                            int? edad = int.tryParse(edadTexto);
                            if (edad == null || edad <= 0 || edad > 70) {
                              await showCustomAlertDialog(
                                context: context,
                                icon: Icons.error,
                                message: 'Por favor, ingresa una edad válida.',
                                buttonColor: Colors.red,
                              );
                              return;
                            }

                            var data = {
                              'nombre': nombre,
                              'edad': edad, // Usamos la edad validada
                              'email': email,
                              'usuario': usuario,
                              'contrasena': contrasena,
                            };

                            await MongoDatabase.insert(data,); // Mostrar ventana de éxito

                            await showCustomAlertDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              icon: Icons.check_circle,
                              message:'Los datos se guardaron correctamente en la base de datos.',
                              buttonColor: Colors.green,
                              borderColor: Colors.green,
                            );

                            // Opcional: Limpiar campos después de un registro exitoso
                            nombreController.clear();
                            edadController.clear();
                            emailController.clear();
                            usuarioController.clear();
                            contrasenaController.clear();
                            setState(() { _selectedDate =null; // Reinicia la fecha seleccionada
                            });
                          },
                        ),
                      ],
                    ),
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
