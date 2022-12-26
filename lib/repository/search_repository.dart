import 'package:rutracker_api/rutracker_api.dart';

import '../models/query_response.dart';

class SearchRepository {
  RutrackerApi api;

  SearchRepository({required this.api});

  Future<List<QueryResponse>?> searchByText(String text) async {
    final response = await api.searchByQuery(query: text, categories: Categories.all);
    List<QueryResponse> responses = response.map((response) {
      return QueryResponse.fromMap(response);
    }).toList();
    return responses;
  }

  Future<List<QueryResponse>?> searchByGenre(Categories categories) async {
    final response = await api.searchByQuery(query: '', categories: categories);
    List<QueryResponse> responses = response.map((response) {
      return QueryResponse.fromMap(response);
    }).toList();
    return responses;
  }
}
