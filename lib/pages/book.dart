// ignore_for_file: must_be_immutable, sized_box_for_whitespace, avoid_print


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:rutracker_app/elements/downloadButton.dart';
import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class BookPage extends StatefulWidget {
  Book torrent;
  RutrackerApi api;

  BookPage(this.api, {Key? key, required this.torrent}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final List<TextEditingController> _controller =
      List.generate(2, (i) => TextEditingController());
  late double width;
  late double heigth;

  @override
  void initState() {
    init();
    _controller[0].text = widget.torrent.title;
    _controller[1].text = widget.torrent.image;
    super.initState();
    Future.delayed(Duration.zero, () {});
  }

  void init() async {
    List<Book> book = await DBHelper.instance.readBook(widget.torrent.id);
    setState(() {
      widget.torrent = book.isNotEmpty ? book[0] : widget.torrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heigth = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: loadData(),
      ),
    );
  }

  void dialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      title: const Text(
        "Подробная информация о книге",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            text('Год выпуска книги: ${widget.torrent.releaseYear}',
                FontWeight.normal, 15),
            const Divider(),
            text('Серия: ${widget.torrent.series}', FontWeight.normal, 15),
            const Divider(),
            text('Номер книги: ${widget.torrent.bookNumber}', FontWeight.normal,
                15),
            const Divider(),
            text('Битрейт: ${widget.torrent.bitrate}', FontWeight.normal, 15),
            const Divider(),
            text('Размер книги: ${widget.torrent.size}', FontWeight.normal, 15),
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

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      actions: [
        IconButton(
          onPressed: () => dialog(context),
          icon: const Icon(Icons.info_outline),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              widget.torrent.isFavorited = !widget.torrent.isFavorited;
              DBHelper.instance.updateBook(widget.torrent);
            });
          },
          icon: widget.torrent.isFavorited
              ? Icon(Icons.favorite,
                  color: Theme.of(context).toggleableActiveColor)
              : const Icon(Icons.favorite_border_outlined),
        ),
      ],
    );
  }

  Widget loadData() {
    return body(widget.torrent);
  }

  Widget networkImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => errorImage(),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: width * 0.6,
    );
  }

  Widget errorImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        width: width * 0.18,
        height: width * 0.17,
        child: Image.asset('assets/cover.jpg', repeat: ImageRepeat.repeat),
      ),
    );
  }

  Widget cachedImage(String urls) {
    return CachedNetworkImage(
      imageUrl: urls,
      placeholder: (context, url) => networkImage(url),
      errorWidget: (context, exception, stackTrace) => errorImage(),
      fit: BoxFit.cover,
      width: width * 0.6,
      filterQuality: FilterQuality.high,
    );
  }

  Widget image(String bookImage) {
    return Container(
      width: width * 0.6,
      height: heigth * 0.32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: widget.torrent.isDownloaded
            ? cachedImage(bookImage)
            : networkImage(bookImage),
      ),
    );
  }

  Widget text(String text, FontWeight fontWeight, double size) {
    return Text(
      text,
      softWrap: true,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
      ),
    );
  }

  Widget body(Book book) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              titleContainer(book),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: heigth * .64,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Container(
                  width: width * .65,
                  height: 55,
                  child: DownloadButton(widget.api, book: book),
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
          descriptionContainer(book)
        ],
      ),
    );
  }

  Widget titleContainer(Book book) {
    return Stack(
      children: [
        Container(
          width: width,
          height: heigth * 0.67,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xFF2F80ED).withOpacity(0.35),
                const Color(0xFFB2FFDA).withOpacity(0.35),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  image(book.image),
                  const SizedBox(height: 40),
                  Container(
                    constraints: BoxConstraints(maxWidth: width * 0.95),
                    child: Text(
                      book.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      book.author.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  progressIndicator(book)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget progressIndicator(Book book) {
    if (book.listeningInfo.maxIndex > 0) {
      return Container(
        width: width * 0.25,
        height: 20,
        child: LinearPercentIndicator(
          progressColor: const Color(0xFF4A73E7),
          percent: book.listeningInfo.index / book.listeningInfo.maxIndex,
        ),
      );
    }
    return Container();
  }

  Widget bookInformationWidget(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Жанр',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(book.genre),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Исполнитель',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                book.executor,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Аудио',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                book.time,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget descriptionContainer(Book book) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              bookInformationWidget(book),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Описание',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Text(
                book.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 25),
              constants.similarBooks
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Связанные книги:',
                          textAlign: TextAlign.left,
                          style: TextStyle(height: 1.5),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              linkedBooks(),
              const SizedBox(height: 25),
              widget.torrent.isFavorited || widget.torrent.isDownloaded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: userSettings(),
                    )
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget linkedList(List<Book> similarBooks) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemCount: similarBooks.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookPage(
                  widget.api,
                  torrent: similarBooks[index],
                ),
              ),
            );
          },
          child: Container(
            width: width * 0.4,
            height: heigth * 0.32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: image(similarBooks[index].image),
            ),
          ),
        );
      },
    );
  }

  Widget linkedBooks() {
    if (constants.similarBooks) {
      return FutureBuilder(
        future: widget.api.getSimilarBooks(
          widget.torrent.id.toString(),
          widget.api,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Связанные книги отсутствуют');
          }
          if (snapshot.hasData) {
            List<Book> similarBooks = snapshot.data as List<Book>;
            if (similarBooks.isNotEmpty) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: heigth * 0.25,
                      child: linkedList(similarBooks),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Связанные книги отсутствуют');
            }
          }
          return Container();
        },
      );
    }
    return Container();
  }

  Widget userSettings() {
    return InkWell(
      onTap: () => showModalSheet(),
      child: Container(
        height: 30,
        child: Row(
          children: const [
            Icon(Icons.settings),
            SizedBox(width: 15),
            Text(
              'Пользовательские настройки',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  showModalSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: MediaQuery.of(context).size.height * .32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Кастомизация книги',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        setState(() {
                          widget.torrent.title = _controller[0].text;
                          widget.torrent.image = _controller[1].text;
                          DBHelper.instance.updateBook(widget.torrent);
                          Navigator.pop(context);
                        });
                      },
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Название книги',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    textInput(_controller[0])
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Изображение книги',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    textInput(_controller[1]),
                  ],
                ),
                const SizedBox(height: 10),
                // elevatedButton(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget textInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
