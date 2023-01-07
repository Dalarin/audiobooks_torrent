import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/bloc/torrent_bloc/torrent_bloc.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:rutracker_app/pages/audio_page.dart';

class DownloadingButton extends StatelessWidget {
  final Book book;
  final List<Book> bookList;

  const DownloadingButton({
    Key? key,
    required this.book,
    required this.bookList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          bloc.add(UpdateBook(book: book, books: bookList));
        }
      },
      builder: (context, state) {
        return WillPopScope(
          child: _getWillPopChild(
            context: context,
            state: state,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          onWillPop: () {
            if (state is TorrentDownloading) {
              return _showPreservationProgressDialog(context, book);
            }
            return Future.value(true);
          },
        );
      },
    );
  }

  Widget _getWillPopChild({
    required BuildContext context,
    required TorrentState state,
    required double height,
    required double width,
  }) {
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
      center: _getCenterWidget(
        context: context,
        state: state,
        book: book,
        books: bookList,
      ),
      percent: 1,
      context: context,
      height: height,
      width: width,
      book: book,
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

  Widget _getCenterWidget({
    required BuildContext context,
    required TorrentState state,
    required Book book,
    required List<Book> books,
  }) {
    if (book.isDownloaded) {
      return InkWell(
        onLongPress: () {
          _showDeletingDialog(context, book, books);
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<BookBloc>(),
                  child: AudioPage(
                    book: book,
                    books: books,
                  ),
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

  void _showDeletingDialog(BuildContext context, Book book, List<Book> books) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Удаление книги'),
          content: Text.rich(
            TextSpan(
              text: 'Вы уверены, что хотите удалить книгу ',
              children: [
                TextSpan(
                  text: book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                final bloc = context.read<BookBloc>();
                book.isDownloaded = false;
                bloc.add(DeleteBook(book: book, books: books));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showPreservationProgressDialog(BuildContext context, Book book) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Выход'),
          content: const Text(
            'Вы хотите сохранить прогресс скачивания?'
            ' Вы сможете продолжить скачивание позже',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                Navigator.pop(context, true);
                // Dismiss alert dialog
              },
            ),
            TextButton(
              onPressed: () {
                final bloc = context.read<TorrentBloc>();
                bloc.add(CancelTorrent(book: book));
                Navigator.pop(context, true);
              },
              child: const Text('Нет'),
            ),
          ],
        );
      },
    );
    return shouldPop!;
  }
}
