import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';

// Definición de estilo de ejemplo, asumiendo que lo tienes en algún lugar


// ignore: camel_case_types
class cajastexto extends StatefulWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hint;
  final bool isPassword; // Para indicar si este campo es una contraseña boleano

  const cajastexto({
    super.key,
    required this.controller,
    this.icon,
    required this.hint,
    this.isPassword = false,  // Por defecto, no es una contraseña
  });

  @override
  State<cajastexto> createState() => _cajastextoState();
}

// ignore: camel_case_types
class _cajastextoState extends State<cajastexto> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: widget.controller,
      obscureText: _obscureText, // Ahora usa la variable de estado interna
      style: menuSectionTitleStyle,

      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon, color:ColoresApp.iconColor):null,
        hintText: widget.hint,
        hintStyle: menuSectionTitleStyle.copyWith(
           color: ColoresApp.iconColor, 
          fontWeight: FontWeight.w400,
        ),

        // Bordes: ¡Correctamente dentro de InputDecoration!
        border: const UnderlineInputBorder(), // línea de abajo del campo
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),

        // Si es un campo de contraseña, muestra el icono de visibilidad while
        suffixIcon: widget.isPassword // si la condicion es falsa  entre en esto caso  contrauiio es null
            ? IconButton( icon: Icon( _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColoresApp.iconColor,),

                onPressed: () {
                  setState(() {  //  presion  encima  del  boton ojito
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
