// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:rutracker_app/pages/book.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/torrent.dart';
import 'package:rutracker_app/rutracker/providers/sort.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class Search extends StatefulWidget {
  RutrackerApi api;

  Search(this.api, {Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool searching = false;
  bool anythingFounded = false;
  List<Torrent> query = [];
  int _selectedValue = 50;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  primary: true,
                  child: body(),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Поиск', style: Theme.of(context).textTheme.headline1),
          const SizedBox(height: 25),
          search(),
        ],
      ),
    );
  }

  Widget search() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Icon(Icons.search),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Theme.of(context).hintColor),
                  onSubmitted: (value) => _lookingForQuery(value,
                      '1036,1279,1350,2127,2137,2152,2165,2324,2325,2326,2327,2328,2342,2348,2387,2388,2389,399,400,401,402,403,467,490,499,530,574,661,695,716'),
                  decoration:
                      const InputDecoration.collapsed(hintText: "Поиск"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  choiseChip(Genres.foreignFantasy),
                  choiseChip(Genres.russianFantasy),
                  choiseChip(Genres.radioPerfomances),
                  choiseChip(Genres.biography),
                  choiseChip(Genres.history),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  choiseChip(Genres.foreignLiterature),
                  choiseChip(Genres.foreignDetectives),
                  choiseChip(Genres.russianDetectives),
                  choiseChip(Genres.educationalLiterature)
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        listView(query),
      ],
    );
  }

  Widget choiseChip(Genres label) {
    return ChoiceChip(
      selectedColor: Theme.of(context).toggleableActiveColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      label: Text(
        label.name,
        style: TextStyle(
          color: _selectedValue == label.index
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      ),
      selected: _selectedValue == label.index,
      onSelected: (value) {
        setState(
          () {
            _selectedValue = _selectedValue == label.index ? 505 : label.index;
            _lookingForQuery("", label.value.toString());
          },
        );
      },
    );
  }

  Widget buildMovieShimmer() => ListTile(
        title: Align(
          alignment: Alignment.centerLeft,
          child: CustomWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        subtitle: const CustomWidget.rectangular(height: 14),
      );

  Widget listView(List<Torrent> query) {
    return anythingFounded
        ? Material(
            elevation: 15.0,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                physics: const ScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                itemCount: searching ? 20 : query.length,
                itemBuilder: (context, index) =>
                    searching ? buildMovieShimmer() : book(query[index]),
              ),
            ),
          )
        : const Center(
            child: Text("Ничего не найдено"),
          );
  }

  _loadData(Torrent torrent) async {
    return await widget.api.openBook(torrent.link);
  }

  Widget book(Torrent torrent) {
    return InkWell(
      onTap: () async {
        try {
          Book book = await _loadData(torrent);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookPage(widget.api, torrent: book),
            ),
          );
        } catch (e) {
          FunkyNotification(notificationText: 'Ошибка загрузки книги')
              .showNotification(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          maxHeight: 150,
        ),
        child: Text(
          torrent.theme,
          style: const TextStyle(height: 1.4),
        ),
      ),
    );
  }

  _lookingForQuery(String value, String categories) async {
    _selectedValue = categories.length > 6 ? 505 : _selectedValue;
    anythingFounded = true;
    setState(() => searching = true);
    try {
      query = await widget.api.search(value, categories);
      searching = false;
      setState(() => anythingFounded = true);
    } catch (E) {
      log(E.toString());
      setState(() => anythingFounded = false);
    }
  }
}

class FunkyNotification extends StatefulWidget {
  String notificationText;

  FunkyNotification({
    Key? key,
    required this.notificationText,
  }) : super(key: key);

  void showNotification(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) =>
            FunkyNotification(notificationText: notificationText));
    Navigator.of(context).overlay?.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => overlayEntry.remove(),
    );
  }

  @override
  State<StatefulWidget> createState() => FunkyNotificationState();
}

class FunkyNotificationState extends State<FunkyNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: SlideTransition(
              position: position,
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.notificationText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColorLight,
        highlightColor: Theme.of(context).primaryColorDark.withOpacity(0.1),
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[400]!,
            shape: shapeBorder,
          ),
        ),
      );
}
