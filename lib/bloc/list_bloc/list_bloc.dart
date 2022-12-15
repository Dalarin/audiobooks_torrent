import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/list_repository.dart';
import '../../rutracker/models/list.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository repository;

  ListBloc({required this.repository}) : super(ListInitial()) {
    on<CreateList>((event, emit) => _createList(event, emit));
    on<UpdateList>((event, emit) => _updateList(event, emit));
    on<DeleteList>((event, emit) => _deleteList(event, emit));
    on<GetLists>((event, emit) => _getLists(event, emit));
  }

  _createList(CreateList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      BookList? bookList = await repository.createList(event.bookList);
      if (bookList != null) {
        event.list.add(bookList);
        emit(ListLoaded(list: event.list));
      } else {
        emit(const ListError(message: 'Ошибка создания списка'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.toString()));
    }
  }

  _updateList(UpdateList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      BookList? bookList = await repository.updateList(event.bookList);
      if (bookList != null) {
        event.list.remove(event.bookList);
        event.list.add(bookList);
        event.list.sort((a, b) => a.id!.compareTo(b.id!));
        emit(ListLoaded(list: event.list));
      } else {
        emit(const ListError(message: 'Ошибка обновления списка'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.toString()));
    }
  }

  _deleteList(DeleteList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      bool deleted = await repository.deleteList(event.listId);
      if (deleted == true) {
        event.list.removeWhere((element) {
          return element.id! == event.listId;
        });
        emit(ListLoaded(list: event.list));
      } else {
        emit(const ListError(message: 'Ошибка удаления списка'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.toString()));
    }
  }

  _getLists(GetLists event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      List<BookList>? bookList = await repository.fetchLists();
      if (bookList != null) {
        emit(ListLoaded(list: bookList));
      } else {
        emit(const ListError(message: 'Ошибка загрузки списков'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.toString()));
    }
  }
}
