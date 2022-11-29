import 'dart:developer';

import 'package:path/path.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:rutracker_app/rutracker/models/listeningInfo.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  final textType = 'TEXT NOT NULL';
  final integerType = 'INTEGER NOT NULL';

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("books.db");
    _database!.rawQuery('PRAGMA foreign_keys = ON;');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
    );
  }

  void _createListeningInfo(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS listening_info(
      bookID $integerType,
      maxIndex $integerType,
      'index' $integerType,
      speed REAL,
      position $integerType,
      isCompleted $integerType,
      FOREIGN KEY(bookID) REFERENCES Book(id) ON DELETE CASCADE)
      ''');
    } catch (_) {
      log('Cant create table listeningInfo');
    }
  }

  void _createListTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS list(
      id $integerType PRIMARY KEY AUTOINCREMENT,
      title $textType,
      cover $textType,
      description $textType
    )
    ''');
    } catch (_) {
      log("Cant create table List");
    }
  }

  void _createListObjectTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS list_object(
      id_book $integerType,
      id_list $integerType,
      FOREIGN KEY(id_book) REFERENCES Book(id) ON DELETE CASCADE,
      FOREIGN KEY(id_list) REFERENCES List(id) ON DELETE CASCADE
    )     
    ''');
    } catch (_) {
      log('Cant create table List_Object');
      throw Exception('Невозможно создать таблицу List_Object');
    }
  }

  void _createBookTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE book(
      id $integerType UNIQUE,
      title $textType,
      release_year $textType,
      author $textType,
      genre $textType,
      executor $textType,
      bitrate $textType,
      image $textType,
      time $textType,
      size $textType,
      series $textType,
      description $textType,
      book_number $textType,
      isFavorite $integerType,
      isDownloaded $integerType)
    ''');
    } catch (_) {
      log("Cant create table Book");
      throw Exception('Невозможно создать таблицу Book');
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      _createBookTable(db);
      _createListObjectTable(db);
      _createListTable(db);
      _createListeningInfo(db);
    } catch (E) {
      log("Database NOT created");
      throw Exception('Ошибка создания базы данных');
    } finally {
      log("Database created");
    }
  }

  Future<Book> createBook(Book book) async {
    final db = await instance.database;
    final bookId = await db.insert('book', book.toJson());
    await db.insert('listening_info', book.listeningInfo.toJson());
    return book.copyWith(
      id: bookId,
      listeningInfo: book.listeningInfo.copyWith(bookID: bookId),
    );
  }

  Future<bool> deleteBook(int bookId) async {
    final db = await instance.database;
    int count = await db.delete('book', where: 'id = ?', whereArgs: [bookId]);
    return count > 0;
  }

  Future<ListeningInfo> createListeningInfo(ListeningInfo listeningInfo) async {
    final db = await instance.database;
    final id = await db.insert('listening_info', listeningInfo.toJson());
    return listeningInfo.copyWith(bookID: id);
  }

  Future<ListObject> createListObject(ListObject listObject) async {
    final db = await instance.database;
    final id = await db.insert('list_object', listObject.toMap());
    return listObject.copyWith(idBook: id);
  }

  Future<BookList?> createList(BookList list) async {
    final db = await instance.database;
    final id = await db.insert('list', list.toJson());
    return list.copyWith(id: id);
  }

  Future<Book?> readBook(int bookId) async {
    final db = await instance.database;
    final result = await db.query('book', where: 'id = ?', whereArgs: [bookId]);
    return Book.fromJson(result.first);
  }

  Future<List<Book>?> readFavoriteBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM 'book' INNER JOIN 'listening_info' on bookID=id WHERE isFavorite = ?",
      [1],
    );
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<Book>?> readDownloadedBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM 'book' INNER JOIN 'listening_info' on bookID=id WHERE isDownloaded = ? and listening_info.maxIndex > 0 LIMIT 2",
      [1],
    );
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<List<BookList>?> readLists() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM 'list' INNER JOIN list_object on list_id=id",
    );
    return result.map((list) => BookList.fromJson(list)).toList();
  }

  Future<bool> deleteList(int listId) async {
    final db = await instance.database;
    return await db.delete('list', where: 'id = ?', whereArgs: [listId]) > 0;
  }

  Future<BookList?> updateList(BookList list) async {
    final db = await instance.database;
    int count = await db.update(
      'list',
      list.toJson(),
      where: "id = ?",
      whereArgs: [list.id],
    );
    return count > 0 ? list : null;
  }

  Future<ListeningInfo?> updateListeningInfo(
      ListeningInfo listeningInfo) async {
    final db = await instance.database;
    int count = await db.update(
      'listeningInfo',
      listeningInfo.toJson(),
      where: "bookID = ?",
      whereArgs: [listeningInfo.bookID],
    );
    return count > 0 ? listeningInfo : null;
  }

  Future<Book?> updateBook(Book book) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "INSERT OR REPLACE INTO 'book'(id, title, release_year, author, genre, executor,"
      "bitrate, image, size, series, description, book_number, isFavorite, isDownloaded) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        book.id,
        book.title,
        book.releaseYear,
        book.author,
        book.genre,
        book.executor,
        book.bitrate,
        book.image,
        book.size,
        book.series,
        book.description,
        book.bookNumber,
        book.isFavorite ? 1 : 0,
        book.isDownloaded ? 1 : 0,
      ],
    );
    return Book.fromJson(result.first);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
