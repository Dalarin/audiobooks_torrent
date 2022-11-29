part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Search extends SearchEvent {
  final String query;

  const Search({required this.query});
}

class SearchByGenre extends SearchEvent {
  final Genres genres;

  const SearchByGenre({required this.genres});
}
