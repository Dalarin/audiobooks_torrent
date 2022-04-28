import 'dart:developer';

import 'package:path/path.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';
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
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    switch (newVersion) {
      case 2:
        _createListObjectTable(db);
        _createListTable(db);
        break;
    }
  }

  void _createListTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS $list_tablename(
      ${ListFields.id} $integerType PRIMARY KEY AUTOINCREMENT,
      ${ListFields.name} $textType,
      ${ListFields.cover} $textType,
      ${ListFields.description} $textType
    )
    ''');
    } catch (_) {
      log("Cant create table $list_tablename");
    }
  }

  void _createListObjectTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS $object_tablename(
      ${ListObjectFields.idBook} $integerType,
      ${ListObjectFields.idList} $integerType,
      FOREIGN KEY(${ListObjectFields.idBook}) REFERENCES $book_tableName(${BookFields.id}),
      FOREIGN KEY(${ListObjectFields.idList}) REFERENCES $list_tablename(${ListFields.id})
    )     
    ''');
    } catch (_) {
      log('Cant create table $object_tablename');
    }
  }

  void _createBookTable(Database db) async {
    try {
      await db.execute('''
    CREATE TABLE $book_tableName(
      ${BookFields.id} $integerType UNIQUE,
      ${BookFields.title} $textType,
      ${BookFields.releaseYear} $textType,
      ${BookFields.author} $textType,
      ${BookFields.genre} $textType,
      ${BookFields.executor} $textType,
      ${BookFields.bitrate} $textType,
      ${BookFields.image} $textType,
      ${BookFields.time} $textType,
      ${BookFields.size} $textType,
      ${BookFields.series} $textType,
      ${BookFields.description} $textType,
      ${BookFields.bookNumber} $textType,
      ${BookFields.isFavorited} $integerType,
      ${BookFields.isDownloaded} $integerType,
      ${BookFields.listeningInfo} $textType
    )
    ''');
    } catch (_) {
      log("Cant create table $book_tableName");
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      _createBookTable(db);
      _createListObjectTable(db);
      _createListObjectTable(db);
      log("Database created");
    } catch (E) {
      log("Database NOT created");
    }
  }

  Future<Book> createBook(Book book) async {
    final db = await instance.database;
    book.listeningInfo = {
      "index": "0",
      "position": "0",
      "maxIndex": "0",
      "speed": "1",
      "isCompleted": "0"
    };
    final id = await db.insert(book_tableName, book.toMap());
    return book.copyWith(id: id);
  }

  Future<ListObject> createListObject(ListObject listObject) async {
    final db = await instance.database;
    final id = await db.insert(object_tablename, listObject.toMap());
    return listObject.copyWith(idBook: id);
  }

  Future<void> createList(BookList list) async {
    final db = await instance.database;
    db.insert(list_tablename, list.toMap());
  }

  Future<List<Book>> readFavoritedBooks(
      {required String orderBy,
      required String orderDirection,
      required int limit}) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT * FROM $book_tableName WHERE ${BookFields.isFavorited} = 1 ORDER BY $orderBy $orderDirection LIMIT $limit");
    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<List<Book>> readDownloadedBooks() async {
    final db = await instance.database;
    final result = await db.query(book_tableName,
        where: '${BookFields.isDownloaded} = ?', whereArgs: [1]);
    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<bool> isExist(int id) async {
    final db = await instance.database;
    final result = await db.query(book_tableName,
        columns: [BookFields.id],
        where: '${BookFields.id} = ?',
        whereArgs: [id]);
    return result.isNotEmpty ? true : false;
  }

  Future<List<BookList>> readLists() async {
    final db = await instance.database;
    final result = await db.query(list_tablename);
    return result.map((e) => BookList.fromMap(e)).toList();
  }

  Future<List<Book>> readBook(int id) async {
    final db = await instance.database;
    final result = await db
        .query(book_tableName, where: '${BookFields.id} = ?', whereArgs: [id]);
    return result.map((e) => Book.fromMap(e)).toList();
  }

  Future<int> deleteBooksInsideLists(int id, int idList) async {
    final db = await instance.database;
    return db.delete(object_tablename,
        where:
            "${ListObjectFields.idBook} = ? and ${ListObjectFields.idList} = ?",
        whereArgs: [id, idList]);
  }

  Future<int> deleteList(int id) async {
    final db = await instance.database;
    db.delete(object_tablename,
        where: "${ListObjectFields.idList} = ?", whereArgs: [id]);
    return db
        .delete(list_tablename, where: "${ListFields.id} = ?", whereArgs: [id]);
  }

  Future<int> updateList(BookList list) async {
    final db = await instance.database;
    int count = await db.update(list_tablename, list.toMap(),
        where: "${ListFields.id} = ?", whereArgs: [list.id]);
    return count;
  }

  Future<int> updateBook(Book book) async {
    bool isExist = await DBHelper.instance.isExist(book.id);
    if (!isExist) createBook(book);
    final db = await instance.database;
    int count = await db.update(book_tableName, book.toMap(),
        where: "${BookFields.id} = ?", whereArgs: [book.id]);
    if (!book.isDownloaded && !book.isFavorited) {
      int count = await db.delete(object_tablename,
          where: "${ListObjectFields.idBook} = ?", whereArgs: [book.id]);
      log('Deleted objects: $count');
    }
    return count;
  }

  Future<List<ListObject>> getBookInList(int idList) async {
    final db = await instance.database;
    final result = await db.query(object_tablename,
        where: '${ListObjectFields.idList} = ?', whereArgs: [idList]);
    return result.map((e) => ListObject.fromMap(e)).toList();
  }

  Future<List<ListObject>> getBooksInList(int idBook) async {
    final db = await instance.database;
    final result = await db.query(object_tablename,
        where: '${ListObjectFields.idBook} = ?', whereArgs: [idBook]);
    return result.map((e) => ListObject.fromMap(e)).toList();
  }

  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    return await db
        .delete(book_tableName, where: '${BookFields.id} = ?', whereArgs: [id]);
  }

  Future clearTable() async {
    final db = await instance.database;
    int count = await db.delete(book_tableName,
        where:
            '${BookFields.isFavorited} = ? and ${BookFields.isDownloaded} = ?',
        whereArgs: [0, 0]);
    log('Deleted entries: $count');
  }

  Future close() async {
    final db = await instance.database;
    clearTable();
    db.close();
  }
}
