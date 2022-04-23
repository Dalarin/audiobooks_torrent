const String list_tablename = "Lists";

class ListFields {
  static final List<String> values = [id, name, description];
  static const String id = 'id';
  static const String name = 'name';
  static const String cover = 'cover';
  static const String description = 'description';
}

class BookList {
  int? id;
  String name;
  String? cover;
  String description;
  BookList({
    required this.name,
    required this.description,
    this.cover,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover ?? "https://img-gorod.ru/21/111/2111187_detail.jpg",
      'description': description,
    };
  }

  factory BookList.fromMap(Map<String, dynamic> map) {
    return BookList(
      id: map['id'] ?? 0,
      cover: map['cover'] ?? "https://img-gorod.ru/21/111/2111187_detail.jpg",
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  BookList copyWith({
    int? id,
    String? cover,
    String? name,
    String? description,
  }) {
    return BookList(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'BookList(id: $id, cover: $cover, name: $name, description: $description)';
  }
}
