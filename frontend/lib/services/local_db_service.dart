import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  factory LocalDbService() => _instance;
  LocalDbService._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'verdex.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE plants (
            id INTEGER PRIMARY KEY,
            scientific_name TEXT,
            name TEXT,
            description TEXT,
            family TEXT,
            category TEXT,
            genus TEXT,
            species TEXT,
            toxicity_level TEXT,
            uses TEXT,
            tags TEXT,
            image_url TEXT,
            created_at TEXT,
            updated_at TEXT,
            needs_sync INTEGER DEFAULT 0
          )
        ''');
        await createUserTable(db);
        await createPostTable(db);
        await createCategoryTable(db);
        await createRoleTable(db);
        await createPermissionTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE plants ADD COLUMN scientific_name TEXT',
          );
          await db.execute('ALTER TABLE plants ADD COLUMN genus TEXT');
          await db.execute('ALTER TABLE plants ADD COLUMN species TEXT');
          await db.execute('ALTER TABLE plants ADD COLUMN toxicity_level TEXT');
          await db.execute('ALTER TABLE plants ADD COLUMN updated_at TEXT');
        }
      },
    );
  }

  Future<int> insertPlant(
    Map<String, dynamic> plant, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final plantToInsert = Map<String, dynamic>.from(plant);
    plantToInsert['tags'] = jsonEncode(plant['tags'] ?? []);
    plantToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'plants',
      plantToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePlant(
    Map<String, dynamic> plant, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final plantToUpdate = Map<String, dynamic>.from(plant);
    plantToUpdate['tags'] = jsonEncode(plant['tags'] ?? []);
    plantToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'plants',
      plantToUpdate,
      where: 'id = ?',
      whereArgs: [plant['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPlants() async {
    final dbClient = await db;
    final result = await dbClient.query('plants');
    return result.map((plant) {
      final tags =
          plant['tags'] != null ? jsonDecode(plant['tags'] as String) : [];
      return {...plant, 'tags': tags};
    }).toList();
  }

  Future<Map<String, dynamic>?> getPlantById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      final plant = result.first;
      final tags =
          plant['tags'] != null ? jsonDecode(plant['tags'] as String) : [];
      return {...plant, 'tags': tags};
    }
    return null;
  }

  Future<int> deletePlant(int id) async {
    final dbClient = await db;
    return await dbClient.delete('plants', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPlantsNeedingSync() async {
    final dbClient = await db;
    final result = await dbClient.query('plants', where: 'needs_sync = 1');
    return result.map((plant) {
      final tags =
          plant['tags'] != null ? jsonDecode(plant['tags'] as String) : [];
      return {...plant, 'tags': tags};
    }).toList();
  }

  Future<int> markPlantSynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'plants',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // USERS
  Future<void> createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        language_preference TEXT,
        avatar TEXT,
        needs_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertUser(
    Map<String, dynamic> user, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final userToInsert = Map<String, dynamic>.from(user);
    userToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'users',
      userToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateUser(
    Map<String, dynamic> user, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final userToUpdate = Map<String, dynamic>.from(user);
    userToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'users',
      userToUpdate,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final dbClient = await db;
    return await dbClient.query('users');
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteUser(int id) async {
    final dbClient = await db;
    return await dbClient.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUsersNeedingSync() async {
    final dbClient = await db;
    return await dbClient.query('users', where: 'needs_sync = 1');
  }

  Future<int> markUserSynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'users',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // POSTS
  Future<void> createPostTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS posts (
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        user_id INTEGER,
        category_id INTEGER,
        created_at TEXT,
        needs_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertPost(
    Map<String, dynamic> post, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final postToInsert = Map<String, dynamic>.from(post);
    postToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'posts',
      postToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePost(
    Map<String, dynamic> post, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final postToUpdate = Map<String, dynamic>.from(post);
    postToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'posts',
      postToUpdate,
      where: 'id = ?',
      whereArgs: [post['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    final dbClient = await db;
    return await dbClient.query('posts');
  }

  Future<Map<String, dynamic>?> getPostById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deletePost(int id) async {
    final dbClient = await db;
    return await dbClient.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPostsNeedingSync() async {
    final dbClient = await db;
    return await dbClient.query('posts', where: 'needs_sync = 1');
  }

  Future<int> markPostSynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'posts',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CATEGORIES
  Future<void> createCategoryTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        needs_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertCategory(
    Map<String, dynamic> category, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final categoryToInsert = Map<String, dynamic>.from(category);
    categoryToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'categories',
      categoryToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCategory(
    Map<String, dynamic> category, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final categoryToUpdate = Map<String, dynamic>.from(category);
    categoryToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'categories',
      categoryToUpdate,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final dbClient = await db;
    return await dbClient.query('categories');
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteCategory(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getCategoriesNeedingSync() async {
    final dbClient = await db;
    return await dbClient.query('categories', where: 'needs_sync = 1');
  }

  Future<int> markCategorySynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'categories',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ROLES
  Future<void> createRoleTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        id INTEGER PRIMARY KEY,
        name TEXT,
        guard_name TEXT,
        needs_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertRole(
    Map<String, dynamic> role, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final roleToInsert = Map<String, dynamic>.from(role);
    roleToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'roles',
      roleToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateRole(
    Map<String, dynamic> role, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final roleToUpdate = Map<String, dynamic>.from(role);
    roleToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'roles',
      roleToUpdate,
      where: 'id = ?',
      whereArgs: [role['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllRoles() async {
    final dbClient = await db;
    return await dbClient.query('roles');
  }

  Future<Map<String, dynamic>?> getRoleById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'roles',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteRole(int id) async {
    final dbClient = await db;
    return await dbClient.delete('roles', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getRolesNeedingSync() async {
    final dbClient = await db;
    return await dbClient.query('roles', where: 'needs_sync = 1');
  }

  Future<int> markRoleSynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'roles',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PERMISSIONS
  Future<void> createPermissionTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS permissions (
        id INTEGER PRIMARY KEY,
        name TEXT,
        guard_name TEXT,
        needs_sync INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertPermission(
    Map<String, dynamic> permission, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final permissionToInsert = Map<String, dynamic>.from(permission);
    permissionToInsert['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.insert(
      'permissions',
      permissionToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePermission(
    Map<String, dynamic> permission, {
    bool needsSync = false,
  }) async {
    final dbClient = await db;
    final permissionToUpdate = Map<String, dynamic>.from(permission);
    permissionToUpdate['needs_sync'] = needsSync ? 1 : 0;
    return await dbClient.update(
      'permissions',
      permissionToUpdate,
      where: 'id = ?',
      whereArgs: [permission['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPermissions() async {
    final dbClient = await db;
    return await dbClient.query('permissions');
  }

  Future<Map<String, dynamic>?> getPermissionById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'permissions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deletePermission(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'permissions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getPermissionsNeedingSync() async {
    final dbClient = await db;
    return await dbClient.query('permissions', where: 'needs_sync = 1');
  }

  Future<int> markPermissionSynced(int id) async {
    final dbClient = await db;
    return await dbClient.update(
      'permissions',
      {'needs_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
