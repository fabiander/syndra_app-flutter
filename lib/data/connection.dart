import 'package:mongo_dart/mongo_dart.dart';
import 'package:syndra_app/data/constante.dart';

class MongoDatabase {
  static late Db db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(mongoUri);
    await db.open();
    collection = db.collection(collectionName); // usa constante aquí también
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    await collection.insertOne(data);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    return await collection.find().toList();
  }

  static Future<void> update(String id, Map<String, dynamic> data) async {
    await collection.update(
      where.eq('_id', ObjectId.parse(id)), // Solo si id es String
      modify.set('campo', data['campo']),
    );
  }

  static Future<void> delete(String id) async {
    await collection.remove(where.id(ObjectId.parse(id)));
  }

  static Future<Map<String, dynamic>?> findUser(String email, String contrasena) async {
    final user = await collection.findOne({
      'email': email,
      'contrasena': contrasena,
    });
    return user;
  }
}

void main() async {
  await MongoDatabase.connect();

  // Insertar un documento de ejemplo
  await MongoDatabase.insert({
    'nombre': 'Documento de ejemplo',
    'campo': 'Valor del campo',
  });

  // Obtener todos los documentos
  for (var doc in await MongoDatabase.getAll()) {
    print('ID: ${doc['_id'].toHexString()}'); // Correcto
    print('Nombre: ${doc['nombre']}');
  }

  // Actualizar un documento (asegúrate de que el ID sea válido)
  //await MongoDatabase.update('ID_DEL_DOCUMENTO', {'campo': 'Nuevo valor'});

  // Eliminar un documento (asegúrate de que el ID sea válido)
  //await MongoDatabase.delete('ID_DEL_DOCUMENTO');
}
