// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/pages/list.dart';
import 'package:rutracker_app/pages/search.dart';
import 'package:rutracker_app/providers/storageManager.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class Favorited extends StatefulWidget {
  RutrackerApi api;

  Favorited(this.api, {Key? key}) : super(key: key);

  @override
  _FavoritedState createState() => _FavoritedState();
}

class _FavoritedState extends State<Favorited> {
  final List<TextEditingController> _controller =
      List.generate(2, (i) => TextEditingController());

  bool isLoading = true;
  bool isFavorited = true;
  int sortType = 0;
  String sortOrder = "";
  Map<int, String> sortMap = {
    0: 'По умолчанию',
    1: 'По автору',
    2: 'По названию',
    3: 'По исполнителю'
  };
  Map<int, String> sortSQL = {
    0: "(SELECT null)",
    1: BookFields.author,
    2: BookFields.title,
    3: BookFields.executor
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: body(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadAsyncInfo() async {
    sortOrder = await StorageManager.readData('sortOrder');
    sortType = await StorageManager.readData('sortType');
  }

  @override
  void initState() {
    _loadAsyncInfo();
    super.initState();
  }

  Widget listDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Создание списка',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        IconButton(
          onPressed: () {
            if (_controller[0].text.isNotEmpty &&
                _controller[1].text.isNotEmpty) {
              DBHelper.instance
                  .createList(
                    BookList(
                      name: _controller[0].text,
                      description: _controller[1].text,
                    ),
                  )
                  .whenComplete(() => Navigator.pop(context));
              _controller[0].clear();
              _controller[1].clear();
            } else {
              FunkyNotification(
                notificationText: 'Ошибка создания списка. Пустые поля',
              ).showNotification(context);
            }
          },
          icon: const Icon(Icons.check_circle_outline),
        ),
      ],
    );
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
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            height: MediaQuery.of(context).size.height * .3,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listDescription(),
                  const Text(
                    'Название списка',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  textInput(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      1,
                      _controller[0],
                      25),
                  const SizedBox(height: 5),
                  const Text(
                    'Описание списка',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  textInput(
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      2,
                      _controller[1],
                      50),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textInput(EdgeInsets insets, int maxLines,
      TextEditingController controller, int textLimit) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: "Gotham"),
      cursorColor: Colors.black,
      maxLines: maxLines,
      inputFormatters: [LengthLimitingTextInputFormatter(textLimit)],
      decoration: InputDecoration(
        contentPadding: insets,
        isDense: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget headerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => setState(() => isFavorited = true),
            child: Text(
              'Избранное',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: isFavorited
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.black, padding: EdgeInsets.zero),
            onPressed: () => setState(() => isFavorited = false),
            child: Text(
              'Списки',
              style: TextStyle(
                fontSize: 20,
                color: isFavorited
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          headerRow(),
          isFavorited ? favoritedList() : listsList()
        ],
      ),
    );
  }

  Widget errorImage(String image) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      height: MediaQuery.of(context).size.width * 0.17,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: Image.asset('login.png'),
      ),
    );
  }

  Widget list(BookList list) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListPage(
            api: widget.api,
            list: list,
          ),
        ),
      ).then((value) => setState(() => {})),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.17,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: Image.network(
                          list.cover!,
                          errorBuilder: (context, error, stackTrace) =>
                              errorImage(list.cover!),
                          loadingBuilder: (context, child, loadingProgress) =>
                              (loadingProgress == null)
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          width: MediaQuery.of(context).size.width * 0.6,
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
                    SizedBox(
                      width: 215,
                      child: Text(
                        list.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                        maxHeight: 45,
                      ),
                      child: Text(
                        list.description,
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget listsList() {
    return Column(
      children: [
        FutureBuilder(
          future: DBHelper.instance.readLists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BookList> bookList = snapshot.data as List<BookList>;
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                shrinkWrap: true,
                itemCount: bookList.length,
                itemBuilder: (context, index) => list(bookList[index]),
              );
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => createListDialog(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).toggleableActiveColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: const Center(child: Icon(Icons.add)),
            ),
          ),
        ),
      ],
    );
  }

  void showSortDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * .95,
        height: MediaQuery.of(context).size.height * .3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            listTile(0, 'По умолчанию'),
            listTile(1, 'По автору'),
            listTile(2, 'По названию'),
            listTile(3, 'По исполнителю')
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

  void showFilter(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * .95,
        height: MediaQuery.of(context).size.height * .3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            listTile(0, 'По умолчанию'),
            listTile(1, 'По автору'),
            listTile(2, 'По названию'),
            listTile(3, 'По исполнителю')
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

  Widget listTile(int value, String text) {
    return StatefulBuilder(
      builder: (context, changeState) {
        return ListTile(
          trailing: value == 0
              ? InkWell(
                  onTap: () => changeState(() {
                    setState(() {
                      sortOrder = sortOrder == "desc" ? "asc" : "desc";
                      StorageManager.saveData('sortOrder', sortOrder);
                    });
                  }),
                  child: Icon(Icons.sort_by_alpha,
                      color: sortOrder == "asc"
                          ? Theme.of(context).toggleableActiveColor
                          : Theme.of(context).disabledColor),
                )
              : null,
          title: Text(text),
          leading: Radio<int>(
            value: value,
            groupValue: sortType,
            onChanged: (int? value) {
              setState(() {
                sortType = value!;
                StorageManager.saveData('sortType', sortType);
                Navigator.pop(context);
              });
            },
          ),
        );
      },
    );
  }

  refresh() {
    setState(() {});
  }

  Widget favoritedList() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          child: Row(
            children: [
              InkWell(
                onTap: () => showSortDialog(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Сортировать",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(sortMap[sortType].toString())
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Фильтр',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: DBHelper.instance.readFavoritedBooks(
              orderBy: sortSQL[sortType]!,
              orderDirection: sortOrder,
              limit: 100),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Book> favoritedBooks = snapshot.data as List<Book>;
              for (var element in favoritedBooks) {
                precacheImage(NetworkImage(element.image), context,
                    onError: (Object object, StackTrace? trace) {
                  log('Cant precache ${element.image}');
                });
              }
              if (favoritedBooks.isNotEmpty) {
                return ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: favoritedBooks.length,
                  itemBuilder: (context, index) {
                    return BookElement(
                        book: favoritedBooks[index],
                        api: widget.api,
                        notifyParent: refresh);
                  },
                );
              } else {
                return emptyContainer(
                    "Здесь будут находится Ваши избранные книги");
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  Widget emptyContainer(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: InkWell(
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
        ),
      ),
    );
  }
}
