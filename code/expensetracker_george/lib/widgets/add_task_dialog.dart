import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_providers/time_entry_provider.dart';
import '../models/category_model.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(SubCategory) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Expense Subcategory'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Subcategory Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) return;

            final newTask = SubCategory(
              id: Provider.of<TimeEntryProvider>(context, listen: false)
                  .generateTaskId()
                  .toString(),
              name: name,
            );

            widget.onAdd(newTask);
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addTask(newTask);
            _controller.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
