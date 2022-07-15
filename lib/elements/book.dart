import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rutracker_app/pages/book.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class BookElement extends StatefulWidget {
  Book book;
  RutrackerApi api;
  final Function() notifyParent;

  BookElement(
      {required this.book,
      required this.api,
      Key? key,
      required this.notifyParent})
      : super(key: key);

  @override
  State<BookElement> createState() => _BookElementState();
}

class _BookElementState extends State<BookElement> {
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
  }

  Widget _bookHeaderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.45),
          child: Text(
            widget.book.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.5, maxHeight: 30),
          child: Text(
            widget.book.author.trim(),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => _pushToScreenBook(widget.book),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: width * 0.95,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: SizedBox(
                          width: width * 0.18,
                          height: width * 0.17,
                          child: widget.book.isDownloaded
                              ? cachedImage(widget.book)
                              : networkImage(widget.book.image),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 25),
                _bookHeaderWidget(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => showContextDialog(context, widget.book),
                  icon: const Icon(Icons.more_horiz_outlined),
                ),
                percentIndicator(widget.book)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _errorImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: SizedBox(
        width: width * 0.18,
        height: width * 0.17,
        child: Image.asset('assets/cover.jpg', repeat: ImageRepeat.repeat,),
      ),
    );
  }

  void _pushToScreenBook(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookPage(widget.api, torrent: book),
      ),
    ).then((value) {
      setState(() {
        widget.notifyParent();
      });
    });
  }

  Widget listOfLists(StateSetter setState) {
    // список списков, оригинально, правда?
    return FutureBuilder(
      future: Future.wait([
        DBHelper.instance.readLists(),
        DBHelper.instance.getBooksInList(widget.book.id)
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BookList> bookList = (snapshot.data as List)[0];
          List<ListObject> books = (snapshot.data as List)[1];
          return SizedBox(
            width: width,
            height: height * 0.2,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: width,
                  height: 50,
                  child: checkBoxWidget(
                    bookList[index],
                    books,
                    setState,
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  void _createListDialog() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                height: height * 0.3,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Списки',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      listOfLists(setState)
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool listObjectContains(List<ListObject> list, int id) {
    for (var element in list) {
      if (element.idList == id) {
        return true;
      }
    }
    return false;
  }

  Widget checkBoxWidget(
      BookList list, List<ListObject> listObjects, StateSetter setState) {
    return CheckboxListTile(
      title: Text(list.name),
      value: listObjectContains(listObjects, list.id!),
      onChanged: (bool? value) {
        if (value == true) {
          ListObject.addToList(
            list.id!,
            widget.book.id,
            list,
            widget.book.image,
          );
        } else {
          ListObject.deleteFromList(list.id!, widget.book.id);
        }
        setState(() {});
      },
    );
  }

  void setCompleted(Book book) {
    if (book.listeningInfo.isCompleted) {
      book.listeningInfo.index = 0;
      book.listeningInfo.maxIndex = 0;
    } else {
      book.listeningInfo.index = 5;
      book.listeningInfo.maxIndex = 5;
    }
    book.listeningInfo.isCompleted = !book.listeningInfo.isCompleted;
    DBHelper.instance.updateBook(book).whenComplete(() => setState(() {}));
    Navigator.pop(context);
  }

  void showContextDialog(BuildContext context, Book book) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      content: SizedBox(
        width: width * .95,
        height: height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                book.isFavorited = false;
                DBHelper.instance.updateBook(book).whenComplete(() {
                  setState(() {
                    widget.notifyParent();
                  });
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).toggleableActiveColor,
                  ),
                  const SizedBox(width: 15),
                  const Text('Удалить из избранного')
                ],
              ),
            ),
            InkWell(
              onTap: () => setCompleted(book),
              child: Row(
                children: [
                  const Icon(Icons.check),
                  const SizedBox(width: 15),
                  Text(
                    book.listeningInfo.isCompleted
                        ? 'Отметить непрослушанным'
                        : 'Отметить прослушанным',
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => _createListDialog(),
              child: Row(
                children: const [
                  Icon(Icons.list),
                  SizedBox(width: 15),
                  Text('Списки')
                ],
              ),
            ),
            InkWell(
              onTap: () => book.isDownloaded
                  ? deleteBook(book)
                  : _pushToScreenBook(book),
              child: Row(
                children: [
                  Icon(book.isDownloaded ? Icons.delete : Icons.download),
                  const SizedBox(width: 15),
                  Text(book.isDownloaded ? 'Удалить книгу' : 'Скачать книгу'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteBook(Book book) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    Directory bookDirectory = Directory('$directory/books/${book.id}/');
    bookDirectory.deleteSync(recursive: true);
    setState(() => book.isDownloaded = false);
    DBHelper.instance.updateBook(book);
    Navigator.pop(context);
  }

  Widget percentIndicator(Book book) {
    if (book.listeningInfo.maxIndex > 0) {
      return Container(
        alignment: Alignment.center,
        child: CircularPercentIndicator(
          progressColor: book.listeningInfo.isCompleted
              ? const Color(0xFF00C400)
              : const Color(0xFF4A73E7),
          radius: 15.0,
          percent: book.listeningInfo.index / book.listeningInfo.maxIndex,
          animation: true,
        ),
      );
    }
    return Container();
  }

  Widget cachedImage(Book book) {
    return Image(
      image: CachedNetworkImageProvider(book.image),
      errorBuilder: (context, error, stackTrace) => _errorImage(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
    );
  }

  Widget networkImage(String image) {
    return Image.network(
      image,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => _errorImage(),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: width * 0.6,
    );
  }
}
