import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';

import '../../repository/search_repository.dart';
import '../../rutracker/models/query_response.dart';
import '../../rutracker/providers/enums.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchRepository repository;

  SearchBloc({required AuthenticationBloc bloc}) : super(SearchInitial()) {
    repository = SearchRepository(api: bloc.rutrackerApi);
    on<Search>((event, emit) => _search(event, emit));
    on<SearchByGenre>((event, emit) => _searchByGenre(event, emit));
  }

  _search(Search event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      List<QueryResponse>? responds = await repository.searchByText(event.query);
      if (responds != null) {
        emit(SearchLoaded(queryResponse: responds));
      } else {
        emit(const SearchError(message: 'Ошибка поиска'));
      }
    } on Exception catch (exception) {
      emit(SearchError(message: exception.message));
    }
  }

  _searchByGenre(SearchByGenre event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      List<QueryResponse>? responds = await repository.searchByGenre(event.genres);
      if (responds != null) {
        emit(SearchLoaded(queryResponse: responds));
      } else {
        emit(const SearchError(message: 'Ошибка поиска'));
      }
    } on Exception catch (exception) {
      emit(SearchError(message: exception.message));
    }
  }
}
