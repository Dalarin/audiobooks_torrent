import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/list.dart';

class ListRepository {
  final _database = DBHelper.instance;

  Future<List<BookList>?> fetchLists() => _database.readLists();

  Future<BookList?> updateList(BookList bookList) =>
      _database.updateList(bookList);

  Future<bool> deleteList(int listId) => _database.deleteList(listId);
}
