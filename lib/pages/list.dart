
import 'package:flutter/material.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class ListPage extends StatefulWidget {
  BookList list;
  RutrackerApi api;
  ListPage({Key? key, required this.list, required this.api}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ListObject> _books = [];

  @override
  void initState() {
    _loadInformation();
    super.initState();
  }

  void _loadInformation() async {
    _books = await DBHelper.instance
        .getBookInList(widget.list.id!)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: body(),
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _books.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: DBHelper.instance.readBook(_books[index].idBook),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Book> book = snapshot.data as List<Book>;
                    return BookElement(
                        book: book[0], api: widget.api, notifyParent: refresh);
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        )
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget.list.name,
                  maxLines: 1,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: constants.fontFamily),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Text(
                      widget.list.description,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: constants.fontFamily,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
        IconButton(
          onPressed: () => showSettingDialog(context),
          icon: const Icon(Icons.more_vert),
        )
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    );
  }

  void showSettingDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(15),
      content: Container(
        width: MediaQuery.of(context).size.width * .95,
        height: MediaQuery.of(context).size.height * .15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            actionSettings(Icons.delete, "Удалить список", deleteList),
            actionSettings(Icons.settings, "Изменить список", changeList)
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

  void changeList() {}

  void deleteList() {
    Navigator.pop(context);

    AlertDialog alert = AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            DBHelper.instance.deleteList(widget.list.id!).then((value) {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            });
          },
          child: Text(
            'Да',
            style: TextStyle(
                fontFamily: constants.fontFamily, fontWeight: FontWeight.bold),
          ),
        )
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      insetPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(25),
      content: Container(
        width: MediaQuery.of(context).size.width * .95,
        height: MediaQuery.of(context).size.height * .05,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Вы уверены, что хотите удалить список ${widget.list.name}?',
              style: TextStyle(fontFamily: constants.fontFamily),
            )
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

  Widget actionSettings(IconData icon, String label, Function function) {
    return InkWell(
      onTap: () => function(),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 15),
          Text(label, style: TextStyle(fontFamily: constants.fontFamily))
        ],
      ),
    );
  }
}
