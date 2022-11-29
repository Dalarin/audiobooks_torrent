
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';

import '../../repository/search_repository.dart';
import '../../rutracker/models/torrent.dart';
import '../../rutracker/providers/sort.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchRepository repository;
  SearchBloc({required AuthenticationBloc bloc}) : super(SearchInitial()) {
    if (bloc.rutrackerApi != null) {
      print('RUTRACKER IS NOT NULL');
      print(bloc.rutrackerApi!.pageProvider.toString());
      repository = SearchRepository(api: bloc.rutrackerApi!);
    }
    on<SearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
