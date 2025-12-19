import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;
  
  static Future<Database> get _database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'app.db'),
      version: 1,
      onCreate: (db, version) {}, // Tabelas criadas sob demanda
    );
    return _db!;
  }

  // 🎯 CRIA TABELA SE NÃO EXISTIR
  static Future<void> _ensureTable(String table, Map<String, String> columns) async {
    final db = await _database;
    final columnsSQL = columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnsSQL,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  // 🎯 CRUD GENÉRICO COMPLETO
  static Future<int> inserir(String table, Map<String, String> columns, Map<String, dynamic> data) async {
    await _ensureTable(table, columns);
    final db = await _database;
    data['created_at'] = DateTime.now().toIso8601String();
    return await db.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final db = await _database;
      // Verifica se a tabela existe antes de fazer query
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [table]
      );
      
      if (result.isEmpty) {
        // Tabela não existe, retorna lista vazia
        return [];
      }
      
      return await db.query(table);
    } catch (e) {
      print('Erro em getAll: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await _database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // 🎯 UPDATE
  static Future<int> atualizar(String table, int id, Map<String, dynamic> data) async {
    final db = await _database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deletar(String table, int id) async {
    final db = await _database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}