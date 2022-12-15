part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class GetLists extends ListEvent {}

class CreateList extends ListEvent {
  final List<BookList> list;
  final BookList bookList;

  const CreateList({required this.bookList, required this.list});
}

class DeleteList extends ListEvent {
  final int listId;
  final List<BookList> list;

  const DeleteList({required this.listId, required this.list});
}

class UpdateList extends ListEvent {
  final BookList bookList;
  final List<BookList> list;

  const UpdateList({required this.bookList, required this.list});
}
