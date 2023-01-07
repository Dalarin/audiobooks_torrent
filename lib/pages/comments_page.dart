import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/bloc/book_bloc/book_bloc.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:rutracker_app/models/comment.dart';
import 'package:rutracker_app/repository/book_repository.dart';

class CommentsPage extends StatelessWidget {
  final AuthenticationBloc bloc;
  final Book book;

  const CommentsPage({
    Key? key,
    required this.bloc,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (context) => BookBloc(
        repository: BookRepository(
          api: bloc.rutrackerApi,
        ),
      )..add(GetComments(bookId: book.id, start: 0, comments: [])),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Комментарии'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateCommentDialog(context),
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _commentsListViewBuilder(context, book.id),
            ),
          ),
        );
      }),
    );
  }

  void _showCreateCommentDialog(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Комментарий'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отправить'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _commentsListViewBuilder(BuildContext context, int bookId) {
    return BlocConsumer(
      bloc: context.read<BookBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        if (state is BookCommentsLoaded) {
          return _commentsListView(context, state.comments, state.start, bookId);
        } else if (state is CommentsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _commentsListView(context, [], 0, bookId);
      },
    );
  }

  Widget _commentsListView(BuildContext context, List<Comment> comments, int start, int bookId) {
    if (comments.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: comments.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (_, index) {
                return _commentElement(comments[index]);
              },
            ),
          ),
          FilledButton(
            onPressed: () {
              final bloc = context.read<BookBloc>();
              bloc.add(GetComments(bookId: bookId, start: start + 30, comments: comments));
            },
            child: const Text('Загрузить новые'),
          ),
        ],
      );
    }
    return Center(
      child: Text(
        'Комментарии отсутствуют',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _commentElement(Comment comment) {
    return ListTile(
      leading: _avatar(comment),
      title: Text(comment.nickname),
      subtitle: Text(comment.message),
    );
  }

  Widget _avatar(Comment comment) {
    return CircleAvatar(
      backgroundImage: NetworkImage(comment.avatar),
    );
  }
}
