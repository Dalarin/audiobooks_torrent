import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/rutracker/models/book.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../repository/book_repository.dart';

class HomePage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  const HomePage({Key? key, required this.authenticationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (context) => BookBloc(repository: BookRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        primary: true,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: _homePageContent(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
        const SizedBox(height: 25),
        const Text(
          'Главная',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 15),
        _title('Недавно прослушанное'),
        _listeningBooksListBuilder(context),
        const SizedBox(height: 15),
        _title('Избранное'),
        const SizedBox(height: 15),
        _favoriteBooksListBuilder(context),
      ],
    );
  }

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return ListView.builder(
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return BookElement(
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

  Widget _listeningBooksListBuilder(BuildContext context) {
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
  }

  Widget _favoriteBooksListBuilder(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      bloc: context.read<BookBloc>()..add(GetFavoritesBooks()),
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
  }

  Widget _emptyListWidget(BuildContext context, String text) {
    return Material(
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
    );
  }
}
