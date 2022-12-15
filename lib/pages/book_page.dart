// ignore_for_file: must_be_immutable, sized_box_for_whitespace, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/pages/audio_page.dart';

import 'package:rutracker_app/rutracker/models/book.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../bloc/torrent_bloc/torrent_bloc.dart';

class BookPage extends StatelessWidget {
  final Book book;
  final List<Book> books;
  final AuthenticationBloc authenticationBloc;

  const BookPage({
    Key? key,
    required this.book,
    required this.books,
    required this.authenticationBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TorrentBloc(api: authenticationBloc.rutrackerApi),
      child: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: _appBar(context, book, books),
              body: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _bookPageContent(context),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bookPageContent(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            _coverGradientBox(context),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.57),
              width: MediaQuery.of(context).size.width * 0.7,
              child: _downloadButtonBuilder(
                context: context,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                book: book,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: _aboutSection(
            context,
            book,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        _descriptionSection(
          context,
          book,
        ),
      ],
    );
  }

  Widget _aboutElement({
    required BuildContext context,
    required String title,
    required String text,
    required CrossAxisAlignment alignment,
    required TextAlign textAlign,
  }) {
    return Tooltip(
      message: text,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33 - 8.0,
        child: Column(
          crossAxisAlignment: alignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text,
              textAlign: textAlign,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  Widget _aboutSection(BuildContext context, Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _aboutElement(
          context: context,
          title: 'Жанр',
          text: book.genre,
          textAlign: TextAlign.start,
          alignment: CrossAxisAlignment.start,
        ),
        _aboutElement(
          context: context,
          title: 'Исполнитель',
          text: book.executor,
          textAlign: TextAlign.center,
          alignment: CrossAxisAlignment.center,
        ),
        _aboutElement(
          context: context,
          title: 'Аудио',
          text: book.time,
          textAlign: TextAlign.end,
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _descriptionSection(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SelectableText(
        book.description,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          height: 1.5,
        ),
      ),
    );
  }

  Widget _coverGradientBox(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: _coverBoxContent(
        context: context,
        book: book,
        width: width,
        height: height,
      ),
    );
  }

  Widget _coverBoxContent({
    required BuildContext context,
    required Book book,
    required double width,
    required double height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _showFullImage(
              context: context,
              book: book,
              width: width,
              height: height,
            );
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: SizedBox(
              width: width * 0.6,
              height: height * 0.35,
              child: book.isDownloaded ? _cachedImage(book, width, height) : _networkImage(book, width, height),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Tooltip(
          message: book.title,
          child: Text(
            book.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Tooltip(
          message: book.author,
          child: Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _downloadButton({
    required BuildContext context,
    required Widget center,
    required double percent,
    required double height,
    required double width,
    required Book book,
  }) {
    return LinearPercentIndicator(
      progressColor: Theme.of(context).colorScheme.primary,
      center: center,
      percent: percent,
      lineHeight: 55,
      animation: false,
      barRadius: const Radius.circular(10),
    );
  }

  Widget _downloadButtonBuilder({
    required BuildContext context,
    required double height,
    required double width,
    required Book book,
  }) {
    return BlocConsumer<TorrentBloc, TorrentState>(
      listener: (context, state) {
        if (state is TorrentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is TorrentDownloaded) {
          final bloc = context.read<BookBloc>();
          book.isDownloaded = true;
          bloc.add(UpdateBook(book: book, books: books));
        }
      },
      builder: (context, state) {
        if (state is TorrentDownloading) {
          return StreamBuilder(
            stream: state.torrentProgress,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double percent = double.parse(snapshot.data.toString());
                return _downloadButton(
                  context: context,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pause,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(percent * 100).toStringAsFixed(2)} %',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  percent: percent,
                  height: height,
                  width: width,
                  book: book,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }
        return _downloadButton(
          center: _getCenterWidget(context, state, book),
          percent: 1,
          context: context,
          height: height,
          width: width,
          book: book,
        );
      },
    );
  }

  Widget _getCenterWidget(BuildContext context, TorrentState state, Book book) {
    if (book.isDownloaded) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<BookBloc>(),
                  child: AudioPage(book: book),
                );
              },
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headphones,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 15),
            Text(
              'Слушать',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          final bloc = context.read<TorrentBloc>();
          bloc.add(StartTorrent(book: book));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 5),
            Text(
              'Скачать',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
      );
    }
  }

  void _showFullImage({
    required BuildContext context,
    required Book book,
    required double width,
    required double height,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: SizedBox(
              width: width,
              height: height * 0.4,
              child: book.isDownloaded ? _cachedImage(book, width, height) : _networkImage(book, width, height),
            ),
          ),
        );
      },
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

  void _showMoreInfoDialog(BuildContext context, Book book) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Подробная информация о книге'),
          content: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Год выпуска книги: ${book.releaseYear}'),
                const Divider(),
                Text('Серия: ${book.series}'),
                const Divider(),
                Text('Номер книги: ${book.bookNumber}'),
                const Divider(),
                Text('Битрейт: ${book.bitrate}'),
                const Divider(),
                Text('Размер книги: ${book.size}'),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(
    BuildContext context,
    Book book,
    List<Book> books,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        InkWell(
          onTap: () {
            book.isFavorite = !book.isFavorite;
            final bloc = context.read<BookBloc>();
            bloc.add(UpdateBook(book: book, books: books));
          },
          child: Icon(
            book.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () {
            _showMoreInfoDialog(context, book);
          },
          child: const Icon(Icons.info_outline_rounded),
        ),
      ],
    );
  }
}