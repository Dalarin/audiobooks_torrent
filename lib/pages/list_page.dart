import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../rutracker/models/book.dart';
import '../rutracker/models/list.dart';

class ListPage extends StatelessWidget {
  final BookList list;
  final AuthenticationBloc authenticationBloc;

  const ListPage({Key? key, required this.list, required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _listPageAppBar(context, list),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _listPageContent(context, list),
      ),
    );
  }

  AppBar _listPageAppBar(BuildContext context, BookList bookList) {
    return AppBar(
      title: Text(bookList.title),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      actions: [
        InkWell(
          onTap: () {
            // TODO : ПОКАЗАТЬ ДИАЛОГ ИЗМЕНЕНИЯ СПИСКА
          },
          child: const Icon(Icons.settings),
        )
      ],
    );
  }

  Widget _emptyListWidget(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 80,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return ListView.builder(
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return BookElement(
            authenticationBloc: authenticationBloc,
            books: books,
            book: books[index],
          );
        },
      );
    }
    return _emptyListWidget(
      context,
      'Здесь будут находиться ваши избранные книги',
    );
  }

  Widget _booksListBuilder(BuildContext context, BookList bookList) {
    return BlocConsumer<BookBloc, BookState>(
      bloc: context.read<BookBloc>(),
      listener: (context, state) {
        if (state is BookError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return _bookList(context, bookList.books);
      },
    );
  }

  Widget _listPageContent(BuildContext context, BookList bookList) {
    return Column(
      children: [
        Expanded(
          child: _booksListBuilder(context, bookList),
        ),
      ],
    );
  }
}
