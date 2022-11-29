import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rutracker_app/pages/book.dart';
import 'package:rutracker_app/rutracker/models/book.dart';

import '../bloc/book_bloc/book_bloc.dart';

class BookElement extends StatelessWidget {
  final Book book;
  final List<Book> books;

  const BookElement({Key? key, required this.book, required this.books})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _leadingImage(
        book: book,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      title: Text(
        book.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        book.author.trim(),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: _actionMenu(
        context: context,
        book: book,
        books: books,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
      onTap: () => function,
      child: Row(
        children: [
          icon,
          const SizedBox(height: 15),
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
          content: Column(
            children: [
              _action(
                context: context,
                book: book,
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                title: 'Удалить из избранного',
                function: (context) {
                  book.isFavorite = !book.isFavorite;
                  final bloc = context.read<BookBloc>();
                  bloc.add(UpdateBook(book: book, books: books));
                },
              ),
              _action(
                context: context,
                book: book,
                icon: const Icon(Icons.check),
                title: book.listeningInfo.isCompleted
                    ? 'Отметить прослушанным'
                    : 'Отметить непрослушанным',
                function: (context) {
                  // TODO: Отметить прослушанным
                  final bloc = context.read<BookBloc>();
                  bloc.add(UpdateBook(book: book, books: books));
                },
              ),
              _action(
                context: context,
                book: book,
                icon: const Icon(Icons.list_alt_rounded),
                title: 'Списки',
                function: (context) {
                  // TODO: Выбор списков
                },
              ),
              _action(
                context: context,
                book: book,
                icon: const Icon(Icons.download),
                title: 'Скачать книгу',
                function: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider.value(
                          value: context.read<BookBloc>(),
                          child: BookPage(book: book),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  double _value({required double value}) {
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
        CircularPercentIndicator(
          progressColor: book.listeningInfo.isCompleted
              ? const Color(0xFF00C400)
              : const Color(0xFF4A73E7),
          animation: true,
          radius: 15.0,
          percent: _value(
            value: book.listeningInfo.index / book.listeningInfo.maxIndex,
          ),
        ),
      ],
    );
  }

  Widget _leadingImage({
    required Book book,
    required double width,
    required double height,
  }) {
    return book.isDownloaded
        ? _cachedImage(book, width, height)
        : _networkImage(book, width, height);
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
      width: width * 0.6,
    );
  }

  Widget _errorImage(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
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
