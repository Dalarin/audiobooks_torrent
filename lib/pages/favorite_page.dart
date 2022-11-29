import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/repository/book_repository.dart';
import 'package:rutracker_app/repository/list_repository.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../bloc/list_bloc/list_bloc.dart';

class FavoritePage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const FavoritePage({Key? key, required this.authenticationBloc})
      : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookBloc>(
          create: (context) {
            return BookBloc(repository: BookRepository());
          },
        ),
        BlocProvider(
          create: (context) {
            return ListBloc(repository: ListRepository());
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
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
                        child: _favoritePageContent(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _favoritePageContent(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          labelColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Избранное'),
            Tab(text: 'Списки'),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.85,
          child: TabBarView(
            controller: tabController,
            children: [
              _favoriteTab(context),
              _listTab(context),
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
      onTap: () => function,
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

  Widget _favoriteActionBar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _action(
            context: context,
            function: (context) {},
            children: const [
              Text(
                'Сортировать',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('По умолчанию'),
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

  Widget _bookList(BuildContext context, List<Book> books) {
    if (books.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return BookElement(
            books: books,
            book: books[index],
          );
        },
      );
    }
    return _emptyListWidget(
      context,
      'Здесь будут находиться ваши избранные книги',
    );
  }

  Widget _favoriteBooksListBuilder(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      bloc: context.read<BookBloc>()..add(GetFavoritesBooks()),
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
    );
  }

  Widget _favoriteTab(BuildContext context) {
    return Column(
      children: [
        _favoriteActionBar(context),
        _favoriteBooksListBuilder(context),
      ],
    );
  }

  Widget _listElement(BookList bookList) {
    return ListTile(
      title: Text(bookList.name),
      subtitle: Text(
        bookList.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _listList(BuildContext context, List<BookList> list) {
    if (list.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _listElement(list[index]);
        },
        itemCount: list.length,
        shrinkWrap: true,
      );
    }
    return _emptyListWidget(context, 'Отсутствуют созданные списки');
  }

  Widget _listOfBooksListBuilder(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
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
      listener: (context, state) {},
    );
  }

  Widget _addListButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO : ПОКАЗАТЬ ОКНО СОЗДАНИЯ СПИСКА
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: const Text(
          'Создать новый список',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _listTab(BuildContext context) {
    return Column(
      children: [
        _listOfBooksListBuilder(context),
        const SizedBox(height: 15),
        _addListButton(context),
      ],
    );
  }
}
