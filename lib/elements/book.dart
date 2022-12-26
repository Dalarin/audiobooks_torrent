import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/pages/book_page.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../rutracker/models/book.dart';

class BookElement extends StatelessWidget {
  final Book book;
  final List<Book> books;
  final AuthenticationBloc authenticationBloc;

  const BookElement({
    Key? key,
    required this.book,
    required this.books,
    required this.authenticationBloc,
  }) : super(key: key);

  ///
  /// ListTile(
  //       ),

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<BookBloc>(),
                  child: BookPage(
                    authenticationBloc: authenticationBloc,
                    book: book,
                    books: books,
                  ),
                );
              },
            ),
          );
        },
        child: _customListTile(
          context: context,
          book: book,
          leading: _leadingImage(
            book: book,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          title: Text(
            book.title,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            book.author,
            maxLines: 3,
          ),
          trailing: _actionMenu(
            context: context,
            book: book,
            books: books,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }

  Widget _customListTile({
    required BuildContext context,
    required Book book,
    required Widget leading,
    required Widget title,
    required Widget subtitle,
    required Widget trailing,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.25,
                child: leading,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.025,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    subtitle,
                  ],
                ),
              ),
            ],
          ),
          trailing
        ],
      ),
    );
  }

  Widget _action({
    required BuildContext context,
    required Book book,
    required Icon icon,
    required String title,
    required Function(BuildContext context) function,
  }) {
    return InkWell(
      onTap: () => function(context),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 15),
          Text(title),
        ],
      ),
    );
  }

  /// УДАЛИТЬ ИЗ ИЗБРАННОГО
  /// ОТМЕТИТЬ ПРОСЛУШАННЫМ
  /// СПИСКИ
  /// СКАЧАТЬ КНИГУ
  void _showActionMenuDialog({
    required BuildContext context,
    required Book book,
    required List<Book> books,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text('Меню действий'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _action(
                  context: context,
                  book: book,
                  icon: Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: 'Удалить из избранного',
                  function: (context) {
                    book.isFavorite = !book.isFavorite;
                    final bloc = context.read<BookBloc>();
                    bloc.add(UpdateBook(book: book, books: books));
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                _action(
                  context: context,
                  book: book,
                  icon: const Icon(Icons.check),
                  title: !book.listeningInfo.isCompleted ? 'Отметить прослушанным' : 'Отметить непрослушанным',
                  function: (context) {
                    // TODO: Отметить прослушанным
                    book.listeningInfo.isCompleted = !book.listeningInfo.isCompleted;
                    final bloc = context.read<BookBloc>();
                    bloc.add(UpdateBook(book: book, books: books));
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                _action(
                  context: context,
                  book: book,
                  icon: const Icon(Icons.list_alt_rounded),
                  title: 'Списки',
                  function: (context) {
                    // TODO: Выбор списков
                  },
                ),
                const Divider(),
                _action(
                  context: context,
                  book: book,
                  icon: const Icon(Icons.download),
                  title: 'Скачать книгу',
                  function: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return BlocProvider.value(
                            value: context.read<BookBloc>(),
                            child: BookPage(
                              authenticationBloc: authenticationBloc,
                              book: book,
                              books: books,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _percentValue({required double value, required Book book}) {
    if (book.listeningInfo.isCompleted) return 1.0;
    return value.isNaN || value.isInfinite ? 0 : value;
  }

  Widget _actionMenu({
    required BuildContext context,
    required Book book,
    required List<Book> books,
    required double width,
    required double height,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => _showActionMenuDialog(
            context: context,
            book: book,
            books: books,
          ),
          child: const Icon(Icons.more_vert_rounded),
        ),
        _progressIndication(context, book),
      ],
    );
  }

  Widget _progressIndication(BuildContext context, Book book) {
    if (book.listeningInfo.maxIndex != 0 || book.listeningInfo.isCompleted) {
      return CircularPercentIndicator(
        progressColor: book.listeningInfo.isCompleted ? const Color(0xFF00C400) : Theme.of(context).colorScheme.primary,
        animation: true,
        radius: 15.0,
        percent: _percentValue(
          value: book.listeningInfo.index / book.listeningInfo.maxIndex,
          book: book
        ),
      );
    }
    return const SizedBox();
  }

  Widget _leadingImage({
    required Book book,
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: width * 0.2,
        height: height * 0.17,
        child: book.isDownloaded ? _cachedImage(book, width, height) : _networkImage(book, width, height),
      ),
    );
  }

  Widget _cachedImage(Book book, double width, double height) {
    return Image(
      image: CachedNetworkImageProvider(book.image),
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
    );
  }

  Widget _networkImage(Book book, double width, double height) {
    return Image.network(
      book.image,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: width * 0.22,
    );
  }

  Widget _errorImage(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        width: width * 0.18,
        height: width * 0.17,
        child: Image.asset(
          'assets/cover.jpg',
          repeat: ImageRepeat.repeat,
        ),
      ),
    );
  }
}
