part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class GetLists extends ListEvent {}

class CreateList extends ListEvent {
  final BookList bookList;

  const CreateList({required this.bookList});
}

class DeleteList extends ListEvent {
  final int listId;

  const DeleteList({required this.listId});
}

class UpdateList extends ListEvent {
  final BookList bookList;

  const UpdateList({required this.bookList});
}
