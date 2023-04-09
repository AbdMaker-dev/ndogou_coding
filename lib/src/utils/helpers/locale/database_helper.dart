import 'dart:html';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../contantes/db_tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  DatabaseHelper._(); // constructeur privé en Dart.

  Future<Database> get database async {
    if (_database == null || !_database!.isOpen) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // path = rep/jjsjbbshs/news.db
    // join() : permet de rejoindre plusieurs parties de chemins en utilisant le séparateur de répertoire approprié pour le système d'exploitation sous-jacent.
    // getDatabasesPath() : permet d'obtenir le chemin du dossier où les bases de données SQLite sont stockées pour l'application.
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $infosTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        author TEXT,
        title TEXT,
        description TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT
      )
    ''');

    // CREATE OTHER TABLES ....
  }

  // ----------- TRANSACTIONS --------------------------------------------------
  Future<int> saveSomeData(String tableName, Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.insert(tableName, data);
  }

  Future<Map<String, dynamic>?> getSomeDataByID(String tableName, int id) async {
    Database db = await instance.database;
    List<Map> maps = await db.query(tableName,
        columns: [], // columns projection
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return maps.first as Map<String, dynamic>;
    }
    return null;
  }

  Future<int> updateSomeData(String tableName, id, Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSomeData(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getSomeData(String tableName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps;
    //return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

}