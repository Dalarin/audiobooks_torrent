import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rutracker_app/pages/book.dart';
import 'package:rutracker_app/providers/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateToBook(widget.book),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width * 0.95,
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
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.width * 0.17,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: widget.book.isDownloaded
                              ? cachedImage(widget.book)
                              : networkImage(widget.book.image),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.45),
                      child: Text(
                        widget.book.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: constants.fontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                          maxHeight: 30),
                      child: Text(
                        widget.book.author.trim(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: constants.fontFamily),
                      ),
                    )
                  ],
                ),
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

  Widget errorImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      height: MediaQuery.of(context).size.width * 0.17,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: Image.asset('assets/cover.jpg'),
      ),
    );
  }

  void navigateToBook(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookPage(widget.api, torrent: book),
      ),
    ).then((value) => setState(() => {}));
  }

  createListDialog() {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                height: MediaQuery.of(context).size.height * .3,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Списки',
                          style: TextStyle(
                              fontFamily: constants.fontFamily,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      FutureBuilder(
                        future: Future.wait([
                          DBHelper.instance.readLists(),
                          DBHelper.instance.getBooksInList(widget.book.id)
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<BookList> bookList =
                                (snapshot.data as List)[0] as List<BookList>;
                            List<ListObject> books =
                                (snapshot.data as List)[1] as List<ListObject>;
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: bookList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: checkBox(context, bookList, index,
                                        books, setState),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
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

  Widget checkBox(BuildContext context, List<BookList> bookList, int index,
      List<ListObject> books, StateSetter setState) {
    return CheckboxListTile(
      selectedTileColor: Theme.of(context).toggleableActiveColor,
      title: Text(bookList[index].name,
          style: TextStyle(fontFamily: constants.fontFamily)),
      value: books
          .where((element) => element.idList == bookList[index].id)
          .isNotEmpty,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            DBHelper.instance.createListObject(
              ListObject(idList: bookList[index].id!, idBook: widget.book.id),
            );
            bookList[index].cover = widget.book.image;
            DBHelper.instance.updateList(bookList[index]);
          } else {
            DBHelper.instance
                .deleteBooksInsideLists(widget.book.id, bookList[index].id!);
          }
          widget.notifyParent();
        });
      },
      secondary: const Icon(Icons.list_alt_outlined),
    );
  }

  void showContextDialog(BuildContext context, Book book) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      content: Container(
        width: MediaQuery.of(context).size.width * .95,
        height: MediaQuery.of(context).size.height * .2,
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
                  Icon(Icons.favorite,
                      color: Theme.of(context).toggleableActiveColor),
                  const SizedBox(width: 15),
                  Text(
                    'Удалить из избранного',
                    style: TextStyle(fontFamily: constants.fontFamily),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                widget.book.listeningInfo['isCompleted'] == '1'
                    ? {
                        book.listeningInfo['isCompleted'] = '0',
                        book.listeningInfo['index'] = '0',
                        book.listeningInfo['maxIndex'] = '0'
                      }
                    : {
                        book.listeningInfo['isCompleted'] = '1',
                        book.listeningInfo['index'] = '5',
                        book.listeningInfo['maxIndex'] = '5'
                      };

                DBHelper.instance
                    .updateBook(book)
                    .whenComplete(() => setState(() {}));
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.check),
                  const SizedBox(width: 15),
                  Text(
                    widget.book.listeningInfo['isCompleted'] == '1'
                        ? 'Отметить непрослушанным'
                        : 'Отметить прослушанным',
                    style: TextStyle(fontFamily: constants.fontFamily),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => createListDialog(),
              child: Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(width: 15),
                  Text(
                    'Списки',
                    style: TextStyle(fontFamily: constants.fontFamily),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () =>
                  book.isDownloaded ? deleteBook(book) : navigateToBook(book),
              child: Row(
                children: [
                  Icon(book.isDownloaded ? Icons.delete : Icons.download),
                  const SizedBox(width: 15),
                  Text(book.isDownloaded ? 'Удалить книгу' : 'Скачать книгу',
                      style: TextStyle(fontFamily: constants.fontFamily)),
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
    return double.parse((book.listeningInfo["maxIndex"] ?? '0').toString()) > 0
        ? Container(
            alignment: Alignment.center,
            child: CircularPercentIndicator(
              progressColor: book.listeningInfo["isCompleted"] == "1"
                  ? const Color(0xFF00C400)
                  : const Color(0xFF4A73E7),
              percent: (double.parse(book.listeningInfo["index"].toString()) /
                  double.parse(book.listeningInfo["maxIndex"].toString())),
              radius: 25.0,
              animation: true,
            ),
          )
        : Container();
  }

  Widget cachedImage(Book book) {
    return Image(
      image: CachedNetworkImageProvider(book.image),
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
    );
  }

  Widget networkImage(String image) {
    return Image.network(
      image,
      loadingBuilder: (context, child, loadingProgress) =>
          (loadingProgress == null)
              ? child
              : const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error, stackTrace) => errorImage(),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: MediaQuery.of(context).size.width * 0.6,
    );
  }
}
