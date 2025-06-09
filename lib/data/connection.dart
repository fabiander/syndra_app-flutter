import 'package:mongo_dart/mongo_dart.dart';
import 'package:syndra_app/data/constante.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(mongoUri);
    await db.open();
    collection = db.collection(collectionName);
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    await collection.insertOne(data);
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
      return null;
    }
  }

  static Future<bool> updateUserPassword(
    String email,
    String newPassword,
  ) async {
    try {

      final userExists = await collection.findOne(where.eq('email', email));
      if (userExists == null) {
        return false;
      }

      final updateResult = await collection.updateOne(
        where.eq('email', email),
        ModifierBuilder().set('contrasena', newPassword),
      );

      final matchedCount = updateResult.nMatched;
      final modifiedCount = updateResult.nModified;


      if (modifiedCount == 1) {
        return true;
      } else if (matchedCount == 1 && modifiedCount == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> close() async {
    await db.close();
  }




static Future<Map<String, dynamic>?> getUserById(String id) async {
    try {
      // 1. Bloque try-catch para manejo de errores

      // 2. Asegurarse de que la conexión a la base de datos esté abierta.
      if (!db.isConnected) {
        // <-- Condición: ¿Está la DB conectada?
        await connect(); // <-- Acción: Conectar si no lo está
      }

      // 3. MongoDB usa ObjectId para el campo _id.
      // Necesitamos parsear la cadena de texto 'id' a un ObjectId.
      final ObjectId objectId = ObjectId.parse(
        id,
      ); // <-- Conversión de String a ObjectId

      // 4. Buscar un documento donde el _id coincida con el ObjectId.
      final user = await collection.findOne(
        where.eq('_id', objectId),
      ); // <-- La consulta principal

      // 5. Retorna el documento del usuario o null si no se encuentra.
      return user; // <-- Devuelve el resultado de la consulta
    } catch (e) {
      // 6. Bloque catch para capturar y manejar errores
      // Captura cualquier error (ej. formato de ID inválido, problemas de conexión)
      print(
        'Error al buscar usuario por ID ($id): $e',
      ); // <-- Mensaje de error para depuración
      return null; // <-- Retorna null en caso de error
    }
  }







}
