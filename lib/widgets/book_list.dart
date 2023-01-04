import 'package:flutter/material.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:rutracker_app/widgets/book.dart';

class ElementsList extends StatelessWidget {
  final List<Book> list;
  final String emptyListText;
  final AuthenticationBloc bloc;
  final bool shrinkWrap;

  const ElementsList({
    Key? key,
    required this.list,
    required this.emptyListText,
    required this.bloc,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return BookElement(
            authenticationBloc: bloc,
            books: list,
            book: list[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: list.length,
        shrinkWrap: shrinkWrap,
      );
    }
    return _emptyListWidget(context, emptyListText);
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
}
