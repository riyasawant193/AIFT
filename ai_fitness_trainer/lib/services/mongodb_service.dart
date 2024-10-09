import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static var db;
  static var userCollection;

  static Future<void> connect() async {
    db = await Db.create(
        'mongodb+srv://riyasawant:dontstartnow@cluster.33yox.mongodb.net/');
    await db.open();
    userCollection = db.collection('user_data');
  }

  static Future<void> insertUser(Map<String, dynamic> userData) async {
    await userCollection.insert(userData);
  }

  static Future<Map<String, dynamic>?> getUser(
      String email, String password) async {
    final user = await userCollection.findOne({
      'email': email,
      'password': password,
    });
    return user;
  }
}
