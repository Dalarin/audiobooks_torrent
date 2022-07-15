import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/list.dart';

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

  static void addToList(
      int listId, int bookId, BookList bookList, String image) {
    var listObject = ListObject(idList: listId, idBook: bookId);
    bookList.cover = image;
    DBHelper.instance.createListObject(listObject);
    DBHelper.instance.updateList(bookList);
  }

  static void deleteFromList(int listId, int bookId) {
    DBHelper.instance.deleteBooksInsideLists(bookId, listId);
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

