import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';

import '../rutracker/models/list.dart';



class ListRepository {
  final _database = DBHelper.instance;

  Future<ListObject?> addBookToList(ListObject listObject) => _database.createListObject(listObject);

  Future<BookList?> createList(BookList bookList) => _database.createList(bookList);

  Future<List<BookList>?> fetchLists() => _database.readLists();

  Future<BookList?> updateList(BookList bookList) => _database.updateList(bookList);

  Future<bool> deleteList(int listId) => _database.deleteList(listId);
}
