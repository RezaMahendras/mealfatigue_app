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

    // --- UBAH VERSI KE 5 (Wajib dinaikkan agar perubahan terdeteksi) ---
    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // --- LOGIKA MIGRASI ---
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrasi Versi 3
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS saved_session (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          password TEXT
        )
      ''');
    }

    // Migrasi Versi 4
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_profile (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fullName TEXT,
          nickName TEXT,
          email TEXT,
          phone TEXT,
          age TEXT,
          height TEXT,
          weight TEXT,
          status TEXT
        )
      ''');

      await db.insert('user_profile', {
        'fullName': '',
        'nickName': '',
        'email': '@gmail.com',
        'phone': '',
        'age': '',
        'height': '',
        'weight': '',
        'status': 'Mahasiswa'
      });
    }

    // --- [PENTING] MIGRASI VERSI 5: TAMBAH KOLOM FOTO ---
    // Ini yang bikin error sebelumnya. Kita harus menambah kolom ini secara manual
    // untuk database yang sudah terlanjur dibuat di HP.
    if (oldVersion < 5) {
      try {
        await db.execute("ALTER TABLE user_profile ADD COLUMN profilePicturePath TEXT");
      } catch (e) {
        print("Error adding column (mungkin sudah ada): $e");
      }
    }
  }

  Future _createDB(Database db, int version) async {
    // 1. TABEL USERS
    await db.execute('''
    CREATE TABLE users ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');

    // 2. TABEL KOSLIFE
    await db.execute('''
      CREATE TABLE koslife_budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_budget INTEGER,
        remaining_budget INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE koslife_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        budget_id INTEGER,
        name TEXT,
        price INTEGER,
        category TEXT, 
        FOREIGN KEY (budget_id) REFERENCES koslife_budgets (id) ON DELETE CASCADE
      )
    ''');

    // 3. TABEL COUPLE PROFILE
    await db.execute('''
      CREATE TABLE couple_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_a_name TEXT,
        person_a_needs TEXT,
        person_a_prefs TEXT,
        person_a_allergies TEXT,
        person_b_name TEXT,
        person_b_needs TEXT,
        person_b_prefs TEXT,
        person_b_allergies TEXT,
        dynamic_problem TEXT,
        ai_analysis TEXT
      )
    ''');

    // 4. TABEL SAVED SESSION
    await db.execute('''
      CREATE TABLE saved_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT
      )
    ''');

    // 5. TABEL USER PROFILE
    // Kita tambahkan profilePicturePath di sini untuk user yang baru install aplikasi
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        nickName TEXT,
        email TEXT,
        phone TEXT,
        age TEXT,
        height TEXT,
        weight TEXT,
        status TEXT,
        profilePicturePath TEXT 
      )
    ''');

    // --- DATA DEFAULT ---
    await db.insert('couple_profile', {
      'person_a_name': 'Alex',
      'person_a_needs': 'Diabetes Type,low cash',
      'person_a_prefs': 'Suka Pedas,Protein Tinggi',
      'person_a_allergies': 'Seafood',
      'person_b_name': 'Blake',
      'person_b_needs': 'Vegan,Plant based',
      'person_b_prefs': 'Budget conscious,Suka warna',
      'person_b_allergies': 'Terong',
      'dynamic_problem': 'Sering debat weekend makan apa',
      'ai_analysis': 'Alex needs careful carb management while Blake prefer full plant based. Our AI focuses on middle ground recipes that satisfy both needs.'
    });

    // --- DATA DEFAULT USER PROFILE ---
    await db.insert('user_profile', {
      'fullName': '',
      'nickName': '',
      'email': '@gmail.com',
      'phone': '',
      'age': '',
      'height': '',
      'weight': '',
      'status': 'Mahasiswa',
      'profilePicturePath': null // Default kosong
    });
  }

  // --- AUTH METHODS (TETAP) ---
  Future<int> registerUser(String email, String password) async {
    final db = await instance.database;
    final data = {'email': email, 'password': password};
    return await db.insert('users', data, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return maps.isNotEmpty;
  }

  // --- REMEMBER ME METHODS (TETAP) ---
  Future<void> saveSession(String email, String password) async {
    final db = await instance.database;
    await db.delete('saved_session');
    await db.insert('saved_session', {'email': email, 'password': password});
  }

  Future<void> clearSession() async {
    final db = await instance.database;
    await db.delete('saved_session');
  }

  Future<Map<String, dynamic>?> getSession() async {
    final db = await instance.database;
    try {
      final result = await db.query('saved_session', limit: 1);
      if (result.isNotEmpty) return result.first;
    } catch (e) {
      return null;
    }
    return null;
  }

  // --- KOSLIFE METHODS (TETAP) ---
  Future<int> createBudget(int total, int remaining) async {
    final db = await instance.database;
    final data = {
      'total_budget': total,
      'remaining_budget': remaining,
      'created_at': DateTime.now().toIso8601String(),
    };
    return await db.insert('koslife_budgets', data);
  }

  Future<void> insertShoppingItems(int budgetId, List<Map<String, dynamic>> items) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var item in items) {
      batch.insert('koslife_items', {
        'budget_id': budgetId,
        'name': item['name'],
        'price': item['price'],
        'category': item['category'],
      });
    }
    await batch.commit(noResult: true);
  }

  Future<Map<String, dynamic>?> getLastBudget() async {
    final db = await instance.database;
    final maps = await db.query('koslife_budgets', orderBy: 'id DESC', limit: 1);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getItemsByBudget(int budgetId) async {
    final db = await instance.database;
    return await db.query('koslife_items', where: 'budget_id = ?', whereArgs: [budgetId]);
  }

  // --- COUPLE PROFILE METHODS (TETAP) ---
  Future<Map<String, dynamic>?> getCoupleProfile() async {
    final db = await instance.database;
    final result = await db.query('couple_profile', limit: 1);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateCoupleProfile(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update('couple_profile', row, where: 'id = ?', whereArgs: [1]);
  }

  // --- USER PROFILE METHODS ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await instance.database;
    final result = await db.query('user_profile', limit: 1);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // Fungsi ini sekarang akan BERHASIL karena tabel user_profile sudah punya kolom foto
  Future<int> updateUserProfile(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update('user_profile', row, where: 'id = ?', whereArgs: [1]);
  }
}
