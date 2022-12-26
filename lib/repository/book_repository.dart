import 'package:rutracker_app/rutracker/providers/enums.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

import '../providers/database.dart';
import '../rutracker/models/book.dart';

class BookRepository {
  final _database = DBHelper.instance;
  final RutrackerApi api;

  BookRepository({required this.api});

  Future<List<Book>?> fetchDownloadedBooks() => _database.readDownloadedBooks();

  Future<Book?> fetchBookFromSource(int bookId) =>
      api.parseBook(bookId.toString());

  Future<List<Book>?> fetchFavoritesBooks(SORT order) => _database.readFavoriteBooks(order);

  Future<Book?> fetchBook(int bookId) => _database.readBook(bookId);

  Future<Book?> updateBook(Book book) => _database.updateBook(book);

  Future<bool> deleteBook(int bookId) => _database.deleteBook(bookId);
}
