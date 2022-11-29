part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class GetFavoritesBooks extends BookEvent {}

class GetDownloadedBooks extends BookEvent {}

class GetBook extends BookEvent {
  final int bookId;

  const GetBook({required this.bookId});
}

class UpdateBook extends BookEvent {
  final Book book;
  final List<Book> books;

  const UpdateBook({required this.book, required this.books});
}

class DeleteBook extends BookEvent {
  final Book book;

  const DeleteBook({required this.book});
}
