import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/document_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'doctools.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE documents(
            id TEXT PRIMARY KEY,
            path TEXT NOT NULL,
            name TEXT NOT NULL,
            type_index INTEGER NOT NULL,
            size_bytes INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            modified_at INTEGER NOT NULL,
            page_count INTEGER,
            checksum TEXT,
            thumbnail_path TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertDocument(DocumentModel doc) async {
    final db = await database;
    return await db.insert(
      'documents',
      doc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('documents', orderBy: 'modified_at DESC');
    return List.generate(maps.length, (i) => DocumentModel.fromMap(maps[i]));
  }

  Future<List<DocumentModel>> getRecentDocuments(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('documents', orderBy: 'modified_at DESC', limit: limit);
    return List.generate(maps.length, (i) => DocumentModel.fromMap(maps[i]));
  }

  Future<int> deleteDocument(String id) async {
    final db = await database;
    return await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateDocument(DocumentModel doc) async {
    final db = await database;
    return await db.update(
      'documents',
      doc.toMap(),
      where: 'id = ?',
      whereArgs: [doc.id],
    );
  }
}
