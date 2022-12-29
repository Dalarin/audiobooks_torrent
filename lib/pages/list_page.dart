import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/repository/book_repository.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../models/book.dart';
import '../models/book_list.dart';

class ListPage extends StatelessWidget {
  final BookList list;
  final AuthenticationBloc authenticationBloc;

  const ListPage({Key? key, required this.list, required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (context) => BookBloc(
        repository: BookRepository(api: authenticationBloc.rutrackerApi),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _listPageAppBar(context, list),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _listPageContent(context, list),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _listPageAppBar(BuildContext context, BookList bookList) {
    return AppBar(
      title: Text(bookList.title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _emptyListWidget(BuildContext context, String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
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
        _booksListBuilder(context, bookList),
      ],
    );
  }
}
