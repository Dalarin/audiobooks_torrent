import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/bloc/list_bloc/list_bloc.dart';
import 'package:rutracker_app/generated/l10n.dart';
import 'package:rutracker_app/models/book_list.dart';
import 'package:rutracker_app/pages/list_page.dart';
import 'package:rutracker_app/providers/enums.dart';
import 'package:rutracker_app/providers/settings_manager.dart';
import 'package:rutracker_app/repository/book_repository.dart';
import 'package:rutracker_app/repository/list_repository.dart';
import 'package:rutracker_app/widgets/book_list.dart';
import 'package:rutracker_app/widgets/create_list_dialog.dart';
import 'package:rutracker_app/widgets/image.dart';

class FavoritePage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const FavoritePage({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin {
  late TabController tabController;
  Sort currentSort = Sort.standart;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorite),
        bottom: TabBar(
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          controller: tabController,
          tabs: [
            Tab(text: S.of(context).favorite),
            Tab(text: S.of(context).lists),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: _favoritePageContent(context),
        ),
      ),
    );
  }

  Widget _favoritePageContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _favoriteTab(context, widget.authenticationBloc),
              _listTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sortListTile(
    BuildContext context,
    Sort sort,
    StateSetter setter,
    SettingsNotifier settingsNotifier,
  ) {
    return RadioListTile(
      title: Text(sort.text),
      value: sort.text,
      groupValue: settingsNotifier.sort.text,
      onChanged: (Object? value) {
        setter.call(() {
          settingsNotifier.sort = sort;
          final bloc = context.read<BookBloc>();
          bloc.add(GetFavoritesBooks(
            sortOrder: sort,
            limit: 400,
            filter: settingsNotifier.filter,
          ));
        });
      },
    );
  }

  void _showSortDialog(BuildContext context, SettingsNotifier settingsNotifier) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).sort),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(
              builder: (_, stateSetter) {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return _sortListTile(
                      context,
                      Sort.values[index],
                      stateSetter,
                      settingsNotifier,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: Sort.values.length,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).filter),
          content: StatefulBuilder(
            builder: (_, stateSetter) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.height,
                child: _filterList(notifier, stateSetter, context),
              );
            },
          ),
        );
      },
    );
  }

  ListView _filterList(SettingsNotifier notifier, StateSetter stateSetter, BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        return _filterListTile(
          Filter.values[index],
          notifier,
          stateSetter,
          context,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: Filter.values.length,
    );
  }

  CheckboxListTile _filterListTile(Filter filter, SettingsNotifier notifier, StateSetter stateSetter, BuildContext context) {
    return CheckboxListTile(
      title: Text(filter.text),
      value: notifier.filter.contains(filter),
      onChanged: (bool? value) {
        final filterList = notifier.filter;
        final bloc = context.read<BookBloc>();
        stateSetter(() {
          if (value == true) {
            filterList.add(filter);
          } else {
            filterList.remove(filter);
          }
        });
        notifier.filter = filterList;
        bloc.add(GetFavoritesBooks(
          sortOrder: notifier.sort,
          limit: 400,
          filter: notifier.filter,
        ));
      },
    );
  }

  Widget _favoriteActionBar(BuildContext context, SettingsNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            onTap: () => _showSortDialog(context, notifier),
            title: Text(
              S.of(context).sort,
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              notifier.sort.text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            onTap: () => _showFilterDialog(context, notifier),
            title: Text(
              S.of(context).filter,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyListWidget(BuildContext context, String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _favoriteBooksListBuilder(
    BuildContext context,
    SettingsNotifier notifier,
  ) {
    final bloc = context.read<BookBloc>();
    return Expanded(
      child: BlocConsumer<BookBloc, BookState>(
        bloc: bloc..add(GetFavoritesBooks(sortOrder: notifier.sort, limit: 400, filter: notifier.filter)),
        listener: (context, state) {
          if (state is BookError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookLoaded) {
            return ElementsList(
              list: state.books,
              emptyListText: S.of(context).emptyFavoriteList,
              bloc: widget.authenticationBloc,
            );
          } else if (state is BookLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ElementsList(
            list: const [],
            emptyListText: S.of(context).emptyFavoriteList,
            bloc: widget.authenticationBloc,
          );
        },
      ),
    );
  }

  Widget _favoriteTab(
    BuildContext context,
    AuthenticationBloc authenticationBloc,
  ) {
    return BlocProvider<BookBloc>(
      create: (_) {
        return BookBloc(
          repository: BookRepository(
            api: authenticationBloc.rutrackerApi,
          ),
        );
      },
      child: Builder(
        builder: (builderContext) {
          return Consumer<SettingsNotifier>(
            builder: (context, theme, _) {
              return Column(
                children: [
                  _favoriteActionBar(builderContext, theme),
                  _favoriteBooksListBuilder(builderContext, theme),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget? _imageStack(BuildContext context, BookList bookList) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (bookList.books.isNotEmpty) {
      var items = bookList.books
          .asMap()
          .map((index, item) {
            final value = ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(left: (35 * index).toDouble()),
                width: width * 0.2,
                height: height * 0.4,
                child: CustomImage(book: item, width: width, height: height),
              ),
            );
            return MapEntry(index, value);
          })
          .values
          .toList();
      items = items.sublist(0, items.length >= 2 ? 2 : items.length);
      return Stack(
        clipBehavior: Clip.none,
        children: items,
      );
    }
    return null;
  }

  Widget _listElement(BuildContext context, BookList bookList, List<BookList> list) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: context.read<ListBloc>(),
                child: ListPage(
                  lists: list,
                  list: bookList,
                  authenticationBloc: widget.authenticationBloc,
                ),
              );
            },
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(
            bookList.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: _imageStack(context, bookList),
          subtitle: Text(
            bookList.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _listListView(BuildContext context, List<BookList> list) {
    if (list.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.68,
        child: ListView.builder(
          itemBuilder: (_, index) => _listElement(context, list[index], list),
          itemCount: list.length,
          shrinkWrap: true,
        ),
      );
    }
    return _emptyListWidget(context, S.of(context).emptyListList);
  }

  Widget _listList(BuildContext context, List<BookList> list) {
    return Column(
      children: [
        _listListView(context, list),
        _addListButton(context, list),
      ],
    );
  }

  Widget _listOfBooksListBuilder(BuildContext context) {
    return Expanded(
      child: BlocConsumer<ListBloc, ListState>(
        bloc: context.read<ListBloc>()..add(GetLists()),
        builder: (context, state) {
          if (state is ListLoaded) {
            return _listList(context, state.list);
          } else if (state is ListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _listList(context, []);
        },
        listener: (context, state) {
          if (state is ListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _addListButton(BuildContext context, List<BookList> list) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return BlocProvider.value(
              value: context.read<ListBloc>(),
              child: CreateListDialog(lists: list),
            );
          },
        );
      },
      child: Text(S.of(context).createList),
    );
  }

  Widget _listTab() {
    return BlocProvider<ListBloc>(
      create: (_) => ListBloc(
        repository: ListRepository(),
      ),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              _listOfBooksListBuilder(context),
            ],
          );
        },
      ),
    );
  }
}
