import 'package:mongo_dart/mongo_dart.dart';
import 'package:syndra_app/data/constante.dart';

class MongoDatabase {
  // ignore: prefer_typing_uninitialized_variables
  static var db;
  // ignore: prefer_typing_uninitialized_variables
  static var collection;

  static connect() async {
    db = await Db.create(mongoUri);
    await db.open();
    collection = db.collection(
      'usuarios',
    ); // cambia 'usuarios' por tu colección
  }

  static insert(Map<String, dynamic> data) async {
    await collection.insertOne(data);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    return await collection.find().toList();
  }

  static update(String id, Map<String, dynamic> data) async {
    await collection.update(
      where.eq('_id', ObjectId.parse(id)),
      modify.set('campo', data['campo']),
    );
  }

  static delete(String id) async {
    await collection.remove(where.id(ObjectId.parse(id)));
  }
}
