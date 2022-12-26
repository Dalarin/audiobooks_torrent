import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/pages/book_page.dart';
import 'package:rutracker_app/repository/book_repository.dart';

import '../bloc/search_bloc/search_bloc.dart';
import '../models/query_response.dart';

class SearchPage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;
  final List<Categories> selectedGenre = [Categories.all];

  SearchPage({
    Key? key,
    required this.authenticationBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(bloc: authenticationBloc),
        ),
        BlocProvider<BookBloc>(
          create: (context) {
            return BookBloc(
              repository: BookRepository(api: authenticationBloc.rutrackerApi),
            );
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: const Text('Поиск'),
              bottom: _searchField(context),
            ),
            body: BlocListener<BookBloc, BookState>(
              listener: (context, state) {
                if (state is BookLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<BookBloc>(),
                          child: BookPage(
                            authenticationBloc: authenticationBloc,
                            book: state.books.first,
                            books: state.books,
                          ),
                        );
                      },
                    ),
                  ).then((value) {
                    Navigator.pop(context);
                  });
                } else if (state is BookLoading) {
                  _showLoadingMenu(context);
                } else if (state is BookError) {
                  _showErrorSnackBar(context, state.message);
                } else if (state is BookUpdated) {
                  Navigator.pop(context);
                }
              },
              child: _searchPageSafeArea(context),
            ),
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showLoadingMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _searchPageSafeArea(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
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
    );
  }

  Widget _tag(BuildContext context, Categories tag, StateSetter setter) {
    return ChoiceChip(
      label: Text(tag.text),
      selected: selectedGenre[0].index == tag.index,
      onSelected: (bool value) {
        setter.call(() {
          selectedGenre.first = tag;
          final bloc = context.read<SearchBloc>();
          bloc.add(SearchByGenre(categories: tag));
        });
      },
    );
  }

  Widget _tagsPanel(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        children: [
          _tag(context, Categories.foreignFantasy, setState),
          _tag(context, Categories.history, setState),
          _tag(context, Categories.russianFantasy, setState),
          _tag(context, Categories.radioPerformances, setState),
          _tag(context, Categories.biography, setState),
          _tag(context, Categories.foreignLiterature, setState),
          _tag(context, Categories.foreignDetectives, setState),
          _tag(context, Categories.russianDetectives, setState),
          _tag(context, Categories.scienceLiterature, setState),
        ],
      );
    });
  }

  PreferredSizeWidget _searchField(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.height * 0.1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          onSubmitted: (String text) {
            final bloc = context.read<SearchBloc>();
            bloc.add(Search(query: text));
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: 'Введите книгу для поиска..',
          ),
        ),
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

  Widget _searchResult(BuildContext context, QueryResponse result) {
    return InkWell(
      onTap: () {
        final bloc = context.read<BookBloc>();
        bloc.add(GetBookFromSource(bookId: result));
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Text(result.theme, textAlign: TextAlign.justify),
      ),
    );
  }

  Widget _searchResultList(BuildContext context, List<QueryResponse> result) {
    if (result.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(),
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
    return BlocConsumer<SearchBloc, SearchState>(
      bloc: context.read<SearchBloc>(),
      builder: (context, state) {
        if (state is SearchLoaded) {
          return _searchResultList(context, state.queryResponse);
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
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
        const SizedBox(height: 15),
        _tagsPanel(context),
        const SizedBox(height: 15),
        _searchBooksListBuilder(context),
      ],
    );
  }
}
