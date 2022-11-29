import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/book_repository.dart';
import '../../rutracker/models/book.dart';
import '../authentication_bloc/authentication_bloc.dart';

part 'book_event.dart';

part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc({required this.repository}) : super(BookInitial()) {
    on<GetFavoritesBooks>((event, emit) => _getFavoritesBooks(event, emit));
    on<GetDownloadedBooks>((event, emit) => _getDownloadedBooks(event, emit));
    on<GetBook>((event, emit) => _getBook(event, emit));
    on<UpdateBook>((event, emit) => _updateBook(event, emit));
    on<DeleteBook>((event, emit) => _deleteBook(event, emit));
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

  void _getFavoritesBooks(
    GetFavoritesBooks event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    List<Book>? favoritesBooks = await repository.fetchFavoritesBooks();
    if (favoritesBooks != null) {
      emit(BookLoaded(books: favoritesBooks));
    } else {
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
    Book? book = await repository.updateBook(event.book);
    if (book != null) {
      event.books.remove(event.book);
      event.books.add(book);
      emit(BookLoaded(books: event.books));
    } else {
      emit(const BookError(message: 'Ошибка обновления информации'));
    }
  }

  void _deleteBook(
    DeleteBook event,
    Emitter<BookState> emit,
  ) async {}
}
