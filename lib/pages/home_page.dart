import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/providers/enums.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../models/book.dart';
import '../repository/book_repository.dart';

class HomePage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  const HomePage({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: _homePageContent(context),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _homePageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        _title('Недавно прослушанное'),
        const SizedBox(height: 15),
        _listeningBooksListBuilder(context, authenticationBloc),
        const SizedBox(height: 15),
        _title('Избранное'),
        const SizedBox(height: 15),
        _favoriteBooksListBuilder(context, authenticationBloc),
      ],
    );
  }

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 15);
        },
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
      'Здесь будут находиться книги в процессе прослушивания',
    );
  }

  Widget _listeningBooksListBuilder(
    BuildContext context,
    AuthenticationBloc authenticationBloc,
  ) {
    return BlocProvider<BookBloc>(
      create: (context) {
        return BookBloc(
          repository: BookRepository(api: authenticationBloc.rutrackerApi),
        );
      },
      child: Builder(
        builder: (context) {
          return BlocConsumer<BookBloc, BookState>(
            bloc: context.read<BookBloc>()..add(GetDownloadedBooks()),
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
              if (state is BookLoaded) {
                return _bookList(context, state.books);
              } else if (state is BookLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _bookList(context, []);
            },
          );
        },
      ),
    );
  }

  Widget _favoriteBooksListBuilder(
    BuildContext context,
    AuthenticationBloc authenticationBloc,
  ) {
    return BlocProvider<BookBloc>(
      create: (context) {
        return BookBloc(
          repository: BookRepository(
            api: authenticationBloc.rutrackerApi,
          ),
        );
      },
      child: Builder(
        builder: (context) {
          return BlocConsumer<BookBloc, BookState>(
            bloc: context.read<BookBloc>()..add(const GetFavoritesBooks(sortOrder: Sort.standart, limit: 3)),
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
              if (state is BookLoaded) {
                return _bookList(context, state.books);
              } else if (state is BookLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return _bookList(context, []);
              }
            },
          );
        },
      ),
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
}
