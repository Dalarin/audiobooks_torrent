import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/rutracker/models/torrent.dart';
import 'package:rutracker_app/rutracker/providers/sort.dart';

import '../bloc/search_bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  const SearchPage({
    Key? key,
    required this.authenticationBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchBloc(bloc: authenticationBloc),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: _searchPageContent(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _tag(Genres tag) {
    return ChoiceChip(
      label: Text(tag.name),
      selected: false,
      onSelected: (bool value) {},
    );
  }

  Widget _tagsPanel(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      children: [
        _tag(Genres.foreignFantasy),
        _tag(Genres.russianFantasy),
        _tag(Genres.radioPerfomances),
        _tag(Genres.biography),
        _tag(Genres.history),
        _tag(Genres.foreignLiterature),
        _tag(Genres.foreignDetectives),
        _tag(Genres.russianDetectives),
        _tag(Genres.educationalLiterature),
      ],
    );
  }

  Widget _searchField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: 'Введите книгу для поиска..'),
    );
  }

  Widget _emptyListWidget(BuildContext context, String text) {
    return Material(
      elevation: 5.0,
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
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
    );
  }

  Widget _searchResult(BuildContext context, Torrent result) {
    return Material(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        child: Text(result.forum),
      ),
    );
  }

  Widget _searchResultList(BuildContext context, List<Torrent> result) {
    if (result.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: result.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _searchResult(context, result[index]);
        },
      );
    }
    return _emptyListWidget(
      context,
      'Ничего не найдено по Вашему запросу',
    );
  }

  Widget _searchBooksListBuilder(BuildContext context) {
    print(context.read<SearchBloc>());
    return BlocConsumer<SearchBloc, SearchState>(
      bloc: context.read<SearchBloc>(),
      builder: (context, state) {
        if (state is SearchLoaded) {
          return _searchResultList(context, state.queryResponse);
        }
        return _searchResultList(context, []);
      },
      listener: (context, state) {
        if (state is SearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
    );
  }

  Widget _searchPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Избранное'),
        const SizedBox(height: 15),
        _searchField(context),
        const SizedBox(height: 10),
        _tagsPanel(context),
        const SizedBox(height: 15),
        _searchBooksListBuilder(context),
      ],
    );
  }
}

