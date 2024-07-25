import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:library_app/book.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, description TEXT, rating REAL, isRead INTEGER, price REAL, filePath TEXT, imageUrl TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<Book>> books() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        description: maps[i]['description'],
        rating: maps[i]['rating'],
        isRead: maps[i]['isRead'] == 1,
        price: maps[i]['price'],
        filePath: maps[i]['filePath'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(
      'books',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
