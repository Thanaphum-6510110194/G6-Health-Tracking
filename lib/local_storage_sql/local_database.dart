import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('localdatabase.db');
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
        id INTEGER PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE about_yourself (
        id INTEGER PRIMARY KEY,
        healthDescription TEXT,
        healthGoal TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE lifestyle (
        id INTEGER PRIMARY KEY,
        sleepDuration TEXT,
        stressLevel TEXT,
        waterIntake TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notification (
        id INTEGER PRIMARY KEY,
        exerciseRemindersEnabled BOOLEAN,
        mealLoggingEnabled BOOLEAN,
        sleepRemindersEnabled BOOLEAN,
        waterRemindersEnabled BOOLEAN,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE physical_info (
        id INTEGER PRIMARY KEY,
        activityLevel TEXT,
        height TEXT,
        weight TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY,
        fullName TEXT,
        gender TEXT,
        dateOfBirth TEXT,
        createdAt TEXT
      )
    ''');
  }

  // ------------------ Update Methods (Insert or Replace) ------------------

  Future<void> updateUser(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('users', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateAboutYourself(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('about_yourself', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateLifestyle(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('lifestyle', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNotification(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('notification', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePhysicalInfo(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('physical_info', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final db = await instance.database;
    data['id'] = 1;
    await db.insert('profile', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ------------------ Get Methods (Only 1 record) ------------------

  Future<Map<String, dynamic>?> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getAboutYourself() async {
    final db = await instance.database;
    final result = await db.query('about_yourself', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getLifestyle() async {
    final db = await instance.database;
    final result = await db.query('lifestyle', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getNotification() async {
    final db = await instance.database;
    final result = await db.query('notification', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getPhysicalInfo() async {
    final db = await instance.database;
    final result = await db.query('physical_info', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await instance.database;
    final result = await db.query('profile', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  // ------------------ Clear All (ล้างข้อมูล) ------------------

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('users');
    await db.delete('about_yourself');
    await db.delete('lifestyle');
    await db.delete('notification');
    await db.delete('physical_info');
    await db.delete('profile');
  }
}
