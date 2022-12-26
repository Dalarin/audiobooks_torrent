import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';

import '../../models/book.dart';
import '../../models/book_list.dart';
import '../../models/list_object.dart';
import '../../repository/list_repository.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository repository;

  ListBloc({required this.repository}) : super(ListInitial()) {
    on<CreateList>((event, emit) => _createList(event, emit));
    on<UpdateList>((event, emit) => _updateList(event, emit));
    on<DeleteList>((event, emit) => _deleteList(event, emit));
    on<GetLists>((event, emit) => _getLists(event, emit));
    on<AddBook>((event, emit) => _addBookToList(event, emit));
  }

  _addBookToList(AddBook event, Emitter<ListState> emit) async {
    try {
      if (!event.bookList.books.contains(event.book)) {
        ListObject? listObject = ListObject(idList: event.bookList.id, idBook: event.book.id);
        listObject = await repository.addBookToList(listObject);
        if (listObject != null) {
          event.bookList.books.add(event.book);
          emit(ListLoaded(list: [event.bookList]));
        } else {
          emit(const ListError(message: 'Ошибка добавления книги в список'));
        }
      } else {
        emit(const ListError(message: 'Ошибка добавления книги в список'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.message));
    }
  }

  _createList(CreateList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(const ListError(message: 'Заполните все поля и попробуйте снова'));
      } else {
        BookList bookList = BookList(title: event.title, description: event.description, books: [], id: 0);
        BookList? createdList = await repository.createList(bookList);
        if (createdList != null) {
          event.list.add(createdList);
          emit(ListLoaded(list: event.list));
        } else {
          emit(const ListError(message: 'Ошибка создания списка'));
        }
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.message));
    }
  }

  _updateList(UpdateList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      BookList? bookList = await repository.updateList(event.bookList);
      if (bookList != null) {
        event.list.remove(event.bookList);
        event.list.add(bookList);
        event.list.sort((a, b) => a.id.compareTo(b.id));
        emit(ListLoaded(list: event.list));
      } else {
        emit(const ListError(message: 'Ошибка обновления списка'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.message));
    }
  }

  _deleteList(DeleteList event, Emitter<ListState> emit) async {
    try {
      emit(ListLoading());
      bool deleted = await repository.deleteList(event.listId);
      if (deleted == true) {
        event.list.removeWhere((element) {
          return element.id == event.listId;
        });
        emit(ListLoaded(list: event.list));
      } else {
        emit(const ListError(message: 'Ошибка удаления списка'));
      }
    } on Exception catch (exception) {
      emit(ListError(message: exception.message));
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
      emit(ListError(message: exception.message));
    }
  }
}
