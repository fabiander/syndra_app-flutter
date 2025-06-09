import 'package:flutter/material.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart'; // Asumiendo que tienes esta ruta para ColoresApp
import 'package:syndra_app/texto/tipoletra.dart'; // Asumiendo que tienes esta ruta para tu estilo de texto

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages =
      []; // Lista para almacenar mensajes { 'sender': 'user/bot', 'text': 'message' }
  final ScrollController _scrollController = ScrollController();
  
  

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return; // No enviar mensajes vacíos

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
    });
    _textController.clear(); // Limpiar el campo de texto
    _scrollToBottom(); // Desplazarse al final de la lista

    // Opcional: Simular una respuesta del "bot" después de un breve retraso
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        // Siempre verificar si el widget está montado antes de setState en async
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': 'Entendido. ¿como te sientes hoy?',
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat de Apoyo',
          style: counterTitleStyle.copyWith(color: ColoresApp.iconColor),
        ),
        backgroundColor: ColoresApp.barColor, // Color de AppBar
        iconTheme: IconThemeData(
          color: ColoresApp.iconColor,
        ), // Color del ícono de retroceso
      ),




      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? ColoresApp.backgroundColor
                          : ColoresApp.texto1, // Ajusta colores
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      message['text']!,
                      style: menuSectionTitleStyle.copyWith(
                        color: isUser
                            ? ColoresApp.iconColor
                            : Colors.white, // Ajusta colores del texto
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1.0),

          Container(
            decoration: BoxDecoration(color: ColoresApp.backgroundColor),
            child: IconTheme(
              data: IconThemeData(
                color: ColoresApp.iconColor,
              ), // Color para el icono de enviar
              child: Row(
                children: <Widget>[

                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _sendMessage, // Enviar al presionar Enter
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enviar un mensaje...',
                          hintStyle: menuSectionTitleStyle.copyWith(
                            color: ColoresApp.iconColor,
                          ),
                        ),
                        style: menuSectionTitleStyle, // Ajusta tu estilo de texto
                      ),
                    ),
                  ),

                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
