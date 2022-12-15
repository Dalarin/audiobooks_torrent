import 'package:rutracker_app/rutracker/providers/enums.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

import '../rutracker/models/query_response.dart';

class SearchRepository {
  RutrackerApi api;

  SearchRepository({required this.api});

  Future<List<QueryResponse>?> searchByText(String text) => api.search(text, Genres.all.value.toString());

  Future<List<QueryResponse>?> searchByGenre(Genres genres) => api.search('', genres.value.toString());
}