class ListObject {
  int idList;
  int idBook;

  ListObject({
    required this.idList,
    required this.idBook,
  });

  Map<String, dynamic> toMap() {
    return {
      'idList': idList,
      'idBook': idBook,
    };
  }

  factory ListObject.fromMap(Map<String, dynamic> map) {
    return ListObject(
      idList: map['idList'],
      idBook: map['idBook'],
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
}
