import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Variabel untuk menyimpan ID pengguna yang sedang aktif di memori
  static int? _activeUserId;

  // Metode helper untuk mengambil ID pengguna aktif.
  // Ini akan dipanggil oleh semua metode yang bergantung pada profil pengguna.
  Future<int?> getActiveUserId() async {
    if (_activeUserId != null) return _activeUserId;

    final session = await getSession();
    if (session != null && session.containsKey('user_id')) {
      _activeUserId = session['user_id'] as int;
      return _activeUserId;
    }
    return null;
  }

  // Metode untuk mengatur ID pengguna aktif setelah login/register
  void setActiveUserId(int userId) {
    _activeUserId = userId;
  }

  // Metode untuk menghapus ID pengguna aktif setelah logout
  void clearActiveUserId() {
    _activeUserId = null;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Versi diupdate ke 8 untuk menangani skema baru
    _database = await _initDB('auth_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Versi diperbarui menjadi 8 (untuk skema user_profile baru)
    return await openDatabase(
      path,
      version: 8, // <--- VERSI DIPERBARUI KE 8
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
          password TEXT,
          user_id INTEGER -- BARU: Tambah user_id
        )
      ''');
    }

    // Migrasi Versi 4 (Perubahan besar di Versi 8, ini untuk kompatibilitas lama)
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

    // Migrasi Versi 5
    if (oldVersion < 5) {
      try {
        await db.execute("ALTER TABLE user_profile ADD COLUMN profilePicturePath TEXT");
      } catch (e) {
        print("Error adding column (mungkin sudah ada): $e");
      }
    }

    // Migrasi Versi 6 (KosLife Smart Tip)
    if (oldVersion < 6) {
      try {
        await db.execute(
            "ALTER TABLE koslife_budgets ADD COLUMN smart_tip TEXT"
        );
      } catch (e) {
        print("smart_tip column mungkin sudah ada: $e");
      }
    }

    // Migrasi Versi 7 (Daily Missions)
    if (oldVersion < 7) {
      try {
        await db.execute('''
          CREATE TABLE daily_missions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mission_key TEXT NOT NULL,
            date TEXT NOT NULL,
            is_completed INTEGER NOT NULL,
            UNIQUE(mission_key, date)
          )
        ''');
      } catch (e) {
        print("Error creating daily_missions table: $e");
      }
    }

    // Migrasi Versi 8: Perbaikan Skema user_profile dan saved_session
    if (oldVersion < 8) {
      // Hapus tabel user_profile lama (karena skema berubah total)
      await db.execute("DROP TABLE IF EXISTS user_profile");

      // Buat ulang tabel user_profile dengan relasi One-to-One
      await db.execute('''
            CREATE TABLE user_profile (
                user_id INTEGER PRIMARY KEY,
                fullName TEXT,
                nickName TEXT,
                email TEXT,
                phone TEXT,
                age TEXT,
                height TEXT,
                weight TEXT,
                status TEXT,
                profilePicturePath TEXT,
                FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
        ''');

      // Cek dan tambahkan kolom user_id ke saved_session jika belum ada
      try {
        await db.execute("ALTER TABLE saved_session ADD COLUMN user_id INTEGER");
      } catch (e) {
        print("Kolom user_id di saved_session sudah ada atau error lain: $e");
      }

      // Jika ada user lama di tabel 'users', buatkan profil default
      final oldUsers = await db.query('users', columns: ['id', 'email']);
      for (var user in oldUsers) {
        final userId = user['id'] as int;
        final userEmail = user['email'] as String;
        await db.insert('user_profile', {
          'user_id': userId,
          'fullName': '',
          'nickName': '',
          'email': userEmail, // Gunakan email dari tabel users
          'phone': '',
          'age': '',
          'height': '',
          'weight': '',
          'status': 'Mahasiswa',
          'profilePicturePath': null
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
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
        smart_tip TEXT,
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
    // Couple Profile tetap global (tidak terkait User ID)
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

    // 4. TABEL SAVED SESSION (DIPERBARUI)
    await db.execute('''
      CREATE TABLE saved_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL, -- BARU: Foreign Key ke users
        email TEXT,
        password TEXT
      )
    ''');

    // 5. TABEL USER PROFILE (DIPERBARUI DENGAN FK)
    await db.execute('''
      CREATE TABLE user_profile (
        user_id INTEGER PRIMARY KEY, -- ID dari tabel users
        fullName TEXT,
        nickName TEXT,
        email TEXT,
        phone TEXT,
        age TEXT,
        height TEXT,
        weight TEXT,
        status TEXT,
        profilePicturePath TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 6. TABEL DAILY MISSIONS
    await db.execute('''
      CREATE TABLE daily_missions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mission_key TEXT NOT NULL,
        date TEXT NOT NULL,
        is_completed INTEGER NOT NULL,
        UNIQUE(mission_key, date)
      )
    ''');

    // --- DATA DEFAULT ---
    // Couple Profile tetap di-insert karena dianggap global
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

    // DATA DEFAULT UNTUK USER PROFILE DIHILANGKAN DARI SINI
    // User Profile akan dibuat saat register
  }

  // --- AUTH METHODS (DIPERBARUI) ---

  // 1. Register: Simpan ke Users dan BUAT Profil Baru
  Future<int> registerUser(String email, String password) async {
    final db = await instance.database;
    final userData = {'email': email, 'password': password};

    // Insert ke tabel Auth utama
    final userId = await db.insert('users', userData, conflictAlgorithm: ConflictAlgorithm.fail);

    // BUAT data profil baru menggunakan userId yang sama
    await db.insert('user_profile', {
      'user_id': userId,
      'fullName': '',
      'nickName': '',
      'email': email, // Gunakan email yang baru didaftarkan
      'phone': '',
      'age': '',
      'height': '',
      'weight': '',
      'status': 'Mahasiswa',
      'profilePicturePath': null
    });

    // Set ID pengguna aktif setelah register
    setActiveUserId(userId);

    return userId;
  }

  // 2. Login: Cek credentials, KEMBALIKAN data pengguna
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);

    if (maps.isNotEmpty) {
      final userId = maps.first['id'] as int;

      // Set ID pengguna aktif saat login berhasil
      setActiveUserId(userId);

      // Kembalikan data lengkap (termasuk ID)
      return maps.first;
    }
    return null;
  }

  // --- REMEMBER ME METHODS (DIPERBARUI) ---
  Future<void> saveSession(int userId, String email, String password) async {
    final db = await instance.database;
    await db.delete('saved_session');
    await db.insert('saved_session', {'user_id': userId, 'email': email, 'password': password});
    setActiveUserId(userId);
  }

  Future<void> clearSession() async {
    final db = await instance.database;
    await db.delete('saved_session');
    clearActiveUserId(); // Hapus ID aktif di memori
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

  // --- USER PROFILE METHODS (DIPERBARUI) ---

  // Mengambil data profil berdasarkan user_id aktif
  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = await getActiveUserId();
    if (userId == null) return null;

    final db = await instance.database;
    final result = await db.query(
        'user_profile',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // Mengubah data profil berdasarkan user_id aktif
  Future<int> updateUserProfile(Map<String, dynamic> row) async {
    final userId = await getActiveUserId();
    if (userId == null) return 0;

    final db = await instance.database;
    // Hapus user_id dari row karena tidak boleh diupdate
    row.remove('user_id');

    return await db.update(
        'user_profile',
        row,
        where: 'user_id = ?',
        whereArgs: [userId]
    );
  }

  // --- CHANGE PASSWORD (DIPERBARUI) ---
  Future<String> changePassword(String oldPassword, String newPassword) async {
    final db = await instance.database;
    final userId = await getActiveUserId();

    if (userId == null) return "User is not logged in!";

    try {
      // 1. Ambil Email Saat Ini dari Profil
      final profile = await getUserProfile();
      String currentEmail = profile?['email'] ?? '';

      // 2. Verifikasi Password menggunakan user_id dan password lama
      var checkUser = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [userId, oldPassword],
      );

      if (checkUser.isEmpty) {
        // Fallback dihapus. Jika user_id dan password tidak match, berarti password salah.
        return "Old password is incorrect!";
      }

      // 3. Update Password di tabel users
      await db.update(
        'users',
        {'password': newPassword},
        where: 'id = ?',
        whereArgs: [userId],
      );

      // 4. Update Session dengan password baru
      await saveSession(userId, currentEmail, newPassword);

      return "Success";
    } catch (e) {
      return "Error: $e";
    }
  }

  // --- CHANGE EMAIL (DIPERBARUI) ---
  Future<String> changeEmail(String password, String newEmail) async {
    final db = await instance.database;
    final userId = await getActiveUserId();

    if (userId == null) return "User is not logged in!";

    try {
      // 1. Ambil Email Saat Ini & Verifikasi Password
      final profile = await getUserProfile();
      String currentEmail = profile?['email'] ?? '';

      final checkUser = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [userId, password],
      );

      if (checkUser.isEmpty) {
        return "Incorrect password!";
      }

      // 2. Cek apakah email baru sudah terdaftar
      final checkUnique = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [newEmail],
      );

      if (checkUnique.isNotEmpty) {
        // Jika ada user lain yang menggunakan email ini, dan itu bukan diri sendiri
        if (checkUnique.first['id'] != userId) {
          return "Email is already registered by another user.";
        }
      }

      // 3. Update Email di tabel users
      await db.update(
        'users',
        {'email': newEmail},
        where: 'id = ?',
        whereArgs: [userId],
      );

      // 4. Update Email di tabel user_profile
      await db.update(
        'user_profile',
        {'email': newEmail},
        where: 'user_id = ?', // Perbaikan: menggunakan user_id
        whereArgs: [userId],
      );

      // 5. Update Session
      await saveSession(userId, newEmail, password);

      return "Success";
    } catch (e) {
      return "Error: $e";
    }
  }

  // --- DELETE ACCOUNT (DIPERBARUI) ---
  Future<String> deleteAccount(String password) async {
    final db = await instance.database;
    final userId = await getActiveUserId();

    if (userId == null) return "User is not logged in!";

    try {
      // 1. Verifikasi Password
      var checkUser = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [userId, password],
      );

      if (checkUser.isEmpty) {
        return "Incorrect password!";
      }

      // 2. Hapus Data
      // Karena user_profile memiliki FOREIGN KEY dengan ON DELETE CASCADE,
      // menghapus dari 'users' akan secara otomatis menghapus profil terkait.
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      // 3. Hapus Session
      await clearSession();

      return "Success";
    } catch (e) {
      return "Error: $e";
    }
  }

  // --- COUPLE PROFILE METHODS (TETAP GLOBAL) ---
  // Metode ini tetap tidak berubah karena Couple Profile diasumsikan global
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

  // --- KOSLIFE METHODS (DIASUMSIKAN GLOBAL/ TIDAK TERIKAT USER) ---
  // Metode ini tidak perlu diubah, diasumsikan KosLife bersifat global atau
  // akan dikaitkan dengan user_id di masa depan (KosLife_budgets.user_id)

  Future<int> createBudget(int total, int remaining, String smartTip) async {
    final db = await instance.database;
    final data = {
      'total_budget': total,
      'remaining_budget': remaining,
      'smart_tip': smartTip,
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

  Future<Map<String, dynamic>?> getBudgetById(int budgetId) async {
    final db = await instance.database;
    final result = await db.query(
      'koslife_budgets',
      where: 'id = ?',
      whereArgs: [budgetId],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getItemsByBudget(int budgetId) async {
    final db = await instance.database;
    return await db.query('koslife_items', where: 'budget_id = ?', whereArgs: [budgetId]);
  }

  // --- DAILY MISSION METHODS (DIPERLUKAN USER_ID DI MASA DEPAN) ---
  // Saat ini tidak diubah, namun di masa depan sebaiknya tambahkan user_id

  String getMissionKey(String categoryTitle, int index) {
    // ... (Logika tidak berubah)
    final category = categoryTitle.toLowerCase().replaceAll(' ', '');
    return '${category}_$index';
  }

  Future<void> updateMissionStatus(String missionKey, bool isCompleted) async {
    // Di masa depan: Gunakan user_id sebagai filter tambahan
    // Contoh: where: 'mission_key = ? AND date = ? AND user_id = ?'
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    // ... (Logika tidak berubah)

    final data = {
      'mission_key': missionKey,
      'date': today,
      'is_completed': isCompleted ? 1 : 0,
    };

    int count = await db.update(
      'daily_missions',
      data,
      where: 'mission_key = ? AND date = ?',
      whereArgs: [missionKey, today],
    );

    if (count == 0) {
      await db.insert(
        'daily_missions',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, bool>> getTodayMissionStatuses() async {
    // Di masa depan: Gunakan user_id sebagai filter tambahan
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.query(
      'daily_missions',
      where: 'date = ?',
      whereArgs: [today],
    );

    final Map<String, bool> statuses = {};
    for (var row in result) {
      final key = row['mission_key'] as String;
      final isCompleted = (row['is_completed'] as int) == 1;
      statuses[key] = isCompleted;
    }
    return statuses;
  }
}
