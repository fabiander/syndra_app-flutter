import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/data/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _userName = 'Usuario Ejemplo';
  int _userAge = 30;
  String _userEmail = 'usuario.ejemplo@email.com';
  String _userUsername = 'ejemplo_user';
  bool _notificationsEnabled = true;
  String _userId = '';

  final Color _primaryColor = const Color.fromRGBO(33, 78, 62, 1.0);
  final Color _secondaryColor = const Color.fromRGBO(163, 217, 207, 1.0);
  final Color _textColor = const Color.fromRGBO(33, 78, 62, 1.0);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('loggedInUserId') ?? '';
    // Si quieres cargar los datos reales del usuario, puedes hacerlo aquí:
    // final user = await MongoDatabase.getUserById(_userId);
    // setState(() {
    //   _userName = user?['name'] ?? _userName;
    //   _userAge = user?['age'] ?? _userAge;
    //   _userEmail = user?['email'] ?? _userEmail;
    //   _userUsername = user?['username'] ?? _userUsername;
    // });
  }

  Future<void> _updateUserProfile({
    String? name,
    int? age,
    String? email,
    String? username,
  }) async {
    await MongoDatabase.updateDocumentById(_userId, {
      'name': name ?? _userName,
      'age': age ?? _userAge,
      'email': email ?? _userEmail,
      'username': username ?? _userUsername,
    });
  }

  void _showEditFieldDialog({
    required String title,
    required String initialValue,
    required Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
  }) {
    TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText:
                  'Nuevo ${title.toLowerCase().replaceAll('editar ', '')}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _saveUserName(String newName) async {
    if (newName.isNotEmpty) {
      setState(() {
        _userName = newName;
      });
      await _updateUserProfile(name: newName);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nombre actualizado')));
    }
  }

  void _saveUserAge(String newAgeStr) async {
    final int? newAge = int.tryParse(newAgeStr);
    if (newAge != null && newAge > 0 && newAge < 120) {
      setState(() {
        _userAge = newAge;
      });
      await _updateUserProfile(age: newAge);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Edad actualizada')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Edad inválida. Por favor, ingresa un número válido.'),
        ),
      );
    }
  }

  void _saveUserEmail(String newEmail) async {
    if (newEmail.isNotEmpty &&
        newEmail.contains('@') &&
        newEmail.contains('.')) {
      setState(() {
        _userEmail = newEmail;
      });
      await _updateUserProfile(email: newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo electrónico actualizado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo electrónico inválido.')),
      );
    }
  }

  void _saveUserUsername(String newUsername) async {
    if (newUsername.isNotEmpty && newUsername.length >= 3) {
      setState(() {
        _userUsername = newUsername;
      });
      await _updateUserProfile(username: newUsername);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario actualizado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El usuario debe tener al menos 3 caracteres.'),
        ),
      );
    }
  }

  void _showChangePasswordDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulando cambio de contraseña...'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cerrando sesión... (Simulado)'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sección de Información del Usuario
            CircleAvatar(
              radius: 60,
              backgroundColor: _secondaryColor,
              child: Icon(Icons.person, size: 70, color: _primaryColor),
            ),
            const SizedBox(height: 20),

            _buildInfoTile(
              label: 'Nombre',
              value: _userName,
              icon: Icons.person_outline,
              onTap: () => _showEditFieldDialog(
                title: 'Editar Nombre',
                initialValue: _userName,
                onSave: _saveUserName,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoTile(
              label: 'Edad',
              value: _userAge.toString(),
              icon: Icons.cake,
              onTap: () => _showEditFieldDialog(
                title: 'Editar Edad',
                initialValue: _userAge.toString(),
                onSave: _saveUserAge,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoTile(
              label: 'Correo Electrónico',
              value: _userEmail,
              icon: Icons.email_outlined,
              onTap: () => _showEditFieldDialog(
                title: 'Editar Correo Electrónico',
                initialValue: _userEmail,
                onSave: _saveUserEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoTile(
              label: 'Usuario',
              value: _userUsername,
              icon: Icons.account_circle_outlined,
              onTap: () => _showEditFieldDialog(
                title: 'Editar Usuario',
                initialValue: _userUsername,
                onSave: _saveUserUsername,
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileTile(
              label: 'Contraseña',
              icon: Icons.lock,
              onTap: _showChangePasswordDialog,
            ),
            const SizedBox(height: 30),

            // Sección de Preferencias
            _buildSectionTitle('Preferencias'),
            const SizedBox(height: 15),
            SwitchListTile(
              title: Text(
                'Notificaciones',
                style: menuSectionTitleStyle.copyWith(color: _textColor),
              ),
              secondary: Icon(Icons.notifications, color: _textColor),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Notificaciones activadas'
                          : 'Notificaciones desactivadas',
                    ),
                  ),
                );
                // Si quieres guardar este cambio en la base de datos, llama aquí a tu método
                // await MongoDatabase.updateDocumentById(_userId, {'notificationsEnabled': value});
              },
              activeColor: _primaryColor,
            ),
            const SizedBox(height: 40),

            // Botón de Cerrar Sesión
            BotonElevado(
              label: 'Cerrar Sesión',
              onPressed: _logout,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              width: 200,
              height: 50,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los títulos de sección
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: menuSectionTitleStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  // Widget auxiliar para mostrar y permitir editar campos de información
  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(
          label,
          style: menuSectionTitleStyle.copyWith(color: _textColor),
        ),
        subtitle: Text(
          value,
          style: menuSectionTitleStyle.copyWith(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        trailing: onTap != null
            ? Icon(Icons.edit, size: 20, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }

  // Widget auxiliar existente para elementos de lista
  Widget _buildProfileTile({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    String? trailingText,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(
          label,
          style: menuSectionTitleStyle.copyWith(color: _textColor),
        ),
        trailing: trailingText != null
            ? Text(
                trailingText,
                style: menuSectionTitleStyle.copyWith(color: Colors.grey),
              )
            : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
