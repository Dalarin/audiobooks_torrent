part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class GetFavoritesBooks extends BookEvent {
  final List<Filter> filter;
  final Sort sortOrder;
  final int limit;

  const GetFavoritesBooks({
    required this.sortOrder,
    required this.limit,
    required this.filter,
  });
}

class GetDownloadedBooks extends BookEvent {}

class GetBook extends BookEvent {
  final int bookId;

  const GetBook({required this.bookId});
}

class GetBookFromSource extends BookEvent {
  final QueryResponse bookId;

  const GetBookFromSource({required this.bookId});
}

class UpdateBook extends BookEvent {
  final Book book;
  final List<Book> books;

  const UpdateBook({required this.book, required this.books});
}

class GetComments extends BookEvent {
  final int bookId;
  final int start;
  final List<Comment> comments;

  const GetComments({
    required this.bookId,
    required this.start,
    required this.comments,
  });
}

class DeleteBook extends BookEvent {
  final Book book;
  final List<Book> books;

  const DeleteBook({required this.book, required this.books});
}
