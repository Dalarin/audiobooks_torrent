import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/elements/book.dart';
import 'package:rutracker_app/repository/book_repository.dart';
import 'package:rutracker_app/repository/list_repository.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/list.dart';
import 'package:rutracker_app/rutracker/providers/enums.dart';

import '../bloc/book_bloc/book_bloc.dart';
import '../bloc/list_bloc/list_bloc.dart';

class FavoritePage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const FavoritePage({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin {
  late TabController tabController;

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

  void _showSortDialog(BuildContext context, SORT sort) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Сортировка'),
          content: const Text('dialogBody'),
          actions: <Widget>[
            TextButton(
              child: const Text('buttonText'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _favoriteActionBar(BuildContext context, SORT sort) {
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
        physics: AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<BookBloc, BookState>(
          bloc: bloc..add(const GetFavoritesBooks(sortOrder: SORT.STANDART)),
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
              _favoriteActionBar(builderContext, SORT.STANDART),
              _favoriteBooksListBuilder(builderContext),
            ],
          );
        },
      ),
    );
  }

  Widget _listElement(BookList bookList) {
    return ListTile(
      title: Text(bookList.title),
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
    return ElevatedButton(
      onPressed: () {
        // TODO : ПОКАЗАТЬ ОКНО СОЗДАНИЯ СПИСКА
      },
      child: const Text('Создать новый список'),
    );
  }

  Widget _listTab(BuildContext context) {
    return BlocProvider<ListBloc>(
      create: (context) => ListBloc(
        repository: ListRepository(),
      ),
      child: Builder(builder: (context) {
        return Column(
          children: [
            _listOfBooksListBuilder(context),
            const SizedBox(height: 15),
            _addListButton(context),
          ],
        );
      }),
    );
  }
}
