import 'dart:developer';

import 'package:path/path.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:rutracker_app/models/book_list.dart';
import 'package:rutracker_app/models/list_object.dart';
import 'package:rutracker_app/models/listening_info.dart';
import 'package:rutracker_app/providers/enums.dart';
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
      id_list $integerType)     
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
    final bookId = (await updateBook(book))!.id;
    await db.insert('listening_info', book.listeningInfo.toJson());
    return book.copyWith(
      id: bookId,
      listeningInfo: book.listeningInfo.copyWith(bookID: bookId),
    );
  }

  Future<bool> deleteBook(int bookId) async {
    final db = await instance.database;
    await db.delete('list_object', where: 'id_book = ?', whereArgs: [bookId]);
    int count = await db.delete('book', where: 'id = ?', whereArgs: [bookId]);
    return count > 0;
  }

  Future<ListeningInfo> createListeningInfo(ListeningInfo listeningInfo) async {
    final db = await instance.database;
    await db.insert('listening_info', listeningInfo.toJson());
    return listeningInfo.copyWith(bookID: listeningInfo.bookID);
  }

  Future<ListObject> createListObject(ListObject listObject) async {
    final db = await instance.database;
    await db.rawQuery(
      'INSERT OR REPLACE INTO list_object(id_book, id_list) VALUES(?, ?)',
      [listObject.idBook, listObject.idList],
    );
    return listObject.copyWith(idBook: listObject.idBook);
  }

  Future<bool> deleteListObject(ListObject listObject) async {
    final db = await instance.database;
    final id = await db.delete(
      'list_object',
      where: 'id_book = ? AND id_list = ?',
      whereArgs: [listObject.idBook, listObject.idList],
    );
    return id > 0;
  }

  Future<BookList?> createList(BookList list) async {
    final db = await instance.database;
    final id = await db.insert('list', list.toMap());
    for (var element in list.books) {
      createListObject(ListObject(idList: list.id, idBook: element.id));
    }
    return list.copyWith(id: id);
  }

  Future<Book?> readBook(int bookId) async {
    final db = await instance.database;
    final result = await db.query('book', where: 'id = ?', whereArgs: [bookId]);
    return result.isNotEmpty ? Book.fromMapDb(result.first) : null;
  }

  Future<List<Book>?> readFavoriteBooks(Sort order, int limit) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM 'book' INNER JOIN 'listening_info' on bookID=id WHERE isFavorite = ? ${order.query} LIMIT $limit",
      [1],
    );
    return result.map((json) => Book.fromMapDb(json)).toList();
  }

  Future<List<Book>?> readDownloadedBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      "SELECT * FROM 'book' INNER JOIN 'listening_info' on bookID=id WHERE isDownloaded = ? and listening_info.maxIndex > 0 LIMIT 2",
      [1],
    );
    return result.map((json) => Book.fromMapDb(json)).toList();
  }

  Future<List<BookList>?> readLists() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM list');
    List<Map<String, dynamic>> res = List.from(result);
    res = await Future.wait(res.map((element) async {
      Map<String, dynamic> booksMap = Map.from(element);
      booksMap['books'] = await (db.rawQuery(
          "SELECT * FROM book INNER JOIN list_object on book.id=list_object.id_book INNER JOIN 'listening_info' on bookID=id WHERE list_object.id_list=${booksMap['id']}"));
      return booksMap;
    }).toList());
    return res.map((element) => BookList.fromMap(element)).toList();
  }

  Future<bool> deleteList(int listId) async {
    final db = await instance.database;
    await db.delete('list_object', where: 'id_list = ?', whereArgs: [listId]);
    return await db.delete('list', where: 'id = ?', whereArgs: [listId]) > 0;
  }

  Future<BookList?> updateList(BookList list) async {
    final db = await instance.database;
    int count = await db.update(
      'list',
      list.toMap(),
      where: "id = ?",
      whereArgs: [list.id],
    );
    return count > 0 ? list : null;
  }

  Future<ListeningInfo?> updateListeningInfo(ListeningInfo listeningInfo) async {
    final db = await instance.database;
    int count = await db.update(
      'listening_info',
      listeningInfo.toJson(),
      where: 'bookID = ?',
      whereArgs: [listeningInfo.bookID],
    );
    return count > 0 ? listeningInfo : null;
  }

  Future<Book?> updateBook(Book book) async {
    final db = await instance.database;
    if ((await db.query('book', where: 'id = ?', whereArgs: [book.id])).isNotEmpty) {
      await db.update('book', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
      await updateListeningInfo(book.listeningInfo);
    } else {
      await db.insert('book', book.toMap());
      await createListeningInfo(book.listeningInfo);
    }
    return book;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
