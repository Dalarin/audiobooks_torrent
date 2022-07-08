import 'dart:developer';

import 'package:path/path.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:rutracker_app/rutracker/models/listeningInfo.dart' as listen;
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
    return await openDatabase(path,
        version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    switch (newVersion) {
      case 2:
        _createListObjectTable(db);
        _createListTable(db);
        break;
      case 3:
        _createListeningInfo(db);
    }
  }

  void _createListeningInfo(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS listeningInfo(
      bookID $integerType,
      maxIndex $integerType,
      'index' $integerType,
      speed REAL,
      position $integerType,
      isCompleted $integerType,
      FOREIGN KEY(bookID) REFERENCES $book_tableName(${BookFields.id}) ON DELETE CASCADE)
      ''');
    } catch (_) {
      log('Cant create table listeningInfo');
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
      FOREIGN KEY(${ListObjectFields.idBook}) REFERENCES $book_tableName(${BookFields.id}) ON DELETE CASCADE,
      FOREIGN KEY(${ListObjectFields.idList}) REFERENCES $list_tablename(${ListFields.id}) ON DELETE CASCADE
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
      ${BookFields.isDownloaded} $integerType)
    ''');
    } catch (_) {
      log("Cant create table $book_tableName");
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      _createBookTable(db);
      _createListObjectTable(db);
      _createListTable(db);
      _createListeningInfo(db);
      log("Database created");
    } catch (E) {
      log("Database NOT created");
    }
  }

  Future<Book> createBook(Book book) async {
    final db = await instance.database;
    final id = await db.insert(book_tableName, book.toMap());
    createListeningInfo(book.listeningInfo);
    return book.copyWith(id: id);
  }

  Future<listen.listeningInfo> createListeningInfo(
      listen.listeningInfo listeningInfo) async {
    final db = await instance.database;
    final id = await db.insert('listeningInfo', listeningInfo.toMap());
    return listeningInfo.copyWith(bookID: id);
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
        "SELECT * FROM $book_tableName INNER JOIN listeningInfo on listeningInfo.bookID=$book_tableName.id WHERE ${BookFields.isFavorited} = ? ORDER BY $orderBy $orderDirection LIMIT $limit",
        [1]);
    return result.map((json) => Book.fromMaps(json)).toList();
  }

  Future<List<Book>> readDownloadedBooks() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM $book_tableName INNER JOIN listeningInfo on listeningInfo.bookID=$book_tableName.id WHERE ${BookFields.isDownloaded} = 1');
    return result.map((json) => Book.fromMaps(json)).toList();
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

  Future<listen.listeningInfo?> readListeningInfo(int bookID) async {
    final db = await instance.database;
    final result = await db
        .query('listeningInfo', where: 'bookID = ?', whereArgs: [bookID]);
    List<listen.listeningInfo> listeningInfo =
        result.map((map) => listen.listeningInfo.fromMap(map)).toList();
    return listeningInfo.isEmpty ? null : listeningInfo.first;
  }

  Future<List<Book>> readBook(int id) async {
    final db = await instance.database;
    listen.listeningInfo listeningInfo =
        (await readListeningInfo(id)) ?? listen.listeningInfo.generateNew(id);
    final result = await db
        .query(book_tableName, where: '${BookFields.id} = ?', whereArgs: [id]);
    return result.map((e) => Book.fromMap(e, listeningInfo)).toList();
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

  Future<int> updateListeningInfo(listen.listeningInfo list) async {
    final db = await instance.database;
    int count = await db.update('listeningInfo', list.toMap(),
        where: "bookID = ?", whereArgs: [list.bookID]);
    return count;
  }

  Future<int> updateBook(Book book) async {
    bool isExist = await DBHelper.instance.isExist(book.id);
    if (!isExist) createBook(book);
    final db = await instance.database;
    int count = await db.update(book_tableName, book.toMap(),
        where: "${BookFields.id} = ?", whereArgs: [book.id]);
    updateListeningInfo(book.listeningInfo);
    if (!book.isDownloaded && !book.isFavorited) {
      deleteBook(book.id);
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

  Future<int> deleteListeningInfo(int idBook) async {
    final db = await instance.database;
    return await db
        .delete('listeningInfo', where: 'bookID = ?', whereArgs: [idBook]);
  }

  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    deleteListeningInfo(id);
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
