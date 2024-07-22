import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'meal.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meals.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE meals(id INTEGER PRIMARY KEY, food TEXT, dateTime TEXT, notes TEXT)",
        );
      },
    );
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert(
      'meals',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Meal>> meals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meals');

    return List.generate(maps.length, (i) {
      return Meal(
        id: maps[i]['id'],
        food: maps[i]['food'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
        notes: maps[i]['notes'],
      );
    });
  }

  Future<void> updateMeal(Meal meal) async {
    final db = await database;
    await db.update(
      'meals',
      meal.toMap(),
      where: "id = ?",
      whereArgs: [meal.id],
    );
  }

  Future<void> deleteMeal(int id) async {
    final db = await database;
    await db.delete(
      'meals',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
