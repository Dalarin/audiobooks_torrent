import 'book.dart';

class BookList {
  int id;
  String title;
  String description;
  List<Book> books;

  BookList({
    required this.id,
    required this.title,
    required this.description,
    required this.books,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description
    };
  }

  factory BookList.fromMap(Map<String, dynamic> map) {
    return BookList(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      books: List.of(map['books']).map((e) => Book.fromMapDb(e)).toList(),
    );
  }

  BookList copyWith({
    int? id,
    String? title,
    String? description,
    List<Book>? books,
  }) {
    return BookList(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      books: books ?? this.books,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookList && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
