import 'package:sqflite/sqflite.dart';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _instanceDatabase;
  static Database? _restaurantDatabase;

  DatabaseHelper._internal() {
    _instanceDatabase = this;
  }

  factory DatabaseHelper() => _instanceDatabase ?? DatabaseHelper._internal();
  static const String _tbFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tbFavorite(
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating DOUBLE
        )
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    // ignore: prefer_conditional_assignment
    if (_restaurantDatabase == null) {
      _restaurantDatabase = await _initializeDb();
    }
    return _restaurantDatabase;
  }

  Future<void> insertFavorite(Restaurants restaurants) async {
    final db = await database;
    await db!.insert(_tbFavorite, restaurants.toJson());
  }

  Future<List<Restaurants>> getFavorite() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(_tbFavorite);
    return result.map((e) => Restaurants.fromJson(e)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(_tbFavorite, where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db!.delete(
      _tbFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
