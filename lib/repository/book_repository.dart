import '../providers/database.dart';
import '../rutracker/models/book.dart';

class BookRepository {
  final _database = DBHelper.instance;

  Future<List<Book>?> fetchDownloadedBooks() => _database.readDownloadedBooks();

  Future<List<Book>?> fetchFavoritesBooks() => _database.readFavoriteBooks();

  Future<Book?> fetchBook(int bookId) => _database.readBook(bookId);

  Future<Book?> updateBook(Book book) => _database.updateBook(book);

  Future<bool> deleteBook(int bookId) => _database.deleteBook(bookId);
}
