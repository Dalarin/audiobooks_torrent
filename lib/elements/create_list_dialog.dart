import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/list_bloc/list_bloc.dart';

import '../models/book_list.dart';


class CreateListDialog extends StatefulWidget {
  final List<BookList> lists;

  const CreateListDialog({Key? key, required this.lists}) : super(key: key);

  @override
  State<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  Widget _title(BuildContext context, List<BookList> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Создание списка',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          tooltip: 'Создать список',
          onPressed: () {
            final bloc = context.read<ListBloc>();
            bloc.add(
              CreateList(
                title: _titleController.text,
                description: _descriptionController.text,
                list: list,
              ),
            );
          },
          icon: const Icon(Icons.create),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(context, widget.lists),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Column(
              children: [
                _textField(
                  context: context,
                  controller: _titleController,
                  hint: 'Название списка',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                _textField(
                  context: context,
                  controller: _descriptionController,
                  hint: 'Описание списка',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hint,
      ),
    );
  }
}
