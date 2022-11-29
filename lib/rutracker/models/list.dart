import 'book.dart';

class BookList {
  int? id;
  String name;
  String cover;
  String description;
  List<Book> books = [];

  BookList({
    this.id,
    required this.name,
    required this.cover,
    required this.description,
    required this.books,
  });

  factory BookList.fromJson(Map<String, dynamic> json) {
    return BookList(
      id: int.parse(json["id"]),
      name: json["name"],
      cover: json["cover"],
      description: json["description"],
      books: List.of(json["books"]).map((i) => Book.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "cover": cover,
      "description": description,
      "books": books.map((e) => e.toJson()).toList(),
    };
  }

  BookList copyWith({
    int? id,
    String? name,
    String? cover,
    String? description,
    List<Book>? books,
  }) {
    return BookList(
      name: name ?? this.name,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      books: books ?? this.books,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookList && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
