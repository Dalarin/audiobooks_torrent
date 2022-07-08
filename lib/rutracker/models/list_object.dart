
const String object_tablename = "insideLists";

class ListObjectFields {
  static const String idList = 'list_id';
  static const String idBook = 'book_id';
  static final List<String> values = [idList, idBook];
}

class ListObject {
  int idList;
  int idBook;
  ListObject({
    required this.idList,
    required this.idBook,
  });

  Map<String, dynamic> toMap() {
    return {
      'list_id': idList,
      'book_id': idBook,
    };
  }

  factory ListObject.fromMap(Map<String, dynamic> map) {
    return ListObject(
      idList: map['list_id']?.toInt() ?? 0,
      idBook: map['book_id']?.toInt() ?? 0,
    );
  }

  ListObject copyWith({
    int? idList,
    int? idBook,
  }) {
    return ListObject(
      idList: idList ?? this.idList,
      idBook: idBook ?? this.idBook,
    );
  }

  @override
  String toString() => 'ListObject(idList: $idList, idBook: $idBook)';
}