// // ignore_for_file: must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace
//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:rutracker_app/pages/book.dart';
// import 'package:rutracker_app/rutracker/models/book.dart';
// import 'package:rutracker_app/rutracker/models/torrent.dart';
// import 'package:rutracker_app/rutracker/providers/sort.dart';
// import 'package:rutracker_app/rutracker/rutracker.dart';
// import 'package:shimmer/shimmer.dart';
//
// class Search extends StatefulWidget {
//   RutrackerApi api;
//
//   Search(this.api, {Key? key}) : super(key: key);
//
//   @override
//   _SearchState createState() => _SearchState();
// }
//
// class _SearchState extends State<Search> {
//   bool searching = false;
//   bool anythingFounded = false;
//   List<Torrent> query = [];
//   int _selectedValue = 50;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Scaffold(
//         extendBody: true,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: Flex(
//           direction: Axis.horizontal,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 primary: true,
//                 physics: const BouncingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics(),
//                 ),
//                 child: body(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget body() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text('Поиск', style: Theme.of(context).textTheme.headline1),
//           const SizedBox(height: 25),
//           search(),
//         ],
//       ),
//     );
//   }
//
//   Widget search() {
//     return Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.05,
//           decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: const BorderRadius.all(Radius.circular(15.0))),
//           child: Row(
//             children: [
//               const SizedBox(width: 15),
//               const Icon(Icons.search),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: TextField(
//                   style: TextStyle(color: Theme.of(context).hintColor),
//                   onSubmitted: (value) => _lookingForQuery(value,
//                       '1036,1279,1350,2127,2137,2152,2165,2324,2325,2326,2327,2328,2342,2348,2387,2388,2389,399,400,401,402,403,467,490,499,530,574,661,695,716'),
//                   decoration:
//                       const InputDecoration.collapsed(hintText: "Поиск"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 15),
//         Wrap(
//           children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   choiseChip(Genres.foreignFantasy),
//                   choiseChip(Genres.russianFantasy),
//                   choiseChip(Genres.radioPerfomances),
//                   choiseChip(Genres.biography),
//                   choiseChip(Genres.history),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   choiseChip(Genres.foreignLiterature),
//                   choiseChip(Genres.foreignDetectives),
//                   choiseChip(Genres.russianDetectives),
//                   choiseChip(Genres.educationalLiterature)
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         listView(query),
//       ],
//     );
//   }
//
//   Widget choiseChip(Genres label) {
//     return ChoiceChip(
//       selectedColor: Theme.of(context).toggleableActiveColor,
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       label: Text(
//         label.name,
//         style: TextStyle(
//           color: _selectedValue == label.index
//               ? Colors.white
//               : Theme.of(context).primaryColor,
//         ),
//       ),
//       selected: _selectedValue == label.index,
//       onSelected: (value) {
//         setState(
//           () {
//             _selectedValue = _selectedValue == label.index ? 505 : label.index;
//             _lookingForQuery("", label.value.toString());
//           },
//         );
//       },
//     );
//   }
//
//   Widget buildMovieShimmer() => ListTile(
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: CustomWidget.rectangular(
//             height: 16,
//             width: MediaQuery.of(context).size.width * 0.3,
//           ),
//         ),
//         subtitle: const CustomWidget.rectangular(height: 14),
//       );
//
//   Widget listView(List<Torrent> query) {
//     return anythingFounded
//         ? Material(
//             elevation: 15.0,
//             borderRadius: const BorderRadius.all(Radius.circular(20.0)),
//             child: Container(
//               padding: const EdgeInsets.all(10.0),
//               child: ListView.separated(
//                 physics: const ScrollPhysics(),
//                 separatorBuilder: (context, index) => const Divider(),
//                 shrinkWrap: true,
//                 itemCount: searching ? 20 : query.length,
//                 itemBuilder: (context, index) =>
//                     searching ? buildMovieShimmer() : book(query[index]),
//               ),
//             ),
//           )
//         : const Center(
//             child: Text("Ничего не найдено"),
//           );
//   }
//
//   _loadData(Torrent torrent) async {
//     return await widget.api.openBook(torrent.link);
//   }
//
//   Widget book(Torrent torrent) {
//     return InkWell(
//       onTap: () async {
//         try {
//           Book book = await _loadData(torrent);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookPage(widget.api, torrent: book),
//             ),
//           );
//         } catch (e) {
//           FunkyNotification(notificationText: 'Ошибка загрузки книги')
//               .showNotification(context);
//         }
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         constraints: const BoxConstraints(
//           maxHeight: 150,
//         ),
//         child: Text(
//           torrent.theme,
//           style: const TextStyle(height: 1.4),
//         ),
//       ),
//     );
//   }
//
//   _lookingForQuery(String value, String categories) async {
//     _selectedValue = categories.length > 6 ? 505 : _selectedValue;
//     anythingFounded = true;
//     setState(() => searching = true);
//     try {
//       query = await widget.api.search(value, categories);
//       searching = false;
//       setState(() => anythingFounded = true);
//     } catch (E) {
//       log(E.toString());
//       setState(() => anythingFounded = false);
//     }
//   }
// }
//
// class FunkyNotification extends StatefulWidget {
//   String notificationText;
//
//   FunkyNotification({
//     Key? key,
//     required this.notificationText,
//   }) : super(key: key);
//
//   void showNotification(BuildContext context) {
//     OverlayEntry overlayEntry = OverlayEntry(
//         builder: (context) =>
//             FunkyNotification(notificationText: notificationText));
//     Navigator.of(context).overlay?.insert(overlayEntry);
//     Future.delayed(const Duration(seconds: 2)).then(
//       (value) => overlayEntry.remove(),
//     );
//   }
//
//   @override
//   State<StatefulWidget> createState() => FunkyNotificationState();
// }
//
// class FunkyNotificationState extends State<FunkyNotification>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<Offset> position;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 750));
//     position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
//         .animate(
//             CurvedAnimation(parent: controller, curve: Curves.bounceInOut));
//
//     controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Material(
//         color: Colors.transparent,
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 32.0),
//             child: SlideTransition(
//               position: position,
//               child: Container(
//                 decoration: ShapeDecoration(
//                     color: Colors.red,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     widget.notificationText,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomWidget extends StatelessWidget {
//   final double width;
//   final double height;
//   final ShapeBorder shapeBorder;
//
//   const CustomWidget.rectangular(
//       {this.width = double.infinity, required this.height})
//       : shapeBorder = const RoundedRectangleBorder();
//
//   @override
//   Widget build(BuildContext context) => Shimmer.fromColors(
//         baseColor: Theme.of(context).primaryColorLight,
//         highlightColor: Theme.of(context).primaryColorDark.withOpacity(0.1),
//         period: const Duration(seconds: 2),
//         child: Container(
//           width: width,
//           height: height,
//           decoration: ShapeDecoration(
//             color: Colors.grey[400]!,
//             shape: shapeBorder,
//           ),
//         ),
//       );
// }
