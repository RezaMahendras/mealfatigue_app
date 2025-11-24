import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('auth_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');
  }

  // --- Register ---
  Future<int> registerUser(String email, String password) async {
    final db = await instance.database;
    final data = {'email': email, 'password': password};

    // ConflictAlgorithm.fail akan melempar error jika email sudah ada
    return await db.insert('users', data, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  // --- Login ---
  Future<bool> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }
}