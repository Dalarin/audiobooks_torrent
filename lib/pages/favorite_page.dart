import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/elements/create_list_dialog.dart';
import 'package:rutracker_app/pages/list_page.dart';
import 'package:rutracker_app/providers/enums.dart';
import 'package:rutracker_app/repository/book_repository.dart';
import 'package:rutracker_app/repository/list_repository.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../bloc/list_bloc/list_bloc.dart';
import '../models/book.dart';
import '../models/book_list.dart';

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
        title: const Text('Избранное'),
        bottom: TabBar(
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          controller: tabController,
          tabs: const [
            Tab(text: 'Избранное'),
            Tab(text: 'Списки'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: _favoritePageContent(context),
          ),
        ),
      ),
    );
  }

  Widget _favoritePageContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.85,
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

  Widget _action({
    required BuildContext context,
    required Function(BuildContext) function,
    required List<Widget> children,
  }) {
    return InkWell(
      onTap: () => function(context),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.5 - 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget _sortListTile(BuildContext context, Sort sort, StateSetter setter) {
    return RadioListTile(
      title: Text(sort.text),
      value: sort.text,
      groupValue: currentSort.text,
      onChanged: (Object? value) {
        setter.call(() {
          currentSort = sort;
          final bloc = context.read<BookBloc>();
          bloc.add(GetFavoritesBooks(sortOrder: sort, limit: 400));
        });
      },
    );
  }

  void _showSortDialog(BuildContext context, Sort sort) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Сортировка'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(
              builder: (_, stateSetter) {
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return _sortListTile(context, Sort.values[index], stateSetter);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: Sort.values.length,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _favoriteActionBar(BuildContext context, Sort sort) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _action(
            context: context,
            function: (context) {
              _showSortDialog(context, sort);
            },
            children: [
              const Text(
                'Сортировать',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(sort.text),
            ],
          ),
          _action(
            context: context,
            function: (context) {},
            children: const [
              Text(
                'Фильтровать',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.68,
        child: ListView.separated(
          itemCount: books.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            return BookElement(
              authenticationBloc: widget.authenticationBloc,
              books: books,
              book: books[index],
            );
          },
        ),
      );
    }
    return _emptyListWidget(
      context,
      'Здесь будут находиться ваши избранные книги',
    );
  }

  Widget _favoriteBooksListBuilder(BuildContext context) {
    final bloc = context.read<BookBloc>();
    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<BookBloc, BookState>(
          bloc: bloc..add(const GetFavoritesBooks(sortOrder: Sort.standart, limit: 400)),
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
              return _bookList(context, state.books);
            } else if (state is BookLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return _bookList(context, []);
          },
        ),
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
          return Column(
            children: [
              _favoriteActionBar(builderContext, currentSort),
              _favoriteBooksListBuilder(builderContext),
            ],
          );
        },
      ),
    );
  }

  Widget _cachedImage(Book book, double width, double height) {
    return Image(
      image: CachedNetworkImageProvider(book.image),
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
    );
  }

  Widget _networkImage(Book book, double width, double height) {
    return Image.network(
      book.image,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: width * 0.22,
    );
  }

  Widget _errorImage(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        width: width * 0.18,
        height: width * 0.17,
        child: Image.asset(
          'assets/cover.jpg',
          repeat: ImageRepeat.repeat,
        ),
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
                child: _networkImage(item, width, height),
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

  Widget _listElement(BuildContext context, BookList bookList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: context.read<ListBloc>(),
                child: ListPage(
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
          visualDensity: const VisualDensity(vertical: 4),
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
          itemBuilder: (_, index) => _listElement(context, list[index]),
          itemCount: list.length,
          shrinkWrap: true,
        ),
      );
    }
    return _emptyListWidget(context, 'Отсутствуют созданные списки');
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
      child: const Text('Создать новый список'),
    );
  }

  Widget _listTab() {
    return BlocProvider<ListBloc>(
      create: (context) => ListBloc(
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
