// ignore_for_file: must_be_immutable, camel_case_types, sized_box_for_whitespace, file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:rutracker_app/elements/book.dart';

import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class subHome extends StatefulWidget {
  subHome(this.api, {Key? key}) : super(key: key);
  RutrackerApi api;

  @override
  _subHomeState createState() => _subHomeState();
}

class _subHomeState extends State<subHome> {
//////////////////////////////// INITIALIZERS

//////////////////////////////// INITIALIZERS

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  primary: true,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: body(),
                ),
              ),
            ],
          )),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Главная',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            color: Colors.blue.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Недавно прослушанное",
            style: TextStyle(
              fontSize: 16,
              fontFamily: constants.fontFamily,
            ),
          ),
        ),
        const SizedBox(height: 15),
        listViewListening(),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Любимое",
            style: TextStyle(fontSize: 16, fontFamily: constants.fontFamily),
          ),
        ),
        const SizedBox(height: 15),
        listViewFavorited(),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }

  Widget listViewListening() {
    return FutureBuilder(
      future: DBHelper.instance.readDownloadedBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Book> downloadedBooks = snapshot.data as List<Book>;
          downloadedBooks = downloadedBooks.reversed
              .where((element) => element.listeningInfo["maxIndex"] != '0')
              .toList();
          if (downloadedBooks.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  downloadedBooks.length > 2 ? 2 : downloadedBooks.length,
              itemBuilder: (context, index) => BookElement(
                book: downloadedBooks[index],
                api: widget.api,
                notifyParent: refresh,
              ),
            );
          } else {
            return emptyContainer(
                "Здесь будут находится последние 2 прослушанные книги");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget emptyContainer(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            height: 80,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: constants.fontFamily,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listViewFavorited() {
    return FutureBuilder(
      future: DBHelper.instance.readFavoritedBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Book> downloadedBooks = snapshot.data as List<Book>;
          downloadedBooks = downloadedBooks.reversed.toList();
          downloadedBooks.shuffle();
          return downloadedBooks.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      downloadedBooks.length > 3 ? 3 : downloadedBooks.length,
                  itemBuilder: (context, index) => InkWell(
                    child: BookElement(
                        book: downloadedBooks[index],
                        notifyParent: refresh,
                        api: widget.api),
                  ),
                )
              : emptyContainer("Здесь будут находится 3 избранные книги");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class LinearIndicator extends StatefulWidget {
  LinearIndicator({Key? key}) : super(key: key);

  @override
  _LinearIndicatorState createState() => _LinearIndicatorState();
}

class _LinearIndicatorState extends State<LinearIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: const LinearProgressIndicator(
          value: 0.3,
          color: Color(0xFF4A73E7),
        ),
      ),
    );
  }
}
