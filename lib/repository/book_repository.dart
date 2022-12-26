import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_app/models/listening_info.dart';
import 'package:rutracker_app/providers/enums.dart';

import '../models/book.dart';
import '../providers/database.dart';

class BookRepository {
  final _database = DBHelper.instance;
  final RutrackerApi api;

  BookRepository({required this.api});

  Future<List<Book>?> fetchDownloadedBooks() => _database.readDownloadedBooks();

  Future<Book?> fetchBookFromSource(int bookId, String size) async {
    Book book = Book.fromMap(await api.getPage(link: bookId.toString()));
    return book.copyWith(
      size: size,
      id: bookId,
      listeningInfo: ListeningInfo(
        bookID: bookId,
        maxIndex: 0,
        index: 0,
        position: 0,
        speed: 1.0,
        isCompleted: false,
      ),
    );
  }

  Future<List<Book>?> fetchFavoritesBooks(Sort order) => _database.readFavoriteBooks(order);

  Future<Book?> fetchBook(int bookId) => _database.readBook(bookId);

  Future<Book?> updateBook(Book book) => _database.updateBook(book);

  Future<bool> deleteBook(int bookId) => _database.deleteBook(bookId);
}
