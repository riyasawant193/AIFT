import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static Db? _db;
  static DbCollection? _collection;

  static Future<void> init() async {
    _db = await Db.create('mongodb://<your-mongo-db-uri>');
    await _db!.open();
    _collection = _db!.collection('user_data');
  }

  static Future<void> insertUser(Map<String, dynamic> userData) async {
    await _collection!.insert(userData);
  }

  static Future<void> close() async {
    await _db!.close();
  }

  static connect() {}
}
