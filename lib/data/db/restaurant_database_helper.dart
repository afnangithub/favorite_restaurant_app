import 'package:favorite_restaurant_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantDatabaseHelper {
  static RestaurantDatabaseHelper? _instance;
  static Database? _database;
  RestaurantDatabaseHelper._internal() {
    _instance = this;
  }
  factory RestaurantDatabaseHelper() =>
      _instance ?? RestaurantDatabaseHelper._internal();
  static const String _tblFavorite = 'favorities';
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }
    return _database;
  }

  Future<void> insertFavoritie(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblFavorite, restaurant.toJson());
  }

  Future<List<Restaurant>> getFavorities() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorite);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getFavoritieByID(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavoritie(String id) async {
    final db = await database;
    await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
