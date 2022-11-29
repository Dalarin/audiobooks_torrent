import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/elements/book.dart';

import '../rutracker/models/book.dart';

class BookList extends StatelessWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookBloc>();
    return BlocConsumer<BookBloc, BookState>(
      bloc: bloc..add(GetFavoritesBooks()),
      listener: (context, state) {
        if (state is BookError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BookLoaded) {
          return _bookList(books: state.books);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _bookList({
    required List<Book> books,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return BookElement(book: books[index], books: books);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: books.length,
    );
  }
}
