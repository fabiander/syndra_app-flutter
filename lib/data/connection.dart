import 'package:mongo_dart/mongo_dart.dart';
import 'package:syndra_app/data/constante.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(mongoUri); // usa la  ruta de la base de datos
    await db.open(); // abre la  conexion  de mongo
    collection = db.collection(collectionName); // usa constante aquí también
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    // inserta un documento d eun usuario
    await collection.insertOne(data);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    //  devuelve  un lista de todod los documentos de  coleccion
    return await collection.find().toList();
  }

  static Future<void> update(String id, Map<String, dynamic> data) async {
    // actualiza un documento especifico
    await collection.update(
      where.eq('_id', ObjectId.parse(id)), // Solo si id es String
      modify.set('campo', data['campo']),
    );
  }

  static Future<void> delete(String id) async {
    // elimina un documento especifico
    await collection.remove(where.id(ObjectId.parse(id)));
  }

  static Future<Map<String, dynamic>?> findUser(
    String email,
    String contrasena,
  ) async {
    //  busca un usuario en la base de datos
    final user = await collection.findOne({
      'email': email,
      'contrasena': contrasena,
    });
    return user;
  }
}
