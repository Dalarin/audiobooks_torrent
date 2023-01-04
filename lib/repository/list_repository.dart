import 'package:rutracker_app/models/book_list.dart';
import 'package:rutracker_app/models/list_object.dart';
import 'package:rutracker_app/providers/database.dart';

class ListRepository {
  final _database = DBHelper.instance;

  Future<ListObject?> addBookToList(ListObject listObject) => _database.createListObject(listObject);

  Future<BookList?> createList(BookList bookList) => _database.createList(bookList);

  Future<List<BookList>?> fetchLists() => _database.readLists();

  Future<BookList?> updateList(BookList bookList) => _database.updateList(bookList);

  Future<bool> deleteList(int listId) => _database.deleteList(listId);

  Future<bool> removeBookFromList(ListObject listObject) => _database.deleteListObject(listObject);
}
