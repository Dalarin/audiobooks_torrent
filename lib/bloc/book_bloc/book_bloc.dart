import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:rutracker_app/models/comment.dart';
import 'package:rutracker_app/models/query_response.dart';
import 'package:rutracker_app/providers/enums.dart';
import 'package:rutracker_app/repository/book_repository.dart';

part 'book_event.dart';

part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc({required this.repository}) : super(BookInitial()) {
    on<GetFavoritesBooks>((event, emit) => _getFavoritesBooks(event, emit));
    on<GetDownloadedBooks>((event, emit) => _getDownloadedBooks(event, emit));
    on<GetBook>((event, emit) => _getBook(event, emit));
    on<GetBookFromSource>((event, emit) => _getBookFromSource(event, emit));
    on<UpdateBook>((event, emit) => _updateBook(event, emit));
    on<DeleteBook>((event, emit) => _deleteBook(event, emit));
    on<GetComments>((event, emit) => _getComments(event, emit));
  }

  void _getComments(GetComments event, emit) async {
    try {
      emit(CommentsLoading());
      List<Comment>? comments = await repository.fetchComments(event.bookId, event.start);
      if (comments != null) {
        emit(BookCommentsLoaded(comments: comments));
      } else {
        emit(const CommentError(message: 'Ошибка загрузки комментариев'));
      }
    } on Exception {
      emit(const CommentError(message: 'Ошибка загрузки комментариев'));
    }
  }

  void _getBook(GetBook event, Emitter<BookState> emit) async {
    emit(BookLoading());
    Book? book = await repository.fetchBook(event.bookId);
    if (book != null) {
      emit(BookLoaded(books: [book]));
    } else {
      emit(const BookError(message: 'Книга не найдена в избранном'));
    }
  }

  void _getBookFromSource(
    GetBookFromSource event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BookLoading());
      Book? book = await repository.fetchBook(int.parse(event.bookId.link));
      if (book == null) {
        book ??= await repository.fetchBookFromSource(int.parse(event.bookId.link), event.bookId.size);
        if (book == null) {
          emit(const BookError(message: 'Ошибка загрузки книги'));
        } else {
          emit(BookLoaded(books: [book]));
        }
      } else {
        emit(BookLoaded(books: [book]));
      }
    } on Exception {
      emit(const BookError(message: 'Ошибка загрузки книги'));
    }
  }

  void _getFavoritesBooks(
    GetFavoritesBooks event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BookLoading());
      List<Book>? favoritesBooks = await repository.fetchFavoritesBooks(
        event.sortOrder,
        event.limit,
      );
      if (favoritesBooks != null) {
        emit(BookLoaded(books: Book.filter(event.filter, favoritesBooks)));
      } else {
        emit(const BookError(message: 'Ошибка загрузки избранных книг'));
      }
    } on Exception {
      emit(const BookError(message: 'Ошибка загрузки избранных книг'));
    }
  }

  void _getDownloadedBooks(
    GetDownloadedBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    List<Book>? favoritesBooks = await repository.fetchDownloadedBooks();
    if (favoritesBooks != null) {
      emit(BookLoaded(books: favoritesBooks));
    } else {
      emit(const BookError(message: 'Ошибка загрузки загруженных книг'));
    }
  }

  void _updateBook(
    UpdateBook event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    if (!event.book.isFavorite && !event.book.isDownloaded) {
      await repository.deleteBook(event.book.id);
      event.books.remove(event.book);
      emit(BookLoaded(books: event.books));
    } else if (event.book.isFavorite || event.book.isDownloaded) {
      if (event.book.image.isNotEmpty && event.book.title.isNotEmpty) {
        Book? book = await repository.updateBook(event.book);
        if (book != null) {
          int index = event.books.indexOf(event.book);
          event.books.replaceRange(index, index + 1, [book]);
          emit(BookLoaded(books: event.books));
        } else {
          emit(const BookError(message: 'Ошибка обновления информации'));
        }
      } else {
        emit(const BookError(message: 'Заполните все поля и попробуйте снова'));
      }
    }
  }

  Future<bool> _deleteDirectory(Directory path, int subPath) async {
    var directory = Directory('${path.path}/books/$subPath/');
    if (await directory.exists()) {
      directory.delete(recursive: true);
      return true;
    } else {
      return false;
    }
  }

  void _deleteBook(
    DeleteBook event,
    Emitter<BookState> emit,
  ) async {
    try {
      var directory = await getApplicationDocumentsDirectory();
      bool directoryDeleted = await _deleteDirectory(directory, event.book.id);
      if (!directoryDeleted) {
        emit(const BookError(message: 'Ошибка удаления скачанных данных'));
      } else {
        event.book.isDownloaded = false;
        Book? bookUpdated = await repository.updateBook(event.book);
        if (bookUpdated != null) {
          int index = event.books.indexOf(event.book);
          event.books.replaceRange(index, index + 1, [bookUpdated]);
          emit(BookLoaded(books: event.books));
        } else {
          emit(const BookError(message: 'Ошибка удаления скачанных данных'));
        }
      }
    } on Exception {
      emit(const BookError(message: 'Ошибка удаления скачанных данных'));
    }
  }
}
