import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/bloc/list_bloc/list_bloc.dart';
import 'package:rutracker_app/models/book_list.dart';
import 'package:rutracker_app/repository/book_repository.dart';
import 'package:rutracker_app/widgets/book_list.dart';

class ListPage extends StatefulWidget {
  final BookList list;
  final List<BookList> lists;
  final AuthenticationBloc authenticationBloc;

  const ListPage({
    Key? key,
    required this.list,
    required this.authenticationBloc,
    required this.lists,
  }) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    titleController.text = widget.list.title;
    descriptionController = TextEditingController();
    descriptionController.text = widget.list.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (context) => BookBloc(
        repository: BookRepository(api: widget.authenticationBloc.rutrackerApi),
      ),
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _listPageAppBar(context, widget.list, widget.lists),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElementsList(
                  list: widget.list.books,
                  emptyListText: 'Здесь будут находиться ваши книги, добавленные в данный список',
                  bloc: widget.authenticationBloc,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showConfirmDeletingDialog(BuildContext context, BookList bookList, List<BookList> list) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Удаление списка'),
          content: Text.rich(
            TextSpan(
              text: 'Вы уверены, что хотите удалить список ',
              children: [
                TextSpan(
                  text: bookList.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                final bloc = context.read<ListBloc>();
                bloc.add(DeleteList(listId: bookList.id, list: list));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hint,
        label: Text(hint),
      ),
    );
  }

  void _showListChangingDialog(BuildContext context, BookList bookList, List<BookList> list) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Изменение списка'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textField(
                context: context,
                controller: titleController,
                hint: 'Название списка',
              ),
              const SizedBox(height: 15),
              _textField(
                context: context,
                controller: descriptionController,
                hint: 'Описание списка',
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final bloc = context.read<ListBloc>();
                bookList.title = titleController.text;
                bookList.description = descriptionController.text;
                bloc.add(UpdateList(bookList: bookList, list: list));
                Navigator.pop(dialogContext);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context, BookList bookList, List<BookList> list) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Настройки'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Настройки'),
                onTap: () => _showListChangingDialog(context, bookList, list),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Удалить список'),
                onTap: () => _showConfirmDeletingDialog(context, bookList, list),
              )
            ],
          ),
        );
      },
    );
  }

  AppBar _listPageAppBar(BuildContext context, BookList bookList, List<BookList> list) {
    return AppBar(
      title: Tooltip(
        message: bookList.title,
        child: Text(bookList.title),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showSettingsDialog(context, bookList, list),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
