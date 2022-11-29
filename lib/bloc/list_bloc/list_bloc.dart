import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rutracker_app/rutracker/models/book.dart';

import '../../repository/list_repository.dart';
import '../../rutracker/models/list.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository repository;
  ListBloc({required this.repository}) : super(ListInitial()) {
    on<ListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
