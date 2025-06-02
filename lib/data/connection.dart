import 'package:mongo_dart/mongo_dart.dart';
import 'package:syndra_app/data/constante.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(mongoUri);
    await db.open();
    collection = db.collection(collectionName);
    print('Conexión a MongoDB establecida.');
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    await collection.insertOne(data);
    print('Documento insertado: $data');
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    return await collection.find().toList();
  }



  static Future<bool> updateDocumentById(
    String id,
    Map<String, dynamic> data,
  ) async {
    
    var modifier = ModifierBuilder(); // metodo de mongo interno
    data.forEach((key, value) {
    modifier.set(key, value);
    });
    
    final updateResult = await collection.updateOne( // busca el id y cambia la contraseña
      where.eq('_id', ObjectId.parse(id)),
      modifier,
      );

      return updateResult.nModified ==  1; //  si el resultado  es igual a 1 retorna la variable caso contrario error
  }

  static Future<void> delete(String id) async {
    await collection.remove(where.id(ObjectId.parse(id)));
  }

  static Future<Map<String, dynamic>?> findUser(
    String email,
    String contrasena,
  ) async {
    final user = await collection.findOne({
      'email': email,
      'contrasena': contrasena,
    });
    return user;
  }

  static Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    try {
      final user = await collection.findOne(where.eq('email', email));
      return user;
    } catch (e) {
      print("Error al buscar usuario por email: $e");
      return null;
    }
  }

  static Future<bool> updateUserPassword(
    String email,
    String newPassword,
  ) async {
    try {
      print('DEBUG: Intentando actualizar contraseña para el email: $email');
      print('DEBUG: Nueva contraseña: $newPassword');

      final userExists = await collection.findOne(where.eq('email', email));
      if (userExists == null) {
        print('DEBUG: El usuario con email "$email" NO fue encontrado.');
        return false;
      }
      print('DEBUG: Usuario con email "$email" ENCONTRADO.');

      final updateResult = await collection.updateOne(
        where.eq('email', email),
        ModifierBuilder().set('contrasena', newPassword),
      );

      final matchedCount = updateResult.nMatched;
      final modifiedCount = updateResult.nModified;

      print('DEBUG: Matched Count: $matchedCount');
      print('DEBUG: Modified Count: $modifiedCount');

      if (modifiedCount == 1) {
        return true;
      } else if (matchedCount == 1 && modifiedCount == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("DEBUG: ¡Error crítico al actualizar contraseña! Excepción: $e");
      return false;
    }
  }

  static Future<void> close() async {
    await db.close();
    print('Conexión a MongoDB cerrada.');
  }
}
