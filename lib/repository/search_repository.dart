import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_app/models/query_response.dart';

class SearchRepository {
  RutrackerApi api;

  SearchRepository({required this.api});

  Future<List<QueryResponse>?> searchByText(String text) async {
    final response = await api.searchByQuery(query: text, categories: Categories.all);
    return response.map((response) {
      return QueryResponse.fromMap(response);
    }).toList();
  }

  Future<List<QueryResponse>?> searchByGenre(Categories categories) async {
    final response = await api.searchByQuery(query: '', categories: categories);
    return response.map((response) {
      return QueryResponse.fromMap(response);
    }).toList();
  }
}
