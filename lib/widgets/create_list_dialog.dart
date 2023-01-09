import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/list_bloc/list_bloc.dart';
import 'package:rutracker_app/generated/l10n.dart';
import 'package:rutracker_app/models/book_list.dart';

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
          S.of(context).createList,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          tooltip: S.of(context).createList,
          onPressed: () {
            final bloc = context.read<ListBloc>();
            bloc.add(
              CreateList(
                title: _titleController.text,
                description: _descriptionController.text,
                list: list,
              ),
            );
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.create),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(context, widget.lists),
            const SizedBox(height: 15),
            _textField(
              context: context,
              controller: _titleController,
              hint: S.of(context).listTitle,
            ),
            const SizedBox(height: 15),
            _textField(
              context: context,
              controller: _descriptionController,
              hint: S.of(context).listDescription,
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
        label: Text(hint),
      ),
    );
  }
}
